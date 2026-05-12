import 'dart:async' show unawaited;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_button.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_loading_indicator.dart';
import 'package:jccm_espacio_ciudadano/core/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/jwt_claims_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/consent/0_entity/clause.dart';
import 'package:jccm_espacio_ciudadano/features/consent/2_presentation/controllers/consent_notifier.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Two-step mandatory legal-consent onboarding gate (JCCMEC-11).
///
/// **Step 1** — Scrollable legal text. The "Aceptar y continuar" CTA is locked
/// until the citizen scrolls to the very bottom of the content.
///
/// **Step 2** — Variable list of authorisation checkboxes. "Aceptar" is locked
/// until every clause is checked. "Marcar todo" checks all at once. The `info`
/// icon in the app bar reopens the full legal text without losing checkbox state.
///
/// Rejection (step 1 or step 2 `X`) clears the in-memory session and navigates
/// the citizen back to the public landing page.
class ConsentPage extends ConsumerStatefulWidget {
  const ConsentPage({super.key});

  @override
  ConsumerState<ConsentPage> createState() => _ConsentPageState();
}

class _ConsentPageState extends ConsumerState<ConsentPage> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) {
      return;
    }
    final pos = _scrollController.position;
    // Trigger unlock when within 64 px of the bottom to give a comfortable
    // threshold and support devices with floating keyboards.
    if (pos.pixels >= pos.maxScrollExtent - 64) {
      final idAgente = ref.read(jwtClaimsProvider)?.idAgente ?? '';
      ref.read(consentProvider(idAgente).notifier).onScrollReachedEnd();
    }
  }

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final idAgente = ref.watch(jwtClaimsProvider)?.idAgente ?? '';
    final state = ref.watch(consentProvider(idAgente));
    final notifier = ref.read(consentProvider(idAgente).notifier);

    // ── Side-effect listener ──────────────────────────────────────────────
    ref.listen<ConsentState>(
      consentProvider(idAgente),
      (final prev, final next) {
        if (!context.mounted) {
          return;
        }
        switch (next.status) {
          case ConsentStatus.accepted:
            context.go(Routes.lifeEvents);
          case ConsentStatus.rejected:
            context.go(Routes.landing);
          case ConsentStatus.saveError:
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(next.errorMessage ?? l10n.consentSaveError),
                behavior: SnackBarBehavior.floating,
              ),
            );
          case ConsentStatus.loading:
          case ConsentStatus.step1Locked:
          case ConsentStatus.step1Unlocked:
          case ConsentStatus.step2:
          case ConsentStatus.saving:
            break;
        }
      },
    );

    // ── Loading ───────────────────────────────────────────────────────────
    if (state.status == ConsentStatus.loading) {
      return const Scaffold(
        body: SafeArea(child: AppLoadingIndicator()),
      );
    }

    // ── Step 1 ────────────────────────────────────────────────────────────
    final isStep1 = state.status == ConsentStatus.step1Locked ||
        state.status == ConsentStatus.step1Unlocked;

    if (isStep1) {
      return _Step1Scaffold(
        l10n: l10n,
        scrollController: _scrollController,
        isUnlocked: state.status == ConsentStatus.step1Unlocked,
        onReject: notifier.reject,
        onAccept: notifier.proceedToStep2,
      );
    }

    // ── Step 2 ────────────────────────────────────────────────────────────
    return _Step2Scaffold(
      l10n: l10n,
      state: state,
      notifier: notifier,
      onShowLegalInfo: () => _showLegalInfoSheet(context, l10n),
    );
  }

  void _showLegalInfoSheet(
    final BuildContext context,
    final AppLocalizations l10n,
  ) {
    unawaited(
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppDimensions.radiusLarge),
          ),
        ),
        builder: (_) => _LegalInfoSheet(l10n: l10n),
      ),
    );
  }
}

// ── Step 1 scaffold ────────────────────────────────────────────────────────────

