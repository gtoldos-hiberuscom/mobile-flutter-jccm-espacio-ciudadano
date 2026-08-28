import 'dart:ui' show SemanticsAction, Tristate;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_card_and_list.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

void main() {
  Widget buildApp(final Widget child, {final Locale locale = const Locale('es')}) => MaterialApp(
    locale: locale,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: SingleChildScrollView(child: child)),
  );

  testWidgets('resume la tarjeta interactiva con nombre, rol, estado y una acción', (final tester) async {
    var taps = 0;
    await tester.pumpWidget(
      buildApp(
        AppCard(
          title: 'Expediente de vivienda',
          categoryLabel: 'Vivienda',
          refNumber: 'EXP-42',
          expiryDate: '30 dic 2026',
          extraLabel: 'Estado',
          extraText: 'En tramitación',
          lastUpdateText: 'Actualizado hoy',
          onTap: () => taps++,
        ),
      ),
    );

    final data = find.semantics
        .byLabel(
          'Vivienda. Expediente de vivienda. N.º ref.: EXP-42. Expiración: 30 dic 2026. Estado: En tramitación. Actualizado hoy',
        )
        .evaluate()
        .single
        .getSemanticsData();
    expect(data.flagsCollection.isButton, isTrue);
    expect(data.flagsCollection.isEnabled, Tristate.isTrue);
    expect(data.hasAction(SemanticsAction.tap), isTrue);
    expect(find.semantics.byLabel('EXP-42'), findsNothing);

    await tester.tap(find.byType(InkWell).first);
    expect(taps, 1);
  });

  testWidgets('permite personalizar nombre y pista accesibles', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        AppCard(
          title: 'Registro',
          semanticLabel: 'Abrir registro de entrada número 15',
          semanticHint: 'Muestra sus datos',
          onTap: () {},
        ),
      ),
    );

    final data = find.semantics.byLabel('Abrir registro de entrada número 15').evaluate().single.getSemanticsData();
    expect(data.hint, 'Muestra sus datos');
  });

  testWidgets('mantiene el adjunto como acción independiente de 48 dp', (final tester) async {
    var cardTaps = 0;
    var attachmentTaps = 0;
    await tester.pumpWidget(
      buildApp(
        AppCard(
          title: 'Expediente',
          attachmentLabel: 'Abrir documento adjunto',
          onTap: () => cardTaps++,
          onAttachmentTap: () => attachmentTaps++,
        ),
      ),
    );

    final attachment = find.semantics.byLabel('Abrir documento adjunto').evaluate().single.getSemanticsData();
    expect(attachment.flagsCollection.isButton, isTrue);
    expect(attachment.hasAction(SemanticsAction.tap), isTrue);
    expect(tester.getSize(find.byType(InkWell).last).height, greaterThanOrEqualTo(48));

    await tester.tap(find.byType(InkWell).last);
    expect(attachmentTaps, 1);
    expect(cardTaps, 0);
  });

  testWidgets('conserva el botón interno como control independiente', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        AppCard(
          title: 'Cita médica',
          actionButton: ElevatedButton(onPressed: () {}, child: const Text('Cambiar cita')),
        ),
      ),
    );

    expect(find.semantics.byLabel('Cita médica'), findsOneWidget);
    final action = find.semantics.byLabel('Cambiar cita').evaluate().single.getSemanticsData();
    expect(action.flagsCollection.isButton, isTrue);
    expect(action.hasAction(SemanticsAction.tap), isTrue);
  });

  testWidgets('una tarjeta deshabilitada anuncia el estado y elimina su acción', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        AppCard(
          title: 'Expediente caducado',
          state: AppCardState.disabled,
          onTap: () {},
        ),
      ),
    );

    final data = find.semantics.byLabel('Expediente caducado').evaluate().single.getSemanticsData();
    expect(data.flagsCollection.isButton, isTrue);
    expect(data.flagsCollection.isEnabled, Tristate.isFalse);
    expect(data.hasAction(SemanticsAction.tap), isFalse);
    expect(find.byType(InkWell), findsNothing);
  });

  testWidgets('localiza las etiquetas predeterminadas en inglés', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        const AppCard(
          title: 'Housing record',
          isInteractive: false,
          refNumber: 'REF-1',
          expiryDate: '30 Dec 2026',
        ),
        locale: const Locale('en'),
      ),
    );

    expect(find.text('REF. NO.'), findsOneWidget);
    expect(find.text('EXPIRY'), findsOneWidget);
    expect(find.semantics.byLabel('Housing record. Ref. no.: REF-1. Expiry: 30 Dec 2026'), findsOneWidget);
  });

  testWidgets('la agenda admite texto al 200 por ciento en 320 dp', (final tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 568);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(2)),
        child: buildApp(
          const AppCard(
            cardClass: AppCardClass.agenda,
            title: 'Cita en Atención Primaria para revisión médica',
            isInteractive: false,
            date: '21 de diciembre de 2026',
            time: '10:30 horas',
            description: 'Consulta de seguimiento con información adicional para la persona usuaria.',
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
  });
}
