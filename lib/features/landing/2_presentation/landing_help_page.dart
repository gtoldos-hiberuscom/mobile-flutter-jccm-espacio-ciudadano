import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/features/landing/2_presentation/landing_notifier.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// "Ayuda con el acceso" screen — per 01_AyudaAcceso.png.
///
/// Static informational screen explaining Cl@ve access methods.
/// The primary CTA re-uses [LandingNotifier.login] — no new provider needed.
class LandingHelpPage extends ConsumerWidget {
  const LandingHelpPage({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final landingState = ref.watch(landingProvider);

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: Text(l10n.landingHelpPageTitle),
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
                    l10n.landingHelpTitle,
                    style: textTheme.headlineMedium?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.space24),

                  // Body paragraph 1
                  Text(
                    l10n.landingHelpBody1,
                    style: textTheme.bodyLarge?.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.space16),

                  // Body paragraph 2
                  Text(
                    l10n.landingHelpBody2,
                    style: textTheme.bodyLarge?.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.space32),
                ],
              ),
            ),
          ),

          // ── Sticky bottom CTA section ──────────────────────────────────────
          _HelpBottomSection(
            l10n: l10n,
            isLoggingIn: landingState.isLoggingIn,
            onLogin: () => ref.read(landingProvider.notifier).login(),
          ),
        ],
      ),
    );
  }
}

// ── Sticky bottom section ─────────────────────────────────────────────────────

class _HelpBottomSection extends StatelessWidget {
  const _HelpBottomSection({
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
                label: l10n.landingHelpAccessButton,
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
                  label: Text(l10n.landingHelpAccessButton),
                ),
              ),
              const SizedBox(height: AppDimensions.space12),

              // "Enlace externo" text link with open_in_new icon
              Center(
                child: Semantics(
                  button: true,
                  label: l10n.landingHelpExternalLink,
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
                            l10n.landingHelpExternalLink,
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