class _Step1Scaffold extends StatelessWidget {
  const _Step1Scaffold({
    required this.l10n,
    required this.scrollController,
    required this.isUnlocked,
    required this.onReject,
    required this.onAccept,
  });

  final AppLocalizations l10n;
  final ScrollController scrollController;
  final bool isUnlocked;
  final VoidCallback onReject;
  final VoidCallback onAccept;

  @override
  Widget build(final BuildContext context) {
    return Semantics(
      label: l10n.consentPageSemantics,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.consentStep1FullTitle),
          automaticallyImplyLeading: false,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: NotificationListener<ScrollUpdateNotification>(
                // Dual detection: NotificationListener catches programmatic
                // scrolls (e.g. keyboard/TalkBack) that may not fire the
                // ScrollController listener.
                onNotification: (final notification) {
                  if (notification.metrics.pixels >=
                      notification.metrics.maxScrollExtent - 64) {
                    final state = context
                        .findAncestorStateOfType<_ConsentPageState>();
                    if (state != null && state.mounted) {
                      state._onScroll();
                    }
                  }
                  return false;
                },
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(
                    AppDimensions.space24,
                    AppDimensions.space16,
                    AppDimensions.space24,
                    AppDimensions.space24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.consentPageSubtitle,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                      ),
                      const SizedBox(height: AppDimensions.space16),
                      Text(
                        l10n.consentPageBody,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: AppColors.textPrimary,
                              height: 1.6,
                            ),
                      ),
                      // Accessibility: visible hint about scroll requirement.
                      if (!isUnlocked) ...[
                        const SizedBox(height: AppDimensions.space24),
                        _ScrollHint(hint: l10n.consentScrollHint),
                      ],
                    ],
                  ),
                ),
              ),
            ),
            _ConsentBottomBar(
              primaryLabel: l10n.consentAcceptButton,
              primarySemantics: l10n.consentAcceptButton,
              secondaryLabel: l10n.consentRejectButton,
              secondarySemantics: l10n.consentRejectButton,
              isPrimaryEnabled: isUnlocked,
              onPrimary: onAccept,
              onSecondary: onReject,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Step 2 scaffold ────────────────────────────────────────────────────────────

class _Step2Scaffold extends StatelessWidget {
  const _Step2Scaffold({
    required this.l10n,
    required this.state,
    required this.notifier,
    required this.onShowLegalInfo,
  });

  final AppLocalizations l10n;
  final ConsentState state;
  final ConsentNotifier notifier;
  final VoidCallback onShowLegalInfo;

  @override
  Widget build(final BuildContext context) {
    final isSaving = state.status == ConsentStatus.saving;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: Semantics(
          label: l10n.consentCloseButtonSemantics,
          button: true,
          child: IconButton(
            icon: const Icon(Icons.close),
            tooltip: l10n.consentCloseButtonSemantics,
            onPressed: notifier.reject,
          ),
        ),
        title: Text(
          l10n.consentStep1FullTitle,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        actions: [
          Semantics(
            label: l10n.consentInfoButtonSemantics,
            button: true,
            child: IconButton(
              icon: const Icon(Icons.info_outline),
              tooltip: l10n.consentInfoButtonSemantics,
              onPressed: onShowLegalInfo,
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.space16,
                vertical: AppDimensions.space8,
              ),
              itemCount: state.clauses.length,
              separatorBuilder: (final _, final _) => const Divider(
                height: 1,
                thickness: 1,
                color: AppColors.divider,
              ),
              itemBuilder: (final context, final index) {
                final clause = state.clauses[index];
                return _ClauseRow(
                  clause: clause,
                  onToggle: () => notifier.toggleClause(clause.id),
                );
              },
            ),
          ),
          _ConsentBottomBar(
            primaryLabel: l10n.consentFinalAcceptButton,
            primarySemantics: l10n.consentFinalAcceptButton,
            secondaryLabel: l10n.consentMarkAllButton,
            secondarySemantics: l10n.consentMarkAllButton,
            isPrimaryEnabled: state.allClausesSelected && !isSaving,
            isSecondaryEnabled: !state.allClausesSelected && !isSaving,
            isPrimaryLoading: isSaving,
            onPrimary: () => unawaited(notifier.accept()),
            onSecondary: notifier.markAll,
          ),
        ],
      ),
    );
  }
}

