import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_card_and_list.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

void main() {
  Widget buildApp(final Widget child, {final Locale locale = const Locale('es')}) => MaterialApp(
    locale: locale,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: Center(child: child)),
  );

  testWidgets('es decorativo por defecto y no anuncia las iniciales', (final tester) async {
    await tester.pumpWidget(buildApp(const AppAvatar(initials: 'MC')));

    expect(find.text('MC'), findsOneWidget);
    expect(find.semantics.byLabel('MC'), findsNothing);
    expect(find.semantics.byLabel('Avatar'), findsNothing);
  });

  testWidgets('expone un avatar informativo como imagen con nombre', (final tester) async {
    await tester.pumpWidget(
      buildApp(const AppAvatar(initials: 'MC', semanticsLabel: 'María Canales')),
    );

    final data = find.semantics.byLabel('María Canales').evaluate().single.getSemanticsData();
    expect(data.flagsCollection.isImage, isTrue);
    expect(data.value, isEmpty);
    expect(find.semantics.byLabel('MC'), findsNothing);
  });

  testWidgets('describe el indicador de estado predeterminado', (final tester) async {
    await tester.pumpWidget(buildApp(const AppAvatar(initials: 'MC', hasStatus: true)));

    final data = find.semantics.byLabel('Avatar').evaluate().single.getSemanticsData();
    expect(data.value, 'Disponible');
  });

  testWidgets('localiza el estado predeterminado en inglés', (final tester) async {
    await tester.pumpWidget(
      buildApp(const AppAvatar(hasStatus: true), locale: const Locale('en')),
    );

    final data = find.semantics.byLabel('Avatar').evaluate().single.getSemanticsData();
    expect(data.value, 'Available');
  });

  testWidgets('permite describir un estado personalizado sin depender del color', (final tester) async {
    await tester.pumpWidget(
      buildApp(
        const AppAvatar(
          initials: 'MC',
          hasStatus: true,
          statusColor: Colors.red,
          semanticsLabel: 'María Canales',
          statusLabel: 'No disponible',
        ),
      ),
    );

    final data = find.semantics.byLabel('María Canales').evaluate().single.getSemanticsData();
    expect(data.value, 'No disponible');
  });

  testWidgets('mantiene sus dimensiones y no desborda con texto al 200 por ciento', (final tester) async {
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(2)),
        child: buildApp(const AppAvatar(initials: 'AB', size: AppAvatarSize.large)),
      ),
    );

    expect(tester.getSize(find.byType(CircleAvatar)), const Size.square(64));
    expect(tester.takeException(), isNull);
  });
}
