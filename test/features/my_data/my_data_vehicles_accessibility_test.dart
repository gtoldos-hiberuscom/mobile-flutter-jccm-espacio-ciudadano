import 'dart:ui' show SemanticsRole, Tristate;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/vehicle.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/my_data_vehicles_page.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/providers/my_data_authorization_provider.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/providers/my_data_vehicles_provider.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Hoja «Mis datos > Vehículos» de la auditoría de accesibilidad.
void main() {
  Widget buildApp() => ProviderScope(
    overrides: [
      ageDataAuthorizationProvider.overrideWith((final ref) async => true),
      vehiclesProvider.overrideWith((final ref) async => const [Vehicle(licensePlate: '1234ABC'), Vehicle(licensePlate: '5678DEF')]),
    ],
    child: const MaterialApp(
      locale: Locale('es'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: MyDataVehiclesPage(),
    ),
  );

  testWidgets('WCAG 4.1.2: las pestañas exponen rol y selección', (final tester) async {
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    final data = find.semantics.byLabel('Mis datos de Vehículos').evaluate().single.getSemanticsData();
    final services = find.semantics.byLabel('Información y servicios').evaluate().single.getSemanticsData();
    expect(data.role, SemanticsRole.tab);
    expect(data.flagsCollection.isSelected, Tristate.isTrue);
    expect(services.role, SemanticsRole.tab);
    expect(services.flagsCollection.isSelected, Tristate.isFalse);
  });

  testWidgets('WCAG 1.3.1: «Mis vehículos» es un encabezado de nivel 2', (final tester) async {
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    final node = find.semantics.byLabel('Mis vehículos').evaluate().single;
    expect(node.flagsCollection.isHeader, isTrue);
    expect(node.headingLevel, 2);
  });

  testWidgets('WCAG 1.3.1: cada vehículo se lee en un nodo, con la etiqueta antes de la matrícula', (final tester) async {
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    expect(find.semantics.byLabel('Matrícula del vehículo: 1234ABC'), findsOneWidget);
    expect(find.semantics.byLabel('Matrícula del vehículo: 5678DEF'), findsOneWidget);
    expect(find.semantics.byLabel('1234ABC'), findsNothing);
    expect(find.semantics.byLabel('Matrícula del vehículo'), findsNothing);
  });
}
