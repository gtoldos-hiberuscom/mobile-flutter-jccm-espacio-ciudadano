import 'dart:async';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/core/app/app_lifecycle_provider.dart';
import 'package:jccm_espacio_ciudadano/core/connectivity/connectivity_status.dart';
import 'package:jccm_espacio_ciudadano/core/errors/app_error.dart';
import 'package:jccm_espacio_ciudadano/core/logger/logger.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/jwt_claims.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/citizen_endpoint_ids_provider.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/jwt_claims_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/aportacion_archivo.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/aportacion_lote.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/expediente.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/inicio_procedimiento_resultado.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/representante.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/2_presentation/providers/gestion_documento_provider.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/2_presentation/providers/gestion_expedientes_provider.dart';

const int maxArchivosAportacion = 5;

/// 20 MB **decimales** (20.000.000 bytes), las mismas unidades con las que
/// iOS muestra los tamaños en Archivos: con 20 MiB, un fichero que el
/// ciudadano ve como «21 MB» pasaba la validación.
const int maxTamanioBytesAportacion = 20 * 1000 * 1000;
const List<String> extensionesPermitidasAportacion = ['pdf', 'doc', 'docx', 'zip', 'xls', 'xlsx'];

/// Tiempo máximo que una subida puede pasar **sin enviar ni un byte** antes de
/// darla por perdida.
///
/// El plazo total de cada subida se dimensiona por su tamaño (~4 min para
/// 20 MB, ver `payloadTransferTimeout`), y con la red caída iOS no rompe el
/// socket: la tarjeta se quedaba minutos en «enviando» y la cola, que es en
/// serie, bloqueaba los reintentos de las demás. Este plazo mide inactividad,
/// no duración, así que una subida lenta pero viva no lo alcanza nunca.
final plazoSinProgresoSubidaProvider = Provider<Duration>((final ref) => const Duration(seconds: 30));

sealed class AddArchivosResult {
  const AddArchivosResult();
}

final class AddArchivosAdded extends AddArchivosResult {
  const AddArchivosAdded(this.count);

  final int count;
}

final class AddArchivosRejectedTooMany extends AddArchivosResult {
  const AddArchivosRejectedTooMany();
}

final class AddArchivosRejectedTooLarge extends AddArchivosResult {
  const AddArchivosRejectedTooLarge(this.nombres);

  final List<String> nombres;
}

final class AddArchivosRejectedInvalidType extends AddArchivosResult {
  const AddArchivosRejectedInvalidType(this.nombres);

  final List<String> nombres;
}

final class AddArchivosRejectedDuplicate extends AddArchivosResult {
  const AddArchivosRejectedDuplicate(this.nombres);

  final List<String> nombres;
}

/// Cuanto necesita la transacción abierta para subir y para cerrar: se
/// resuelve una sola vez al abrirla y no se vuelve a leer, porque el `idunico`
/// y los datos con los que se abrió tienen que ser los mismos con los que se
/// cierra.
typedef _ContextoAportacion = ({
  String citizenId,
  String documentNumber,
  Expediente expediente,
  Representante? representante,
  InicioProcedimientoResultado inicio,
});

/// Orquesta la aportación completa: abre la transacción al seleccionar el
/// primer fichero, sube en cuanto hay algo pendiente y cierra con
/// `registrarfichero` cuando el ciudadano lo pide.
///
/// La cola vive aquí y no en la pantalla porque **avanza sin que nadie pulse
/// nada**: con la carga temprana no hay un callback de botón del que colgarla.
/// El notifier es además el dueño de los `CancelToken`, atados a
/// `ref.onDispose` para que abandonar la pantalla no deje peticiones vivas.
///
/// No toca `BuildContext` ni l10n: los fallos se publican tipados en
/// [AportacionLote.error] y la pantalla elige el mensaje curado.
class GestionAportarDocumentacionNotifier extends Notifier<AportacionLote> {
  GestionAportarDocumentacionNotifier(this._key);

  /// Mismo `(numexp, tercero)` con el que se consulta el detalle: el titular
  /// del expediente ajeno sustituye al documento del JWT en toda la aportación.
  final ExpedienteDetailKey _key;

  final Map<String, CancelToken> _cancelTokens = {};
  CancelToken? _registroToken;
  CancelToken? _transaccionToken;

