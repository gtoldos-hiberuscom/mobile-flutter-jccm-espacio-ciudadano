import 'dart:async' show TimeoutException, unawaited;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_page_layout.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_typography.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_alert.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_button.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_stickybar.dart';
import 'package:jccm_espacio_ciudadano/core/routing/app_router.dart';
import 'package:jccm_espacio_ciudadano/core/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/features/landing/2_presentation/landing_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/landing/2_presentation/widgets/clave_login_veil.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Public anonymous landing screen — 00_Splash/Inicio from Figma.
///
/// Layout (top to bottom):
/// - Scrollable hero area:
///   1. `castilla_logo.svg` (116×68 dp, centered)
///   2. `espacioCiudadano_logo.svg` (256×64 dp)
///   3. Tagline text (Body/Large/Medium + Headings/H2)
///   4. `splash_image.png` hero (full-width, aspect ~353:301)
/// - Fixed [AppStickybar] with 3 action buttons.
///
/// **Accessibility (WCAG 2.1 AA):**
/// - H1 heading announced first via [Semantics] header node.
/// - Decorative images excluded from semantics tree.
/// - Button labels and roles declared via [AppButton] component.
/// - Focus order follows visual order (top-to-bottom).
class LandingPage extends ConsumerStatefulWidget {
  const LandingPage({super.key});

