/// Sprint 9 / STORY-67 — logged-in home golden (DEFERRED).
///
/// The "home" route currently redirects to `/sitemap` (see
/// `Routes.home`) and there is no `LoggedHomePage` yet. The home
/// surface that this golden is meant to capture lives behind STORY-22
/// in the EPIC-3 family, which is paused.
///
/// We keep the file structure ready so the eventual STORY-22 author
/// only needs to:
///   1) delete the `skip:` argument
///   2) replace the placeholder `Placeholder()` widget with the real
///      logged-in home page widget
///   3) run `flutter test --update-goldens test/qa/goldens/logged_home_golden_test.dart`
///
/// See `documentation/qa/STORY-22-home-route-investigation.md` (lives
/// on the epic/EPIC-3 branch family).
library;

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

Future<void> _pumpHome(final WidgetTester tester) async {
  await tester.pumpWidget(
    const ProviderScope(
      child: MaterialApp(
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        // TODO(STORY-22): replace with the real LoggedHomePage widget
        // once the home dashboard surface lands.
        home: Placeholder(),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets(
    'LoggedHomePage golden — phone portrait '
    '(DEFERRED until STORY-22 reopens — see '
    'documentation/qa/STORY-22-home-route-investigation.md '
    'on epic/EPIC-3 branch family)',
    (final tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 3.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await _pumpHome(tester);
      await expectLater(
        find.byType(Placeholder),
        matchesGoldenFile('logged_home_phone_portrait.png'),
      );
    },
    skip: true, // STORY-22 deferred — see test name above.
  );
}