  /// La transacción abierta, o la apertura en vuelo. Un único future
  /// compartido: dos selecciones seguidas esperan a la misma apertura en vez
  /// de abrir dos `idunico` entrelazados, que corromperían los hashes.
  Future<_ContextoAportacion>? _transaccion;

  bool _colaActiva = false;

  /// Se completa al vaciarse la cola en curso: `registrar` espera a que
  /// terminen los reintentos de los fallidos antes de cerrar.
  Completer<void>? _finCola;

  int _secuenciaError = 0;

  /// Subidas abortadas por la app al perder la red (evento de conectividad,
  /// plazo sin progreso o vuelta de segundo plano). Su `CancelToken` se cancela igual que cuando el
  /// ciudadano retira el fichero, pero el resultado tiene que ser el
  /// contrario: un fallo con su "Reintentar", no una retirada silenciosa que
  /// dejaría la tarjeta congelada en «enviando».
  final Set<String> _abortadasPorRed = {};

  /// Sin red según el sistema. Mientras dure, la cola no arranca subidas
  /// nuevas —fallarían o, peor, se colgarían—: las marca en error para que se
  /// reintenten al volver la red.
  bool _sinRed = false;

  /// Se abandonó la pantalla. Detiene la cola **en el acto**, sin esperar a que
  /// Riverpod libere el provider `autoDispose`: esa liberación se agenda para
  /// más tarde, y en esa ventana la cola alcanzaba a subir otro fichero al
  /// buzón de una transacción que ya nadie va a cerrar.
  bool _abandonado = false;

  @override
  AportacionLote build() {
    // En segundo plano iOS suspende la app, corta sus conexiones y congela los
    // temporizadores de Dart: al volver, una subida en curso —o esperando la
    // respuesta del servidor tras enviar el cuerpo— se quedaba en «enviando»
    // con una conexión muerta y un plazo que no había corrido (JCCMEC-185).
    // Se da por fallida para que el ciudadano pueda reintentarla ya.
    final vueltaDeSegundoPlano = ref.read(appResumedFromBackgroundProvider).listen((final _) {
      if (_cancelTokens.isNotEmpty) {
        logger.w('La app vuelve de segundo plano con subidas en curso: se abortan');
      }
      _abortarSubidasPorRed();
    });
    ref
      ..onDispose(cancelarTodas)
      ..onDispose(vueltaDeSegundoPlano.cancel)
      ..listen(connectivityStatusProvider, fireImmediately: true, (final previo, final actual) {
        _sinRed = actual == ConnectivityStatus.offline;
        if (_sinRed) {
          _abortarSubidasPorRed();
        }
      });
    return const AportacionLote();
  }

  // ── Lista de ficheros ──────────────────────────────────────────────────────

  /// Añade los ficheros elegidos y **arranca su subida inmediatamente**, como
  /// la web: el ciudadano ve el resultado de cada carga sin pulsar nada más.
  AddArchivosResult addArchivos(final List<AportacionArchivo> nuevos) {
    final existingPaths = state.archivos.map((final a) => a.path).toSet();

    final duplicados = nuevos.where((final a) => existingPaths.contains(a.path)).map((final a) => a.nombre).toList(growable: false);
    if (duplicados.isNotEmpty) {
      return AddArchivosRejectedDuplicate(duplicados);
    }

    final tiposInvalidos = nuevos.where((final a) => !_hasAllowedExtension(a.nombre)).map((final a) => a.nombre).toList(growable: false);
    if (tiposInvalidos.isNotEmpty) {
      return AddArchivosRejectedInvalidType(tiposInvalidos);
    }

    final demasiadoGrandes = nuevos.where((final a) => a.tamanioBytes > maxTamanioBytesAportacion).map((final a) => a.nombre).toList(growable: false);
    if (demasiadoGrandes.isNotEmpty) {
      return AddArchivosRejectedTooLarge(demasiadoGrandes);
    }

    if (state.archivos.length + nuevos.length > maxArchivosAportacion) {
      return const AddArchivosRejectedTooMany();
    }

    state = state.copyWith(archivos: [...state.archivos, ...nuevos]);
    unawaited(_procesarCola());
    return AddArchivosAdded(nuevos.length);
  }

  /// Retira un fichero del lote, cancelando su subida si está en vuelo.
  ///
  /// Si ya estaba subido, su adjunto queda huérfano en el buzón de la
  /// transacción: solo desaparece de la lista `documentos` con la que se
  /// cierra, que es la que manda. Los hermanos **conservan su hash** — antes
  /// se descartaba el intento entero, que es lo que reportó el cliente.
  void removeArchivo(final String path) {
    _cancelTokens.remove(path)?.cancel();
    state = state.copyWith(archivos: state.archivos.where((final a) => a.path != path).toList(growable: false));
  }

