import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/app/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/app/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/core/auth/session_state_provider.dart';
import 'package:jccm_espacio_ciudadano/core/ui_states/empty_state_widget.dart';
import 'package:jccm_espacio_ciudadano/core/ui_states/error_state_widget.dart';
import 'package:jccm_espacio_ciudadano/core/ui_states/loading_state_widget.dart';
import 'package:jccm_espacio_ciudadano/features/personalization/0_entity/data_consent.dart';
import 'package:jccm_espacio_ciudadano/features/personalization/0_entity/data_consent_state.dart';
import 'package:jccm_espacio_ciudadano/features/personalization/1_domain/data_consent_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/personalization/2_presentation/life_events_page.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Mis autorizaciones — citizen data-consent screen (STORY-55).
///
/// Renders the three `clausulas` ([DataConsentType.jccm],
/// [DataConsentType.otrasAdmin], [DataConsentType.perfilado]) as switch
/// tiles, exposes an explicit save action with persistence feedback, a
/// revoke-all action behind a confirmation dialog, and a CTA that links to
/// the onboarding consent screen ([Routes.consent]) so the citizen can
/// review the protección-de-datos information accepted at sign-in.
///
/// Mocked data — the underlying repository carries the
/// `TODO(future-sprint)` for Dio wiring against
/// `/hechos-vitales/clausulas/{idAgente}`,
/// `PATCH /hechos-vitales/clausulas` and
/// `DELETE /hechos-vitales/preferencias/{idAgente}`.
class DataConsentPage extends ConsumerStatefulWidget {
  const DataConsentPage({super.key, this.idAgente});

  /// Optional override. When omitted, the page reads `idAgente` from the
  /// shared `sessionStateProvider`. As a last resort (no session yet during
  /// development) the same stub used by [LifeEventsPage] is reused so both
  /// screens stay aligned for the mock backend.
  final String? idAgente;

  @override
  ConsumerState<DataConsentPage> createState() => _DataConsentPageState();
}

class _DataConsentPageState extends ConsumerState<DataConsentPage> {
  DataConsentLoadState? _previousState;

  String _resolveIdAgente() {
    if (widget.idAgente != null && widget.idAgente!.isNotEmpty) {
      return widget.idAgente!;
    }
    final sessionToken = ref.read(sessionStateProvider);
    if (sessionToken != null && sessionToken.isNotEmpty) {
      return sessionToken;
    }
    return LifeEventsPage.stubIdAgente;
  }

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final idAgente = _resolveIdAgente();
    final asyncSnapshot = ref.watch(dataConsentProvider(idAgente));

    ref.listen<AsyncValue<DataConsentSnapshot>>(
      dataConsentProvider(idAgente),
      (final previous, final next) {
        final value = next.value;
        if (value == null) {
          return;
        }
        if (value.state == DataConsentLoadState.saved &&
            _previousState != DataConsentLoadState.saved) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(l10n.dataConsentSavedFeedback)),
            );
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              ref
                  .read(dataConsentProvider(idAgente).notifier)
                  .acknowledgeSaved();
            }
          });
        } else if (value.state == DataConsentLoadState.error &&
            _previousState != DataConsentLoadState.error) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(l10n.dataConsentErrorFeedback)),
            );
        }
        _previousState = value.state;
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.dataConsentTitle),
        actions: <Widget>[
          asyncSnapshot.maybeWhen<Widget>(
            data: (final snapshot) => _SaveAction(
              snapshot: snapshot,
              onSave: () => ref
                  .read(dataConsentProvider(idAgente).notifier)
                  .save(),
            ),
            orElse: () => const SizedBox.shrink(),
          ),
        ],
      ),
      body: asyncSnapshot.when(
        loading: () => LoadingStateWidget(message: l10n.loadingStateDefault),
        error: (final err, final _) => ErrorStateWidget(
          message: l10n.dataConsentLoadError,
          onRetry: () => ref
              .read(dataConsentProvider(idAgente).notifier)
              .refresh(),
        ),
        data: (final snapshot) => _DataConsentBody(
          snapshot: snapshot,
          onToggle: (final id) => ref
              .read(dataConsentProvider(idAgente).notifier)
              .toggle(id),
          onRevoke: () => _confirmRevoke(context, l10n, idAgente),
        ),
      ),
    );
  }

  Future<void> _confirmRevoke(
    final BuildContext context,
    final AppLocalizations l10n,
    final String idAgente,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (final dialogCtx) => AlertDialog(
        title: Text(l10n.dataConsentRevokeConfirmTitle),
        content: Text(l10n.dataConsentRevokeConfirmBody),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(false),
            child: Text(l10n.dataConsentRevokeCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogCtx).pop(true),
            child: Text(l10n.dataConsentRevokeConfirm),
          ),
        ],
      ),
    );
    if (confirmed ?? false) {
      await ref
          .read(dataConsentProvider(idAgente).notifier)
          .revokeAll();
    }
  }
}

