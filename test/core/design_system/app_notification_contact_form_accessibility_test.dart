import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_input_case.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_notification_contact_form.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_phone_input_case.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

void main() {
  late TextEditingController phoneController;
  late TextEditingController emailController;

  setUp(() {
    phoneController = TextEditingController();
    emailController = TextEditingController();
  });

  tearDown(() {
    phoneController.dispose();
    emailController.dispose();
  });

  Widget buildApp(
    final Widget child, {
    final TextScaler textScaler = TextScaler.noScaling,
  }) => MaterialApp(
    locale: const Locale('es'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    builder: (final context, final child) => MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: textScaler),
      child: child!,
    ),
    home: Scaffold(body: child),
  );

  AppNotificationContactForm form({
    final bool saving = false,
    final VoidCallback? onSave,
  }) => AppNotificationContactForm(
    formError: null,
    phoneError: null,
    emailError: null,
    saving: saving,
    phoneController: phoneController,
    emailController: emailController,
    onClearError: () {},
    onLeave: () {},
    onSave: onSave ?? () {},
  );

  testWidgets('expone el título como encabezado', (final tester) async {
    await tester.pumpWidget(buildApp(form()));

    final data = tester.getSemantics(find.text('Datos de contacto para notificaciones electrónicas')).getSemanticsData();
    expect(data.flagsCollection.isHeader, isTrue);
  });

  testWidgets('anuncia claramente que basta con un medio de contacto', (
    final tester,
  ) async {
    await tester.pumpWidget(buildApp(form()));

    expect(
      find.semantics.byLabel('Obligatorio: rellena al menos uno de los medios de contacto'),
      findsOneWidget,
    );
    expect(
      find.semantics.byLabel('* Obligatorio rellenar al menos uno de los medios de contacto'),
      findsNothing,
    );
  });

  testWidgets('configura entrada y autocompletado apropiados', (final tester) async {
    await tester.pumpWidget(buildApp(form()));

    final email = tester.widget<AppInputCase>(find.byType(AppInputCase));
    expect(email.keyboardType, TextInputType.emailAddress);
    expect(email.textInputAction, TextInputAction.done);
    expect(email.autofillHints, contains(AutofillHints.email));
    expect(email.autocorrect, isFalse);
    expect(find.byType(AutofillGroup), findsOneWidget);
  });

  testWidgets('la acción hecho guarda cuando el formulario no está ocupado', (
    final tester,
  ) async {
    var saves = 0;
    await tester.pumpWidget(buildApp(form(onSave: () => saves++)));

    tester.widget<AppInputCase>(find.byType(AppInputCase)).onSubmitted?.call('persona@correo.es');
    expect(saves, 1);

    await tester.pumpWidget(buildApp(form(saving: true, onSave: () => saves++)));
    expect(tester.widget<AppInputCase>(find.byType(AppInputCase)).onSubmitted, isNull);
  });

  testWidgets('permite recorrer todo el formulario al 200 por ciento en 320 dp', (
    final tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 568);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      buildApp(form(), textScaler: const TextScaler.linear(2)),
    );

    expect(find.byType(SingleChildScrollView), findsWidgets);
    expect(find.byType(AppPhoneInputCase), findsOneWidget);
    expect(find.byType(AppInputCase), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