  /// Vuelve a subir **solo** [path], dentro de la misma transacción abierta:
  /// los hashes de los hermanos siguen siendo válidos porque el `idunico` no
  /// cambia. Antes reintentar rearrancaba el lote completo.
  void reintentarArchivo(final String path) {
    if (!state.puedeEditarLista) {
      return;
    }
    _cancelTokens.remove(path)?.cancel();
    _updateArchivo(path, (final a) => a.copyWith(estado: AportacionArchivoEstado.noEnviado, clearProgreso: true, clearHash: true));
    unawaited(_procesarCola());
  }

  void _marcarPendientesEnError() {
    state = state.copyWith(
      archivos: [
        for (final archivo in state.archivos)
          if (archivo.estado == AportacionArchivoEstado.noEnviado) archivo.copyWith(estado: AportacionArchivoEstado.error) else archivo,
      ],
    );
  }

  /// Devuelve a la cola todos los ficheros en error.
  void _reencolarFallidos() {
    state = state.copyWith(
      archivos: [
        for (final archivo in state.archivos)
          if (archivo.estado == AportacionArchivoEstado.error) archivo.copyWith(estado: AportacionArchivoEstado.noEnviado, clearProgreso: true, clearHash: true) else archivo,
      ],
    );
  }

  // ── Cola de subidas ────────────────────────────────────────────────────────

  /// Sube los ficheros pendientes **de uno en uno**.
  ///
  /// En serie y no en paralelo: el plazo de cada subida está dimensionado por
  /// el tamaño de ESE fichero, y cinco subidas simultáneas comparten el mismo
  /// enlace, así que con ficheros grandes ninguna llegaría a tiempo (5 × 20 MB
  /// son ~133 MB en base64 por el mismo tubo). En serie el tiempo total es el
  /// mismo —lo limita el ancho de banda, no la concurrencia—, cada plazo es el
  /// que corresponde y solo hay un fichero codificado en memoria a la vez.
  ///
  /// Un fallo **no corta la cola**: ese fichero queda en `error` con su propio
  /// "Reintentar" y los demás siguen subiendo. Al vaciarse, si algo falló en
  /// esta pasada se publica un único aviso ([AportacionLoteErrorTipo.subidaParcial]).
  ///
  /// Si ya hay una cola en marcha devuelve su final: relee el estado en cada
  /// vuelta, así que recoge sola lo que se acabe de encolar.
  Future<void> _procesarCola() {
    final enCurso = _finCola;
    if (_colaActiva && enCurso != null) {
      return enCurso.future;
    }
    return _ejecutarCola();
  }

  Future<void> _ejecutarCola() async {
    // Ambos se fijan antes del primer `await`: una segunda llamada en el mismo
    // frame ya ve la cola activa.
    _colaActiva = true;
    final fin = _finCola = Completer<void>();
    var huboFallos = false;
    try {
      while (ref.mounted && !_abandonado && !state.cerrando) {
        // El estado se relee en cada vuelta: el ciudadano puede retirar o
        // añadir ficheros mientras sube otro.
        final siguiente = _primerPendiente();
        if (siguiente == null) {
          if (huboFallos) {
            _publicarError(AportacionLoteErrorTipo.subidaParcial, null);
          }
          return;
        }
        if (_sinRed) {
          _marcarError(siguiente.path);
          huboFallos = true;
          continue;
        }
        final contexto = await _asegurarContexto();
        if (!ref.mounted) {
          return;
        }
        if (contexto == null) {
          // Sin transacción no hay dónde subir, y el aviso ya está publicado.
          // Los pendientes pasan a error y no se quedan «Seleccionado»: esa
          // tarjeta solo ofrece eliminar, así que el lote quedaba sin salida
          // —sin "Reintentar" y con "Registrar" apagado— (JCCMEC-185, al
          // perder la red antes de la primera subida). Reintentar cualquiera
          // vuelve a intentar la apertura.
          _marcarPendientesEnError();
          return;
        }
        if (!await _subirArchivo(siguiente, contexto)) {
          huboFallos = true;
        }
      }
    } finally {
      _colaActiva = false;
      _finCola = null;
      fin.complete();
    }
  }

