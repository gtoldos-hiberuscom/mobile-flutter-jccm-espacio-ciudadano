import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/app/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/features/casework/uploads/0_entity/upload_attachment.dart';
import 'package:jccm_espacio_ciudadano/features/casework/uploads/1_domain/upload_session_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/casework/uploads/2_presentation/widgets/justificante_panel.dart';
import 'package:jccm_espacio_ciudadano/features/casework/uploads/2_presentation/widgets/upload_attachment_tile.dart';
import 'package:jccm_espacio_ciudadano/features/casework/uploads/2_presentation/widgets/upload_picker_panel.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Composable upload section bound to an [expedienteRef].
///
/// Designed to be embedded by STORY-35 (expediente detail) and STORY-37
/// (third-party contribution wizard) — does not own routing or scaffold.
class UploadEvidenceSection extends ConsumerStatefulWidget {
  const UploadEvidenceSection({
    required this.expedienteRef,
    this.picker,
    super.key,
  });

  final String expedienteRef;

  /// Test seam — overrides the default `file_selector` picker.
  final UploadFilePicker? picker;

  @override
  ConsumerState<UploadEvidenceSection> createState() =>
      _UploadEvidenceSectionState();
}

class _UploadEvidenceSectionState extends ConsumerState<UploadEvidenceSection> {
  final Map<String, Uint8List> _bytesById = <String, Uint8List>{};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(uploadSessionProvider.notifier)
          .start(widget.expedienteRef);
    });
  }

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final session = ref.watch(uploadSessionProvider);
    final notifier = ref.read(uploadSessionProvider.notifier);
    final hasHashed = session.files.any(
      (final f) => f.status == UploadAttachmentStatus.hashed,
    );
    final allUploaded = session.files.isNotEmpty &&
        session.files.every(
          (final f) => f.status == UploadAttachmentStatus.uploaded,
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _buildPicker(session.files.length, session.finalized, notifier),
        const SizedBox(height: AppDimensions.space12),
        if (session.files.isEmpty)
          Padding(
            padding: const EdgeInsets.all(AppDimensions.space12),
            child: Text(l10n.caseworkUploadEmptyList),
          )
        else
          Column(
            children: <Widget>[
              for (final attachment in session.files)
                UploadAttachmentTile(
                  attachment: attachment,
                  onRemove: session.finalized
                      ? null
                      : () {
                          _bytesById.remove(attachment.id);
                          notifier.removeFile(attachment.id);
                        },
                ),
            ],
          ),
        const SizedBox(height: AppDimensions.space12),
        Row(
          children: <Widget>[
            FilledButton.icon(
              onPressed: hasHashed && !session.finalized
                  ? () => notifier.uploadAll(_bytesById)
                  : null,
              icon: const Icon(Icons.cloud_upload),
              label: Text(l10n.caseworkUploadUploadAllCta),
            ),
            const SizedBox(width: AppDimensions.space8),
            OutlinedButton.icon(
              onPressed: allUploaded && !session.finalized
                  ? notifier.finalizeAndRequestJustificante
                  : null,
              icon: const Icon(Icons.check),
              label: Text(l10n.caseworkUploadFinalizeCta),
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.space12),
        JustificantePanel(
          state: session.justificante,
          onDownload: (_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l10n.caseworkUploadJustificanteDownloadStub),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildPicker(
    final int currentCount,
    final bool finalized,
    final UploadSessionNotifier notifier,
  ) {
    void onPicked(final List<PickedFile> picked) {
      final idsBefore = ref
          .read(uploadSessionProvider)
          .files
          .map((final f) => f.id)
          .toSet();
      // Fire-and-forget; the notifier mutates state asynchronously.
      // ignore: discarded_futures
      notifier.addFiles(picked).then((_) {
        final after = ref.read(uploadSessionProvider).files;
        for (final attachment in after) {
          if (idsBefore.contains(attachment.id)) {
            continue;
          }
          final match = picked.firstWhere(
            (final p) =>
                p.name == attachment.displayName &&
                p.sizeBytes == attachment.sizeBytes,
            orElse: () => picked.first,
          );
          _bytesById[attachment.id] = match.bytes;
        }
      });
    }

    if (widget.picker != null) {
      return UploadPickerPanel(
        currentCount: currentCount,
        disabled: finalized,
        picker: widget.picker!,
        onFilesPicked: onPicked,
      );
    }
    return UploadPickerPanel(
      currentCount: currentCount,
      disabled: finalized,
      onFilesPicked: onPicked,
    );
  }
}
