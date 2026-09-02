import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/core/errors/app_error.dart';
import 'package:jccm_espacio_ciudadano/core/logger/logger.dart';
import 'package:jccm_espacio_ciudadano/core/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/jwt_claims.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/citizen_endpoint_ids_provider.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/jwt_claims_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/aportacion_archivo.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/expediente.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/inicio_procedimiento_resultado.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/representante.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/2_presentation/providers/gestion_aportar_documentacion_provider.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/2_presentation/providers/gestion_documento_provider.dart';
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

/// Aportar documentación — Figma node 44242:24884, subida en paralelo con
/// progreso (44198:64251) y diálogo de éxito (44242:24055).
///
/// **Integración de backend no verificada**: el flujo completo
/// (`procedimiento/inicproc` → `procedimiento/subiradjuntosinfirma` por
/// fichero → `documentacion/registrarfichero`) se ha inferido cruzando el
/// swagger del proyecto con el manual de integración público — ningún paso
/// se ha podido probar contra un backend real. `idunico` se autogenera como
/// `{NIF}_{timestamp}` y se sustituye por el que confirme `inicproc`.
class GestionAportarDocumentacionPage extends ConsumerWidget {
  const GestionAportarDocumentacionPage({required this.numexp, this.tercero, super.key});

  final String numexp;

  /// No nulo cuando se llega desde la búsqueda de un expediente ajeno — el
  /// documento del titular sustituye al del usuario autenticado para
  /// consultar el detalle e iniciar/registrar la aportación.
  final TerceroIdentificacion? tercero;

  String get _decodedNumexp => Uri.decodeComponent(numexp);

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final archivos = ref.watch(gestionAportarDocumentacionProvider);
    final expedienteRoute = '${Routes.gestionExpedientes}/${Uri.encodeComponent(_decodedNumexp)}';
    final estaSubiendo = archivos.any((final a) => a.estado == AportacionArchivoEstado.enviando);