  /// Sube un fichero. Devuelve `false` solo si terminó en error: un fichero
  /// subido o retirado por el ciudadano no cuenta como fallo de la pasada.
  Future<bool> _subirArchivo(final AportacionArchivo archivo, final _ContextoAportacion contexto) async {
    final repository = ref.read(gestionDocumentoRepositoryProvider);
    final plazoSinProgreso = ref.read(plazoSinProgresoSubidaProvider);
    final token = _beginUpload(archivo.path);
    // Vigila que la subida avance: cada bloque enviado lo rearma y, con el
    // cuerpo ya enviado, se apaga —la espera de la respuesta la cubre el
    // `receiveTimeout` de la petición—.
    Timer? vigilante;
    void rearmarVigilante() {
      vigilante?.cancel();
      vigilante = Timer(plazoSinProgreso, () {
        logger.w('Subida de ${archivo.nombre} sin progreso en ${plazoSinProgreso.inSeconds} s: se aborta');
        _abortarPorRed(archivo.path);
      });
    }

    try {
      final bytes = await XFile(archivo.path).readAsBytes();
      if (!ref.mounted) {
        return true;
      }
      rearmarVigilante();
      final hash = await repository.subirDocumentoSinFirma(
        citizenId: contexto.citizenId,
        documentNumber: contexto.documentNumber,
        idUnico: contexto.inicio.idunico,
        tipoProcedimiento: contexto.expediente.tipoproc ?? '',
        nombreFichero: archivo.nombre,
        bytes: bytes,
        cancelToken: token,
        // El provider es `autoDispose`: tocar el notifier liberado lanza.
        onProgress: (final progreso) {
          if (progreso >= 1) {
            vigilante?.cancel();
          } else {
            rearmarVigilante();
          }
          if (ref.mounted) {
            _updateProgreso(archivo.path, progreso);
          }
        },
      );
      if (!ref.mounted) {
        return true;
      }
      _marcarCompletado(archivo.path, hash);
      return true;
    } on Object catch (error, stackTrace) {
      final abortadaPorRed = _abortadasPorRed.remove(archivo.path);
      if (_esCancelacion(error) && !abortadaPorRed) {
        // Lo canceló el ciudadano o se retiró el fichero: en ambos casos el
        // estado ya lo dejó quien canceló el token, y la cola sigue.
        return true;
      }
      if (abortadaPorRed) {
        logger.w('Subida de ${archivo.nombre} abortada: red perdida o app en segundo plano');
      } else {
        logger.e('Error al subir ${archivo.nombre}', error: error, stackTrace: stackTrace);
      }
      if (ref.mounted) {
        _marcarError(archivo.path);
      }
      return false;
    } finally {
      vigilante?.cancel();
    }
  }

  /// Aborta la subida de [path] como fallo de red, no como retirada.
  void _abortarPorRed(final String path) {
    final token = _cancelTokens[path];
    if (token == null || token.isCancelled) {
      return;
    }
    _abortadasPorRed.add(path);
    token.cancel();
  }

  void _abortarSubidasPorRed() {
    _cancelTokens.keys.toList(growable: false).forEach(_abortarPorRed);
  }

  // ── Transacción ────────────────────────────────────────────────────────────

  /// Devuelve la transacción abierta, abriéndola la primera vez, o `null` si
  /// no se pudo abrir (con el fallo ya publicado).
  Future<_ContextoAportacion?> _asegurarContexto() async {
    final enVuelo = _transaccion;
    if (enVuelo != null) {
      try {
        return await enVuelo;
      } on Object {
        // La publicó y limpió quien la abrió; aquí solo se arrastra el fallo.
        return null;
      }
    }

    final apertura = _abrirTransaccion();
    _transaccion = apertura;
    try {
      return await apertura;
    } on Object catch (error, stackTrace) {
      // Se limpia para que el siguiente intento pueda volver a abrirla.
      _transaccion = null;
      if (_esCancelacion(error)) {
        return null;
      }
      logger.e('Error al iniciar el procedimiento de aportación', error: error, stackTrace: stackTrace);
      if (ref.mounted) {
        _publicarError(AportacionLoteErrorTipo.aperturaTransaccion, error);
      }
      return null;
    }
  }

