import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_typography.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_bullet_list.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_button.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_navigation.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_stickybar.dart';
import 'package:jccm_espacio_ciudadano/core/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/features/landing/2_presentation/landing_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/landing/2_presentation/widgets/clave_login_veil.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// "Saber más sobre Espacio Ciudadano" screen — Figma `44469:24782`.
///
/// Uses DS components: [AppNavBar], [AppStickybar], [AppButton], [AppBulletItem].
///
/// **Accessibility (WCAG 2.1 AA):**
/// - Rule 3.1/3.2: H1 via Positioned node announced first.
/// - Rule 3.5: 48dp touch targets via [AppButton].
/// - Rule 3.18: bullet items use unified Semantics label per item.
class LandingAboutPage extends ConsumerWidget {
  const LandingAboutPage({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final landingState = ref.watch(landingProvider);

    // Mismo velo que en la home pública: desde aquí también se accede con
    // Cl@ve, y sin él se pulsaba "Acceder" y no ocurría nada visible.
    return ClaveLoginVeil(
      isAuthenticating: landingState.isLoggingIn || landingState.loginSuccess,
      child: Scaffold(
        backgroundColor: AppColors.surface,
        appBar: AppNavBar(
          type: AppNavBarType.detail,
          title: l10n.landingAboutPageTitle,
          onClose: () => Navigator.of(context).pop(),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Scrollable body ────────────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  AppDimensions.space16,
                  AppDimensions.space16,
                  AppDimensions.space16,
                  AppDimensions.space24,
                ),
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
                        label: l10n.landingAboutTitle,
                        child: const SizedBox(width: 1, height: 1),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            top: AppDimensions.space8,
                            bottom: AppDimensions.space16,
                          ),
                          child: ExcludeSemantics(
                            child: Text(
                              l10n.landingAboutTitle,
                              style: AppTypography.h1.copyWith(
                                color: AppColors.primaryDark,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: AppDimensions.space8),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: AppDimensions.space4),
                          child: Text(
                            l10n.landingAboutBody,
                            style: AppTypography.bodyRegular.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppDimensions.space16),

                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: AppDimensions.space8),
                          child: Semantics(
                            header: true,
                            headingLevel: 2,
                            child: Text(
                              l10n.landingAboutWhatYouFindTitle,
                              style: AppTypography.h2.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: AppDimensions.space8),

                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: AppDimensions.space4),
                          child: Text(
                            l10n.landingAboutWhatYouFindIntro,
                            style: AppTypography.bodyRegular.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppDimensions.space8),

                        Padding(
                          padding: const EdgeInsets.fromLTRB(
                            AppDimensions.space16,
                            AppDimensions.space4,
                            0,
                            AppDimensions.space4,
                          ),
                          child: AppBulletList(
                            textStyle: AppTypography.bodyRegular.copyWith(
                              color: AppColors.textBlack,
                            ),
                            items: [
                              l10n.landingAboutBullet1,
                              l10n.landingAboutBullet2,
                              l10n.landingAboutBullet3,
                              l10n.landingAboutBullet4,
                              l10n.landingAboutBullet5,
                              l10n.landingAboutBullet6,
                            ],
                          ),
                        ),
                        const SizedBox(height: AppDimensions.space16),

                        AppButton(
                          label: l10n.landingAboutHelpLink,
                          hierarchy: AppButtonHierarchy.ghost,
                          size: AppButtonSize.small,
                          icon: const Icon(Icons.help_outline, size: AppDimensions.iconSmall),
                          onPressed: () => context.push(Routes.helpContact),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // ── Sticky CTA bar ─────────────────────────────────────────────
            AppStickybar(
              bottomPadding: AppDimensions.space24,
              children: [
                AppButton(
                  label: l10n.landingAboutAccessButton,
                  icon: const Icon(Icons.check, size: AppDimensions.iconMedium),
                  isLoading: landingState.isLoggingIn,
                  onPressed: landingState.isLoggingIn ? null : () => ref.read(landingProvider.notifier).login(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
