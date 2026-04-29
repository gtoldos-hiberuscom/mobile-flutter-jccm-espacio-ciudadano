import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/app/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/app/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_button.dart';
import 'package:jccm_espacio_ciudadano/core/ui_states/error_state_widget.dart';
import 'package:jccm_espacio_ciudadano/core/ui_states/loading_state_widget.dart';
import 'package:jccm_espacio_ciudadano/features/notifications/0_entity/notification_decision.dart';
import 'package:jccm_espacio_ciudadano/features/notifications/0_entity/notification_detail.dart';
import 'package:jccm_espacio_ciudadano/features/notifications/0_entity/notification_status.dart';
import 'package:jccm_espacio_ciudadano/features/notifications/1_domain/notification_detail_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/notifications/2_presentation/widgets/notification_status_chip.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Notification detail surface for the **pending** decision flow
/// (STORY-43).
///
/// STORY-44 will extend this page with the aceptada / rechazada /
/// caducada variants and the document download actions; this iteration
/// only renders the pending detail and the accept / reject decision
/// bar (with explicit confirmation modal for the reject path).
class NotificationDetailPage extends ConsumerStatefulWidget {
  const NotificationDetailPage({required this.notificationId, super.key});

  final String notificationId;

  @override
  ConsumerState<NotificationDetailPage> createState() => _NotificationDetailPageState();
}

class _NotificationDetailPageState extends ConsumerState<NotificationDetailPage> {
  bool _isSubmitting = false;

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
              onAccept: () => _onAcceptPressed(detail),
              onReject: () => _onRejectPressed(detail),
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
}

class _DetailBody extends StatelessWidget {
  const _DetailBody({
    required this.detail,
    required this.isSubmitting,
    required this.onAccept,
    required this.onReject,
  });

  final NotificationDetail detail;
  final bool isSubmitting;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

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
                ],
              ),
            ),
          ),
          if (detail.status == NotificationStatus.pendiente)
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
            const SizedBox(height: AppDimensions.space12),
            Align(
              alignment: Alignment.centerLeft,
              child: NotificationStatusChip(status: detail.status),
            ),
          ],
        ),
      ),
    );
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
