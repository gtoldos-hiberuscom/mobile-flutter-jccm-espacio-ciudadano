import 'dart:typed_data';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/app/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/features/casework/uploads/0_entity/upload_constraints.dart';
import 'package:jccm_espacio_ciudadano/features/casework/uploads/1_domain/upload_session_notifier.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Function used by the picker to obtain files. Defaults to
/// `package:file_selector`. Tests inject a deterministic alternative.
typedef UploadFilePicker = Future<List<PickedFile>> Function();

Future<List<PickedFile>> _defaultFilePicker() async {
  final result = await openFiles();
  final out = <PickedFile>[];
  for (final f in result) {
    final bytes = await f.readAsBytes();
    final mime = (f.mimeType ?? _mimeFromName(f.name)).toLowerCase();
    out.add((
      name: f.name,
      sizeBytes: bytes.length,
      mimeType: mime,
      bytes: Uint8List.fromList(bytes),
    ));
  }
  return out;
}

String _mimeFromName(final String name) {
  final lower = name.toLowerCase();
  if (lower.endsWith('.pdf')) {
    return 'application/pdf';
  }
  if (lower.endsWith('.jpg') || lower.endsWith('.jpeg')) {
    return 'image/jpeg';
  }
  if (lower.endsWith('.png')) {
    return 'image/png';
  }
  if (lower.endsWith('.doc')) {
    return 'application/msword';
  }
  if (lower.endsWith('.docx')) {
    return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
  }
  if (lower.endsWith('.xls')) {
    return 'application/vnd.ms-excel';
  }
  if (lower.endsWith('.xlsx')) {
    return 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
  }
  if (lower.endsWith('.txt')) {
    return 'text/plain';
  }
  return 'application/octet-stream';
}

/// Picker / drop-target panel. The drag&drop affordance is exposed via
/// [Semantics] only — `desktop_drop` is intentionally not wired in
/// Sprint 5 because it cannot be confirmed cleanly across mobile and
/// web targets. The visible CTA always uses `file_selector`.
class UploadPickerPanel extends StatelessWidget {
  const UploadPickerPanel({
    required this.currentCount,
    required this.onFilesPicked,
    this.picker = _defaultFilePicker,
    this.disabled = false,
    super.key,
  });

  final int currentCount;
  final ValueChanged<List<PickedFile>> onFilesPicked;
  final UploadFilePicker picker;
  final bool disabled;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final remaining = kMaxFiles - currentCount;
    final canPick = !disabled && remaining > 0;
    return Semantics(
      label: l10n.caseworkUploadDropZoneSemantic,
      button: true,
      child: InkWell(
        onTap: canPick
            ? () async {
                final picked = await picker();
                if (picked.isNotEmpty) {
                  onFilesPicked(picked);
                }
              }
            : null,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        child: Container(
          padding: const EdgeInsets.all(AppDimensions.space16),
          decoration: BoxDecoration(
            border: Border.all(
              color: theme.colorScheme.outline,
            ),
            borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  const Icon(Icons.upload_file),
                  const SizedBox(width: AppDimensions.space8),
                  Expanded(
                    child: Text(
                      l10n.caseworkUploadPickerCta,
                      style: theme.textTheme.titleSmall,
                    ),
                  ),
                  FilledButton(
                    onPressed: canPick
                        ? () async {
                            final picked = await picker();
                            if (picked.isNotEmpty) {
                              onFilesPicked(picked);
                            }
                          }
                        : null,
                    child: Text(l10n.caseworkUploadSelectFilesCta),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.space8),
              Text(
                l10n.caseworkUploadLimitHint(kMaxFiles, _maxFileMb()),
                style: theme.textTheme.bodySmall,
              ),
              Text(
                l10n.caseworkUploadRemainingHint(remaining),
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }

  static int _maxFileMb() => kMaxFileBytes ~/ (1024 * 1024);
}
