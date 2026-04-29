import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/features/casework/uploads/2_presentation/upload_evidence_section.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Standalone routed page wrapping [UploadEvidenceSection].
///
/// Bound to `Routes.caseworkUpload` (`/casework/item/:id/upload`).
class UploadEvidencePage extends StatelessWidget {
  const UploadEvidencePage({required this.expedienteRef, super.key});

  final String expedienteRef;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.caseworkUploadPageTitle)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: UploadEvidenceSection(expedienteRef: expedienteRef),
        ),
      ),
    );
  }
}
