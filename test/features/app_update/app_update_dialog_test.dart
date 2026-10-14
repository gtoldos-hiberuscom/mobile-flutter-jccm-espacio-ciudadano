import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/0_entity/app_update_info.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/0_entity/app_version.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/0_entity/update_policy.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/2_presentation/widgets/app_update_dialog.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

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

  AppUpdateInfo info({required final UpdatePolicy policy, final String? message}) => AppUpdateInfo(
    policy: policy,
    latestVersion: const AppVersion(2, 0, 0),
    message: message,
  );

  group('AppUpdateDialog', () {
    testWidgets('forzada enseña la versión y no ofrece «Ahora no»', (final tester) async {
      await pumpDialog(tester, info(policy: UpdatePolicy.forced));
      expect(find.text('Actualización necesaria'), findsOneWidget);
      expect(find.textContaining('2.0.0'), findsOneWidget);
      expect(find.text('Ahora no'), findsNothing);
    });

    testWidgets('recomendada enseña la versión y ofrece «Ahora no»', (final tester) async {
      await pumpDialog(tester, info(policy: UpdatePolicy.recommended), onLater: () {});
      expect(find.text('Hay una nueva versión disponible'), findsOneWidget);
      expect(find.textContaining('2.0.0'), findsOneWidget);
      expect(find.text('Ahora no'), findsOneWidget);
    });

    testWidgets('el mensaje del servidor sustituye la explicación por defecto', (final tester) async {
      await pumpDialog(tester, info(policy: UpdatePolicy.forced, message: 'Esta versión ya no está disponible.'));
      expect(find.text('Actualización necesaria'), findsOneWidget);
      expect(find.text('Esta versión ya no está disponible.'), findsOneWidget);
      expect(find.textContaining('2.0.0'), findsNothing);
    });
  });
}
