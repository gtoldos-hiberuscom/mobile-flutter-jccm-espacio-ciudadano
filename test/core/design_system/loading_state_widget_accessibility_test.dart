import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_loading_indicator.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/ui_states/loading_state_widget.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

void main() {
  Widget buildApp(final Widget child) => MaterialApp(
    locale: const Locale('es'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: child),
  );

  testWidgets('expone una única región activa localizada', (final tester) async {
    await tester.pumpWidget(buildApp(const LoadingStateWidget()));

    final finder = find.semantics.byLabel('Cargando…');
    expect(finder, findsOneWidget);
    expect(finder.evaluate().single.flagsCollection.isLiveRegion, isTrue);
    expect(find.byType(AppLoadingIndicator), findsOneWidget);
  });

  testWidgets('usa el mensaje visible como anuncio accesible', (final tester) async {
    await tester.pumpWidget(
      buildApp(const LoadingStateWidget(message: 'Cargando tus expedientes')),
    );

    expect(find.text('Cargando tus expedientes'), findsOneWidget);
    expect(find.semantics.byLabel('Cargando tus expedientes'), findsOneWidget);
  });

  testWidgets('permite separar mensaje visual y etiqueta accesible', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        const LoadingStateWidget(
          message: 'Un momento, por favor',
          semanticsLabel: 'Cargando notificaciones',
        ),
      ),
    );

    expect(find.text('Un momento, por favor'), findsOneWidget);
    expect(find.semantics.byLabel('Cargando notificaciones'), findsOneWidget);
    expect(find.semantics.byLabel('Un momento, por favor'), findsNothing);
  });

  testWidgets('anuncia una única finalización al desaparecer', (final tester) async {
    await tester.pumpWidget(buildApp(const LoadingStateWidget()));
    tester.takeAnnouncements();

    await tester.pumpWidget(buildApp(const SizedBox.shrink()));
    await tester.pump();

    final announcements = tester.takeAnnouncements();
    expect(announcements, hasLength(1));
    expect(announcements.single.message, 'Contenido cargado');
  });

  testWidgets('permite desactivar el anuncio final', (final tester) async {
    await tester.pumpWidget(
      buildApp(const LoadingStateWidget(announceCompletion: false)),
    );
    tester.takeAnnouncements();

    await tester.pumpWidget(buildApp(const SizedBox.shrink()));
    await tester.pump();
    expect(tester.takeAnnouncements(), isEmpty);
  });

  testWidgets('admite mensaje largo al 200 por ciento en 320 dp', (final tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 568);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(2)),
        child: buildApp(
          const LoadingStateWidget(
            message: 'Estamos cargando toda la información de tus expedientes administrativos',
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
  });
}
