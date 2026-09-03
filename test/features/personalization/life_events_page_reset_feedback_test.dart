import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/storage/app_storage.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/citizen_endpoint_ids_provider.dart';
import 'package:jccm_espacio_ciudadano/features/personalization/0_entity/life_event.dart';
import 'package:jccm_espacio_ciudadano/features/personalization/1_domain/repositories/life_events_repository.dart';
import 'package:jccm_espacio_ciudadano/features/personalization/2_presentation/life_events_page.dart';
import 'package:jccm_espacio_ciudadano/features/personalization/2_presentation/providers/life_events_repository_provider.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

// N-06: el reset de hechos vitales era el único flujo destructivo sin ningún
// feedback — tras confirmar el diálogo, ni el éxito ni el fallo del guardado
// llegaban al usuario, que se quedaba creyendo que había borrado su selección.

const _resetErrorFeedback = 'No hemos podido borrar tus preferencias. Inténtalo de nuevo.';
const _resetSuccessFeedback = 'Tus preferencias se han borrado.';

void main() {
  Future<void> pumpAndConfirmReset(final WidgetTester tester, {required final bool saveFails}) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          lifeEventsRepositoryProvider.overrideWithValue(_FakeLifeEventsRepository(saveFails: saveFails)),
          citizenEndpointIdsProvider.overrideWithValue((numDocumento: '12345678A', idAgente: 'agente-1')),
          appStorageProvider.overrideWithValue(_InMemoryAppStorage()),
        ],
        child: const MaterialApp(
          locale: Locale('es'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: LifeEventsPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Barra inferior → acción secundaria (abre el diálogo de borrado).
    await tester.tap(find.text('Cancelar').first);
    await tester.pumpAndSettle();
    expect(find.text('Borrar tus preferencias'), findsOneWidget, reason: 'debe abrirse el diálogo de confirmación');

    await tester.tap(find.text('Borrar'));
    await tester.pumpAndSettle();
  }

  testWidgets('un reset fallido avisa en vez de fallar en silencio', (final tester) async {
    await pumpAndConfirmReset(tester, saveFails: true);

    expect(find.text(_resetErrorFeedback), findsOneWidget);
    expect(find.text(_resetSuccessFeedback), findsNothing);

    await tester.pumpAndSettle(const Duration(seconds: 5));
  });

  testWidgets('un reset correcto confirma el borrado', (final tester) async {
    await pumpAndConfirmReset(tester, saveFails: false);

    expect(find.text(_resetSuccessFeedback), findsOneWidget);
    expect(find.text(_resetErrorFeedback), findsNothing);

    await tester.pumpAndSettle(const Duration(seconds: 5));
  });
}

final class _FakeLifeEventsRepository implements LifeEventsRepository {
  _FakeLifeEventsRepository({required this.saveFails});

  final bool saveFails;

  @override
  Future<List<LifeEvent>> loadLifeEvents({required final String idAgente}) async => const [
    LifeEvent(id: 1, label: 'Nacimiento', selected: true),
  ];

  @override
  Future<void> saveLifeEvents({
    required final String idAgente,
    required final List<LifeEvent> events,
  }) async {
    if (saveFails) {
      throw Exception('backend caído');
    }
  }

  @override
  Future<void> resetPreferences({required final String idAgente}) async {}
}

final class _InMemoryAppStorage implements AppStorage {
  final Map<String, Object> _store = {};

  @override
  T? read<T>(final String key) => _store[key] as T?;

  @override
  Future<bool> write(final String key, final Object value) async {
    _store[key] = value;
    return true;
  }

  @override
  Future<bool> remove(final String key) async {
    _store.remove(key);
    return true;
  }

  @override
  Future<bool> clear() async {
    _store.clear();
    return true;
  }
}