  @override
  ConsumerState<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends ConsumerState<LandingPage> {
  /// Si hay un acceso en curso iniciado *mientras esta página está montada*.
  ///
  /// No se deriva de `landingProvider` directamente: `loginSuccess` es una señal
  /// de un solo uso que nadie limpia, y el provider no es `autoDispose`, así que
  /// al volver a la landing tras cerrar sesión seguiría valiendo `true` y el
  /// velo se quedaría pegado. Al alimentarlo sólo desde las transiciones que
  /// observa `ref.listen`, un valor heredado de la sesión anterior no lo activa.
  bool _isAuthenticating = false;

  /// Cached notifier for safe use in [dispose] (where ref is no longer valid).
  /// Assigned once in [initState] — assigning a `late final` in [build] would
  /// throw on the second build (this page rebuilds on every veil toggle).
  late final LandingNotifier _landingNotifier;

  /// El intento de reanudar la sesión guardada se lanza una sola vez por
  /// montaje: `didChangeDependencies` puede correr varias veces (cambios de
  /// tema, de locale, de métricas).
  bool _didTryRestore = false;

  @override
  void initState() {
    super.initState();
    _landingNotifier = ref.read(landingProvider.notifier);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didTryRestore) {
      return;
    }
    _didTryRestore = true;

    // Las cadenas se resuelven aquí, con el `context` todavía a mano: el
    // notifier no puede traducirlas y el diálogo biométrico de Android las
    // necesita. Se aplaza a después del primer frame para no lanzar trabajo
    // asíncrono durante la construcción del árbol.
    final l10n = AppLocalizations.of(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      unawaited(
        ref.read(landingProvider.notifier).tryRestoreSession(
          localizedTitle: l10n.sessionUnlockBiometricTitle,
          localizedReason: l10n.sessionUnlockBiometricReason,
          localizedCancel: l10n.sessionUnlockBiometricCancel,
        ),
      );
    });
  }

  @override
  void dispose() {
    unawaited(Future.microtask(_landingNotifier.consumeLoginSuccess));
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    final landingState = ref.watch(landingProvider);
    final l10n = AppLocalizations.of(context);

    ref.listen<LandingState>(landingProvider, (final previous, final next) {
      final isAuthenticating = next.isLoggingIn || next.loginSuccess;
      if (mounted && isAuthenticating != _isAuthenticating) {
        setState(() => _isAuthenticating = isAuthenticating);
      }
      if (next.loginSuccess) {
        if (next.isolationDegradedWarning) {
          // Shown via the root ScaffoldMessenger, so it survives the
          // navigation to home below. Curated copy only (project rule).
          AppAlertSnackbar.show(
            context,
            message: l10n.loginIsolationDegradedWarning,
            severity: AppAlertSeverity.warning,
            duration: const Duration(seconds: 8),
          );
        }
        ref.read(goRouterProvider).go(Routes.home);
      }
      if (next.error != null) {
        final errorMsg = next.error!.cause is TimeoutException ? l10n.loginTimeoutError : l10n.domainGenericLoadError;
        AppAlertSnackbar.show(
          context,
          message: errorMsg,
          severity: AppAlertSeverity.error,
        );
        ref.read(landingProvider.notifier).clearError();
      }
    });

    final scaffold = Scaffold(
      backgroundColor: AppColors.surface,
      body: Column(
        children: [
          // ── Scrollable hero content ─────────────────────────────────────
          Expanded(
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: appPageHorizontalPadding(context),
                ),
                child: LayoutBuilder(
                  builder: (final context, final constraints) => FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.topCenter,
                    child: SizedBox(
                      width: 353.15,
                      // Rule 3.2 — H1 announced BEFORE navigation via Positioned(top:0,left:0)
                      child: Stack(
                        children: [
                          // ── H1 semantic heading — 1×1px node announced first by SR ──
                          Positioned(
                            top: 0,
                            left: 0,
                            child: Semantics(
                              header: true,
                              headingLevel: 1,
                              focusable: true,
                              label: l10n.a11yLandingH1Label,
                              child: const SizedBox(width: 1, height: 1),
                            ),
                          ),
                          Column(
                            children: [
                              const SizedBox(height: AppDimensions.space16),

                              // ── Castilla-La Mancha institutional logo ───────────
                              Semantics(
                                label: l10n.a11yCastillaLogoLabel,
                                image: true,
                                excludeSemantics: true,
                                child: SvgPicture.asset(
                                  'assets/images/castilla_logo.svg',
                                  width: 116,
                                  height: 68,
                                ),
                              ),
                              const SizedBox(height: AppDimensions.space24),

                              // ── Espacio Ciudadano logo ──────────────────────────
                              ExcludeSemantics(
                                child: SvgPicture.asset(
                                  'assets/images/espacioCiudadano_logo.svg',
                                  width: 256,
                                  height: 64,
                                ),
                              ),
                              const SizedBox(height: AppDimensions.space24),

                              // ── Tagline ─────────────────────────────────────────
                              const Align(
                                alignment: Alignment.centerLeft,
                                child: _TaglineText(),
                              ),
                              const SizedBox(height: AppDimensions.space24),

                              // ── Hero composition (splash_logo bg + mask group) ──
                              ExcludeSemantics(
                                child: AspectRatio(
                                  aspectRatio: 353.15 / 301.45,
                                  child: LayoutBuilder(
                                    builder: (final context, final constraints) {
                                      final w = constraints.maxWidth;
                                      final h = constraints.maxHeight;
                                      return Stack(
                                        clipBehavior: Clip.none,
                                        children: [
                                          // Background decorative shape (full size)
                                          Positioned.fill(
                                            child: Image.asset(
                                              'assets/images/splash_logo.png',
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                          // Foreground mask group (windmill + hands)
                                          Positioned(
                                            left: w * (75.0 / 353.15),
                                            right: w * (-5.0 / 353.15),
                                            bottom: h * (25.0 / 301.45),
                                            child: Image.asset(
                                              'assets/images/splash_image.png',
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(height: AppDimensions.space16),
                            ],
                          ), // Column
                        ],
                      ), // Stack
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ── Stickybar ───────────────────────────────────────────────────
          AppStickybar(
            children: [
              // Ghost — "Ayuda y contacto"
              AppButton(
                label: l10n.landingHelpLink,
                hierarchy: AppButtonHierarchy.ghost,
                icon: const Icon(Icons.help_outline, size: AppDimensions.iconMedium),
                onPressed: () => context.push(Routes.helpContact),
              ),

              // Secondary — "Información y ayuda sobre el espacio"
              AppButton(
                label: l10n.landingAboutButton,
                hierarchy: AppButtonHierarchy.secondary,
                icon: const Icon(Icons.info_outline, size: AppDimensions.iconMedium),
                onPressed: () => context.push(Routes.landingAbout),
              ),

              // Primary — "Acceder a mi Espacio ciudadano"
              AppButton(
                label: l10n.landingCtaButton,
                icon: const Icon(Icons.check, size: AppDimensions.iconMedium),
                isLoading: landingState.isLoggingIn,
                onPressed: landingState.isLoggingIn ? null : () => ref.read(landingProvider.notifier).login(),
              ),
            ],
          ),
        ],
      ),
    );

    // Sin AppBar, la home debe declarar el estilo desde el primer frame.
    // El velo de Cl@ve declara su propio estilo claro cuando está activo.
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: ClaveLoginVeil(isAuthenticating: _isAuthenticating, child: scaffold),
    );
  }
}

// ── Tagline with mixed weight (Body/Large/Medium + Headings/H2) ───────────────

class _TaglineText extends StatelessWidget {
  const _TaglineText();

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return RichText(
      text: TextSpan(
        style: AppTypography.bodyL.copyWith(color: AppColors.textPrimary),
        children: [
          TextSpan(text: l10n.landingTaglinePrefix),
          TextSpan(
            text: l10n.landingTaglineHighlight,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              height: 1.28,
            ),
          ),
        ],
      ),
    );
  }
}
