import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/connectivity/connectivity_status.dart';
import 'package:jccm_espacio_ciudadano/core/connectivity/offline_banner.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// STORY-65 / Sprint 9 — verifies that the OfflineBanner default copy is
/// driven by the AppLocalizations delegate (no hard-coded Spanish string)
/// while still honouring an explicit `message:` override.
void main() {
  Widget buildHarness({
    required final Locale locale,
    final String? message,
  }) {
    return ProviderScope(
      overrides: [
        connectivityStatusProvider.overrideWithValue(
          ConnectivityStatus.offline,
        ),
      ],
      child: MaterialApp(
        locale: locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: OfflineBanner(
            message: message,
            child: const SizedBox.shrink(),
          ),
        ),
      ),
    );
  }

  testWidgets('renders Spanish default copy under es locale', (
    final tester,
  ) async {
    await tester.pumpWidget(buildHarness(locale: const Locale('es')));
    await tester.pumpAndSettle();

    expect(
      find.text('Sin conexión. Mostrando datos guardados.'),
      findsOneWidget,
    );
  });

  testWidgets('renders English default copy under en locale', (
    final tester,
  ) async {
    await tester.pumpWidget(buildHarness(locale: const Locale('en')));
    await tester.pumpAndSettle();

    expect(find.text('Offline. Showing cached data.'), findsOneWidget);
  });

  testWidgets('explicit message override wins over localized default', (
    final tester,
  ) async {
    await tester.pumpWidget(
      buildHarness(
        locale: const Locale('en'),
        message: 'Custom override message',
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Custom override message'), findsOneWidget);
    expect(find.text('Offline. Showing cached data.'), findsNothing);
  });
}
