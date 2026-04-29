import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/app/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/app/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/app/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_button.dart';
import 'package:jccm_espacio_ciudadano/core/ui_states/empty_state_widget.dart';
import 'package:jccm_espacio_ciudadano/core/ui_states/error_state_widget.dart';
import 'package:jccm_espacio_ciudadano/core/ui_states/loading_state_widget.dart';
import 'package:jccm_espacio_ciudadano/features/notifications/0_entity/notification_decision.dart';
import 'package:jccm_espacio_ciudadano/features/notifications/0_entity/notification_detail.dart';
import 'package:jccm_espacio_ciudadano/features/notifications/0_entity/notification_document.dart';
import 'package:jccm_espacio_ciudadano/features/notifications/0_entity/notification_document_download_result.dart';
import 'package:jccm_espacio_ciudadano/features/notifications/0_entity/notification_status.dart';
import 'package:jccm_espacio_ciudadano/features/notifications/1_domain/notification_detail_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/notifications/2_presentation/widgets/notification_document_tile.dart';
import 'package:jccm_espacio_ciudadano/features/notifications/2_presentation/widgets/notification_status_chip.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Notification detail surface for both the **pending** decision flow
/// (STORY-43) and the **aceptada / rechazada / caducada** read-only
/// variants with associated documents (STORY-44).
class NotificationDetailPage extends ConsumerStatefulWidget {
  const NotificationDetailPage({required this.notificationId, super.key});

  final String notificationId;

  @override
  ConsumerState<NotificationDetailPage> createState() => _NotificationDetailPageState();
}

class _NotificationDetailPageState extends ConsumerState<NotificationDetailPage> {
  bool _isSubmitting = false;
  final Set<String> _downloadingDocIds = <String>{};

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final asyncDetail = ref.watch(notificationDetailProvider(widget.notificationId));

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.notificationDetailTitle),
        leading: BackButton(
          onPressed: () => _handleBack(context),
        ),
      ),
      body: asyncDetail.when(
        loading: () => LoadingStateWidget(message: l10n.notificationDetailLoading),
        error: (final error, final stack) => ErrorStateWidget(
          message: l10n.notificationDetailErrorMessage,
          onRetry: () => ref.invalidate(notificationDetailProvider(widget.notificationId)),
          retryLabel: l10n.notificationDetailRetry,
        ),
        data: (final detail) => Stack(
          children: <Widget>[
            _DetailBody(
              detail: detail,
              isSubmitting: _isSubmitting,
              downloadingDocIds: _downloadingDocIds,
              onAccept: () => _onAcceptPressed(detail),
              onReject: () => _onRejectPressed(detail),
              onDownload: _onDownloadPressed,
            ),
            if (_isSubmitting)
              ColoredBox(
                color: Colors.black54,
                child: Center(
                  child: LoadingStateWidget(
                    message: l10n.notificationDetailDecisionInFlight,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _handleBack(final BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(Routes.notifications);
    }
  }

  Future<void> _onAcceptPressed(final NotificationDetail detail) async {
    if (_isSubmitting) {
      return;
    }
    await _submit(NotificationDecisionAction.accept);
  }

  Future<void> _onRejectPressed(final NotificationDetail detail) async {
    if (_isSubmitting) {
      return;
    }
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (final ctx) => const _RejectConfirmationDialog(),
    );
    if (confirmed != true) {
      return;
    }
    await _submit(NotificationDecisionAction.reject);
  }

  Future<void> _submit(final NotificationDecisionAction action) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _isSubmitting = true);
    try {
      final outcome = await ref
          .read(notificationDetailProvider(widget.notificationId).notifier)
          .submitDecision(action);
      if (!mounted) {
        return;
      }
      final toast = outcome.resultStatus == NotificationStatus.aceptada
          ? l10n.notificationDetailDecisionAcceptedToast
          : l10n.notificationDetailDecisionRejectedToast;
      messenger.showSnackBar(SnackBar(content: Text(toast)));
      // Give the user a moment to read the toast before popping.
      await Future<void>.delayed(const Duration(milliseconds: 800));
      if (!mounted) {
        return;
      }
      _handleBack(context);
    } on NotificationDecisionConflict {
      if (!mounted) {
        return;
      }
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.notificationDetailConflictToast)),
      );
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  Future<void> _onDownloadPressed(final NotificationDocument document) async {
    if (_downloadingDocIds.contains(document.id)) {
      return;
    }
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _downloadingDocIds.add(document.id));
    NotificationDocumentDownloadResult result;
    try {
      result = await ref
          .read(notificationDetailProvider(widget.notificationId).notifier)
          .downloadDocument(document.id);
    } on Object {
      result = NotificationDocumentDownloadResult.error();
    }
    if (!mounted) {
      return;
    }
    final toast = switch (result.status) {
      NotificationDocumentDownloadStatus.success =>
        l10n.notificationDetailDocumentDownloadSuccessToast,
      NotificationDocumentDownloadStatus.unavailable =>
        l10n.notificationDetailDocumentDownloadUnavailableToast,
      NotificationDocumentDownloadStatus.error =>
        l10n.notificationDetailDocumentDownloadErrorToast,
    };
    messenger.showSnackBar(SnackBar(content: Text(toast)));
    setState(() => _downloadingDocIds.remove(document.id));
  }
}

