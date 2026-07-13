import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/core/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/0_entity/digital_card.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/2_presentation/providers/digital_cards_provider.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

class DigitalCardsPage extends ConsumerWidget {
  const DigitalCardsPage({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final cardsAsync = ref.watch(digitalCardsProvider);
    final isDownloading = ref.watch(digitalCardsDownloadingProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundBlueLighter,
      appBar: AppNavBar(
        title: l10n.digitalCardsPageTitle,
        onBack: () => context.go(Routes.home),
        leading: IconButton(
          onPressed: () => context.go(Routes.home),
          tooltip: 'Volver',
          icon: const AppIcon(AppIcons.arrowBack, color: AppColors.textPrimary),
        ),
        actions: [
          IconButton(
            onPressed: () => _showInfo(context),
            tooltip: 'Informacion',
            icon: const AppIcon(AppIcons.info, color: AppColors.textPrimary),
          ),
        ],
      ),
      body: cardsAsync.when(
        loading: () => const AppLoadingIndicator(),
        error: (final error, final stackTrace) => _DigitalCardsMessage(
          message: l10n.digitalCardsErrorMessage,
          actionLabel: 'Reintentar',
          onAction: () => ref.invalidate(digitalCardsProvider),
        ),
        data: (final cards) {
          if (cards.isEmpty) {
            return _DigitalCardsMessage(message: l10n.digitalCardsEmptyMessage);
          }

          return RefreshIndicator(
            onRefresh: () async => ref.refresh(digitalCardsProvider.future),
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(
                AppDimensions.space16,
                AppDimensions.space24,
                AppDimensions.space16,
                AppDimensions.space64,
              ),
              itemBuilder: (final context, final index) {
                final card = cards[index];
                return AppDigitalCard(
                  title: _title(card, l10n),
                  number: card.number,
                  primaryDateLabel: switch (card.type) {
                    DigitalCardType.largeFamily => l10n.digitalCardsIssueDate,
                    DigitalCardType.disability => l10n.digitalCardsEffectiveDate,
                    DigitalCardType.youth => l10n.digitalCardsExpiryDate,
                  },
                  primaryDate: _formatDate(context, card.type == DigitalCardType.youth ? card.expiresAt : card.validFrom),
                  secondaryDateLabel: card.type == DigitalCardType.largeFamily ? l10n.digitalCardsExpiryDate : null,
                  secondaryDate: card.type == DigitalCardType.largeFamily ? _formatDate(context, card.expiresAt) : null,
                  statusLabel: card.isDefinitive ? l10n.digitalCardsDefinitive : null,
                  downloadLabel: 'Descargar',
                  isDownloading: isDownloading,
                  onDownload: () => _showDownloadSheet(context, ref, card),
                );
              },
              separatorBuilder: (final context, final index) => const SizedBox(height: AppDimensions.space16),
              itemCount: cards.length,
            ),
          );
        },
      ),
    );
  }

  Future<void> _showInfo(final BuildContext context) async {
    await AppInfoSheet.show(
      context: context,
      title: 'Sobre Mis Carnets Digitales',
      bodyText: 'Descarga los carnets emitidos por la Junta de Comunidades de Castilla-La Mancha.',
    );
  }

  Future<void> _showDownloadSheet(final BuildContext context, final WidgetRef ref, final DigitalCard card) async {
    ref.invalidate(digitalCardQrImageProvider(card));
    final supportsQrAndPdf = card.type == DigitalCardType.youth;
    await AppBottomSheet.show<void>(
      context: context,
      body: Consumer(
        builder: (final context, final ref, final child) {
          final qrImage = supportsQrAndPdf ? ref.watch(digitalCardQrImageProvider(card)) : null;
          return AppQrDownloadBottomSheetBody(
            qrImageBytes: qrImage?.asData?.value,
            isQrLoading: qrImage?.isLoading ?? false,
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
    required final Future<DigitalCardArtifact> Function(WidgetRef ref, DigitalCard card) action,
  }) async {
    ref.read(digitalCardsDownloadingProvider.notifier).startDownload();
    try {
      final artifact = await action(ref, card);
      final path = await FilePicker.saveFile(
        dialogTitle: 'Guardar $label',
        fileName: artifact.fileName,
        type: FileType.custom,
        allowedExtensions: [artifact.extension],
        bytes: artifact.bytes,
      );
      if (path == null) {
        return;
      }
      if (!Platform.isAndroid && !Platform.isIOS) {
        await File(path).writeAsBytes(artifact.bytes);
      }
      if (!context.mounted) {
        return;
      }
      AppAlertSnackbar.show(
        context,
        message: '$label guardado correctamente.',
      );
    } catch (_) {
      if (!context.mounted) {
        return;
      }
      AppAlertSnackbar.show(
        context,
        message: 'No hemos podido descargar $label.',
        severity: AppAlertSeverity.error,
      );
    } finally {
      ref.read(digitalCardsDownloadingProvider.notifier).finishDownload();
    }
  }

  String _title(final DigitalCard card, final AppLocalizations l10n) => switch (card.type) {
    DigitalCardType.largeFamily => l10n.digitalCardsTypeFamiliaNumerosa,
    DigitalCardType.youth => l10n.digitalCardsTypeJoven,
    DigitalCardType.disability => l10n.digitalCardsTypeDiscapacidad,
  };

  String? _formatDate(final BuildContext context, final DateTime? value) {
    if (value == null) {
      return null;
    }
    return DateFormat('dd MMM yyyy', Localizations.localeOf(context).languageCode).format(value);
  }
}

class _DigitalCardsMessage extends StatelessWidget {
  const _DigitalCardsMessage({
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(final BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.space24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTypography.bodyRegular.copyWith(color: AppColors.textPrimary),
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: AppDimensions.space16),
              AppButton(
                label: actionLabel!,
                onPressed: onAction,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
