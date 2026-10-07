import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/non_university_title.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/my_data_non_university_titles_page.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/providers/my_data_education_provider.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// «Mis datos > Educación > Títulos no universitarios».
void main() {
  final title = NonUniversityTitle(
    titleName: 'Técnico en Gestión Administrativa',
    centerName: 'IES Merced',
    book: '12',
    order: '34',
    folio: '56',
    province: 'Madrid',
    expeditionDate: DateTime(1989, 4, 8),
  );

  Widget buildPage({final TextScaler textScaler = TextScaler.noScaling}) => ProviderScope(
    overrides: [
      nonUniversityTitlesProvider.overrideWith((final ref) async => [title]),
    ],
    child: MaterialApp(
      locale: const Locale('es'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (final context, final child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaler: textScaler),
        child: child!,
      ),
      home: const MyDataNonUniversityTitlesPage(),
    ),
  );

  testWidgets('WCAG 1.3.1: cada título se anuncia en un único nodo, en orden y con etiquetas', (final tester) async {
    await tester.pumpWidget(buildPage());
    await tester.pumpAndSettle();

    expect(
      find.semantics.byLabel(
        'Libro: 12, orden: 34, folio: 56. Técnico en Gestión Administrativa. IES Merced. Provincia: Madrid. Fecha expedición: 08/04/1989',
      ),
      findsOneWidget,
    );
    expect(find.semantics.byLabel('Madrid'), findsNothing);
  });

  testWidgets('WCAG 1.4.4: al 200 por ciento provincia y fecha se apilan bajo su etiqueta', (final tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(360, 740);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(buildPage(textScaler: const TextScaler.linear(2)));
    await tester.pumpAndSettle();
    final l10n = AppLocalizations.of(tester.element(find.byType(MyDataNonUniversityTitlesPage)));

    final label = find.text(l10n.myDataEducationProvinceLabel);
    await tester.ensureVisible(label);
    await tester.pumpAndSettle();
    expect(tester.getRect(label).width, greaterThan(150));
    expect(tester.getRect(find.text('Madrid')).top, greaterThanOrEqualTo(tester.getRect(label).bottom));
    expect(tester.takeException(), isNull);
  });
}
