import 'package:dio/dio.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/core/logger/logger.dart';
import 'package:jccm_espacio_ciudadano/core/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/jwt_claims.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/jwt_claims_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/aportacion_archivo.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/2_presentation/providers/gestion_aportar_documentacion_provider.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/2_presentation/providers/gestion_documento_provider.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/2_presentation/providers/gestion_expedientes_provider.dart';
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
/// **Integración de backend no verificada**: `procedimiento/subiradjuntosinfirma`
/// exige un `idunico` que ningún endpoint de lectura devuelve para un
/// expediente ya existente; aquí se autogenera como `{NIF}_{timestamp}` por
/// inferencia de los ejemplos del swagger, sin confirmación del backend.
class GestionAportarDocumentacionPage extends ConsumerWidget {
  const GestionAportarDocumentacionPage({required this.numexp, super.key});

  final String numexp;

  String get _decodedNumexp => Uri.decodeComponent(numexp);

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final archivos = ref.watch(gestionAportarDocumentacionProvider);
    final expedienteRoute = '${Routes.gestionExpedientes}/${Uri.encodeComponent(_decodedNumexp)}';
    final estaSubiendo = archivos.any((final a) => a.estado == AportacionArchivoEstado.enviando);

    void volverAlExpediente() {
      ref.read(gestionAportarDocumentacionProvider.notifier).cancelarTodas();
      context.go(expedienteRoute);
    }

    return Scaffold(
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

  /// Sube en paralelo todos los ficheros que no estén ya `completado`
  /// (`noEnviado` o `error` — así "Reintentar" en una tarjeta y "Registrar"
  /// comparten el mismo flujo, sin reenviar los ya completados).
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

    final documentNumber = _documentNumber(ref.read(jwtClaimsProvider));
    if (documentNumber == null) {
      AppAlertSnackbar.show(context, message: l10n.gestionAportarDocumentacionRegistroError, severity: AppAlertSeverity.error);
      return;
    }

    final String tipoProcedimiento;
    try {
      final expediente = await ref.read(expedienteDetailProvider(_decodedNumexp).future);
      tipoProcedimiento = expediente.tipoproc ?? '';
    } on Object catch (error, stackTrace) {
      logger.e('Error al obtener el expediente para aportar documentación', error: error, stackTrace: stackTrace);
      if (context.mounted) {
        AppAlertSnackbar.show(context, message: l10n.gestionAportarDocumentacionRegistroError, severity: AppAlertSeverity.error);
      }
      return;
    }

    final idUnico = '${documentNumber}_${DateTime.now().millisecondsSinceEpoch}';

    await Future.wait(
      pendientes.map(
        (final archivo) => _subirArchivo(
          ref: ref,
          archivo: archivo,
          documentNumber: documentNumber,
          idUnico: idUnico,
          tipoProcedimiento: tipoProcedimiento,
        ),
      ),
    );

    if (!context.mounted) {
      return;
    }

    final actuales = ref.read(gestionAportarDocumentacionProvider);
    if (actuales.any((final a) => a.estado == AportacionArchivoEstado.error)) {
      AppAlertSnackbar.show(context, message: l10n.gestionAportarDocumentacionUploadErrorParcial, severity: AppAlertSeverity.error);
      return;
    }

    await AppSuccessDialog.show(
      context,
      title: l10n.gestionAportarDocumentacionExitoTitulo,
      description: l10n.gestionAportarDocumentacionExitoDescripcion,
      secondaryLabel: l10n.gestionAportarDocumentacionCerrarSinDescargarButton,
      primaryLabel: l10n.gestionAportarDocumentacionDescargarJustificanteButton,
      onSecondary: () => context.go(expedienteRoute),
      onPrimary: () => AppAlertSnackbar.show(context, message: l10n.gestionSectionComingSoon),
    );
  }

  Future<void> _subirArchivo({
    required final WidgetRef ref,
    required final AportacionArchivo archivo,
    required final String documentNumber,
    required final String idUnico,
    required final String tipoProcedimiento,
  }) async {
    final notifier = ref.read(gestionAportarDocumentacionProvider.notifier);
    final repository = ref.read(gestionDocumentoRepositoryProvider);
    final token = notifier.beginUpload(archivo.path);

    try {
      final bytes = await XFile(archivo.path).readAsBytes();
      await repository.subirDocumentoSinFirma(
        documentNumber: documentNumber,
        idUnico: idUnico,
        tipoProcedimiento: tipoProcedimiento,
        nombreFichero: archivo.nombre,
        bytes: bytes,
        cancelToken: token,
        onProgress: (final progreso) => notifier.updateProgreso(archivo.path, progreso),
      );
      notifier.marcarCompletado(archivo.path);
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
