/// Digital cards exporters (EPIC-7 / STORY-52) — presentation.
library;

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/app/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/exporters/0_entity/binary_artifact_kind.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Lightweight preview placeholder for a binary artifact.
///
/// - PDF / PKPass → icon + label (no embedded viewer in MVP).
/// - PNG          → `Image.memory` with the decoded bytes.
/// - QR text      → fallback `Text` rendering the payload (a real QR
///                   widget is deferred to STORY-49/50/51 once the
///                   `qr_flutter` dependency is added — see TODO).
///
/// Pure widget — no state, no providers, no side effects.
class BinaryArtifactPreview extends StatelessWidget {
  const BinaryArtifactPreview({
    required this.kind,
    this.bytes,
    this.text,
    super.key,
  });

  final BinaryArtifactKind kind;

  /// Required for [BinaryArtifactKind.png]; ignored otherwise.
  final Uint8List? bytes;

  /// Required for [BinaryArtifactKind.qrText]; ignored otherwise.
  final String? text;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return switch (kind) {
      BinaryArtifactKind.pdf => _IconPlaceholder(
        icon: Icons.picture_as_pdf,
        label: l10n.walletPreviewPdfPlaceholder,
        theme: theme,
      ),
      BinaryArtifactKind.pkpass => _IconPlaceholder(
        icon: Icons.account_balance_wallet,
        label: l10n.walletPreviewPkpassPlaceholder,
        theme: theme,
      ),
      BinaryArtifactKind.png =>
        bytes == null || bytes!.isEmpty
            ? _IconPlaceholder(
                icon: Icons.image_not_supported,
                label: l10n.walletPreviewQrUnavailable,
                theme: theme,
              )
            : Semantics(
                label: l10n.walletPreviewQrImageSemantic,
                image: true,
                child: Image.memory(
                  bytes!,
                  fit: BoxFit.contain,
                  gaplessPlayback: true,
                ),
              ),
      // TODO(future-sprint): replace with `QrImageView` once `qr_flutter`
      //   is added to the pubspec; the textual fallback below remains a
      //   safe accessibility net.
      BinaryArtifactKind.qrText => Semantics(
        label: l10n.walletPreviewQrTextSemantic,
        child: SelectableText(
          text ?? '',
          style: theme.textTheme.bodyMedium?.copyWith(fontFamily: 'Roboto'),
        ),
      ),
    };
  }
}

class _IconPlaceholder extends StatelessWidget {
  const _IconPlaceholder({
    required this.icon,
    required this.label,
    required this.theme,
  });

  final IconData icon;
  final String label;
  final ThemeData theme;

  @override
  Widget build(final BuildContext context) => Padding(
    padding: const EdgeInsets.all(AppDimensions.space16),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(icon, size: AppDimensions.iconLarge),
        const SizedBox(height: AppDimensions.space8),
        Text(label, style: theme.textTheme.bodyMedium),
      ],
    ),
  );
}
