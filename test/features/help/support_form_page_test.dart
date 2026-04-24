import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/help/2_presentation/support_form_page.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

Widget _harness() => const ProviderScope(
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: Locale('es'),
        home: SupportFormPage(),
      ),
    );

void _useLargeViewport(final WidgetTester tester) {
  tester.view.physicalSize = const Size(1080, 4000);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

void main() {
  testWidgets('renders all required fields and submit button',
      (final tester) async {
    _useLargeViewport(tester);
    await tester.pumpWidget(_harness());
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('support_name_field')), findsOneWidget);
    expect(find.byKey(const Key('support_email_field')), findsOneWidget);
    expect(
      find.byKey(const Key('support_email_confirm_field')),
      findsOneWidget,
    );
    expect(find.byKey(const Key('support_subject_field')), findsOneWidget);
    expect(
      find.byKey(const Key('support_description_field')),
      findsOneWidget,
    );
    expect(find.byKey(const Key('support_consent_checkbox')), findsOneWidget);
    expect(find.byKey(const Key('support_captcha_checkbox')), findsOneWidget);
    expect(find.byKey(const Key('support_submit_btn')), findsOneWidget);
  });

  testWidgets('submitting an empty form keeps the page (no success snackbar)',
      (final tester) async {
    _useLargeViewport(tester);
    await tester.pumpWidget(_harness());
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('support_submit_btn')));
    await tester.pumpAndSettle();

    expect(
      find.byKey(const Key('support_success_snackbar')),
      findsNothing,
    );
    expect(find.byKey(const Key('support_submit_btn')), findsOneWidget);
  });

  testWidgets('happy path submits and shows confirmation screen',
      (final tester) async {
    _useLargeViewport(tester);
    await tester.pumpWidget(_harness());
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('support_name_field')), 'Ana');
    await tester.enterText(
      find.byKey(const Key('support_email_field')),
      'ana@example.com',
    );
    await tester.enterText(
      find.byKey(const Key('support_email_confirm_field')),
      'ana@example.com',
    );
    await tester.enterText(
      find.byKey(const Key('support_subject_field')),
      'Incidencia',
    );
    await tester.enterText(
      find.byKey(const Key('support_description_field')),
      'No puedo iniciar sesión con Cl@ve.',
    );
    await tester.tap(find.byKey(const Key('support_consent_checkbox')));
    await tester.pump();
    await tester.tap(find.byKey(const Key('support_captcha_checkbox')));
    await tester.pump();

    await tester.tap(find.byKey(const Key('support_submit_btn')));
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pumpAndSettle();

    expect(
      find.byKey(const Key('support_success_close_btn')),
      findsOneWidget,
    );
  });
}
