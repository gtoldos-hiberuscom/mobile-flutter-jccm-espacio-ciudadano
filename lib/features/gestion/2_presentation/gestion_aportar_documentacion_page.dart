import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/core/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/aportacion_archivo.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/2_presentation/providers/gestion_aportar_documentacion_provider.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Aportar documentación — Figma node 44242:24884.
class GestionAportarDocumentacionPage extends ConsumerWidget {
  const GestionAportarDocumentacionPage({required this.numexp, super.key});

  final String numexp;

  String get _decodedNumexp => Uri.decodeComponent(numexp);

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final archivos = ref.watch(gestionAportarDocumentacionProvider);
    final expedienteRoute = '${Routes.gestionExpedientes}/${Uri.encodeComponent(_decodedNumexp)}';

    return Scaffold(
      appBar: AppNavBar(
        type: AppNavBarType.detail,
        title: l10n.gestionAportarDocumentacionTitle,
        onBack: () => context.go(expedienteRoute),
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
                onPressed: () => context.go(expedienteRoute),
              ),
              AppButton(
                label: l10n.gestionAportarDocumentacionSeleccionarButton,
                hierarchy: AppButtonHierarchy.secondary,
                isExpanded: true,
                leadingIcon: AppIcons.upload,
                onPressed: () => _pickFiles(context, ref),
              ),
              AppButton(
                label: l10n.gestionAportarDocumentacionRegistrarButton,
                isExpanded: true,
                leadingIcon: AppIcons.check,
                onPressed: () => AppAlertSnackbar.show(
                  context,
                  message: l10n.gestionSectionComingSoon,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _pickFiles(final BuildContext context, final WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final selected = await openFiles(
      acceptedTypeGroups: const [
        XTypeGroup(label: 'documentos', extensions: extensionesPermitidasAportacion),
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
}

class _AportacionArchivoCard extends StatelessWidget {
  const _AportacionArchivoCard({required this.archivo, required this.onDelete});

  final AportacionArchivo archivo;
  final VoidCallback onDelete;

  @override
  Widget build(final BuildContext context) {
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
        status: AppFileUploadStatus.uploaded,
        onDelete: onDelete,
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