  Future<_ContextoAportacion> _abrirTransaccion() async {
    final claims = ref.read(jwtClaimsProvider);
    final tercero = _key.tercero;
    // `citizenId` va en el path /ciudadanos/{sid} (sub_alt contra el gateway);
    // `documentNumber` es el titular del expediente y viaja en el cuerpo.
    final documentNumber = tercero?.documentNumber ?? _documentNumber(claims);
    final citizenId = ref.read(citizenEndpointIdsProvider).idAgente;
    if (documentNumber == null || citizenId == null || citizenId.isEmpty) {
      throw StateError('No se ha encontrado el número de documento del ciudadano.');
    }
    // No nulo solo al aportar a un expediente de terceros: identifica ante el
    // backend a quien presenta realmente la documentación (el usuario
    // autenticado), distinto del titular que va en `documentNumber`.
    final representante = tercero == null
        ? null
        : Representante(
            nombre: claims?.givenName ?? '',
            apellido1: claims?.firstSurname ?? '',
            apellido2: claims?.secondSurname ?? '',
            nifcif: _documentNumber(claims) ?? '',
            tipodoc: 'NIF',
          );
    // Se lee antes del primer `await`: después el provider `autoDispose` puede
    // estar liberado y `ref.read` lanzaría.
    final repository = ref.read(gestionDocumentoRepositoryProvider);
    final expediente = await ref.read(expedienteDetailProvider(_key).future);

    final token = CancelToken();
    _transaccionToken = token;
    final idUnicoLocal = '${documentNumber}_${DateTime.now().millisecondsSinceEpoch}';
    final inicio = await repository.iniciarProcedimiento(
      citizenId: citizenId,
      idUnico: idUnicoLocal,
      documentNumber: documentNumber,
      expediente: expediente,
      representante: representante,
      cancelToken: token,
    );
    return (citizenId: citizenId, documentNumber: documentNumber, expediente: expediente, representante: representante, inicio: inicio);
  }

  // ── Cierre ─────────────────────────────────────────────────────────────────

  /// Cierra la transacción con los ficheros que quedan en la lista y devuelve
  /// el justificante, o `null` si no se pudo (con el fallo ya publicado).
  ///
  /// Un cierre fallido **conserva los hashes**: la transacción sigue abierta,
  /// así que volver a pulsar "Registrar" reintenta solo `registrarfichero`,
  /// sin re-subir nada.
  ///
  /// Con ficheros en error ([AportacionLote.puedeReintentarYRegistrar]) antes
  /// los vuelve a subir y, si llegan todos, cierra sin que haya que pulsar otra
  /// vez; si alguno vuelve a fallar, la cola ya publicó el aviso.
  Future<({Uint8List justificante, String numexp})?> registrar() async {
    if (_abandonado) {
      return null;
    }
    if (state.puedeReintentarYRegistrar) {
      state = state.copyWith(reintentandoParaRegistrar: true, clearError: true);
      _reencolarFallidos();
      await _procesarCola();
      if (!ref.mounted) {
        return null;
      }
      state = state.copyWith(reintentandoParaRegistrar: false);
    }
    if (_abandonado || !state.puedeRegistrar) {
      return null;
    }
    final documentos = _documentosParaRegistro();
    if (documentos == null) {
      return null;
    }
    final contexto = await _asegurarContexto();
    if (!ref.mounted || _abandonado || contexto == null) {
      return null;
    }

    final repository = ref.read(gestionDocumentoRepositoryProvider);
    state = state.copyWith(cerrando: true, clearError: true);
    try {
      final justificante = await repository.registrarFicheros(
        citizenId: contexto.citizenId,
        documentNumber: contexto.documentNumber,
        expediente: contexto.expediente,
        inicio: contexto.inicio,
        documentos: documentos,
        representante: contexto.representante,
        cancelToken: _beginRegistro(),
      );
      if (!ref.mounted) {
        return null;
      }
      state = state.copyWith(cerrando: false);
      return (justificante: justificante, numexp: contexto.expediente.numexp);
    } on Object catch (error, stackTrace) {
      if (_esCancelacion(error)) {
        // Se abandonó la pantalla mientras se cerraba: no hay a quién avisar.
        return null;
      }
      logger.e('Error al finalizar el registro de la aportación', error: error, stackTrace: stackTrace);
      if (ref.mounted) {
        state = state.copyWith(cerrando: false);
        _publicarError(AportacionLoteErrorTipo.cierre, error);
      }
      return null;
    }
  }