class _DetailBody extends StatelessWidget {
  const _DetailBody({
    required this.detail,
    required this.isSubmitting,
    required this.downloadingDocIds,
    required this.onAccept,
    required this.onReject,
    required this.onDownload,
  });

  final NotificationDetail detail;
  final bool isSubmitting;
  final Set<String> downloadingDocIds;
  final VoidCallback onAccept;
  final VoidCallback onReject;
  final ValueChanged<NotificationDocument> onDownload;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isPending = detail.status == NotificationStatus.pendiente;
    final showDocuments = !isPending;

    return SafeArea(
      child: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppDimensions.space16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  _HeaderCard(detail: detail),
                  const SizedBox(height: AppDimensions.space16),
                  _MetadataSection(detail: detail),
                  const SizedBox(height: AppDimensions.space24),
                  Text(
                    l10n.notificationDetailDescriptionTitle,
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppDimensions.space8),
                  Text(
                    detail.descripcion,
                    style: theme.textTheme.bodyMedium,
                  ),
                  if (showDocuments) ...<Widget>[
                    const SizedBox(height: AppDimensions.space24),
                    _DocumentsSection(
                      detail: detail,
                      downloadingDocIds: downloadingDocIds,
                      onDownload: onDownload,
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (isPending)
            _DecisionBar(
              isSubmitting: isSubmitting,
              onAccept: onAccept,
              onReject: onReject,
            ),
        ],
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  const _HeaderCard({required this.detail});

  final NotificationDetail detail;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final readAt = detail.readAt;
    final variantBanner = _variantBannerText(l10n, detail.status);
    final variantBannerColor = _variantBannerColor(theme, detail.status);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.space16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              detail.asunto,
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: AppDimensions.space8),
            Text(
              l10n.notificationDetailHeaderOrganismo(detail.organismoEmisor),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.outline,
              ),
            ),
            const SizedBox(height: AppDimensions.space4),
            Text(
              l10n.notificationDetailHeaderEmittedOn(_formatDate(detail.fechaEmision)),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.outline,
              ),
            ),
            if (readAt != null) ...<Widget>[
              const SizedBox(height: AppDimensions.space4),
              Text(
                l10n.notificationDetailReadOn(_formatDate(readAt)),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.outline,
                ),
              ),
            ],
            const SizedBox(height: AppDimensions.space12),
            Align(
              alignment: Alignment.centerLeft,
              child: NotificationStatusChip(status: detail.status),
            ),
            if (variantBanner != null) ...<Widget>[
              const SizedBox(height: AppDimensions.space12),
              Container(
                padding: const EdgeInsets.all(AppDimensions.space12),
                decoration: BoxDecoration(
                  color: variantBannerColor.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                  border: Border.all(
                    color: variantBannerColor.withValues(alpha: 0.40),
                  ),
                ),
                child: Text(
                  variantBanner,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: variantBannerColor,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String? _variantBannerText(final AppLocalizations l10n, final NotificationStatus status) {
    switch (status) {
      case NotificationStatus.aceptada:
        return l10n.notificationDetailVariantAceptadaBanner;
      case NotificationStatus.rechazada:
        return l10n.notificationDetailVariantRechazadaBanner;
      case NotificationStatus.caducada:
        return l10n.notificationDetailVariantCaducadaBanner;
      case NotificationStatus.pendiente:
      case NotificationStatus.unknown:
        return null;
    }
  }

  Color _variantBannerColor(final ThemeData theme, final NotificationStatus status) {
    switch (status) {
      case NotificationStatus.aceptada:
        return AppColors.success;
      case NotificationStatus.rechazada:
        return AppColors.error;
      case NotificationStatus.caducada:
      case NotificationStatus.pendiente:
      case NotificationStatus.unknown:
        return theme.colorScheme.outline;
    }
  }
}

class _MetadataSection extends StatelessWidget {
  const _MetadataSection({required this.detail});

  final NotificationDetail detail;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final entries = <Widget>[];
    if (detail.expedienteRef != null) {
      entries.add(_metadataRow(
        theme,
        l10n.notificationDetailHeaderExpediente(detail.expedienteRef!),
      ));
    }
    if (detail.procedimiento != null) {
      entries.add(_metadataRow(
        theme,
        l10n.notificationDetailHeaderProcedimiento(detail.procedimiento!),
      ));
    }
    if (detail.decisionDeadline != null) {
      entries.add(_metadataRow(
        theme,
        l10n.notificationDetailHeaderDeadline(_formatDate(detail.decisionDeadline!)),
      ));
    }
    if (entries.isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        for (final entry in entries) ...<Widget>[
          entry,
          const SizedBox(height: AppDimensions.space4),
        ],
      ],
    );
  }

  Widget _metadataRow(final ThemeData theme, final String text) => Text(
    text,
    style: theme.textTheme.bodyMedium,
  );
}

