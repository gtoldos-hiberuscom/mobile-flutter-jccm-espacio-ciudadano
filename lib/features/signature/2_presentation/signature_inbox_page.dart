import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/app/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/core/connectivity/offline_banner.dart';
import 'package:jccm_espacio_ciudadano/core/ui_states/empty_state_widget.dart';
import 'package:jccm_espacio_ciudadano/core/ui_states/error_state_widget.dart';
import 'package:jccm_espacio_ciudadano/core/ui_states/loading_state_widget.dart';
import 'package:jccm_espacio_ciudadano/features/signature/0_entity/signature_document.dart';
import 'package:jccm_espacio_ciudadano/features/signature/0_entity/signature_handoff_outcome.dart';
import 'package:jccm_espacio_ciudadano/features/signature/0_entity/signature_handoff_request.dart';
import 'package:jccm_espacio_ciudadano/features/signature/1_domain/signature_handoff_controller.dart';
import 'package:jccm_espacio_ciudadano/features/signature/1_domain/signature_inbox_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/signature/2_presentation/widgets/certificate_status_banner.dart';
import 'package:jccm_espacio_ciudadano/features/signature/2_presentation/widgets/signature_document_tile.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Citizen signature inbox (STORY-45 + STORY-46).
///
/// Two segmented sections — pending documents and signed history —
/// preceded by a banner that surfaces the certificate / VEC validation
/// outcome. Pull-to-refresh re-runs both the inbox load and the
/// certificate validation.
///
/// As of STORY-46 the "Firmar" CTA on each pending document triggers a
/// real handoff via [SignatureHandoffController]; the page also listens
/// to the controller and surfaces non-blocking SnackBars for each
/// terminal outcome (signed / cancelled / error) plus a recoverable
/// retry when the OS refused to launch the external flow.
class SignatureInboxPage extends ConsumerStatefulWidget {
  const SignatureInboxPage({super.key});

  @override
  ConsumerState<SignatureInboxPage> createState() =>
      _SignatureInboxPageState();
}

class _SignatureInboxPageState extends ConsumerState<SignatureInboxPage> {
  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final asyncState = ref.watch(signatureInboxProvider);
    final notifier = ref.read(signatureInboxProvider.notifier);

    ref.listen<SignatureHandoffOutcome?>(
      signatureHandoffControllerProvider,
      (final previous, final next) => _handleOutcomeChange(
        context: context,
        l10n: l10n,
        previous: previous,
        next: next,
      ),
    );

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.signatureInboxTitle),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(text: l10n.signatureTabPending),
              Tab(text: l10n.signatureTabHistory),
            ],
          ),
        ),
        body: OfflineBanner(
          child: asyncState.when(
          loading: () => LoadingStateWidget(message: l10n.signatureLoading),
          error: (final error, final stack) => ErrorStateWidget(
            message: l10n.signatureErrorMessage,
            retryLabel: l10n.signatureRetry,
            onRetry: notifier.refresh,
          ),
          data: (final state) => Column(
            children: <Widget>[
              const CertificateStatusBanner(),
              Expanded(
                child: TabBarView(
                  children: <Widget>[
                    _DocumentsList(
                      key: const ValueKey<String>('signature-pending-list'),
                      items: state.pending,
                      emptyTitle: l10n.signatureEmptyPendingTitle,
                      emptySubtitle: l10n.signatureEmptyPendingSubtitle,
                      onRefresh: notifier.refresh,
                      onSign: _onSignPressed,
                    ),
                    _DocumentsList(
                      key: const ValueKey<String>('signature-signed-list'),
                      items: state.signed,
                      emptyTitle: l10n.signatureEmptyHistoryTitle,
                      emptySubtitle: l10n.signatureEmptyHistorySubtitle,
                      onRefresh: notifier.refresh,
                      onSign: null,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        ),
      ),
    );
  }

  Future<void> _onSignPressed(final SignatureDocument document) async {
    final l10n = AppLocalizations.of(context);
    final controller = ref.read(signatureHandoffControllerProvider.notifier);
    final returnDeepLink = Uri.parse(
      'jccmespacio://sign/afirma/return?docId=${Uri.encodeComponent(document.id)}',
    );
    // STUB Afirma URL — see TODO in UrlLauncherSignatureHandoffLauncher.
    final externalUri = Uri.parse(
      'https://afirma.jccm.es/sign'
      '?docId=${Uri.encodeComponent(document.id)}'
      '&returnTo=${Uri.encodeComponent(returnDeepLink.toString())}',
    );
    final request = SignatureHandoffRequest(
      documentId: document.id,
      documentTitle: document.title,
      externalUri: externalUri,
      returnDeepLink: returnDeepLink,
      requestedAt: DateTime.now(),
    );

    final accepted = await controller.startHandoff(request);
    if (!accepted && mounted) {
      // Launcher refused — surface a recoverable SnackBar with retry.
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
        SnackBar(
          content: Text(l10n.signatureHandoffLaunchFailedToast),
          action: SnackBarAction(
            label: l10n.signatureRetry,
            onPressed: () => _onSignPressed(document),
          ),
        ),
      );
    }
  }

  void _handleOutcomeChange({
    required final BuildContext context,
    required final AppLocalizations l10n,
    required final SignatureHandoffOutcome? previous,
    required final SignatureHandoffOutcome? next,
  }) {
    if (next == null) {
      return;
    }
    if (previous?.status == next.status &&
        previous?.documentId == next.documentId &&
        previous?.completedAt == next.completedAt) {
      return;
    }
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) {
      return;
    }
    switch (next.status) {
      case SignatureHandoffStatus.pending:
        messenger
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(content: Text(l10n.signatureHandoffPendingToast)),
          );
      case SignatureHandoffStatus.signed:
        messenger
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(content: Text(l10n.signatureHandoffSignedToast)),
          );
        _consumeOutcome();
      case SignatureHandoffStatus.cancelled:
        messenger
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(content: Text(l10n.signatureHandoffCancelledToast)),
          );
        _consumeOutcome();
      case SignatureHandoffStatus.error:
        messenger
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(content: Text(l10n.signatureHandoffErrorToast)),
          );
        _consumeOutcome();
    }
  }

  /// Resets the handoff controller after a terminal outcome has been
  /// shown to the citizen, so the next visit starts from a clean slate
  /// and the SnackBar is not re-fired on rebuild.
  void _consumeOutcome() {
    // Microtask so we don't mutate a notifier during a `ref.listen`
    // callback.
    unawaited(
      Future<void>.microtask(() {
        if (!mounted) {
          return;
        }
        ref.read(signatureHandoffControllerProvider.notifier).clear();
      }),
    );
  }
}

class _DocumentsList extends StatelessWidget {
  const _DocumentsList({
    required this.items,
    required this.emptyTitle,
    required this.emptySubtitle,
    required this.onRefresh,
    required this.onSign,
    super.key,
  });

  final List<SignatureDocument> items;
  final String emptyTitle;
  final String emptySubtitle;
  final Future<void> Function() onRefresh;
  final void Function(SignatureDocument document)? onSign;

  @override
  Widget build(final BuildContext context) {
    if (items.isEmpty) {
      return RefreshIndicator(
        onRefresh: onRefresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: <Widget>[
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.6,
              child: EmptyStateWidget(
                message: emptyTitle,
                subtitle: emptySubtitle,
              ),
            ),
          ],
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: AppDimensions.space8),
        itemCount: items.length,
        itemBuilder: (final ctx, final index) {
          final doc = items[index];
          return SignatureDocumentTile(
            document: doc,
            onSign: () => onSign?.call(doc),
          );
        },
      ),
    );
  }
}
