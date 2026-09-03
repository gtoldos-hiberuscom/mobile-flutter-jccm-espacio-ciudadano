import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/routing/app_router.dart';
import 'package:jccm_espacio_ciudadano/core/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/features/legal/2_presentation/privacy_page.dart';

void main() {
  group('buildLegalPrivacy', () {
    test('la ruta informativa abre la página para leerla, no como paso del consentimiento', () {
      // La (i) de "Condiciones de uso y autorizaciones" y el menú de perfil
      // abren esta ruta: pintarla como paso del consentimiento arrastraba sus
      // botones de "Salir" y "Continuar" y dejaba la pantalla sin flecha de
      // volver.
      final page = buildLegalPrivacy(Uri.parse(Routes.legalPrivacyInfo));

      expect(page, isA<PrivacyPage>().having((final p) => p.fromHome, 'fromHome', isTrue));
    });

    test('sin marcador es un paso del flujo legal', () {
      final page = buildLegalPrivacy(Uri.parse(Routes.legalPrivacy));

      expect(page, isA<PrivacyPage>().having((final p) => p.fromHome, 'fromHome', isFalse));
    });

    test('el modo onboarding llega a la página', () {
      final page = buildLegalPrivacy(Uri.parse('${Routes.legalPrivacy}?mode=onboarding'));

      expect(
        page,
        isA<PrivacyPage>().having((final p) => p.isOnboarding, 'isOnboarding', isTrue).having((final p) => p.fromHome, 'fromHome', isFalse),
      );
    });
  });
}
