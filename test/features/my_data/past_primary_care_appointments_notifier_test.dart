import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/citizen_endpoint_ids_provider.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/health_appointment.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/hospital_appointment.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/my_data_authorization_required.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/my_data_health_cip_missing.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/1_domain/repositories/my_data_health_repository.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/controllers/past_primary_care_appointments_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/providers/my_data_health_provider.dart';

void main() {
  group('PastPrimaryCareAppointmentsNotifier', () {
    test('loads the first page and reports that more pages may follow', () async {
      final repository = _FakeHealthRepository(pages: [
        [_appointment(DateTime(2026, 5, 3, 12))],
      ]);
      final container = _container(repository);

      final state = await _loaded(container);

      expect(repository.requestedPages, [0]);
      // Primaria se resuelve por documento: la fachada declara {numDocumento} en
      // estas rutas y responde 403 si se le manda el idAgente.
      expect(repository.requestedCitizenIds, ['12345678A']);
      expect(state.appointments.map((final appointment) => appointment.dateTime), [DateTime(2026, 5, 3, 12)]);
      expect(state.hasMore, isTrue);
      expect(state.isLoadingMore, isFalse);
    });

    test('appends further pages and keeps the whole list newest first', () async {
      final repository = _FakeHealthRepository(pages: [
        [_appointment(DateTime(2026, 5, 3, 12))],
        [_appointment(DateTime(2026, 7, 1, 9)), _appointment(DateTime(2026, 1, 8, 8))],
      ]);
      final container = _container(repository);
      await _loaded(container);

      await container.read(pastPrimaryCareAppointmentsProvider.notifier).loadMore();
      final state = container.read(pastPrimaryCareAppointmentsProvider);

      expect(repository.requestedPages, [0, 1]);
      expect(state.appointments.map((final appointment) => appointment.dateTime), [
        DateTime(2026, 7, 1, 9),
        DateTime(2026, 5, 3, 12),
        DateTime(2026, 1, 8, 8),
      ]);
    });

    test('stops paginating when a page comes back empty', () async {
      final repository = _FakeHealthRepository(pages: [
        [_appointment(DateTime(2026, 5, 3, 12))],
        [],
      ]);
      final container = _container(repository);
      await _loaded(container);

      await container.read(pastPrimaryCareAppointmentsProvider.notifier).loadMore();
      final state = container.read(pastPrimaryCareAppointmentsProvider);

      expect(state.hasMore, isFalse);
      expect(state.appointments, hasLength(1));

      // Una vez agotadas las páginas, loadMore no vuelve a llamar al backend.
      await container.read(pastPrimaryCareAppointmentsProvider.notifier).loadMore();
      expect(repository.requestedPages, [0, 1]);
    });

    test('keeps the pages already loaded when a later page fails', () async {
      final repository = _FakeHealthRepository(
        pages: [
          [_appointment(DateTime(2026, 5, 3, 12))],
        ],
        failFromPage: 1,
      );
      final container = _container(repository);
      await _loaded(container);

      await container.read(pastPrimaryCareAppointmentsProvider.notifier).loadMore();
      final state = container.read(pastPrimaryCareAppointmentsProvider);

      expect(state.status, PastPrimaryCareAppointmentsStatus.loaded);
      expect(state.appointments, hasLength(1));
      expect(state.hasMore, isFalse);
      expect(state.isLoadingMore, isFalse);
    });

    test('separates a missing authorization from a transport failure', () async {
      final repository = _FakeHealthRepository(pages: const [], unauthorized: true);
      final container = _container(repository);

      final state = await _settled(container);

      expect(state.status, PastPrimaryCareAppointmentsStatus.authorizationRequired);
      expect(state.hasMore, isFalse);
    });

    test('reports a missing CIP instead of a service failure (JCCMEC-266)', () async {
      final repository = _FakeHealthRepository(pages: const [], cipMissing: true);
      final container = _container(repository);

      final state = await _settled(container);

      expect(state.status, PastPrimaryCareAppointmentsStatus.cipMissing);
      expect(state.hasMore, isFalse);
    });

    test('surfaces an error when the first page fails', () async {
      final repository = _FakeHealthRepository(pages: const [], failFromPage: 0);
      final container = _container(repository);

      final state = await _settled(container);

      expect(state.status, PastPrimaryCareAppointmentsStatus.loadError);
      expect(state.appointments, isEmpty);
      expect(state.hasMore, isFalse);
    });

    test('fails without asking the backend when the token has no document number', () async {
      final repository = _FakeHealthRepository(pages: const []);
      final container = ProviderContainer(
        overrides: [
          citizenEndpointIdsProvider.overrideWithValue((numDocumento: null, idAgente: 'PER9998003')),
          myDataHealthRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);

      final state = await _settled(container);

      expect(state.status, PastPrimaryCareAppointmentsStatus.loadError);
      expect(repository.requestedPages, isEmpty);
    });
  });
}

ProviderContainer _container(final _FakeHealthRepository repository) {
  final container = ProviderContainer(
    overrides: [
      citizenEndpointIdsProvider.overrideWithValue((numDocumento: '12345678A', idAgente: 'PER9998003')),
      myDataHealthRepositoryProvider.overrideWithValue(repository),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

/// Espera a que termine la carga que arranca en `build`.
///
/// El provider es `autoDispose`, así que hace falta una suscripción viva: con un
/// `read` suelto se descartaría antes de que la carga termine.
Future<PastPrimaryCareAppointmentsState> _settled(final ProviderContainer container) async {
  container.listen(pastPrimaryCareAppointmentsProvider, (final previous, final next) {}, fireImmediately: true);
  for (var attempt = 0; attempt < 20; attempt++) {
    await Future<void>.delayed(Duration.zero);
    if (container.read(pastPrimaryCareAppointmentsProvider).status != PastPrimaryCareAppointmentsStatus.loading) {
      break;
    }
  }
  return container.read(pastPrimaryCareAppointmentsProvider);
}

Future<PastPrimaryCareAppointmentsState> _loaded(final ProviderContainer container) async {
  final state = await _settled(container);
  expect(state.status, PastPrimaryCareAppointmentsStatus.loaded);
  return state;
}

HealthAppointment _appointment(final DateTime dateTime) => HealthAppointment(
  dateTime: dateTime,
  professional: 'LAGUNA RUIDERA MONTESINOS',
  description: 'DEMANDA',
);

final class _FakeHealthRepository implements MyDataHealthRepository {
  _FakeHealthRepository({required this.pages, this.failFromPage, this.unauthorized = false, this.cipMissing = false});

  final List<List<HealthAppointment>> pages;
  final int? failFromPage;
  final bool unauthorized;
  final bool cipMissing;
  final List<int> requestedPages = [];
  final List<String> requestedCitizenIds = [];

  @override
  Future<String?> loadCip({required final String citizenId}) async => null;

  @override
  Future<List<HealthAppointment>> loadPrimaryCareAppointments({
    required final String citizenId,
    required final HealthAppointmentFilter filter,
    final int page = 0,
  }) async {
    requestedPages.add(page);
    requestedCitizenIds.add(citizenId);
    if (unauthorized) {
      throw const MyDataAuthorizationRequired();
    }
    if (cipMissing) {
      throw const MyDataHealthCipMissing();
    }
    final failFrom = failFromPage;
    if (failFrom != null && page >= failFrom) {
      throw StateError('backend down');
    }
    return page < pages.length ? pages[page] : const [];
  }

  @override
  Future<List<HospitalAppointment>> loadHospitalAppointments({
    required final String citizenId,
    required final HealthAppointmentFilter filter,
  }) async => const [];
}
