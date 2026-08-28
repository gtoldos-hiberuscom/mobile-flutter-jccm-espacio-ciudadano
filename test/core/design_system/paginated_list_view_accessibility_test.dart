import 'dart:ui' show SemanticsAction;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/ui_states/paginated_list_view.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

void main() {
  Widget buildApp(
    final Widget child, {
    final TextScaler textScaler = TextScaler.noScaling,
  }) => MaterialApp(
    locale: const Locale('es'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    builder: (final context, final child) => MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: textScaler),
      child: child!,
    ),
    home: Scaffold(body: child),
  );

  PaginatedListView<String> buildList({
    final bool hasMore = true,
    final bool isLoadingMore = false,
    final VoidCallback? onLoadMore,
    final Future<void> Function()? onRefresh,
    final String? semanticLabel,
  }) => PaginatedListView<String>(
    items: const ['Primero', 'Segundo'],
    itemBuilder: (final context, final item, final index) => ListTile(title: Text(item)),
    hasMore: hasMore,
    isLoadingMore: isLoadingMore,
    onLoadMore: onLoadMore ?? () {},
    onRefresh: onRefresh,
    semanticLabel: semanticLabel,
  );

  testWidgets('cargar más es un botón visible con acción semántica', (
    final tester,
  ) async {
    var calls = 0;
    await tester.pumpWidget(buildApp(buildList(onLoadMore: () => calls++)));

    final node = find.semantics.byLabel('Cargar más elementos').evaluate().single;
    final data = node.getSemanticsData();
    expect(data.flagsCollection.isButton, isTrue);
    expect(data.hasAction(SemanticsAction.tap), isTrue);
    node.owner!.performAction(node.id, SemanticsAction.tap);
    expect(calls, 1);
  });

  testWidgets('el botón de paginación conserva un área mínima de 48 dp', (
    final tester,
  ) async {
    await tester.pumpWidget(buildApp(buildList()));

    final size = tester.getSize(find.byType(TextButton));
    expect(size.width, greaterThanOrEqualTo(48));
    expect(size.height, greaterThanOrEqualTo(48));
  });

  testWidgets('la carga incremental se anuncia sin exponer un botón', (
    final tester,
  ) async {
    await tester.pumpWidget(
      buildApp(buildList(isLoadingMore: true)),
    );

    final node = find.semantics.byLabel('Cargando: Cargar más elementos');
    expect(node, findsOneWidget);
    final data = node.evaluate().single.getSemanticsData();
    expect(data.flagsCollection.isLiveRegion, isTrue);
    expect(data.flagsCollection.isButton, isFalse);
    expect(data.hasAction(SemanticsAction.tap), isFalse);
    expect(find.byType(TextButton), findsNothing);
  });

  testWidgets('ofrece actualizar como acción personalizada accesible', (
    final tester,
  ) async {
    var refreshes = 0;
    await tester.pumpWidget(
      buildApp(
        buildList(
          semanticLabel: 'Notificaciones',
          onRefresh: () async => refreshes++,
        ),
      ),
    );

    final node = find.semantics.byLabel('Notificaciones').evaluate().single;
    final data = node.getSemanticsData();
    expect(data.customSemanticsActionIds, isNotEmpty);

    node.owner!.performAction(
      node.id,
      SemanticsAction.customAction,
      data.customSemanticsActionIds!.first,
    );
    await tester.pump();
    expect(refreshes, 1);
  });

  testWidgets('mantiene el estado vacío proporcionado sin añadir controles', (
    final tester,
  ) async {
    await tester.pumpWidget(
      buildApp(
        PaginatedListView<String>(
          items: const [],
          itemBuilder: (final context, final item, final index) => Text(item),
          hasMore: true,
          onLoadMore: () {},
          emptyState: const Text('No hay resultados'),
        ),
      ),
    );

    expect(find.semantics.byLabel('No hay resultados'), findsOneWidget);
    expect(find.byType(TextButton), findsNothing);
  });

  testWidgets('no trunca cargar más al 200 por ciento en 320 dp', (
    final tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 568);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      buildApp(
        buildList(),
        textScaler: const TextScaler.linear(2),
      ),
    );

    expect(tester.widget<Text>(find.text('Cargar más elementos')).maxLines, isNull);
    expect(tester.takeException(), isNull);
  });

  testWidgets('rechaza un nombre accesible vacío', (final tester) async {
    expect(
      () => PaginatedListView<String>(
        items: const [],
        itemBuilder: (final context, final item, final index) => Text(item),
        hasMore: false,
        onLoadMore: () {},
        semanticLabel: '',
      ),
      throwsAssertionError,
    );
  });
}
