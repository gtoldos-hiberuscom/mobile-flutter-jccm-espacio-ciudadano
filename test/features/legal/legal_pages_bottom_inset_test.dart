import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/citizen_endpoint_ids_provider.dart';
import 'package:jccm_espacio_ciudadano/features/consent/2_presentation/controllers/consent_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/legal/2_presentation/accessibility_page.dart';
import 'package:jccm_espacio_ciudadano/features/legal/2_presentation/privacy_page.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

void main() {
  for (final page in <String, Widget>{
    'accessibility': const AccessibilityPage(),
    'privacy': const PrivacyPage(fromHome: true),
  }.entries) {
    for (final inset in [0.0, 24.0, 64.0]) {
      testWidgets('${page.key} keeps scroll content above navigation inset $inset', (final tester) async {
        await tester.binding.setSurfaceSize(const Size(360, 640));
        addTearDown(() => tester.binding.setSurfaceSize(null));
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              citizenEndpointIdsProvider.overrideWithValue((numDocumento: null, idAgente: null)),
              consentProvider('').overrideWith(() => _StaticConsentNotifier()),
            ],
            child: MaterialApp(
              locale: const Locale('es'),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              builder: (final context, final child) => MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  padding: EdgeInsets.only(bottom: inset),
                  viewPadding: EdgeInsets.only(bottom: inset),
                ),
                child: child!,
              ),
              home: page.value,
            ),
          ),
        );
        await tester.pumpAndSettle();
        final scroll = find.byType(SingleChildScrollView);
        final state = tester.state<ScrollableState>(
          find.descendant(of: scroll, matching: find.byType(Scrollable)).first,
        );
        state.position.jumpTo(state.position.maxScrollExtent);
        await tester.pumpAndSettle();
        final reserved = inset > 48 ? inset : 48.0;
        expect(tester.getRect(scroll).bottom, lessThanOrEqualTo(640 - reserved));
        expect(tester.takeException(), isNull);
      });
    }
  }
}

class _StaticConsentNotifier extends ConsentNotifier {
  _StaticConsentNotifier() : super('');

  @override
  ConsentState build() => const ConsentState(status: ConsentStatus.step1Locked);
}
