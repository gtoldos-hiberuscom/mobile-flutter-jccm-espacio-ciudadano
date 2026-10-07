import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/university_title.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/my_data_university_titles_page.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/providers/my_data_education_provider.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// «Mis datos > Educación > Títulos universitarios».
void main() {
  final title = UniversityTitle(
    titleNumber: '1988000333',
    titleName: 'Grado en Ingeniería Informática por la Universidad de Castilla-La Mancha',
    universityName: 'Universidad de Castilla-La Mancha',
    completionDate: DateTime(2000, 6, 2),
    expeditionDate: DateTime(2000, 9, 2),
  );

  Widget buildPage({final TextScaler textScaler = TextScaler.noScaling}) => ProviderScope(
    overrides: [
      universityTitlesProvider.overrideWith((final ref) async => [title]),
    ],
    child: MaterialApp(
      locale: const Locale('es'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (final context, final child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaler: textScaler),
        child: child!,
      ),
      home: const MyDataUniversityTitlesPage(),
    ),
  );

  testWidgets('WCAG 1.4.3: «Nº Título» alcanza 4,5:1 sobre blanco', (final tester) async {
    await tester.pumpWidget(buildPage());
    await tester.pumpAndSettle();
    final l10n = AppLocalizations.of(tester.element(find.byType(MyDataUniversityTitlesPage)));

    final color = tester.widget<Text>(find.text(l10n.myDataEducationTitleNumberLabel('1988000333'))).style!.color!;
    final (hi, lo) = (AppColors.backgroundWhite.computeLuminance(), color.computeLuminance());
    expect((hi + 0.05) / (lo + 0.05), greaterThanOrEqualTo(4.5));
  });

  testWidgets('WCAG 1.4.4: al 200 por ciento las fechas se apilan bajo su etiqueta y nada se recorta', (final tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(360, 740);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(buildPage(textScaler: const TextScaler.linear(2)));
    await tester.pumpAndSettle();
    final l10n = AppLocalizations.of(tester.element(find.byType(MyDataUniversityTitlesPage)));

    final label = find.text(l10n.myDataEducationCompletionDateLabel);
    await tester.ensureVisible(label);
    await tester.pumpAndSettle();
    final labelRect = tester.getRect(label);
    // La etiqueta usa todo el ancho: no se parte letra a letra.
    expect(labelRect.width, greaterThan(150));
    final dateRect = tester.getRect(find.text('02/06/2000'));
    expect(dateRect.top, greaterThanOrEqualTo(labelRect.bottom));

    for (final text in [title.titleName, title.universityName]) {
      final widget = tester.widget<Text>(find.text(text));
      expect(widget.maxLines, isNull, reason: text);
      expect(widget.overflow, isNot(TextOverflow.ellipsis), reason: text);
    }
    expect(tester.takeException(), isNull);
  });

  testWidgets('WCAG 1.3.1: cada título se anuncia en un único nodo, con etiquetas legibles', (final tester) async {
    await tester.pumpWidget(buildPage());
    await tester.pumpAndSettle();

    expect(
      find.semantics.byLabel(
        'Nº título: 1988000333. ${title.titleName}. ${title.universityName}. Fecha finalización: 02/06/2000. Fecha expedición: 02/09/2000',
      ),
      findsOneWidget,
    );
    expect(find.semantics.byLabel(title.universityName), findsNothing);
  });
}