  /// Documentos listos para `registrarfichero`. `null` si alguno no está
  /// subido: cada entrada necesita el hash que devolvió su subida, y solo un
  /// fichero `completado` lo tiene.
  List<({String nombre, String hash, int tamanioBytes})>? _documentosParaRegistro() {
    final documentos = <({String nombre, String hash, int tamanioBytes})>[];
    for (final archivo in state.archivos) {
      final hash = archivo.hash;
      if (archivo.estado != AportacionArchivoEstado.completado || hash == null) {
        return null;
      }
      documentos.add((nombre: archivo.nombre, hash: hash, tamanioBytes: archivo.tamanioBytes));
    }
    return documentos.isEmpty ? null : documentos;
  }

  // ── Cancelación ────────────────────────────────────────────────────────────

  /// Cancela todas las peticiones en curso —apertura, subidas y cierre—.
  ///
  /// La usa `ref.onDispose` para no dejar nada colgado si se abandona la
  /// pantalla: con un lote grande el backend puede tardar minutos en procesar
  /// el buzón, y la apertura la dispara ahora la simple selección de un
  /// fichero.
  void cancelarTodas() {
    _abandonado = true;
    for (final token in _cancelTokens.values) {
      token.cancel();
    }
    _cancelTokens.clear();
    _transaccionToken?.cancel();
    _transaccionToken = null;
    _registroToken?.cancel();
    _registroToken = null;
  }

  // ── Mutaciones de estado ───────────────────────────────────────────────────

  CancelToken _beginUpload(final String path) {
    final token = CancelToken();
    _cancelTokens[path] = token;
    _abortadasPorRed.remove(path);
    _updateArchivo(path, (final a) => a.copyWith(estado: AportacionArchivoEstado.enviando, progreso: 0));
    return token;
  }

  CancelToken _beginRegistro() {
    final token = CancelToken();
    _registroToken = token;
    return token;
  }

  void _updateProgreso(final String path, final double progreso) {
    _updateArchivo(path, (final a) => a.copyWith(progreso: progreso));
  }

  void _marcarCompletado(final String path, final String hash) {
    _cancelTokens.remove(path);
    _updateArchivo(path, (final a) => a.copyWith(estado: AportacionArchivoEstado.completado, clearProgreso: true, hash: hash));
  }

  void _marcarError(final String path) {
    _cancelTokens.remove(path);
    _updateArchivo(path, (final a) => a.copyWith(estado: AportacionArchivoEstado.error, clearProgreso: true, clearHash: true));
  }

  void _publicarError(final AportacionLoteErrorTipo tipo, final Object? error) {
    _secuenciaError++;
    state = state.copyWith(
      error: AportacionLoteError(tipo: tipo, secuencia: _secuenciaError, sesionCaducada: error is DioException && error.error is UnauthorizedError),
    );
  }

  void _updateArchivo(final String path, final AportacionArchivo Function(AportacionArchivo) update) {
    state = state.copyWith(
      archivos: [
        for (final archivo in state.archivos)
          if (archivo.path == path) update(archivo) else archivo,
      ],
    );
  }

  AportacionArchivo? _primerPendiente() {
    for (final archivo in state.archivos) {
      if (archivo.estado == AportacionArchivoEstado.noEnviado) {
        return archivo;
      }
    }
    return null;
  }

  bool _hasAllowedExtension(final String nombre) {
    final dotIndex = nombre.lastIndexOf('.');
    if (dotIndex == -1 || dotIndex == nombre.length - 1) {
      return false;
    }
    final extension = nombre.substring(dotIndex + 1).toLowerCase();
    return extensionesPermitidasAportacion.contains(extension);
  }
}

bool _esCancelacion(final Object error) => error is DioException && error.type == DioExceptionType.cancel;

/// Duplicado deliberadamente pequeño del helper de
/// `gestion_expedientes_provider.dart` — no amerita una abstracción compartida
/// para 10 líneas usadas en dos sitios.
String? _documentNumber(final JwtClaims? claims) {
  final candidates = [
    claims?.personIdentifier,
    claims?.preferredUsername,
    claims?.sub,
  ];
  for (final candidate in candidates) {
    final normalized = candidate?.trim();
    if (normalized != null && normalized.isNotEmpty) {
      return normalized;
    }
  }
  return null;
}

final gestionAportarDocumentacionProvider = NotifierProvider.autoDispose.family<GestionAportarDocumentacionNotifier, AportacionLote, ExpedienteDetailKey>(
  GestionAportarDocumentacionNotifier.new,
);
