import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/0_entity/app_update_info.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/0_entity/app_version.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/0_entity/update_policy.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/2_presentation/widgets/app_update_dialog.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

import 'support/app_update_fakes.dart';

void main() {
  Future<void> pumpDialog(final WidgetTester tester, final AppUpdateInfo info, {final VoidCallback? onLater}) => tester.pumpWidget(
    MaterialApp(
      locale: const Locale('es'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: AppUpdateDialog(info: info, onUpdate: () {}, onLater: onLater),
      ),
    ),
  );

  AppUpdateInfo info({required final UpdatePolicy policy, final String? displayVersion}) => AppUpdateInfo(
    policy: policy,
    latestVersion: const AppVersion(2, 0, 0),
    storeUrl: playStoreUrl,
    displayVersion: displayVersion,
  );

  group('AppUpdateDialog', () {
    testWidgets('forzada con versión legible la enseña', (final tester) async {
      await pumpDialog(tester, info(policy: UpdatePolicy.forced, displayVersion: '2.0.0'));
      expect(find.text('Actualización necesaria'), findsOneWidget);
      expect(find.textContaining('2.0.0'), findsOneWidget);
      expect(find.text('Ahora no'), findsNothing);
    });

    testWidgets('forzada sin versión legible va sin número', (final tester) async {
      await pumpDialog(tester, info(policy: UpdatePolicy.forced));
      expect(find.text('Para seguir usando la aplicación necesitas instalar la última versión disponible. Las versiones anteriores ya no reciben soporte.'), findsOneWidget);
      expect(find.textContaining('0.0.'), findsNothing);
      expect(find.textContaining('2.0.0'), findsNothing);
    });

    testWidgets('recomendada con versión legible la enseña y ofrece «Ahora no»', (final tester) async {
      await pumpDialog(
        tester,
        info(policy: UpdatePolicy.recommended, displayVersion: '2.0.0'),
        onLater: () {},
      );
      expect(find.text('Hay una nueva versión disponible'), findsOneWidget);
      expect(find.textContaining('2.0.0'), findsOneWidget);
      expect(find.text('Ahora no'), findsOneWidget);
    });

    testWidgets('recomendada sin versión legible va sin número', (final tester) async {
      await pumpDialog(tester, info(policy: UpdatePolicy.recommended), onLater: () {});
      expect(find.text('Hay una versión más reciente con mejoras y correcciones. Puedes actualizar ahora o hacerlo más tarde.'), findsOneWidget);
      expect(find.textContaining('2.0.0'), findsNothing);
    });
  });
}
