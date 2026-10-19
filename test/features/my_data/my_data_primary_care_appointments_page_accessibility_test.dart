import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/health_appointment.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/jwt_claims.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/jwt_claims_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/my_data_primary_care_appointments_page.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/providers/my_data_authorization_provider.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/providers/my_data_health_provider.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// WCAG 1.3.1: el título de la pantalla, el año y el mes son encabezados, en
/// niveles contiguos; el mes se anuncia con su año.
///
/// Venía de Salud, que es donde vivía el listado antes de repartirse en dos
/// pantallas. Los niveles del año y el mes suben de 3 y 4 a 2 y 3: allí había
/// un título de sección entre medias y aquí no, y saltarse el 2 rompería la
/// secuencia.
void main() {
  testWidgets('el título, el año y «septiembre de 2026» son encabezados contiguos', (final tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          // El provider de primaria resuelve el identificador desde los claims.
          jwtClaimsProvider.overrideWith(_StubClaims.new),
          jccmDataAuthorizationProvider.overrideWith((final ref) async => true),
          myDataHealthCipProvider.overrideWith((final ref) async => 'CIP123'),
          myDataPrimaryCarePendingAppointmentsProvider.overrideWith(
            (final ref) async => [
              HealthAppointment(
                dateTime: DateTime(2026, 9, 23, 8, 25),
                professional: 'Dra. García',
                description: 'Medicina de familia',
                channel: 'Telefónica',
                center: 'Campo de Criptana',
              ),
            ],
          ),
        ],
        child: const MaterialApp(
          locale: Locale('es'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: MyDataPrimaryCareAppointmentsPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final l10n = AppLocalizations.of(tester.element(find.byType(MyDataPrimaryCareAppointmentsPage)));

    // El título aparece además como etiqueta del nodo que envuelve la ruta, que
    // no es un encabezado: se busca el que sí lo es.
    final titleHeadings = find.semantics
        .byLabel(l10n.myDataHealthAppointmentsTitle)
        .evaluate()
        .where((final node) => node.flagsCollection.isHeader);
    expect(titleHeadings, hasLength(1));
    expect(titleHeadings.single.headingLevel, 1);

    final year = find.semantics.byLabel('2026').evaluate().single;
    expect(year.flagsCollection.isHeader, isTrue);
    expect(year.headingLevel, 2);

    final month = find.semantics.byLabel('septiembre de 2026').evaluate().single;
    expect(month.flagsCollection.isHeader, isTrue);
    expect(month.headingLevel, 3);

    // La cita se anuncia en un único nodo, con el canal como encabezado y el
    // profesional como contenido principal.
    expect(find.semantics.byLabel(RegExp('23.*Dra. García.*Telefónica.*Medicina de familia')), findsOneWidget);
  });
}

final class _StubClaims extends JwtClaimsNotifier {
  @override
  JwtClaims? build() => const JwtClaims(
    exp: 0,
    iat: 0,
    iss: 'issuer',
    aud: [],
    sub: 'subject',
    subAlt: 'PER1',
    idAgente: 'PER1',
  );
}
