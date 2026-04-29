import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/app/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/core/ui_states/empty_state_widget.dart';
import 'package:jccm_espacio_ciudadano/core/ui_states/error_state_widget.dart';
import 'package:jccm_espacio_ciudadano/core/ui_states/loading_state_widget.dart';
import 'package:jccm_espacio_ciudadano/features/signature/0_entity/signature_document.dart';
import 'package:jccm_espacio_ciudadano/features/signature/1_domain/signature_inbox_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/signature/2_presentation/widgets/certificate_status_banner.dart';
import 'package:jccm_espacio_ciudadano/features/signature/2_presentation/widgets/signature_document_tile.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Citizen signature inbox (STORY-45).
///
/// Two segmented sections — pending documents and signed history —
/// preceded by a banner that surfaces the certificate / VEC validation
/// outcome. Pull-to-refresh re-runs both the inbox load and the
/// certificate validation.
///
/// Real handoff to Afirma is deferred to STORY-46 — for now the
/// pending-document CTA shows a placeholder SnackBar.
class SignatureInboxPage extends ConsumerWidget {
  const SignatureInboxPage({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final asyncState = ref.watch(signatureInboxProvider);
    final notifier = ref.read(signatureInboxProvider.notifier);

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
        body: asyncState.when(
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
                      onSign: (final doc) => _onSignPlaceholder(context, l10n),
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
    );
  }

  // TODO(STORY-46): replace this SnackBar with the real handoff to the
  // external Afirma flow once the deep-link contract lands.
  void _onSignPlaceholder(final BuildContext context, final AppLocalizations l10n) {
    final messenger = ScaffoldMessenger.maybeOf(context);
    messenger?.showSnackBar(
      SnackBar(content: Text(l10n.signatureExternalLaunchPlaceholder)),
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
