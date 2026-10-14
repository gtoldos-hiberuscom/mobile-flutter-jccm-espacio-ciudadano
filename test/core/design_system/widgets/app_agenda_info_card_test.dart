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
}
