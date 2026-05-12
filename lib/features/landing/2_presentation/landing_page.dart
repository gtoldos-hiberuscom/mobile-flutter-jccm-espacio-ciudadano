import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_button.dart';
import 'package:jccm_espacio_ciudadano/core/routing/app_router.dart';
import 'package:jccm_espacio_ciudadano/core/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/features/landing/2_presentation/landing_notifier.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Public anonymous landing screen — redesigned per 00_Splash_Inicio.png.
///
/// Layout:
/// - Expanded scrollable hero area (logo, title+dot-grid, tagline, decorative circles).
/// - Fixed sticky bottom CTA section (about, login, help).
///
/// All auth orchestration is delegated to [LandingNotifier].
/// Route navigation uses GoRouter's [context.push] extension.
class LandingPage extends ConsumerWidget {
  const LandingPage({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final landingState = ref.watch(landingProvider);
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;

    ref.listen<LandingState>(landingProvider, (final previous, final next) {
      if (next.loginSuccess) {
        ref.read(goRouterProvider).go(Routes.sitemap);
      }
      if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.domainGenericLoadError)),
        );
        ref.read(landingProvider.notifier).clearError();
      }
    });

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Scrollable hero area ─────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.space24,
              ),
              child: SafeArea(
                bottom: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: AppDimensions.space40),

                    // ── JCCM logo ─────────────────────────────────────────
                    const _JccmLogo(),
                    const SizedBox(height: AppDimensions.space32),

                    // ── Title row (dot-grid + "Espacio ciudadano") ─────────
                    Row(
                      children: [
                        const _DotGridDecoration(),
                        const SizedBox(width: AppDimensions.space16),
                        Expanded(
                          child: Text(
                            l10n.landingTitle,
                            style: textTheme.headlineLarge?.copyWith(
                              color: AppColors.primaryDark,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.space16),

                    // ── Tagline (mixed weight) ─────────────────────────────
                    _TaglineText(l10n: l10n, textTheme: textTheme),
                    const SizedBox(height: AppDimensions.space32),

                    // ── Decorative circle hero area ────────────────────────
                    const _DecorativeHero(),
                    const SizedBox(height: AppDimensions.space32),
                  ],
                ),
              ),
            ),
          ),

          // ── Sticky bottom CTA section ─────────────────────────────────────
          _BottomCtaSection(
            l10n: l10n,
            isLoggingIn: landingState.isLoggingIn,
            onLogin: () => ref.read(landingProvider.notifier).login(),
            onAbout: () => context.push(Routes.landingAbout),
            onHelp: () => context.push(Routes.landingHelp),
          ),
        ],
      ),
    );
  }
}

// ── JCCM institutional logo ────────────────────────────────────────────────────

class _JccmLogo extends StatelessWidget {
  const _JccmLogo();