class _DocumentsSection extends StatelessWidget {
  const _DocumentsSection({
    required this.detail,
    required this.downloadingDocIds,
    required this.onDownload,
  });

  final NotificationDetail detail;
  final Set<String> downloadingDocIds;
  final ValueChanged<NotificationDocument> onDownload;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final docs = detail.documents;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          l10n.notificationDetailDocumentsTitle,
          style: theme.textTheme.titleMedium,
        ),
        const SizedBox(height: AppDimensions.space8),
        if (docs.isEmpty)
          EmptyStateWidget(
            message: l10n.notificationDetailDocumentsEmpty,
            icon: Icons.folder_off_outlined,
          )
        else
          ...docs.map(
            (final doc) => NotificationDocumentTile(
              document: doc,
              isDownloading: downloadingDocIds.contains(doc.id),
              onDownload: doc.availability == NotificationDocumentAvailability.available
                  ? () => onDownload(doc)
                  : null,
            ),
          ),
      ],
    );
  }
}

class _DecisionBar extends StatelessWidget {
  const _DecisionBar({
    required this.isSubmitting,
    required this.onAccept,
    required this.onReject,
  });

  final bool isSubmitting;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Material(
      elevation: 4,
      color: theme.colorScheme.surface,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.space16),
          child: Row(
            children: <Widget>[
              Expanded(
                child: AppButton(
                  label: l10n.notificationDetailRejectCta,
                  variant: AppButtonVariant.outlined,
                  onPressed: isSubmitting ? null : onReject,
                ),
              ),
              const SizedBox(width: AppDimensions.space12),
              Expanded(
                child: AppButton(
                  label: l10n.notificationDetailAcceptCta,
                  onPressed: isSubmitting ? null : onAccept,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RejectConfirmationDialog extends StatelessWidget {
  const _RejectConfirmationDialog();

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(l10n.notificationDetailRejectDialogTitle),
      content: Text(l10n.notificationDetailRejectDialogBody),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(l10n.notificationDetailRejectDialogCancel),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(l10n.notificationDetailRejectDialogConfirm),
        ),
      ],
    );
  }
}

String _formatDate(final DateTime when) {
  final dd = when.day.toString().padLeft(2, '0');
  final mm = when.month.toString().padLeft(2, '0');
  return '$dd/$mm/${when.year}';
}
