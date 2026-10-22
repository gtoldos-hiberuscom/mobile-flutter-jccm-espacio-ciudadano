import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

void main() {
  testWidgets('renders notification, health and credential variants', (
    final tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        locale: Locale('es'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SizedBox(
            width: 398,
            child: Column(
              children: [
                AppAgendaInfoCard(
                  type: AppAgendaInfoCardType.notification,
                  day: '11',
                  weekday: 'martes',
                  time: '23:32',
                  title: 'Caducidad de notificación',
                  primaryText: 'Asunto: Gestión electrónica',
                  secondaryText: 'Emisor: Servicio de contratación',
                ),
                AppAgendaInfoCard(
                  type: AppAgendaInfoCardType.health,
                  day: '13',
                  weekday: 'jueves',
                  time: '9:00',
                  title: 'CITA DE ATENCIÓN PRIMARIA',
                  channel: 'PRESENCIAL',
                  primaryText: 'DR. JOSÉ MANUEL FERNÁNDEZ GARCÍA',
                  secondaryText: 'CONSULTA A DEMANDA',
                ),
                AppAgendaInfoCard(
                  type: AppAgendaInfoCardType.credential,
                  day: '12',
                  weekday: 'miércoles',
                  title: 'Carnet familia numerosa',
                  primaryText: 'Tu carnet caduca el día 12 abr. 2026',
                ),
              ],
            ),
          ),
        ),
      ),
    );

    expect(find.text('Caducidad de notificación'), findsOneWidget);
    expect(find.text('Cita de atención primaria'), findsOneWidget);
    expect(find.text('Carnet familia numerosa'), findsOneWidget);
    expect(find.text('PRESENCIAL'), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (final widget) => widget is AppSvgIcon && widget.assetPath == AppIconAssets.health && widget.size == AppDimensions.iconMedium && widget.semanticsLabel == 'Cita sanitaria',
      ),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('la notificación usa su variante de Card-info: borde de marca, esquinas y sombra (Figma 791:1258)', (final tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        locale: Locale('es'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: Column(
            children: [
              AppAgendaInfoCard(
                type: AppAgendaInfoCardType.notification,
                day: '11',
                weekday: 'martes',
                time: '23:32',
                title: 'Caducidad de notificación',
                primaryText: 'Asunto: Gestión electrónica',
              ),
              AppAgendaInfoCard(
                type: AppAgendaInfoCardType.credential,
                day: '12',
                weekday: 'miércoles',
                title: 'Carnet familia numerosa',
              ),
            ],
          ),
        ),
      ),
    );

    BoxDecoration decorationOf(final String title) {
      final container = tester.widget<Container>(
        find.ancestor(of: find.text(title), matching: find.byType(Container)).last,
      );
      return container.decoration! as BoxDecoration;
    }

    final notification = decorationOf('Caducidad de notificación');
    expect(notification.border, Border.all(color: AppColors.secondaryLight400, width: 2));
    expect(notification.borderRadius, BorderRadius.circular(AppDimensions.radiusMedium));
    expect(notification.boxShadow, AppShadows.medium);

    // El resto de variantes conserva la barra lateral y no lleva sombra.
    final credential = decorationOf('Carnet familia numerosa');
    expect((credential.border! as Border).left.width, 4);
    expect(credential.boxShadow, isNull);
  });

  testWidgets('al pasar a tipo frase respeta siglas y códigos', (final tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        locale: Locale('es'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: AppAgendaInfoCard(
            type: AppAgendaInfoCardType.health,
            day: '19',
            weekday: 'lunes',
            time: '14:06',
            title: 'VACUNA GRIPE',
            primaryText: 'CAMPO CRIPTANA MOLINO',
            secondaryText: 'DR. JOSÉ MANUEL FERNÁNDEZ',
            details: [
              (label: 'Centro', value: 'C.S. PALOMAREJOS_PREN'),
              (label: 'Sala', value: 'CONSULTAS B-203'),
              (label: 'Organismo emisor', value: 'DELEGACIÓN DE HACIENDA, AAPP Y TD'),
            ],
          ),
        ),
      ),
    );

    expect(find.text('Vacuna gripe'), findsOneWidget);
    expect(find.text('Campo criptana molino'), findsOneWidget);
    expect(find.text('Dr. josé manuel fernández'), findsOneWidget);
    expect(find.text('Centro: C.S. palomarejos_pren'), findsOneWidget);
    expect(find.text('Sala: Consultas B-203'), findsOneWidget);
    expect(find.text('Organismo emisor: Delegación de hacienda, aapp y TD'), findsOneWidget);

    // Etiqueta en negrita, valor en peso normal.
    final spans = <TextSpan>[];
    tester.widget<RichText>(find.text('Sala: Consultas B-203', findRichText: true)).text.visitChildren((final span) {
      if (span is TextSpan && span.text != null) {
        spans.add(span);
      }
      return true;
    });
    expect(spans.map((final span) => span.text), ['Sala: ', 'Consultas B-203']);
    expect(spans.first.style!.fontWeight, FontWeight.w700);
    expect(spans.last.style!.fontWeight, FontWeight.w400);
  });
}
