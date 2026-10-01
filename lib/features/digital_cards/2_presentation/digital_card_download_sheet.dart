import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/0_entity/digital_card.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/2_presentation/providers/digital_cards_provider.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

const _pkPassChannel = MethodChannel(
  'es.jccm.espaciociudadano/pkpass',
);

Future<void> showDigitalCardDownloadSheet(
  final BuildContext context,
  final WidgetRef ref,
  final DigitalCard card,
) async {
  ref.invalidate(digitalCardQrImageProvider(card));
  final supportsQrAndPdf = card.type == DigitalCardType.youth;
  await AppBottomSheet.show<void>(
    context: context,
    body: Consumer(
      builder: (final context, final ref, final child) {
        final qrImage = supportsQrAndPdf ? ref.watch(digitalCardQrImageProvider(card)) : null;
        final downloadingFormat = ref.watch(digitalCardsDownloadingProvider);
        return AppQrDownloadBottomSheetBody(
          qrImageBytes: qrImage?.asData?.value,
          isQrLoading: qrImage?.isLoading ?? false,
          downloadingFormat: downloadingFormat,
          onQrPressed: !supportsQrAndPdf
              ? null
              : () => _downloadFormat(
                  context,
                  ref,
                  card,
                  label: 'QR',
                  action: downloadDigitalCardsQr,
                ),
          onPkPassPressed: () => _downloadFormat(
            context,
            ref,
            card,
            label: 'PKPASS',
            action: downloadDigitalCardsPkPass,
          ),
          onPdfPressed: !supportsQrAndPdf
              ? null
              : () => _downloadFormat(
                  context,
                  ref,
                  card,
                  label: 'PDF',
                  action: downloadDigitalCardsPdf,
                ),
        );
      },
    ),
    horizontalMargin: AppDimensions.space4,
  );
}

Future<void> _downloadFormat(
  final BuildContext context,
  final WidgetRef ref,
  final DigitalCard card, {
  required final String label,
  required final Future<DigitalCardArtifact> Function(
    WidgetRef ref,
    DigitalCard card,
  )
  action,
}) async {
  final l10n = AppLocalizations.of(context);
  if (!ref.read(digitalCardsDownloadingProvider.notifier).tryStartDownload(label)) {
    return;
  }
  try {
    final artifact = await action(ref, card);
    final saveResult = await _saveArtifact(artifact, dialogTitle: l10n.digitalCardsSaveDialogTitle(label));
    if (saveResult == _ArtifactSaveResult.cancelled) {
      return;
    }
    if (!context.mounted) {
      return;
    }
    AppAlertSnackbar.show(
      context,
      message: saveResult == _ArtifactSaveResult.addedToIosWallet ? l10n.digitalCardsPkPassAddedToWallet : l10n.digitalCardsDownloadSuccess(label),
    );
  } catch (_) {
    if (!context.mounted) {
      return;
    }
    AppAlertSnackbar.show(
      context,
      message: l10n.digitalCardsDownloadError(label),
      severity: AppAlertSeverity.error,
    );
  } finally {
    ref.read(digitalCardsDownloadingProvider.notifier).finishDownload();
  }
}

enum _ArtifactSaveResult { cancelled, saved, addedToIosWallet }

Future<_ArtifactSaveResult> _saveArtifact(
  final DigitalCardArtifact artifact, {
  required final String dialogTitle,
}) async {
  if ((Platform.isAndroid || Platform.isIOS) && artifact.extension.toLowerCase() == 'pkpass') {
    try {
      final openedInWallet =
          await _pkPassChannel.invokeMethod<bool>('openPkPass', {
            'fileName': artifact.fileName,
            'bytes': artifact.bytes,
          }) ??
          false;
      if (openedInWallet) {
        return Platform.isIOS ? _ArtifactSaveResult.addedToIosWallet : _ArtifactSaveResult.saved;
      }
    } on Exception {
      // Wallet could not open the pass; continue with the manual save flow.
    }
  }

  // If no wallet app can handle the pass, let the user save it manually.
  final path = await FilePicker.saveFile(
    dialogTitle: dialogTitle,
    fileName: artifact.fileName,
    type: FileType.custom,
    allowedExtensions: [artifact.extension],
    bytes: artifact.bytes,
  );
  if (path == null) {
    return _ArtifactSaveResult.cancelled;
  }
  if (!Platform.isAndroid && !Platform.isIOS) {
    await File(path).writeAsBytes(artifact.bytes);
  }
  return _ArtifactSaveResult.saved;
}
