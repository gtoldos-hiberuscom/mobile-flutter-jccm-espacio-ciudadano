import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/features/landing/2_presentation/landing_notifier.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// "Saber más sobre el Espacio Ciudadano" screen — per 02_About.png.
///
/// Static informational screen describing the Citizen Space features.
/// The primary CTA re-uses [LandingNotifier.login] — no new provider needed.
class LandingAboutPage extends ConsumerWidget {
  const LandingAboutPage({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final landingState = ref.watch(landingProvider);

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: Text(l10n.landingAboutPageTitle),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Scrollable body ────────────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.space24,
                vertical: AppDimensions.space24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Large bold title
                  Text(
                    l10n.landingAboutTitle,
                    style: textTheme.headlineMedium?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.space16),

                  // Mixed-weight description paragraph
                  RichText(
                    text: TextSpan(
                      style: textTheme.bodyLarge?.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                      children: [
                        // Title is repeated inline as the subject
                        TextSpan(
                          text: '${l10n.landingAboutTitle} ',
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        TextSpan(text: '${l10n.landingAboutBodyPrefix} '),
                        TextSpan(
                          text: l10n.landingAboutBodyBold,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        TextSpan(text: ' ${l10n.landingAboutBodySuffix}'),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppDimensions.space32),

                  // "¿Qué encontrarás?" section
                  Text(
                    l10n.landingAboutWhatYouFindTitle,
                    style: textTheme.titleLarge?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.space12),

                  Text(
                    l10n.landingAboutWhatYouFindIntro,
                    style: textTheme.bodyLarge?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.space16),

                  // Bullet list with two-dot style
                  ...[
                    l10n.landingAboutBullet1,
                    l10n.landingAboutBullet2,
                    l10n.landingAboutBullet3,
                    l10n.landingAboutBullet4,
                    l10n.landingAboutBullet5,
                    l10n.landingAboutBullet6,
                    l10n.landingAboutBullet7,
                  ].map(
                    (final bullet) => Padding(
                      padding: const EdgeInsets.only(bottom: AppDimensions.space12),
                      child: _TwoDotBulletItem(text: bullet, textTheme: textTheme),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.space32),
                ],
              ),
            ),
          ),

          // ── Sticky bottom CTA section ──────────────────────────────────────
          _AboutBottomSection(
            l10n: l10n,
            isLoggingIn: landingState.isLoggingIn,
            onLogin: () => ref.read(landingProvider.notifier).login(),
          ),
        ],
      ),
    );
  }
}

// ── Two-dot bullet item ───────────────────────────────────────────────────────

class _TwoDotBulletItem extends StatelessWidget {
  const _TwoDotBulletItem({required this.text, required this.textTheme});

  final String text;
  final TextTheme textTheme;

  static const _teal = Color(0xFF009DA5);

  @override
  Widget build(final BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: _teal,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 3),
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.primaryDark,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: AppDimensions.space12),
        Expanded(
          child: Text(
            text,
            style: textTheme.bodyLarge?.copyWith(
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}

// ── Sticky bottom section ─────────────────────────────────────────────────────

class _AboutBottomSection extends StatelessWidget {
  const _AboutBottomSection({
    required this.l10n,
    required this.isLoggingIn,
    required this.onLogin,
  });

  final AppLocalizations l10n;
  final bool isLoggingIn;
  final VoidCallback onLogin;

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
              // "Acceder ahora" filled navy button
              Semantics(
                label: l10n.landingAboutAccessButton,
                button: true,
                enabled: !isLoggingIn,
                child: ElevatedButton.icon(
                  onPressed: isLoggingIn ? null : onLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryDark,
                    foregroundColor: AppColors.textOnPrimary,
                    disabledBackgroundColor: AppColors.disabled,
                    minimumSize: const Size(double.infinity, 52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                    ),
                  ),
                  icon: isLoggingIn
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.textOnPrimary,
                          ),
                        )
                      : const Icon(Icons.launch_rounded, size: AppDimensions.iconSmall),
                  label: Text(l10n.landingAboutAccessButton),
                ),
              ),
              const SizedBox(height: AppDimensions.space12),

              // "Enlace externo" text link with open_in_new icon
              Center(
                child: Semantics(
                  button: true,
                  label: l10n.landingAboutExternalLink,
                  child: InkWell(
                    onTap: () {
                      // TODO(STORY-17): open external URL via url_launcher when added.
                    },
                    borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.space8,
                        vertical: AppDimensions.space8,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.open_in_new_rounded,
                            size: AppDimensions.iconSmall,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: AppDimensions.space4),
                          Text(
                            l10n.landingAboutExternalLink,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.primary,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
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
