import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// A row of document action icon-buttons (open, download, share).
///
/// Only renders buttons for non-null callbacks.
class DocumentActionBar extends StatelessWidget {
  const DocumentActionBar({
    super.key,
    required this.documentName,
    this.onOpen,
    this.onDownload,
    this.onShare,
    this.isLoading = false,
  });

  final String documentName;
  final VoidCallback? onOpen;
  final VoidCallback? onDownload;
  final VoidCallback? onShare;

  /// When true replaces the action icons with a small adaptive spinner.
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (isLoading) {
      return const Padding(
        padding: EdgeInsets.all(8),
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator.adaptive(strokeWidth: 2),
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (onOpen != null)
          Semantics(
            label: '${l10n.documentOpen}: $documentName',
            button: true,
            child: IconButton(
              icon: const Icon(Icons.open_in_new),
              onPressed: onOpen,
              tooltip: l10n.documentOpen,
            ),
          ),
        if (onDownload != null)
          Semantics(
            label: '${l10n.documentDownload}: $documentName',
            button: true,
            child: IconButton(
              icon: const Icon(Icons.download_outlined),
              onPressed: onDownload,
              tooltip: l10n.documentDownload,
            ),
          ),
        if (onShare != null)
          Semantics(
            label: '${l10n.documentShare}: $documentName',
            button: true,
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