// ── Clause row ─────────────────────────────────────────────────────────────────

class _ClauseRow extends StatelessWidget {
  const _ClauseRow({
    required this.clause,
    required this.onToggle,
  });

  final Clause clause;
  final VoidCallback onToggle;

  @override
  Widget build(final BuildContext context) {
    return Semantics(
      label: clause.label,
      checked: clause.isSelected,
      button: true,
      child: InkWell(
        onTap: onToggle,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: AppDimensions.space12,
            horizontal: AppDimensions.space8,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Checkbox is visual only — full-row InkWell handles taps.
              ExcludeSemantics(
                child: Checkbox(
                  value: clause.isSelected,
                  onChanged: (_) => onToggle(),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(AppDimensions.radiusSmall),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppDimensions.space8),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: AppDimensions.space12),
                  child: Text(
                    clause.label,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textPrimary,
                          height: 1.5,
                        ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Scroll hint ────────────────────────────────────────────────────────────────

class _ScrollHint extends StatelessWidget {
  const _ScrollHint({required this.hint});

  final String hint;

  @override
  Widget build(final BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.keyboard_arrow_down, size: AppDimensions.iconSmall),
        const SizedBox(width: AppDimensions.space4),
        Text(
          hint,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
                fontStyle: FontStyle.italic,
              ),
        ),
      ],
    );
  }
}

// ── Shared bottom action bar ───────────────────────────────────────────────────

class _ConsentBottomBar extends StatelessWidget {
  const _ConsentBottomBar({
    required this.primaryLabel,
    required this.primarySemantics,
    required this.secondaryLabel,
    required this.secondarySemantics,
    required this.isPrimaryEnabled,
    required this.onPrimary,
    required this.onSecondary,
    this.isSecondaryEnabled = true,
    this.isPrimaryLoading = false,
  });

  final String primaryLabel;
  final String primarySemantics;
  final String secondaryLabel;
  final String secondarySemantics;
  final bool isPrimaryEnabled;
  final bool isSecondaryEnabled;
  final bool isPrimaryLoading;
  final VoidCallback onPrimary;
  final VoidCallback onSecondary;

  @override
  Widget build(final BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.space24,
            vertical: AppDimensions.space16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppButton(
                label: primaryLabel,
                semanticsLabel: primarySemantics,
                onPressed: isPrimaryEnabled ? onPrimary : null,
                isLoading: isPrimaryLoading,
              ),
              const SizedBox(height: AppDimensions.space12),
              AppButton(
                label: secondaryLabel,
                semanticsLabel: secondarySemantics,
                variant: AppButtonVariant.outlined,
                onPressed: isSecondaryEnabled ? onSecondary : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Legal info bottom sheet ────────────────────────────────────────────────────

class _LegalInfoSheet extends StatelessWidget {
  const _LegalInfoSheet({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(final BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (final context, final scrollController) {
        return Column(
          children: [
            // Drag handle
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: AppDimensions.space12),
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusSmall),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.space24,
              ),
              child: Text(
                l10n.consentStep1FullTitle,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
            const SizedBox(height: AppDimensions.space8),
            Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
                padding: const EdgeInsets.fromLTRB(
                  AppDimensions.space24,
                  AppDimensions.space8,
                  AppDimensions.space24,
                  AppDimensions.space32,
                ),
                child: Text(
                  l10n.consentPageBody,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textPrimary,
                        height: 1.6,
                      ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
