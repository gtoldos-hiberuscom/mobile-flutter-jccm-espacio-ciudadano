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

/// Aportar documentación — Figma node 44242:24884.
///
/// **Integración de backend no verificada**: `procedimiento/subiradjuntosinfirma`
/// exige un `idunico` que ningún endpoint de lectura devuelve para un
/// expediente ya existente; aquí se autogenera como `{NIF}_{timestamp}` por
/// inferencia de los ejemplos del swagger, sin confirmación del backend.
class GestionAportarDocumentacionPage extends ConsumerStatefulWidget {
  const GestionAportarDocumentacionPage({required this.numexp, super.key});

  final String numexp;

  @override
  ConsumerState<GestionAportarDocumentacionPage> createState() => _GestionAportarDocumentacionPageState();
}

class _GestionAportarDocumentacionPageState extends ConsumerState<GestionAportarDocumentacionPage> {
  bool _isRegistering = false;

  String get _decodedNumexp => Uri.decodeComponent(widget.numexp);

  @override
  Widget build(final BuildContext context) {
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
                onPressed: () => _pickFiles(archivos),
              ),
              AppButton(
                label: l10n.gestionAportarDocumentacionRegistrarButton,
                isExpanded: true,
                leadingIcon: AppIcons.check,
                isLoading: _isRegistering,
                onPressed: _isRegistering ? null : () => _registrar(archivos, expedienteRoute),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _pickFiles(final List<AportacionArchivo> archivosActuales) async {
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

  Future<void> _registrar(final List<AportacionArchivo> archivos, final String expedienteRoute) async {
    final l10n = AppLocalizations.of(context);
    if (archivos.isEmpty) {
      AppAlertSnackbar.show(context, message: l10n.gestionAportarDocumentacionNoFilesError, severity: AppAlertSeverity.error);
      return;
    }

    final documentNumber = _documentNumber(ref.read(jwtClaimsProvider));
    if (documentNumber == null) {
      AppAlertSnackbar.show(context, message: l10n.gestionAportarDocumentacionRegistroError, severity: AppAlertSeverity.error);
      return;
    }

    setState(() => _isRegistering = true);
    try {
      final expediente = await ref.read(expedienteDetailProvider(_decodedNumexp).future);
      final tipoProcedimiento = expediente.tipoproc ?? '';
      final idUnico = '${documentNumber}_${DateTime.now().millisecondsSinceEpoch}';
      final repository = ref.read(gestionDocumentoRepositoryProvider);

      for (final archivo in archivos) {
        final bytes = await XFile(archivo.path).readAsBytes();
        await repository.subirDocumentoSinFirma(
          documentNumber: documentNumber,
          idUnico: idUnico,
          tipoProcedimiento: tipoProcedimiento,
          nombreFichero: archivo.nombre,
          bytes: bytes,
        );
      }

      if (!mounted) {
        return;
      }
      AppAlertSnackbar.show(context, message: l10n.gestionAportarDocumentacionRegistroSuccess, severity: AppAlertSeverity.success);
      context.go(expedienteRoute);
    } on Object catch (error, stackTrace) {
      logger.e('Error al registrar documentación aportada', error: error, stackTrace: stackTrace);
      if (mounted) {
        AppAlertSnackbar.show(context, message: l10n.gestionAportarDocumentacionRegistroError, severity: AppAlertSeverity.error);
      }
    } finally {
      if (mounted) {
        setState(() => _isRegistering = false);
      }
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