class _SaveAction extends StatelessWidget {
  const _SaveAction({required this.snapshot, required this.onSave});

  final DataConsentSnapshot snapshot;
  final VoidCallback onSave;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isSaving = snapshot.state == DataConsentLoadState.saving;
    if (isSaving) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: AppDimensions.space16),
        child: Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }
    final canSave = snapshot.isDirty &&
        snapshot.state != DataConsentLoadState.saving;
    return TextButton(
      onPressed: canSave ? onSave : null,
      child: Text(l10n.dataConsentSaveAction),
    );
  }
}

class _DataConsentBody extends StatelessWidget {
  const _DataConsentBody({
    required this.snapshot,
    required this.onToggle,
    required this.onRevoke,
  });

  final DataConsentSnapshot snapshot;
  final ValueChanged<String> onToggle;
  final VoidCallback onRevoke;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    if (snapshot.state == DataConsentLoadState.empty ||
        snapshot.items.isEmpty) {
      return EmptyStateWidget(message: l10n.dataConsentEmpty);
    }
    final disabled = snapshot.state == DataConsentLoadState.saving;
    return Column(
      children: <Widget>[
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(
              vertical: AppDimensions.space12,
            ),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.space16,
                  vertical: AppDimensions.space8,
                ),
                child: Text(
                  l10n.dataConsentHeaderDescription,
                  style: theme.textTheme.bodyMedium,
                ),
              ),
              for (final consent in snapshot.items)
                SwitchListTile(
                  key: ValueKey<String>('data-consent-tile-${consent.id}'),
                  title: Text(_typeTitle(l10n, consent.type)),
                  subtitle: Text(_typeSubtitle(l10n, consent.type)),
                  value: snapshot.isAccepted(consent.id),
                  onChanged: disabled ? null : (_) => onToggle(consent.id),
                ),
              const Divider(height: AppDimensions.space32),
              _PrivacyReferenceLink(l10n: l10n),
            ],
          ),
        ),
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.space16),
            child: OutlinedButton.icon(
              key: const ValueKey<String>('data-consent-revoke-button'),
              onPressed: disabled ? null : onRevoke,
              icon: const Icon(Icons.lock_reset_outlined),
              label: Text(l10n.dataConsentRevokeAction),
            ),
          ),
        ),
      ],
    );
  }

  String _typeTitle(final AppLocalizations l10n, final DataConsentType t) {
    switch (t) {
      case DataConsentType.jccm:
        return l10n.dataConsentTypeJccmTitle;
      case DataConsentType.otrasAdmin:
        return l10n.dataConsentTypeOtrasAdminTitle;
      case DataConsentType.perfilado:
        return l10n.dataConsentTypePerfiladoTitle;
    }
  }

  String _typeSubtitle(
    final AppLocalizations l10n,
    final DataConsentType t,
  ) {
    switch (t) {
      case DataConsentType.jccm:
        return l10n.dataConsentTypeJccmSubtitle;
      case DataConsentType.otrasAdmin:
        return l10n.dataConsentTypeOtrasAdminSubtitle;
      case DataConsentType.perfilado:
        return l10n.dataConsentTypePerfiladoSubtitle;
    }
  }
}

class _PrivacyReferenceLink extends StatelessWidget {
  const _PrivacyReferenceLink({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.space16,
        vertical: AppDimensions.space8,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            l10n.dataConsentPrivacyReferenceTitle,
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: AppDimensions.space4),
          Text(
            l10n.dataConsentPrivacyReferenceBody,
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: AppDimensions.space8),
          TextButton.icon(
            key: const ValueKey<String>('data-consent-privacy-link'),
            onPressed: () => context.go(Routes.consent),
            icon: const Icon(Icons.open_in_new),
            label: Text(l10n.dataConsentPrivacyReferenceCta),
          ),
        ],
      ),
    );
  }
}
