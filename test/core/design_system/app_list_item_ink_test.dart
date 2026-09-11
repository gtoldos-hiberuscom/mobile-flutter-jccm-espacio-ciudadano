import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_card_and_list.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_list.dart';

void main() {
  testWidgets('AppListItem dentro de AppList pinta el ripple en su propio Material sin avisos', (final tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppList(
            children: [
              AppListItem(title: 'Preguntas frecuentes', onTap: () {}),
              AppListItem(title: 'Contacto', onTap: () {}),
            ],
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(
      find.ancestor(of: find.byType(ListTile).first, matching: find.byType(Material)).first,
      findsOneWidget,
    );
    await tester.tap(find.byType(ListTile).first);
    await tester.pump();
    expect(tester.takeException(), isNull);
  });
}
