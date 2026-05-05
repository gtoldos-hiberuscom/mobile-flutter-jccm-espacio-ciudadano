import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/app/routing/app_router.dart';
import 'package:jccm_espacio_ciudadano/app/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/app/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_button.dart';
import 'package:jccm_espacio_ciudadano/features/landing/0_entity/landing_content.dart';
import 'package:jccm_espacio_ciudadano/features/landing/2_presentation/landing_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/landing/2_presentation/providers/landing_content_provider.dart';
import 'package:jccm_espacio_ciudadano/features/landing/2_presentation/widgets/landing_access_step.dart';
import 'package:jccm_espacio_ciudadano/features/landing/2_presentation/widgets/landing_feature_card.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Public anonymous landing screen.
///
/// Shown to unauthenticated users before they initiate the Cl@ve login flow.
/// Sections:
/// 1. Hero — logo, title, tagline.
/// 2. "Qué encontrarás" — 2-column feature grid.
/// 3. "Cómo acceder" — numbered onboarding steps.
/// 4. Primary CTA — navigates to the login route.
/// 5. Footer — accessibility, legal, and help links.
///
/// No business logic lives here — data comes from [landingContentProvider].
/// Login orchestration is delegated to [LandingNotifier].
class LandingPage extends ConsumerWidget {
  const LandingPage({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final content = ref.watch(landingContentProvider);
    final landingState = ref.watch(landingProvider);
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;

    ref.listen<LandingState>(landingProvider, (final previous, final next) {
      if (next.loginSuccess) {
        ref.read(goRouterProvider).go('/sitemap');
      }
      if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.domainGenericLoadError)),
        );
        ref.read(landingProvider.notifier).clearError();
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.space24,
            vertical: AppDimensions.space32,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── 1. Hero section ───────────────────────────────────────────
              _HeroSection(
                title: l10n.landingTitle,
                tagline: l10n.landingTagline,
                textTheme: textTheme,
              ),
              const SizedBox(height: AppDimensions.space40),

              // ── 2. "Qué encontrarás" section ──────────────────────────────
              Text(
                l10n.landingWhatYouFindTitle,
                style: textTheme.headlineSmall?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppDimensions.space16),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: content.features.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: AppDimensions.space12,
                  crossAxisSpacing: AppDimensions.space12,
                  childAspectRatio: 0.9,
                ),
                itemBuilder: (final context, final index) => LandingFeatureCard(item: content.features[index]),
              ),
              const SizedBox(height: AppDimensions.space40),

              // ── 3. "Cómo acceder" section ─────────────────────────────────
              Text(
                l10n.landingHowToAccessTitle,
                style: textTheme.headlineSmall?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppDimensions.space16),
              ...content.accessSteps.map(
                (final step) => Padding(
                  padding: const EdgeInsets.only(bottom: AppDimensions.space20),
                  child: LandingAccessStepWidget(step: step),
                ),
              ),
              const SizedBox(height: AppDimensions.space24),

              // ── 4. Primary CTA ────────────────────────────────────────────
              AppButton(
                label: l10n.landingCtaButton,
                semanticsLabel: l10n.landingCtaButton,
                onPressed: landingState.isLoggingIn ? null : () => ref.read(landingProvider.notifier).login(),
              ),
              const SizedBox(height: AppDimensions.space40),

              // ── 5. Footer links ───────────────────────────────────────────
              _FooterLinks(l10n: l10n, links: content.links),
              const SizedBox(height: AppDimensions.space24),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Hero section ─────────────────────────────────────────────────────────────

class _HeroSection extends StatelessWidget {
  const _HeroSection({
    required this.title,
    required this.tagline,
    required this.textTheme,
  });

  final String title;
  final String tagline;
  final TextTheme textTheme;

  @override
  Widget build(final BuildContext context) {
    return Column(
      children: [
        // JCCM logo placeholder — replace with actual asset when available.
        Semantics(
          label: 'Logotipo de la Junta de Comunidades de Castilla-La Mancha',
          child: Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              color: AppColors.primaryContainer,
              borderRadius: BorderRadius.circular(AppDimensions.radiusXLarge),
            ),
            child: const Icon(
              Icons.account_balance_outlined,
              size: 48,
              color: AppColors.primary,
            ),
          ),
        ),
        const SizedBox(height: AppDimensions.space24),
        Text(
          title,
          style: textTheme.headlineLarge?.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppDimensions.space8),
        Text(
          tagline,
          style: textTheme.bodyLarge?.copyWith(
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

// ── Footer links ──────────────────────────────────────────────────────────────

class _FooterLinks extends StatelessWidget {
  const _FooterLinks({required this.l10n, required this.links});

  final AppLocalizations l10n;
  final LandingLinks links;

  @override
  Widget build(final BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: AppDimensions.space16,
      runSpacing: AppDimensions.space8,
      children: [
        _FooterLink(label: l10n.landingFooterHelp),
        _FooterLink(label: l10n.landingFooterAccessibility),
        _FooterLink(label: l10n.landingFooterLegal),
        _FooterLink(label: l10n.landingFooterPrivacy),
      ],
    );
  }
}

class _FooterLink extends StatelessWidget {
  const _FooterLink({required this.label});

  final String label;

  @override
  Widget build(final BuildContext context) {
    return Semantics(
      link: true,
      label: label,
      child: InkWell(
        onTap: () {
          // TODO(STORY-17): open URL via url_launcher when added in a future story.
        },
        borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.space8,
            vertical: AppDimensions.space8,
          ),
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.primary,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ),
    );
  }
}
