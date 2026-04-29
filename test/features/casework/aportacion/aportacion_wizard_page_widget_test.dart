import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:jccm_espacio_ciudadano/features/casework/0_entity/casework_item.dart';
import 'package:jccm_espacio_ciudadano/features/casework/0_entity/casework_tab.dart';
import 'package:jccm_espacio_ciudadano/features/casework/1_domain/casework_repository.dart';
import 'package:jccm_espacio_ciudadano/features/casework/aportacion/0_entity/aportacion_search_query.dart';
import 'package:jccm_espacio_ciudadano/features/casework/aportacion/1_domain/aportacion_resolver.dart';
import 'package:jccm_espacio_ciudadano/features/casework/aportacion/2_presentation/aportacion_wizard_page.dart';
import 'package:jccm_espacio_ciudadano/features/casework/detail/0_entity/expediente_detail.dart';
import 'package:jccm_espacio_ciudadano/features/casework/detail/0_entity/expediente_estado.dart';
import 'package:jccm_espacio_ciudadano/features/casework/detail/0_entity/expediente_fichero.dart';
import 'package:jccm_espacio_ciudadano/features/casework/detail/1_domain/expediente_detail_repository.dart';
import 'package:jccm_espacio_ciudadano/features/casework/detail/3_data/expediente_detail_repository_provider.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

class _StubResolver extends AportacionResolver {
  _StubResolver(this._match) : super(_NoopRepo());
  final CaseworkItem? _match;
  @override
  Future<CaseworkItem?> resolve(final AportacionSearchQuery query) async => _match;
}

class _NoopRepo implements CaseworkRepository {
  @override
  Future<List<CaseworkItem>> loadByTab(final CaseworkTab tab) async => const <CaseworkItem>[];
  @override
  Future<List<CaseworkItem>> searchByNif(final String identification) async => const <CaseworkItem>[];
  @override
  Future<List<CaseworkItem>> searchByExpedienteNumber(
    final String number,
  ) async => const <CaseworkItem>[];
  @override
  Future<List<CaseworkItem>> searchByRegistroNumber(
    final String number,
  ) async => const <CaseworkItem>[];
}

class _StubDetailRepo implements ExpedienteDetailRepository {
  _StubDetailRepo(this.detail);
  final ExpedienteDetail detail;
  @override
  Future<ExpedienteDetail> loadByNumber(final String numexp) async => detail;
}

ExpedienteDetail _detailFixture() => ExpedienteDetail(
  id: 'x1',
  numero: 'EXP/2025/00123',
  asuntoCodigo: 'AS-1',
  asunto: 'Solicitud',
  consejeria: 'Consejería de Bienestar',
  oficinaTramitadora: 'Oficina de Toledo',
  procedimiento: 'Ayudas',
  fechaInicio: DateTime(2025, 3, 4),
  fechaUltimaActualizacion: DateTime(2025, 4, 18),
  estado: ExpedienteEstado.cerrado,
  ficheros: <ExpedienteFichero>[
    ExpedienteFichero(
      id: 'f1',
      nombre: 'documento.pdf',
      mimeType: 'application/pdf',
      sizeBytes: 1024,
      fechaSubida: DateTime(2025, 3, 5),
      descargaRef: 'ref://x',
    ),
  ],
);

CaseworkItem _matchItem() => CaseworkItem(
  id: 'm1',
  type: CaseworkTab.expedientes,
  number: 'EXP/2025/00123',
  date: DateTime(2025, 6, 15),
  organism: 'Org',
  subject: 'Asunto',
  status: CaseworkItemStatus.enTramite,
);

Widget _wrap({final ProviderContainer? container}) {
  final scope = container == null
      ? const ProviderScope(child: _Host())
      : UncontrolledProviderScope(
          container: container,
          child: const _Host(),
        );
  return scope;
}

class _Host extends StatelessWidget {
  const _Host();
  @override
  Widget build(final BuildContext context) => const MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: Locale('es'),
    home: AportacionWizardPage(),
  );
}

ProviderContainer _container({
  final AportacionResolver? resolver,
  final ExpedienteDetailRepository? detailRepo,
}) {
  final c = ProviderContainer(
    overrides: [
      if (resolver != null) aportacionResolverProvider.overrideWith((final ref) => resolver),
      if (detailRepo != null) expedienteDetailRepositoryProvider.overrideWith((final ref) => detailRepo),
    ],
  );
  addTearDown(c.dispose);
  return c;
}

void main() {
  testWidgets('AportacionWizardPage renders intro step initially', (final tester) async {
    await tester.pumpWidget(_wrap());
    await tester.pumpAndSettle();
    expect(find.text('Aportación de documentos'), findsOneWidget);
    expect(find.text('Aporta documentación a un expediente'), findsOneWidget);
    expect(find.text('Continuar'), findsOneWidget);
    expect(find.text('Paso 1 de 5'), findsOneWidget);
  });

  testWidgets('Wizard advances intro → identification → search → detail', (final tester) async {
    await tester.pumpWidget(
      _wrap(
        container: _container(
          resolver: _StubResolver(_matchItem()),
          detailRepo: _StubDetailRepo(_detailFixture()),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Intro → continue
    await tester.tap(find.text('Continuar'));
    await tester.pumpAndSettle();
    expect(find.text('Identifica al interesado'), findsOneWidget);
    expect(find.text('Paso 2 de 5'), findsOneWidget);

    // Identification → next
    await tester.enterText(
      find.byType(TextField).first,
      '12345678Z',
    );
    await tester.tap(find.text('Siguiente'));
    await tester.pumpAndSettle();
    expect(find.text('Localiza el expediente'), findsOneWidget);
    expect(find.text('Paso 3 de 5'), findsOneWidget);

    // Search → submit (resolver returns a match)
    await tester.enterText(
      find.byType(TextField).first,
      'EXP/2025/00123',
    );
    await tester.tap(find.text('Buscar'));
    await tester.pumpAndSettle();

    // Detail step is rendered (uses ExpedienteDetailView with cerrado estado)
    expect(find.text('Paso 4 de 5'), findsOneWidget);
    // Metadata block surfaces the fixture número.
    expect(find.text('EXP/2025/00123'), findsWidgets);
    // Closed expediente shows the locked banner from ExpedienteDetailView.
    expect(find.byIcon(Icons.lock_outline), findsOneWidget);
  });

  testWidgets('Search step surfaces notFound failure when resolver yields null', (final tester) async {
    await tester.pumpWidget(
      _wrap(container: _container(resolver: _StubResolver(null))),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continuar'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, '12345678Z');
    await tester.tap(find.text('Siguiente'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, 'EXP/2025/99999');
    await tester.tap(find.text('Buscar'));
    await tester.pumpAndSettle();
    expect(
      find.text('No hemos encontrado ningún expediente con esos datos.'),
      findsOneWidget,
    );
    // Still on search step.
    expect(find.text('Paso 3 de 5'), findsOneWidget);
  });
}
