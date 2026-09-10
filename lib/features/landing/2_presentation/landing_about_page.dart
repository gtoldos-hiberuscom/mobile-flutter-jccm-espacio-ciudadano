import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_page_layout.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_typography.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_bullet_list.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_button.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_navigation.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_stickybar.dart';
import 'package:jccm_espacio_ciudadano/features/landing/2_presentation/landing_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/landing/2_presentation/widgets/clave_login_veil.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// "Saber más sobre Espacio Ciudadano" screen — per 02_About.png.
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
          type: AppNavBarType.level2,
          title: l10n.landingAboutPageTitle,
          onBack: () => Navigator.of(context).pop(),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Scrollable body ────────────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: isTabletLayout(context) ? AppDimensions.space40 : AppDimensions.space24,
                  vertical: AppDimensions.space24,
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
                        // Visual H1 title
                        ExcludeSemantics(
                          child: Text(
                            l10n.landingAboutTitle,
                            style: AppTypography.h1.copyWith(
                              color: AppColors.textBase,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppDimensions.space16),

                        // Mixed-weight description paragraph — Figma: Body/Base 16px w400/w700
                        Semantics(
                          label: '${l10n.landingAboutBodyPrefix} ${l10n.landingAboutBodyBold} ${l10n.landingAboutBodySuffix}',
                          child: ExcludeSemantics(
                            child: RichText(
                              text: TextSpan(
                                style: AppTypography.bodyBase.copyWith(
                                  color: AppColors.textBase,
                                ),
                                children: [
                                  TextSpan(text: '${l10n.landingAboutBodyPrefix} '),
                                  TextSpan(
                                    text: l10n.landingAboutBodyBold,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  TextSpan(text: ' ${l10n.landingAboutBodySuffix}'),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: AppDimensions.space32),

                        // "¿Qué encontrarás?" — Figma: Headings/H2 24px w600 h150%
                        Semantics(
                          header: true,
                          headingLevel: 2,
                          child: Text(
                            l10n.landingAboutWhatYouFindTitle,
                            style: AppTypography.h2.copyWith(
                              color: AppColors.textBase,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppDimensions.space8),

                        Text(
                          l10n.landingAboutWhatYouFindIntro,
                          style: AppTypography.bodyBase.copyWith(
                            color: AppColors.textBase,
                          ),
                        ),
                        const SizedBox(height: AppDimensions.space16),

                        // Bullet list — 6 items, color primary
                        ...[
                          l10n.landingAboutBullet1,
                          l10n.landingAboutBullet2,
                          l10n.landingAboutBullet3,
                          l10n.landingAboutBullet4,
                          l10n.landingAboutBullet5,
                          l10n.landingAboutBullet6,
                        ].map(
                          (final bullet) => Padding(
                            padding: const EdgeInsets.only(
                              bottom: AppDimensions.space12,
                            ),
                            child: AppBulletItem(text: bullet),
                          ),
                        ),
                        const SizedBox(height: AppDimensions.space32),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // ── Sticky CTA bar ─────────────────────────────────────────────
            AppStickybar(
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
