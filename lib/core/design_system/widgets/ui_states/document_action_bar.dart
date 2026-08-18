import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// A row of document action icon-buttons (open, download, share).
///
/// Only renders buttons for non-null callbacks.
class DocumentActionBar extends StatelessWidget {
  const DocumentActionBar({
    required this.documentName,
    super.key,
    this.onOpen,
    this.onDownload,
    this.onShare,
    this.isLoading = false,
    this.documentSemanticLabel,
  }) : assert(documentName != '', 'documentName must not be empty'),
       assert(
         documentSemanticLabel == null || documentSemanticLabel != '',
         'documentSemanticLabel must not be empty',
       );

  final String documentName;
  final VoidCallback? onOpen;
  final VoidCallback? onDownload;
  final VoidCallback? onShare;

  /// Optional spoken form of [documentName] for technical file names.
  final String? documentSemanticLabel;

  /// When true replaces the action icons with a small adaptive spinner.
  final bool isLoading;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final accessibleDocumentName = documentSemanticLabel ?? documentName;

    if (isLoading) {
      return Semantics(
        container: true,
        excludeSemantics: true,
        liveRegion: true,
        label: '${l10n.a11yLoading}: $accessibleDocumentName',
        child: const SizedBox.square(
          dimension: 48,
          child: Padding(
            padding: EdgeInsets.all(12),
            child: CircularProgressIndicator.adaptive(strokeWidth: 2),
          ),
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (onOpen != null)
          Semantics(
            container: true,
            excludeSemantics: true,
            label: '${l10n.documentOpen}: $accessibleDocumentName',
            button: true,
            enabled: true,
            onTap: onOpen,
            child: IconButton(
              icon: const Icon(Icons.open_in_new),
              onPressed: onOpen,
              tooltip: l10n.documentOpen,
            ),
          ),
        if (onDownload != null)
          Semantics(
            container: true,
            excludeSemantics: true,
            label: '${l10n.documentDownload}: $accessibleDocumentName',
            button: true,
            enabled: true,
            onTap: onDownload,
            child: IconButton(
              icon: const Icon(Icons.download_outlined),
              onPressed: onDownload,
              tooltip: l10n.documentDownload,
            ),
          ),
        if (onShare != null)
          Semantics(
            container: true,
            excludeSemantics: true,
            label: '${l10n.documentShare}: $accessibleDocumentName',
            button: true,
            enabled: true,
            onTap: onShare,
            child: IconButton(
              icon: const Icon(Icons.share_outlined),
              onPressed: onShare,
              tooltip: l10n.documentShare,
            ),
          ),
      ],
    );
  }
}
