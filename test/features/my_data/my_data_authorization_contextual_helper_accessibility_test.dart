import 'dart:ui' show SemanticsAction;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_button.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/widgets/my_data_authorization_contextual_helper.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

void main() {
  Widget buildApp(
    final Widget child, {
    final Locale locale = const Locale('es'),
    final TextScaler textScaler = TextScaler.noScaling,
  }) => MaterialApp(
    locale: locale,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    builder: (final context, final child) => MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: textScaler),
      child: child!,
    ),
    home: Scaffold(body: SingleChildScrollView(child: child)),
  );

  testWidgets('mantiene mensaje y acción como nodos separados', (
    final tester,
  ) async {
    await tester.pumpWidget(
      buildApp(
        MyDataAuthorizationContextualHelper(
          message: 'Autoriza el acceso para consultar estos datos.',
          onOpenSettings: () {},
        ),
      ),
    );

    final message = find.semantics.byLabel('Autoriza el acceso para consultar estos datos.').evaluate().single.getSemanticsData();
    expect(message.flagsCollection.isButton, isFalse);
    expect(message.hasAction(SemanticsAction.tap), isFalse);
    expect(find.byType(AppButton), findsOneWidget);
  });

  testWidgets('el enlace ejecuta su acción semántica', (
    final tester,
  ) async {
    var calls = 0;
    await tester.pumpWidget(
      buildApp(
        MyDataAuthorizationContextualHelper(
          onOpenSettings: () => calls++,
        ),
      ),
    );

    final node = find.semantics.byLabel('Ir a Condiciones de uso y autorizaciones').evaluate().single;
    final data = node.getSemanticsData();
    expect(data.flagsCollection.isButton, isTrue);
    expect(data.hasAction(SemanticsAction.tap), isTrue);
    node.owner!.performAction(node.id, SemanticsAction.tap);
    expect(calls, 1);
    expect(find.byType(AppButton), findsOneWidget);
  });

  testWidgets('permite personalizar la pronunciación de mensaje y acción', (
    final tester,
  ) async {
    await tester.pumpWidget(
      buildApp(
        MyDataAuthorizationContextualHelper(
          message: 'JCCM requiere autorización.',
          messageSemanticLabel: 'La Junta de Comunidades de Castilla-La Mancha requiere autorización.',
          semanticsLabel: 'Abrir configuración de autorizaciones',
          onOpenSettings: () {},
        ),
      ),
    );

    expect(
      find.semantics.byLabel(
        'La Junta de Comunidades de Castilla-La Mancha requiere autorización.',
      ),
      findsOneWidget,
    );
    expect(
      find.semantics.byLabel('Abrir configuración de autorizaciones'),
      findsOneWidget,
    );
    expect(find.semantics.byLabel('JCCM requiere autorización.'), findsNothing);
  });

  testWidgets('localiza el mensaje y la acción predeterminados en inglés', (
    final tester,
  ) async {
    await tester.pumpWidget(
      buildApp(
        MyDataAuthorizationContextualHelper(onOpenSettings: () {}),
        locale: const Locale('en'),
      ),
    );

    final l10n = await AppLocalizations.delegate.load(const Locale('en'));
    expect(
      find.semantics.byLabel(l10n.myDataJccmAuthorizationRequiredMessage),
      findsOneWidget,
    );
    expect(
      find.semantics.byLabel(l10n.myDataJccmAuthorizationRequiredCta),
      findsOneWidget,
    );
  });

  testWidgets('hace reflow al 200 por ciento sin truncar', (
    final tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 568);
    addTearDown(tester.view.reset);

    const message = 'Para consultar toda esta información debe configurar previamente sus autorizaciones.';
    await tester.pumpWidget(
      buildApp(
        MyDataAuthorizationContextualHelper(
          message: message,
          onOpenSettings: () {},
        ),
        textScaler: const TextScaler.linear(2),
      ),
    );

    expect(tester.widget<Text>(find.text(message)).maxLines, isNull);
    expect(
      tester.getTopLeft(find.byType(AppButton)).dy,
      greaterThan(tester.getBottomLeft(find.text(message)).dy),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('rechaza etiquetas opcionales vacías', (final tester) async {
    expect(
      () => MyDataAuthorizationContextualHelper(
        message: '',
        onOpenSettings: () {},
      ),
      throwsAssertionError,
    );
    expect(
      () => MyDataAuthorizationContextualHelper(
        semanticsLabel: '',
        onOpenSettings: () {},
      ),
      throwsAssertionError,
    );
    expect(
      () => MyDataAuthorizationContextualHelper(
        messageSemanticLabel: '',
        onOpenSettings: () {},
      ),
      throwsAssertionError,
    );
  });
}
