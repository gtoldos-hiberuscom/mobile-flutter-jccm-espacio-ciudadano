import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/core/demo/demo_mode_provider.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Cinta «DEMO» sobre toda la aplicación mientras la sesión es la de
/// demostración.
///
/// Se engancha en el `builder` de `MaterialApp.router`, por encima del router,
/// así que se ve en **todas** las pantallas —también las que viven fuera de la
/// `ShellRoute` (preferencias, consentimiento, carnés)— sin tocar ningún
/// layout ni `SafeArea`: la cinta se pinta encima, no ocupa sitio.
class DemoModeBanner extends ConsumerWidget {
  const DemoModeBanner({required this.child, super.key});

  final Widget child;

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    if (!ref.watch(demoModeProvider)) {
      return child;
    }
    return Banner(
      message: AppLocalizations.of(context).demoBannerLabel,
      location: BannerLocation.topEnd,
      color: AppColors.warningDark,
      child: child,
    );
  }
}
