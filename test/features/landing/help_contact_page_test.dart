import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/core/config/app_config.dart';
import 'package:jccm_espacio_ciudadano/core/config/app_config_provider.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/core/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/jwt_claims.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/jwt_claims_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/external_links/0_entity/external_link.dart';
import 'package:jccm_espacio_ciudadano/features/external_links/1_domain/external_link_launcher.dart';
import 'package:jccm_espacio_ciudadano/features/external_links/2_presentation/providers/external_links_provider.dart';
import 'package:jccm_espacio_ciudadano/features/landing/2_presentation/help_contact_page.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

void main() {
  // Sin sesión el gateway no atiende el formulario de la app, así que el botón
  // manda al formulario de la web avisando de que se sale (JCCMEC-212).
  testWidgets('sin sesión, el formulario de soporte abre la web tras avisar', (final tester) async {
    final launcher = _RecordingLauncher();
    await _pumpContactTab(tester, launcher: launcher);

    final button = find.widgetWithText(AppButton, 'Formulario de Soporte');
    expect(tester.widget<AppButton>(button).trailingIcon, AppIcons.openInNew);

    await tester.tap(button);
    await tester.pumpAndSettle();
    expect(find.text('Vas a salir de la aplicación'), findsOneWidget);

    await tester.tap(find.text('Continuar'));
    await tester.pumpAndSettle();

    expect(launcher.launched.map((final link) => link.url), [Uri.parse('https://espaciociudadano-uat.jccm.es/soporte')]);
    expect(find.text('support-form'), findsNothing);
  });

  testWidgets('con sesión, el formulario de soporte sigue dentro de la app', (final tester) async {
    final launcher = _RecordingLauncher();
    await _pumpContactTab(
      tester,
      launcher: launcher,
      claims: const JwtClaims(exp: 0, iat: 0, iss: '', aud: [], sub: 'sub'),
    );

    final button = find.widgetWithText(AppButton, 'Formulario de Soporte');
    expect(tester.widget<AppButton>(button).trailingIcon, AppIcons.arrowForward);

    await tester.tap(button);
    await tester.pumpAndSettle();

    expect(find.text('support-form'), findsOneWidget);
    expect(launcher.launched, isEmpty);
  });
}

Future<void> _pumpContactTab(final WidgetTester tester, {required final ExternalLinkLauncher launcher, final JwtClaims? claims}) async {
  final router = GoRouter(
    routes: [
      GoRoute(path: '/', builder: (final context, final state) => const HelpContactPage()),
      GoRoute(path: Routes.supportForm, builder: (final context, final state) => const Text('support-form')),
    ],
  );
  addTearDown(router.dispose);
  // La pestaña es una ListView perezosa: con la pantalla por defecto el botón
  // de soporte, que va al final, ni se construye.
  tester.view.physicalSize = const Size(1080, 4000);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        appConfigProvider.overrideWithValue(const AppConfig.fromMap({'APP_FLAVOR': 'development'})),
        externalLinkLauncherProvider.overrideWithValue(launcher),
        if (claims != null) jwtClaimsProvider.overrideWith(() => _StubJwtClaimsNotifier(claims)),
      ],
      child: MaterialApp.router(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('es'),
        routerConfig: router,
      ),
    ),
  );
  await tester.pumpAndSettle();
  await tester.tap(find.text('Contacto'));
  await tester.pumpAndSettle();
}

final class _RecordingLauncher implements ExternalLinkLauncher {
  final List<ExternalLink> launched = [];

  @override
  Future<ExternalLinkLaunchResult> launch(final ExternalLink link) async {
    launched.add(link);
    return const ExternalLinkLaunchSuccess();
  }
}

final class _StubJwtClaimsNotifier extends JwtClaimsNotifier {
  _StubJwtClaimsNotifier(this._claims);

  final JwtClaims _claims;

  @override
  JwtClaims? build() => _claims;
}
