import 'dart:typed_data';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/core/files/file_save.dart';
import 'package:jccm_espacio_ciudadano/core/logger/logger.dart';
import 'package:jccm_espacio_ciudadano/core/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/aportacion_archivo.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/aportacion_lote.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/2_presentation/providers/gestion_aportar_documentacion_provider.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/2_presentation/providers/gestion_expedientes_provider.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/2_presentation/tercero_identificacion.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// UTIs de iOS para las extensiones permitidas — `file_selector_ios` ignora
/// `extensions` por completo y exige `uniformTypeIdentifiers` explícitos,
/// o lanza un `ArgumentError` antes de abrir el picker nativo.
const List<String> _iosUniformTypeIdentifiersAportacion = [
  'com.adobe.pdf',
  'com.microsoft.word.doc',
  'org.openxmlformats.wordprocessingml.document', // .docx
  'com.microsoft.excel.xls',
  'org.openxmlformats.spreadsheetml.sheet', // .xlsx
  'public.zip-archive',
];

/// Aportar documentación — Figma node 44242:24884, subida con progreso
/// (44198:64251) y diálogo de éxito (44242:24055).
///
/// Sigue el modelo de la web: **la subida arranca al seleccionar**, no al
/// registrar, y cancelar, reintentar o eliminar actúan solo sobre su fichero.
/// La orquestación entera —abrir la transacción, la cola de subidas y el
/// cierre— vive en `GestionAportarDocumentacionNotifier`, porque la cola
/// avanza sin que nadie pulse nada. Aquí quedan el selector de ficheros, los
/// avisos curados y el justificante.
///
/// **Integración de backend no verificada**: el flujo completo
/// (`procedimiento/inicproc` → `procedimiento/subiradjuntosinfirma` por
/// fichero → `documentacion/registrarfichero`) se ha inferido cruzando el
/// swagger del proyecto con el manual de integración público — ningún paso
/// se ha podido probar contra un backend real. Se asume además que
/// `registrarfichero` registra lo que se le lista en `documentos` y no el
/// buzón entero (ver los riesgos del plan de la iteración).
class GestionAportarDocumentacionPage extends ConsumerStatefulWidget {
  const GestionAportarDocumentacionPage({required this.numexp, this.tercero, super.key});

  final String numexp;

  /// No nulo cuando se llega desde la búsqueda de un expediente ajeno — el
  /// documento del titular sustituye al del usuario autenticado para
  /// consultar el detalle e iniciar/registrar la aportación.
  final TerceroIdentificacion? tercero;

  @override
  ConsumerState<GestionAportarDocumentacionPage> createState() => _GestionAportarDocumentacionPageState();
}

class _GestionAportarDocumentacionPageState extends ConsumerState<GestionAportarDocumentacionPage> {
  String get _decodedNumexp => Uri.decodeComponent(widget.numexp);

  /// Misma clave con la que se consulta el detalle: no mezcla en caché la
  /// aportación a un expediente propio con la de un tercero.
  ExpedienteDetailKey get _key => (numexp: _decodedNumexp, tercero: widget.tercero);

  String get _expedienteRoute => '${Routes.gestionExpedientes}/${Uri.encodeComponent(_decodedNumexp)}';

  /// Se captura al montar para poder detener la cola en [dispose]: ahí `ref` ya
  /// no es utilizable, y esperar a que Riverpod libere el provider
  /// `autoDispose` llega tarde —esa liberación se agenda para más tarde y en
  /// esa ventana la cola alcanza a subir otro fichero al buzón de una
  /// transacción que nadie va a cerrar.
  late final GestionAportarDocumentacionNotifier _notifier;

  @override
  void initState() {
    super.initState();
    _notifier = ref.read(gestionAportarDocumentacionProvider(_key).notifier);
  }

