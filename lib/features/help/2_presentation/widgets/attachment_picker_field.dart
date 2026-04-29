import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/app/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/features/help/0_entity/picked_attachment.dart';
import 'package:jccm_espacio_ciudadano/features/help/3_data/stub_attachment_picker.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Single-attachment picker affordance for the support form.
///
/// MVP uses [StubAttachmentPicker] (no plugin dependency). The picked
/// metadata is propagated through [onPicked]; the parent screen owns the
/// state via the support-form notifier.
///
// TODO(TASK-63): swap the stub picker for a real platform-backed
/// implementation behind a feature flag.
class AttachmentPickerField extends ConsumerWidget {
  const AttachmentPickerField({
    required this.attachment,
    required this.onPicked,
    required this.onCleared,
    super.key,
  });

  final PickedAttachment? attachment;
  final ValueChanged<PickedAttachment> onPicked;
  final VoidCallback onCleared;

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final picker = ref.watch(attachmentPickerProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.supportAttachmentLabel,
          style: theme.textTheme.titleSmall,
        ),
        const SizedBox(height: AppDimensions.space4),
        Text(
          l10n.supportAttachmentHint,
          style: theme.textTheme.bodySmall,
        ),
        const SizedBox(height: AppDimensions.space8),
        Row(
          children: [
            OutlinedButton.icon(
              key: const Key('support_attachment_pick_btn'),
              icon: const Icon(Icons.attach_file),
              label: Text(
                attachment == null ? l10n.supportAttachmentPick : l10n.supportAttachmentChange,
              ),
              onPressed: () async {
                final picked = await picker.pickSingle();
                if (picked != null) {
                  onPicked(picked);
                }
              },
            ),
            const SizedBox(width: AppDimensions.space12),
            if (attachment != null)
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${attachment!.name} '
                        '(${(attachment!.sizeBytes / 1024).toStringAsFixed(1)} KB)',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      key: const Key('support_attachment_clear_btn'),
                      icon: const Icon(Icons.close),
                      tooltip: l10n.supportAttachmentRemove,
                      onPressed: onCleared,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }
}
