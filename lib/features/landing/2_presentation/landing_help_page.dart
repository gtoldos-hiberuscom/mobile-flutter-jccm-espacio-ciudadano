import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_typography.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_button.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_navigation.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_stickybar.dart';
import 'package:jccm_espacio_ciudadano/core/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/features/landing/2_presentation/landing_notifier.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// "Cómo acceder" screen — per 01_AyudaAcceso.png.
///
/// Uses DS components: [AppNavBar], [AppStickybar], [AppButton].
///
/// **Accessibility (WCAG 2.1 AA):**
/// - Rule 3.1/3.2: H1 via Positioned node announced first.
/// - Rule 3.5: 48dp touch targets via [AppButton].
class LandingHelpPage extends ConsumerWidget {
  const LandingHelpPage({
    super.key,
    this.fromHome = false,
  });

  final bool fromHome;

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final landingState = ref.watch(landingProvider);

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppNavBar(
        type: AppNavBarType.level2,
        title: l10n.landingHelpPageTitle,
        onBack: () => _goBack(context),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Scrollable body ────────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.space24,
              ).copyWith(top: AppDimensions.space16),
              child: Stack(
                children: [
                  // Rule 3.2 — H1 announced first by SR
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Semantics(
                      header: true,
                      headingLevel: 1,
                      focusable: true,
                      label: l10n.landingHelpTitle,
                      child: const SizedBox(width: 1, height: 1),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Visual H1 title — Figma: Headings/H1 28px w600 h150% — padding: 8px top / 16px bottom
                      Padding(
                        padding: const EdgeInsets.only(
                          top: AppDimensions.space8,
                          bottom: AppDimensions.space16,
                        ),
                        child: ExcludeSemantics(
                          child: Text(
                            l10n.landingHelpTitle,
                            style: AppTypography.h1.copyWith(
                              color: AppColors.textBase,
                            ),
                          ),
                        ),
                      ),

                      // Body paragraph 1 — Figma: Body/Large 18px w500 h150% — padding: 4px top / 16px bottom
                      Padding(
                        padding: const EdgeInsets.only(
                          top: AppDimensions.space4,
                          bottom: AppDimensions.space16,
                        ),
                        child: Text(
                          l10n.landingHelpBody1,
                          style: AppTypography.bodyL.copyWith(
                            color: AppColors.textBase,
                          ),
                        ),
                      ),

                      // Body paragraph 2 — Figma: Body/Large 18px w500 h150% — padding: 4px top / 8px bottom
                      Padding(
                        padding: const EdgeInsets.only(
                          top: AppDimensions.space4,
                          bottom: AppDimensions.space8,
                        ),
                        child: Text(
                          l10n.landingHelpBody2,
                          style: AppTypography.bodyL.copyWith(
                            color: AppColors.textBase,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // ── Sticky CTA bar ─────────────────────────────────────────────
          if (!fromHome)
            AppStickybar(
              children: [
                AppButton(
                  label: l10n.landingHelpAccessButton,
                  icon: const Icon(Icons.check, size: AppDimensions.iconMedium),
                  isLoading: landingState.isLoggingIn,
                  onPressed: landingState.isLoggingIn ? null : () => ref.read(landingProvider.notifier).login(),
                ),
              ],
            ),
        ],
      ),
    );
  }

  void _goBack(final BuildContext context) {
    if (fromHome) {
      context.go(Routes.home);
      return;
    }
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go(Routes.landing);
  }
}
