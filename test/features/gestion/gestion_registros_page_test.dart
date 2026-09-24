import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/registro.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/2_presentation/gestion_registros_page.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/2_presentation/providers/gestion_registros_provider.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

void main() {
  testWidgets('reintenta la carga de entradas después de un error', (final tester) async {
    var attempts = 0;

    await tester.pumpWidget(
      ProviderScope(
        retry: (final _, final _) => null,
        overrides: [
          entradasProvider.overrideWith((final ref) async {
            attempts++;
            if (attempts == 1) {
              throw Exception('Error transitorio');
            }
            return const <Registro>[];
          }),
          salidasProvider.overrideWith((final ref) async => const <Registro>[]),
        ],
        child: const MaterialApp(
          locale: Locale('es'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: GestionRegistrosPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Reintentar'));
    await tester.pumpAndSettle();

    expect(attempts, 2);
    expect(find.text('Reintentar'), findsNothing);
  });

  testWidgets('reintenta la carga de salidas después de un error', (final tester) async {
    var attempts = 0;

    await tester.pumpWidget(
      ProviderScope(
        retry: (final _, final _) => null,
        overrides: [
          entradasProvider.overrideWith((final ref) async => const <Registro>[]),
          salidasProvider.overrideWith((final ref) async {
            attempts++;
            if (attempts == 1) {
              throw Exception('Error transitorio');
            }
            return const <Registro>[];
          }),
        ],
        child: const MaterialApp(
          locale: Locale('es'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: GestionRegistrosPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Salidas de registro'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Reintentar'));
    await tester.pumpAndSettle();

    expect(attempts, 2);
    expect(find.text('Reintentar'), findsNothing);
  });

  testWidgets('muestra el texto introductorio correspondiente a cada pestaña', (final tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          entradasProvider.overrideWith((final ref) async => const <Registro>[]),
          salidasProvider.overrideWith((final ref) async => const <Registro>[]),
        ],
        child: const MaterialApp(
          locale: Locale('es'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: GestionRegistrosPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    const sentDescription = 'Consulta los registros de comunicaciones que has enviado a la Junta de Comunidades de Castilla-La Mancha (JCCM).';
    const receivedDescription = 'Consulta los registros de comunicaciones que has recibido de la Junta de Comunidades de Castilla-La Mancha (JCCM).';

    expect(find.text(sentDescription), findsOneWidget);
    expect(find.text(receivedDescription), findsNothing);

    await tester.tap(find.text('Salidas de registro'));
    await tester.pumpAndSettle();

    expect(find.text(sentDescription), findsNothing);
    expect(find.text(receivedDescription), findsOneWidget);
  });

  testWidgets('presenta número y fecha en filas horizontales dentro de la card', (final tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 844);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          entradasProvider.overrideWith(
            (final ref) async => const [
              Registro(
                numregistro: 'AAAA-E-RE-XXXXX',
                titulo: 'SOLICITUD DE AYUDA PARA EFICIENCIA ENERGÉTICA',
                fecha: '2026-09-25',
              ),
            ],
          ),
          salidasProvider.overrideWith((final ref) async => const <Registro>[]),
        ],
        child: const MaterialApp(
          locale: Locale('es'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: GestionRegistrosPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Solicitud de ayuda para eficiencia energética'), findsOneWidget);
    expect(find.text('AAAA-E-RE-XXXXX'), findsOneWidget);
    expect(find.text('25/09/2026'), findsOneWidget);
    expect(find.text('FECHA DE REGISTRO'), findsOneWidget);
    expect(tester.widget<Text>(find.text('FECHA DE REGISTRO')).maxLines, 1);
    expect(
      tester.getCenter(find.text('Nº REGISTRO')).dy,
      closeTo(tester.getCenter(find.text('AAAA-E-RE-XXXXX')).dy, 1),
    );
    expect(
      tester.getCenter(find.text('FECHA DE REGISTRO')).dy,
      closeTo(tester.getCenter(find.text('25/09/2026')).dy, 1),
    );
  });
}
