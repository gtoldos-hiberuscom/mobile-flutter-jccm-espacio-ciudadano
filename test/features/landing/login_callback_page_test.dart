import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/core/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/features/landing/2_presentation/landing_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/landing/2_presentation/login_callback_page.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

GoRouter _buildRouter() => GoRouter(
  initialLocation: Routes.claveCallback,
  routes: [
    GoRoute(path: Routes.claveCallback, builder: (final _, final _) => const LoginCallbackPage()),
    GoRoute(path: Routes.landing, builder: (final _, final _) => const Scaffold(body: Text('LANDING'))),
    GoRoute(path: Routes.home, builder: (final _, final _) => const Scaffold(body: Text('HOME'))),
  ],
);

Widget _buildApp({final LandingNotifier Function()? landingNotifier}) => ProviderScope(
  overrides: [
    if (landingNotifier != null) landingProvider.overrideWith(landingNotifier),
  ],
  child: MaterialApp.router(
    routerConfig: _buildRouter(),
    locale: const Locale('es'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
  ),
);

void main() {
  testWidgets('with nothing in flight, the watchdog returns to the landing instead of hanging forever', (final tester) async {
    await tester.pumpWidget(_buildApp());

    expect(find.text('Accediendo con Cl@ve'), findsOneWidget);

    await tester.pump(LoginCallbackPage.neutralGrace + const Duration(milliseconds: 100));
    await tester.pump();
    await tester.pump();

    expect(find.text('LANDING'), findsOneWidget);
  });

  testWidgets('a stale loginSuccess navigates once and the one-shot flag is consumed', (final tester) async {
    await tester.pumpWidget(
      _buildApp(landingNotifier: () => _SeededLandingNotifier(const LandingState(loginSuccess: true))),
    );

    await tester.pump();
    await tester.pump();

    expect(find.text('HOME'), findsOneWidget);
    final container = ProviderScope.containerOf(tester.element(find.text('HOME')));
    expect(container.read(landingProvider).loginSuccess, isFalse, reason: 'the flag must not auto-navigate a later visit');
  });

  testWidgets('an in-flight login that never resolves is aborted by the long watchdog', (final tester) async {
    await tester.pumpWidget(
      _buildApp(landingNotifier: () => _SeededLandingNotifier(const LandingState(isLoggingIn: true))),
    );

    expect(find.text('Accediendo con Cl@ve'), findsOneWidget);

    await tester.pump(LoginCallbackPage.inFlightGrace + const Duration(seconds: 1));
    await tester.pump();
    await tester.pump();

    expect(find.text('LANDING'), findsOneWidget);
  });
}

final class _SeededLandingNotifier extends LandingNotifier {
  _SeededLandingNotifier(this._initial);

  final LandingState _initial;

  @override
  LandingState build() => _initial;
}
