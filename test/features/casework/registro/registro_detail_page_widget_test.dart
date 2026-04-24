import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/casework/registro/0_entity/registro_detail.dart';
import 'package:jccm_espacio_ciudadano/features/casework/registro/0_entity/registro_fichero.dart';
import 'package:jccm_espacio_ciudadano/features/casework/registro/0_entity/registro_kind.dart';
import 'package:jccm_espacio_ciudadano/features/casework/registro/1_domain/registro_repository.dart';
import 'package:jccm_espacio_ciudadano/features/casework/registro/2_presentation/registro_detail_page.dart';
import 'package:jccm_espacio_ciudadano/features/casework/registro/3_data/registro_repository_provider.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

class _StubRepo implements RegistroRepository {
  _StubRepo(this._builder);
  final Future<RegistroDetail> Function(String numreg, RegistroKind kind) _builder;

  @override
  Future<RegistroDetail> loadByNumber({
    required final String numreg,
    required final RegistroKind kind,
  }) =>
      _builder(numreg, kind);
}

Widget _wrap({
  required final RegistroRepository repo,
  required final String numreg,
  required final RegistroKind kind,
}) =>
    ProviderScope(
      overrides: [
        registroRepositoryProvider.overrideWith((final ref) => repo),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('es'),
        home: RegistroDetailPage(numreg: numreg, kind: kind),
      ),
    );

RegistroDetail _detail({
  required final RegistroKind kind,
  final List<RegistroFichero> ficheros = const <RegistroFichero>[],
}) =>
    RegistroDetail(
      id: 'id-1',
      numero: kind == RegistroKind.entrada ? 'REG/E/45612' : 'REG/S/12044',
      fecha: DateTime(2025, 6, 12, 9, 30),
      kind: kind,
      consejeriaDestino: 'Consejería de Educación, Cultura y Deportes',
      asunto: 'Solicitud de admisión en ciclos formativos',
      oficina: 'Oficina de Registro de Toledo',
      observaciones: 'Documentación presentada presencialmente.',
      ficheros: ficheros,
    );

void main() {
  testWidgets('renders entrada detail with metadata, ficheros and banner', (final tester) async {
    final detail = _detail(
      kind: RegistroKind.entrada,
      ficheros: const <RegistroFichero>[
        RegistroFichero(
          id: 'f1',
          nombre: 'solicitud-admision.pdf',
          mimeType: 'application/pdf',
          sizeBytes: 184320,
          descargaRef: 'mock://x',
        ),
      ],
    );
    final repo = _StubRepo((final _, final _) async => detail);

    await tester.pumpWidget(
      _wrap(repo: repo, numreg: 'REG/E/45612', kind: RegistroKind.entrada),
    );
    await tester.pumpAndSettle();

    expect(find.text('Detalle de entrada de registro'), findsOneWidget);
    expect(find.text('REG/E/45612'), findsWidgets);
    expect(find.text('solicitud-admision.pdf'), findsOneWidget);
    expect(find.textContaining('Esta pantalla muestra el detalle'), findsOneWidget);
  });

  testWidgets('renders salida detail with its specific title', (final tester) async {
    final detail = _detail(kind: RegistroKind.salida);
    final repo = _StubRepo((final _, final _) async => detail);

    await tester.pumpWidget(
      _wrap(repo: repo, numreg: 'REG/S/12044', kind: RegistroKind.salida),
    );
    await tester.pumpAndSettle();

    expect(find.text('Detalle de salida de registro'), findsOneWidget);
    expect(find.text('REG/S/12044'), findsWidgets);
  });

  testWidgets('renders empty-ficheros message when the list is empty', (final tester) async {
    final detail = _detail(kind: RegistroKind.entrada);
    final repo = _StubRepo((final _, final _) async => detail);

    await tester.pumpWidget(
      _wrap(repo: repo, numreg: 'REG/E/00000', kind: RegistroKind.entrada),
    );
    await tester.pumpAndSettle();

    expect(
      find.text('Este registro no incluye ficheros adjuntos.'),
      findsOneWidget,
    );
  });

  testWidgets('renders error state when the repository throws', (final tester) async {
    final repo = _StubRepo(
      (final _, final _) async => throw StateError('boom'),
    );

    await tester.pumpWidget(
      _wrap(repo: repo, numreg: 'REG/E/UNKNOWN', kind: RegistroKind.entrada),
    );
    await tester.pumpAndSettle();

    expect(
      find.text('No hemos podido cargar el detalle del registro.'),
      findsOneWidget,
    );
  });
}
