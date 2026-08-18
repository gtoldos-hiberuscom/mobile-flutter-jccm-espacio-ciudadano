import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_divider.dart';

void main() {
  Widget buildApp(final Widget child) => MaterialApp(
    home: Scaffold(body: Center(child: child)),
  );

  testWidgets('el separador horizontal es decorativo', (final tester) async {
    await tester.pumpWidget(buildApp(const AppDivider()));

    expect(find.byType(Divider), findsOneWidget);
    expect(
      find.descendant(of: find.byType(AppDivider), matching: find.byType(ExcludeSemantics)),
      findsOneWidget,
    );
  });

  testWidgets('el separador vertical también queda fuera del árbol semántico', (final tester) async {
    await tester.pumpWidget(
      buildApp(const AppDivider(axis: Axis.vertical, extent: 80, indent: 8, endIndent: 16)),
    );

    expect(
      find.descendant(of: find.byType(AppDivider), matching: find.byType(ExcludeSemantics)),
      findsOneWidget,
    );
    final container = tester.widget<Container>(find.byType(Container).last);
    expect(container.margin, const EdgeInsets.only(top: 8, bottom: 16));
  });

  testWidgets('mantiene el grosor visual con texto al 200 por ciento', (final tester) async {
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(2)),
        child: buildApp(const AppDivider(extent: 24)),
      ),
    );

    final divider = tester.widget<Divider>(find.byType(Divider));
    expect(divider.thickness, 1);
    expect(divider.height, 24);
    expect(tester.takeException(), isNull);
  });
}