  @override
  Widget build(final BuildContext context) {
    return Semantics(
      label: 'Logotipo de la Junta de Comunidades de Castilla-La Mancha',
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.primaryContainer,
              borderRadius: BorderRadius.circular(AppDimensions.radiusXLarge),
            ),
            child: const Icon(
              Icons.account_balance_outlined,
              size: 40,
              color: AppColors.primaryDark,
            ),
          ),
          const SizedBox(height: AppDimensions.space8),
          const Text(
            'Castilla - La Mancha',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.primaryDark,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Dot-grid decoration (4×5 grid, teal top rows / navy bottom rows) ──────────

class _DotGridDecoration extends StatelessWidget {
  const _DotGridDecoration();

  static const _teal = Color(0xFF009DA5);
  static const _navy = AppColors.primaryDark;
  static const _dotSize = 7.0;
  static const _dotGap = 5.0;
  static const _cols = 4;
  static const _rows = 5;

  @override
  Widget build(final BuildContext context) {
    return Semantics(
      excludeSemantics: true,
      child: SizedBox(
        width: _cols * (_dotSize + _dotGap) - _dotGap,
        height: _rows * (_dotSize + _dotGap) - _dotGap,
        child: Column(
          children: List.generate(_rows, (final row) {
            final color = row < 3 ? _teal : _navy;
            return Padding(
              padding: EdgeInsets.only(bottom: row < _rows - 1 ? _dotGap : 0),
              child: Row(
                children: List.generate(_cols, (final col) {
                  return Padding(
                    padding: EdgeInsets.only(right: col < _cols - 1 ? _dotGap : 0),
                    child: Container(
                      width: _dotSize,
                      height: _dotSize,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                    ),
                  );
                }),
              ),
            );
          }),
        ),
      ),
    );
  }
}

// ── Tagline with mixed weight ─────────────────────────────────────────────────

class _TaglineText extends StatelessWidget {
  const _TaglineText({required this.l10n, required this.textTheme});

  final AppLocalizations l10n;
  final TextTheme textTheme;

  @override
  Widget build(final BuildContext context) {
    // "Gestión ágil y online de trámites para la ciudadanía de" (regular)
    // "Castilla-La Mancha" (bold)
    const regular = 'Gestión ágil y online de trámites para la ciudadanía de ';
    const bold = 'Castilla-La Mancha';
    final baseStyle = textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary);
    // ignore: prefer_const_constructors
    return RichText(
      text: TextSpan(
        style: baseStyle,
        children: [
          const TextSpan(text: regular),
          TextSpan(
            text: bold,
            style: baseStyle?.copyWith(fontWeight: FontWeight.w700, color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }
}

// ── Decorative hero (scattered teal + navy circles placeholder) ───────────────

class _DecorativeHero extends StatelessWidget {
  const _DecorativeHero();

  @override
  Widget build(final BuildContext context) {
    return Semantics(
      excludeSemantics: true,
      child: const SizedBox(
        height: 220,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Large teal circle — top-left
            Positioned(
              top: 10,
              left: 20,
              child: _Circle(size: 90, color: Color(0xBF009DA5)),
            ),
            // Medium navy circle — top-right
            Positioned(
              top: 0,
              right: 30,
              child: _Circle(size: 60, color: Color(0x99002B73)),
            ),
            // Small teal circle — right edge
            Positioned(
              top: 70,
              right: 10,
              child: _Circle(size: 36, color: Color(0x80009DA5)),
            ),
            // Large navy circle — bottom-left
            Positioned(
              bottom: 10,
              left: 0,
              child: _Circle(size: 80, color: Color(0x66002B73)),
            ),
            // Medium teal circle — bottom-center
            Positioned(
              bottom: 5,
              left: 100,
              child: _Circle(size: 55, color: Color(0x99009DA5)),
            ),
            // Small navy circle — center
            Positioned(
              top: 90,
              left: 160,
              child: _Circle(size: 30, color: Color(0x59002B73)),
            ),
            // Small teal circle — bottom-right
            Positioned(
              bottom: 20,
              right: 60,
              child: _Circle(size: 44, color: Color(0x73009DA5)),
            ),
            // Very small navy — top-center
            Positioned(
              top: 30,
              left: 140,
              child: _Circle(size: 22, color: Color(0x80002B73)),
            ),
          ],
        ),
      ),
    );
  }
}

class _Circle extends StatelessWidget {
  const _Circle({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(final BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}

// ── Sticky bottom CTA section ─────────────────────────────────────────────────

class _BottomCtaSection extends StatelessWidget {
  const _BottomCtaSection({
    required this.l10n,
    required this.isLoggingIn,
    required this.onLogin,
    required this.onAbout,
    required this.onHelp,
  });

  final AppLocalizations l10n;
  final bool isLoggingIn;
  final VoidCallback onLogin;
  final VoidCallback onAbout;
  final VoidCallback onHelp;

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
              // ── "Saber más" outlined button ──────────────────────────────
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  label: l10n.landingAboutButton,
                  semanticsLabel: l10n.landingAboutButton,
                  variant: AppButtonVariant.outlined,
                  onPressed: onAbout,
                ),
              ),
              const SizedBox(height: AppDimensions.space12),

              // ── "Acceder a tu espacio" filled navy button ─────────────────
              SizedBox(
                width: double.infinity,
                child: _NavyFilledButton(
                  label: l10n.landingCtaButton,
                  icon: Icons.launch_rounded,
                  isLoading: isLoggingIn,
                  onPressed: isLoggingIn ? null : onLogin,
                ),
              ),
              const SizedBox(height: AppDimensions.space12),

              // ── "¿Cómo acceder? - Ayuda" text link ───────────────────────
              Center(
                child: Semantics(
                  button: true,
                  label: l10n.landingHelpLink,
                  child: InkWell(
                    onTap: onHelp,
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
                            Icons.help_outline_rounded,
                            size: AppDimensions.iconSmall,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: AppDimensions.space4),
                          Text(
                            l10n.landingHelpLink,
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

// ── Navy filled button (design-token override for primaryDark bg) ─────────────

class _NavyFilledButton extends StatelessWidget {
  const _NavyFilledButton({
    required this.label,
    required this.icon,
    required this.isLoading,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final bool isLoading;
  final VoidCallback? onPressed;

  @override
  Widget build(final BuildContext context) {
    return Semantics(
      label: label,
      button: true,
      enabled: onPressed != null,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryDark,
          foregroundColor: AppColors.textOnPrimary,
          disabledBackgroundColor: AppColors.disabled,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          ),
        ),
        icon: isLoading
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.textOnPrimary),
              )
            : Icon(icon, size: AppDimensions.iconSmall),
        label: Text(label),
      ),
    );
  }
}