  @override
  void dispose() {
    _notifier.cancelarTodas();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final lote = ref.watch(gestionAportarDocumentacionProvider(_key));

    // Solo se anuncian los fallos que ninguna tarjeta explica por sí sola
    // —abrir o cerrar la transacción— y, una vez por pasada de la cola, que
    // algún fichero no llegó: el detalle de cada subida ya se ve en su propia
    // tarjeta. `secuencia` cambia en cada fallo, así que reintentar el cierre
    // y que vuelva a fallar avisa otra vez en vez de callarse porque el error
    // «no ha cambiado».
    ref.listen(gestionAportarDocumentacionProvider(_key).select((final estado) => estado.error), (final previo, final actual) {
      if (actual == null || !mounted) {
        return;
      }
      AppAlertSnackbar.show(context, message: _mensajeError(l10n, actual), severity: AppAlertSeverity.error);
    });

    void volverAlExpediente() {
      _notifier.cancelarTodas();
      context.go(_expedienteRoute, extra: widget.tercero);
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppNavBar(
        type: AppNavBarType.detail,
        title: l10n.gestionAportarDocumentacionTitle,
        onBack: volverAlExpediente,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: appPageHorizontalPadding(context),
                vertical: AppDimensions.space8,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppAlertContextual(
                    message: l10n.gestionAportarDocumentacionHelperText,
                    size: AppAlertContextualSize.small,
                  ),
                  for (final archivo in lote.archivos)
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppDimensions.space16),
                      child: _AportacionArchivoCard(
                        archivo: archivo,
                        // Las tres acciones de retirada son la misma: sacarlo
                        // del lote. Cancelar una subida en curso lo retira
                        // igual —dejar la fila en el limbo, seleccionada pero
                        // sin que la cola la vaya a reintentar, bloquearía
                        // Registrar—, y el que ya está subido solo desaparece
                        // de `documentos`, dejando su adjunto huérfano en el
                        // buzón.
                        onDelete: lote.puedeEditarLista ? () => _notifier.removeArchivo(archivo.path) : null,
                        onCancel: lote.puedeEditarLista ? () => _notifier.removeArchivo(archivo.path) : null,
                        onRemove: lote.puedeEditarLista ? () => _notifier.removeArchivo(archivo.path) : null,
                        onRetry: lote.puedeEditarLista ? () => _notifier.reintentarArchivo(archivo.path) : null,
                      ),
                    ),
                ],
              ),
            ),
          ),
          AppStickybar(
            children: [
              AppButton(
                label: l10n.gestionAportarDocumentacionCancelarButton,
                hierarchy: AppButtonHierarchy.tertiary,
                isExpanded: true,
                leadingIcon: AppIcons.cancel,
                onPressed: volverAlExpediente,
              ),
              AppButton(
                label: l10n.gestionAportarDocumentacionSeleccionarButton,
                hierarchy: AppButtonHierarchy.secondary,
                isExpanded: true,
                leadingIcon: AppIcons.upload,
                onPressed: _pickFiles,
              ),
              // Como en la web, no se ofrece registrar sin documentos; y
              // mientras algo sube se muestra deshabilitado, porque cada
              // entrada de `documentos` necesita el hash de su subida. Con la
              // cola parada y ficheros en error sí se habilita: reintenta los
              // fallidos y cierra si llegan todos.
              if (lote.archivos.isNotEmpty)
                AppButton(
                  label: l10n.gestionAportarDocumentacionRegistrarButton,
                  isExpanded: true,
                  leadingIcon: AppIcons.check,
                  isLoading: lote.cerrando || lote.reintentandoParaRegistrar,
                  onPressed: lote.puedeRegistrar || lote.puedeReintentarYRegistrar ? _registrar : null,
                ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _pickFiles() async {
    final l10n = AppLocalizations.of(context);
    final selected = await openFiles(
      acceptedTypeGroups: const [
        XTypeGroup(
          label: 'documentos',
          extensions: extensionesPermitidasAportacion,
          uniformTypeIdentifiers: _iosUniformTypeIdentifiersAportacion,
        ),
      ],
    );
    if (selected.isEmpty || !mounted) {
      return;
    }

    final archivos = await Future.wait(
      selected.map(
        (final file) async => AportacionArchivo(
          path: file.path,
          nombre: file.name,
          tamanioBytes: await file.length(),
        ),
      ),
    );
    if (!mounted) {
      return;
    }

    // `addArchivos` arranca la subida por su cuenta: el ciudadano no tiene que
    // pulsar nada más para que empiece.
    final result = _notifier.addArchivos(archivos);
    final message = switch (result) {
      AddArchivosAdded() => null,
      AddArchivosRejectedTooMany() => l10n.gestionAportarDocumentacionMaxFilesError,
      AddArchivosRejectedTooLarge() => l10n.gestionAportarDocumentacionMaxSizeError,
      AddArchivosRejectedInvalidType() => l10n.gestionAportarDocumentacionInvalidTypeError,
      AddArchivosRejectedDuplicate() => l10n.gestionAportarDocumentacionDuplicateError,
    };
    if (message != null) {
      AppAlertSnackbar.show(context, message: message, severity: AppAlertSeverity.error);
    }
  }

  /// Cierra la transacción y, si quedó registrada, ofrece el justificante.
  ///
  /// Un cierre fallido lo publica el notifier —conservando los hashes, así que
  /// volver a pulsar reintenta solo el cierre— y lo pinta el `ref.listen` de
  /// [build]: aquí solo queda el camino de éxito.
  Future<void> _registrar() async {
    final resultado = await _notifier.registrar();
    if (resultado == null || !mounted) {
      return;
    }
    await _mostrarExitoYDescargar(resultado.justificante, resultado.numexp);
  }

  /// Diálogo de éxito y descarga del justificante, ya obtenido: aquí no hay
  /// ninguna llamada de red al backend.
  Future<void> _mostrarExitoYDescargar(final Uint8List justificante, final String numexp) async {
    final l10n = AppLocalizations.of(context);
    // Bucle deliberado: los callbacks del diálogo solo registran la elección
    // (AppSuccessDialog se auto-cierra antes de invocarlos) y la acción se
    // ejecuta cuando `show` resuelve. Si el usuario cancela el selector de
    // guardado (o falla la escritura) se reabre el diálogo, porque el
    // justificante solo existe en memoria y no se puede recuperar después.
    while (mounted) {
      var descargar = false;
      await AppSuccessDialog.show(
        context,
        title: l10n.gestionAportarDocumentacionExitoTitulo,
        description: l10n.gestionAportarDocumentacionExitoDescripcion,
        secondaryLabel: l10n.gestionAportarDocumentacionCerrarSinDescargarButton,
        primaryLabel: l10n.gestionAportarDocumentacionDescargarJustificanteButton,
        onSecondary: () {},
        onPrimary: () => descargar = true,
      );
      if (!mounted) {
        return;
      }
      if (!descargar) {
        context.go(_expedienteRoute, extra: widget.tercero);
        return;
      }
      final guardado = await _descargarJustificante(justificante, numexp);
      if (!mounted) {
        return;
      }
      if (guardado) {
        context.go(_expedienteRoute, extra: widget.tercero);
        return;
      }
    }
  }

  /// Guarda el justificante ya obtenido (por `registrarFicheros`) mediante el
  /// selector nativo de destino — no hace ninguna llamada de red nueva.
  ///
  /// Devuelve `true` si el fichero quedó guardado; `false` si el usuario
  /// canceló el selector o falló la escritura (el llamador reabre el diálogo).
  Future<bool> _descargarJustificante(final Uint8List bytes, final String numexp) async {
    final l10n = AppLocalizations.of(context);
    try {
      final ruta = await saveBytesWithPicker(
        bytes: bytes,
        fileName: _nombreFicheroJustificante(numexp),
        dialogTitle: l10n.gestionAportarDocumentacionDescargarJustificanteButton,
      );
      if (ruta == null) {
        // El usuario canceló el selector nativo.
        return false;
      }
      if (mounted) {
        AppAlertToast.show(context, message: l10n.gestionAportarDocumentacionJustificanteDescargado, severity: AppAlertSeverity.success);
      }
      return true;
    } on Object catch (error, stackTrace) {
      logger.e('Error al guardar el justificante', error: error, stackTrace: stackTrace);
      if (mounted) {
        AppAlertSnackbar.show(context, message: l10n.gestionAportarDocumentacionJustificanteError, severity: AppAlertSeverity.error);
      }
      return false;
    }
  }

  /// Mensaje curado para un fallo del lote.
  ///
  /// SOLO se exponen mensajes orientados al ciudadano (p. ej. sesión
  /// caducada); NUNCA el detalle interno —`StateError` de la aplicación, el
  /// cuerpo técnico del backend (BAC) o las excepciones de transporte de
  /// Dio—, que revelaría información interna del sistema. Ese detalle se
  /// queda en los logs del notifier (`logger.e`), no en la UI.
  String _mensajeError(final AppLocalizations l10n, final AportacionLoteError error) {
    if (error.sesionCaducada) {
      return l10n.sessionExpired;
    }
    return switch (error.tipo) {
      AportacionLoteErrorTipo.aperturaTransaccion => l10n.gestionAportarDocumentacionRegistroError,
      AportacionLoteErrorTipo.cierre => l10n.gestionAportarDocumentacionFinalizacionError,
      AportacionLoteErrorTipo.subidaParcial => l10n.gestionAportarDocumentacionUploadErrorParcial,
    };
  }

  /// `numexp` contiene `/` (ej. `WMEQ/2026/000002`), inválido en un nombre de
  /// fichero — se sustituye todo carácter fuera de `[A-Za-z0-9._-]`.
  String _nombreFicheroJustificante(final String numexp) => 'justificante_${numexp.replaceAll(RegExp('[^A-Za-z0-9._-]'), '_')}.pdf';
}

/// Tope de la barra mientras se envía: el último tramo lo reserva la espera
/// del hash.
///
/// Con el cuerpo ya enviado, el servidor todavía tiene que procesar el adjunto
/// y devolver su hash —con 20 MB, un buen rato—. Pintar el 100 % entonces daba
/// la subida por terminada cuando aún podía fallar; el 100 % llega solo con el
/// hash, al pasar a «Subido», que es cuando el fichero se puede eliminar.
const double _topeProgresoEnvio = 0.9;

class _AportacionArchivoCard extends StatelessWidget {
  const _AportacionArchivoCard({
    required this.archivo,
    required this.onDelete,
    required this.onCancel,
    required this.onRemove,
    required this.onRetry,
  });

  final AportacionArchivo archivo;
  final VoidCallback? onDelete;
  final VoidCallback? onCancel;
  final VoidCallback? onRemove;
  final VoidCallback? onRetry;

  @override
  Widget build(final BuildContext context) {
    final status = switch (archivo.estado) {
      // Un fichero sin enviar (recién elegido o tras abortarse el lote) se
      // anuncia «Seleccionado»: mapearlo a `uploaded` lo anunciaba «Subido»
      // junto al snackbar rojo de «falta algún fichero por enviar» (AP-7).
      AportacionArchivoEstado.noEnviado => AppFileUploadStatus.pending,
      AportacionArchivoEstado.enviando => AppFileUploadStatus.uploading,
      AportacionArchivoEstado.completado => AppFileUploadStatus.complete,
      AportacionArchivoEstado.error => AppFileUploadStatus.error,
    };

    return Container(
      padding: const EdgeInsets.all(AppDimensions.space16),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(color: AppColors.borderBlueMutedLight),
          right: BorderSide(color: AppColors.borderBlueMutedLight),
          bottom: BorderSide(color: AppColors.borderBlueMutedLight),
          left: BorderSide(color: AppColors.borderBlueMutedLight, width: 4),
        ),
      ),
      child: AppFileUpload(
        fileName: archivo.nombre,
        fileInfo: _formatFileInfo(archivo.tamanioBytes),
        status: status,
        progress: switch (archivo.progreso) {
          final progreso? => progreso * _topeProgresoEnvio,
          null => null,
        },
        onDelete: onDelete,
        onCancel: onCancel,
        onRemove: onRemove,
        onRetry: onRetry,
      ),
    );
  }

  /// Unidades decimales, como iOS en Archivos y como el límite
  /// `maxTamanioBytesAportacion`: el tamaño de la tarjeta tiene que coincidir
  /// con el que el ciudadano vio al elegir el fichero.
  String _formatFileInfo(final int bytes) {
    if (bytes < 1000) {
      return '$bytes B';
    }
    final kb = bytes / 1000;
    if (kb < 1000) {
      return '${kb.toStringAsFixed(kb >= 100 ? 0 : 1)} KB';
    }
    final mb = kb / 1000;
    return '${mb.toStringAsFixed(mb >= 100 ? 0 : 1)} MB';
  }
}