    void volverAlExpediente() {
      ref.read(gestionAportarDocumentacionProvider.notifier).cancelarTodas();
      context.go(expedienteRoute, extra: tercero);
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
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.space16,
                vertical: AppDimensions.space8,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppAlertContextual(
                    message: l10n.gestionAportarDocumentacionHelperText,
                    size: AppAlertContextualSize.small,
                  ),
                  for (final archivo in archivos)
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppDimensions.space16),
                      child: _AportacionArchivoCard(
                        archivo: archivo,
                        onDelete: () => ref.read(gestionAportarDocumentacionProvider.notifier).removeArchivo(archivo.path),
                        onCancel: () => ref.read(gestionAportarDocumentacionProvider.notifier).cancelarSubida(archivo.path),
                        onRetry: () => _registrar(context, ref, archivos, expedienteRoute),
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
                onPressed: () => _pickFiles(context, ref, archivos),
              ),
              AppButton(
                label: l10n.gestionAportarDocumentacionRegistrarButton,
                isExpanded: true,
                leadingIcon: AppIcons.check,
                isLoading: estaSubiendo,
                onPressed: estaSubiendo ? null : () => _registrar(context, ref, archivos, expedienteRoute),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _pickFiles(final BuildContext context, final WidgetRef ref, final List<AportacionArchivo> archivosActuales) async {
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
    if (selected.isEmpty || !context.mounted) {
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
    if (!context.mounted) {
      return;
    }

    final result = ref.read(gestionAportarDocumentacionProvider.notifier).addArchivos(archivos);
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

  /// Orquesta el flujo completo: `iniciarProcedimiento` → subir en paralelo
  /// todos los ficheros que no estén ya `completado` (`noEnviado` o `error`
  /// — así "Reintentar" en una tarjeta y "Registrar" comparten el mismo
  /// flujo) → `registrarFicheros` para cerrar la transacción y obtener el
  /// justificante. Si `registrarFicheros` falla tras subir todo, se
  /// revierten todos los ficheros a `error` para reintentar la secuencia
  /// completa desde cero (ver riesgos conocidos en el plan de la
  /// iteración).
  Future<void> _registrar(
    final BuildContext context,
    final WidgetRef ref,
    final List<AportacionArchivo> archivos,
    final String expedienteRoute,
  ) async {
    final l10n = AppLocalizations.of(context);
    final pendientes = archivos.where((final a) => a.estado != AportacionArchivoEstado.completado).toList(growable: false);
    if (pendientes.isEmpty) {
      AppAlertSnackbar.show(context, message: l10n.gestionAportarDocumentacionNoFilesError, severity: AppAlertSeverity.error);
      return;
    }

    final claims = ref.read(jwtClaimsProvider);
    final documentNumber = tercero?.documentNumber ?? _documentNumber(claims);
    // `citizenId` va en el path /ciudadanos/{sid} (sub_alt contra el gateway);
    // `documentNumber` es el titular del expediente y viaja en el cuerpo.
    final citizenId = ref.read(citizenEndpointIdsProvider).idAgente;
    if (documentNumber == null || citizenId == null || citizenId.isEmpty) {
      AppAlertSnackbar.show(context, message: l10n.gestionAportarDocumentacionRegistroError, severity: AppAlertSeverity.error);
      return;
    }
    // No nulo solo al aportar a un expediente de terceros: identifica ante
    // el backend a quien presenta realmente la documentación (el usuario
    // autenticado), distinto del titular del expediente que va en
    // `documentNumber`.
    final representante = tercero == null
        ? null
        : Representante(
            nombre: claims?.givenName ?? '',
            apellido1: claims?.firstSurname ?? '',
            apellido2: claims?.secondSurname ?? '',
            nifcif: _documentNumber(claims) ?? '',
            tipodoc: 'NIF',
          );

    final Expediente expediente;
    try {
      expediente = await ref.read(expedienteDetailProvider((numexp: _decodedNumexp, tercero: tercero)).future);
    } on Object catch (error, stackTrace) {
      logger.e('Error al obtener el expediente para aportar documentación', error: error, stackTrace: stackTrace);
      if (context.mounted) {
        AppAlertSnackbar.show(context, message: _mensajeUsuarioError(l10n, l10n.gestionAportarDocumentacionRegistroError, error), severity: AppAlertSeverity.error);
      }
      return;
    }

    final repository = ref.read(gestionDocumentoRepositoryProvider);
    final InicioProcedimientoResultado inicio;
    try {
      final idUnicoLocal = '${documentNumber}_${DateTime.now().millisecondsSinceEpoch}';
      inicio = await repository.iniciarProcedimiento(citizenId: citizenId, idUnico: idUnicoLocal, documentNumber: documentNumber, expediente: expediente, representante: representante);
    } on Object catch (error, stackTrace) {
      logger.e('Error al iniciar el procedimiento de aportación', error: error, stackTrace: stackTrace);
      if (context.mounted) {
        AppAlertSnackbar.show(context, message: _mensajeUsuarioError(l10n, l10n.gestionAportarDocumentacionRegistroError, error), severity: AppAlertSeverity.error);
      }
      return;
    }

    // De una en una, no en paralelo: el plazo de cada subida está dimensionado
    // por el tamaño de ESE fichero, y cinco subidas simultáneas comparten el
    // mismo enlace, así que con ficheros grandes ninguna llegaría a tiempo
    // (5 × 20 MB son ~133 MB en base64 por el mismo tubo). En serie el tiempo
    // total es el mismo — lo limita el ancho de banda, no la concurrencia —,
    // cada plazo es el que corresponde y solo hay un fichero codificado en
    // memoria a la vez.
    for (final archivo in pendientes) {
      await _subirArchivo(
        ref: ref,
        archivo: archivo,
        citizenId: citizenId,
        documentNumber: documentNumber,
        idUnico: inicio.idunico,
        tipoProcedimiento: expediente.tipoproc ?? '',
      );
    }

    if (!context.mounted) {
      return;
    }

    final actuales = ref.read(gestionAportarDocumentacionProvider);
    final notifier = ref.read(gestionAportarDocumentacionProvider.notifier);
    // Registrar exige que TODOS los ficheros estén subidos, no solo que
    // ninguno haya fallado: un fichero cancelado a mitad de la subida se queda
    // en `noEnviado` y sin hash, y pasaba esta comprobación cuando solo miraba
    // `error`, para reventar después al construir el cuerpo.
    final documentos = _documentosParaRegistro(actuales);
    if (documentos == null) {
      // Este intento muere aquí, así que los hashes que sí se obtuvieron dejan
      // de servir (pertenecen a este `idunico`): se descartan y el siguiente
      // registro vuelve a subir todos los ficheros.
      final huboError = actuales.any((final a) => a.estado == AportacionArchivoEstado.error);
      notifier.reiniciarSubidas();
      AppAlertSnackbar.show(
        context,
        message: huboError ? l10n.gestionAportarDocumentacionUploadErrorParcial : l10n.gestionAportarDocumentacionUploadIncompleto,
        severity: AppAlertSeverity.error,
      );
      return;
    }

    final Uint8List justificante;
    try {
      justificante = await repository.registrarFicheros(
        citizenId: citizenId,
        documentNumber: documentNumber,
        expediente: expediente,
        inicio: inicio,
        documentos: documentos,
        representante: representante,
      );
    } on Object catch (error, stackTrace) {
      logger.e('Error al finalizar el registro de la aportación', error: error, stackTrace: stackTrace);
      notifier.marcarErrorTodos();
      if (context.mounted) {
        AppAlertSnackbar.show(context, message: _mensajeUsuarioError(l10n, l10n.gestionAportarDocumentacionFinalizacionError, error), severity: AppAlertSeverity.error);
      }
      return;
    }

    if (!context.mounted) {
      return;
    }

    // Bucle deliberado: los callbacks del diálogo solo registran la elección
    // (AppSuccessDialog se auto-cierra antes de invocarlos) y la acción se
    // ejecuta cuando `show` resuelve. Si el usuario cancela el selector de
    // guardado (o falla la escritura) se reabre el diálogo, porque el
    // justificante solo existe en memoria y no se puede recuperar después.
    while (context.mounted) {
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
      if (!context.mounted) {
        return;
      }
      if (!descargar) {
        context.go(expedienteRoute, extra: tercero);
        return;
      }
      final guardado = await _descargarJustificante(context, justificante, expediente.numexp);
      if (!context.mounted) {
        return;
      }
      if (guardado) {
        context.go(expedienteRoute, extra: tercero);
        return;
      }
    }
  }

  Future<void> _subirArchivo({
    required final WidgetRef ref,
    required final AportacionArchivo archivo,
    required final String citizenId,
    required final String documentNumber,
    required final String idUnico,
    required final String tipoProcedimiento,
  }) async {
    final notifier = ref.read(gestionAportarDocumentacionProvider.notifier);
    final repository = ref.read(gestionDocumentoRepositoryProvider);
    final token = notifier.beginUpload(archivo.path);

    try {
      final bytes = await XFile(archivo.path).readAsBytes();
      final hash = await repository.subirDocumentoSinFirma(
        citizenId: citizenId,
        documentNumber: documentNumber,
        idUnico: idUnico,
        tipoProcedimiento: tipoProcedimiento,
        nombreFichero: archivo.nombre,
        bytes: bytes,
        cancelToken: token,
        onProgress: (final progreso) => notifier.updateProgreso(archivo.path, progreso),
      );
      notifier.marcarCompletado(archivo.path, hash);
    } on DioException catch (error, stackTrace) {
      if (error.type == DioExceptionType.cancel) {
        // Cancelación manual del usuario — `cancelarSubida` ya revirtió el
        // estado a `noEnviado`; no se trata como error.
        return;
      }
      logger.e('Error al subir ${archivo.nombre}', error: error, stackTrace: stackTrace);
      notifier.marcarError(archivo.path);
    } on Object catch (error, stackTrace) {
      logger.e('Error al subir ${archivo.nombre}', error: error, stackTrace: stackTrace);
      notifier.marcarError(archivo.path);
    }
  }

  /// Guarda el justificante ya obtenido (por `registrarFicheros`) mediante el
  /// selector nativo de destino — no hace ninguna llamada de red nueva.
  ///
  /// Se usa `FilePicker.saveFile` (y no `getSaveLocation` de `file_selector`)
  /// porque este último no está implementado en Android/iOS: en móvil lanza
  /// `UnimplementedError` sin mostrar selector alguno. `FilePicker.saveFile`
  /// abre el selector SAF en Android y el export picker de Archivos en iOS,
  /// y en ambos casos escribe los bytes por sí mismo.
  ///
  /// Devuelve `true` si el fichero quedó guardado; `false` si el usuario
  /// canceló el selector o falló la escritura (el llamador reabre el diálogo).
  Future<bool> _descargarJustificante(
    final BuildContext context,
    final Uint8List bytes,
    final String numexp,
  ) async {
    final l10n = AppLocalizations.of(context);
    try {
      final ruta = await FilePicker.saveFile(
        dialogTitle: l10n.gestionAportarDocumentacionDescargarJustificanteButton,
        fileName: _nombreFicheroJustificante(numexp),
        type: FileType.custom,
        allowedExtensions: const ['pdf'],
        bytes: bytes,
      );
      if (ruta == null) {
        // El usuario canceló el selector nativo.
        return false;
      }
      // En Android/iOS el plugin ya escribió los bytes; en escritorio (solo
      // entorno de desarrollo) devuelve la ruta sin escribir el fichero.
      if (!Platform.isAndroid && !Platform.isIOS) {
        await File(ruta).writeAsBytes(bytes);
      }
      if (context.mounted) {
        AppAlertToast.show(context, message: l10n.gestionAportarDocumentacionJustificanteDescargado, severity: AppAlertSeverity.success);
      }
      return true;
    } on Object catch (error, stackTrace) {
      logger.e('Error al guardar el justificante', error: error, stackTrace: stackTrace);
      if (context.mounted) {
        AppAlertSnackbar.show(context, message: l10n.gestionAportarDocumentacionJustificanteError, severity: AppAlertSeverity.error);
      }
      return false;
    }
  }

  /// Documentos listos para `registrarfichero`, o `null` si alguno no está
  /// subido: cada entrada necesita el hash que devolvió su subida y solo un
  /// fichero `completado` lo tiene.
  List<({String nombre, String hash, int tamanioBytes})>? _documentosParaRegistro(final List<AportacionArchivo> archivos) {
    final documentos = <({String nombre, String hash, int tamanioBytes})>[];
    for (final archivo in archivos) {
      final hash = archivo.hash;
      if (archivo.estado != AportacionArchivoEstado.completado || hash == null) {
        return null;
      }
      documentos.add((nombre: archivo.nombre, hash: hash, tamanioBytes: archivo.tamanioBytes));
    }
    return documentos;
  }

  /// `numexp` contiene `/` (ej. `WMEQ/2026/000002`), inválido en un nombre de
  /// fichero — se sustituye todo carácter fuera de `[A-Za-z0-9._-]`.
  String _nombreFicheroJustificante(final String numexp) => 'justificante_${numexp.replaceAll(RegExp('[^A-Za-z0-9._-]'), '_')}.pdf';
}

/// Duplicado deliberadamente pequeño del helper de
/// `gestion_expedientes_provider.dart` — no amerita una abstracción
/// compartida para 10 líneas usadas en dos sitios.
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

class _AportacionArchivoCard extends StatelessWidget {
  const _AportacionArchivoCard({
    required this.archivo,
    required this.onDelete,
    required this.onCancel,
    required this.onRetry,
  });

  final AportacionArchivo archivo;
  final VoidCallback onDelete;
  final VoidCallback onCancel;
  final VoidCallback onRetry;

  @override
  Widget build(final BuildContext context) {
    final status = switch (archivo.estado) {
      AportacionArchivoEstado.noEnviado => AppFileUploadStatus.uploaded,
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
        progress: archivo.progreso,
        onDelete: onDelete,
        onCancel: onCancel,
        onRetry: onRetry,
      ),
    );
  }

  String _formatFileInfo(final int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    }
    final kb = bytes / 1024;
    if (kb < 1024) {
      return '${kb.toStringAsFixed(kb >= 100 ? 0 : 1)} KB';
    }
    final mb = kb / 1024;
    return '${mb.toStringAsFixed(mb >= 100 ? 0 : 1)} MB';
  }
}

/// Devuelve un mensaje orientado al usuario final, segmentando por tipo de
/// error. SOLO se exponen mensajes curados y seguros (p.ej. sesión caducada);
/// NUNCA el detalle interno del error —`StateError` de la aplicación, el
/// `mensaje`/cuerpo técnico del backend (BAC) o las excepciones de transporte
/// de Dio—, que revelaría información interna del sistema. Ese detalle sigue
/// registrándose en los logs (`logger.e`) para depuración, no en la UI.
String _mensajeUsuarioError(final AppLocalizations l10n, final String base, final Object error) {
  if (error is DioException && error.error is UnauthorizedError) {
    return l10n.sessionExpired;
  }
  return base;
}
