import 'dart:async' show unawaited;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/citizen_endpoint_ids_provider.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/health_appointment.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/my_data_authorization_required.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/my_data_health_cip_missing.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/1_domain/repositories/my_data_health_repository.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/providers/my_data_health_provider.dart';

// ── State ─────────────────────────────────────────────────────────────────────

enum PastPrimaryCareAppointmentsStatus {
  /// Carga de la primera página en curso.
  loading,

  /// Hay al menos una página cargada.
  loaded,

  /// La primera página falló y no hay nada que mostrar.
  loadError,

  /// El backend rechazó la consulta por falta de autorización (cláusula 1).
  authorizationRequired,

  /// SESCAM no tiene un CIP vinculado a la identidad del ciudadano.
  cipMissing,
}

/// Estado del listado paginado de citas pasadas de atención primaria.
final class PastPrimaryCareAppointmentsState {
  const PastPrimaryCareAppointmentsState({
    this.status = PastPrimaryCareAppointmentsStatus.loading,
    this.appointments = const [],
    this.hasMore = true,
    this.isLoadingMore = false,
  });

  final PastPrimaryCareAppointmentsStatus status;

  /// Citas acumuladas de todas las páginas cargadas, de más reciente a más
  /// antigua.
  final List<HealthAppointment> appointments;

  /// `false` cuando la última página vino vacía, que es la única señal de fin
  /// que da el backend: la respuesta no informa total ni número de páginas.
  final bool hasMore;

  final bool isLoadingMore;

  PastPrimaryCareAppointmentsState copyWith({
    final PastPrimaryCareAppointmentsStatus? status,
    final List<HealthAppointment>? appointments,
    final bool? hasMore,
    final bool? isLoadingMore,
  }) => PastPrimaryCareAppointmentsState(
    status: status ?? this.status,
    appointments: appointments ?? this.appointments,
    hasMore: hasMore ?? this.hasMore,
    isLoadingMore: isLoadingMore ?? this.isLoadingMore,
  );
}

// ── Notifier ──────────────────────────────────────────────────────────────────

/// Acumula las páginas de `primaria-citas-pasadas` para el scroll infinito.
///
/// Es el único listado de Salud paginado: el gateway sólo acepta el parámetro
/// `pagina` en esa operación.
class PastPrimaryCareAppointmentsNotifier extends Notifier<PastPrimaryCareAppointmentsState> {
  int _nextPage = 0;
  bool _isFetching = false;

  @override
  PastPrimaryCareAppointmentsState build() {
    // La carga se lanza tras el frame actual para que `build` sea síncrono.
    unawaited(Future.microtask(_fetchNextPage));
    return const PastPrimaryCareAppointmentsState();
  }

  /// Pide la siguiente página. Es idempotente mientras haya una en vuelo.
  Future<void> loadMore() async {
    if (_isFetching || !state.hasMore || state.status != PastPrimaryCareAppointmentsStatus.loaded) {
      return;
    }
    state = state.copyWith(isLoadingMore: true);
    await _fetchNextPage();
  }

  /// Reinicia el listado desde la primera página.
  Future<void> retry() async {
    if (_isFetching) {
      return;
    }
    _nextPage = 0;
    state = const PastPrimaryCareAppointmentsState();
    await _fetchNextPage();
  }

  Future<void> _fetchNextPage() async {
    final String citizenId;
    try {
      citizenId = ref.read(citizenEndpointIdsProvider).requireNumDocumento();
    } on StateError {
      state = state.copyWith(
        status: state.appointments.isEmpty ? PastPrimaryCareAppointmentsStatus.loadError : PastPrimaryCareAppointmentsStatus.loaded,
        hasMore: false,
        isLoadingMore: false,
      );
      return;
    }

    _isFetching = true;
    try {
      final page = await ref
          .read(myDataHealthRepositoryProvider)
          .loadPrimaryCareAppointments(
            citizenId: citizenId,
            filter: HealthAppointmentFilter.past,
            page: _nextPage,
          );
      if (!ref.mounted) {
        return;
      }

      _nextPage++;
      // Se reordena el acumulado en vez de concatenar sin más: el repositorio
      // ordena cada página por separado y no está garantizado que el backend
      // devuelva las páginas en orden cronológico entre sí.
      final accumulated = [...state.appointments, ...page]..sort((final a, final b) => b.dateTime.compareTo(a.dateTime));

      state = state.copyWith(
        status: PastPrimaryCareAppointmentsStatus.loaded,
        appointments: List.unmodifiable(accumulated),
        hasMore: page.isNotEmpty,
        isLoadingMore: false,
      );
    } on MyDataAuthorizationRequired {
      if (!ref.mounted) {
        return;
      }
      state = state.copyWith(
        status: state.appointments.isEmpty ? PastPrimaryCareAppointmentsStatus.authorizationRequired : PastPrimaryCareAppointmentsStatus.loaded,
        hasMore: false,
        isLoadingMore: false,
      );
    } on MyDataHealthCipMissing {
      if (!ref.mounted) {
        return;
      }
      state = state.copyWith(
        status: state.appointments.isEmpty ? PastPrimaryCareAppointmentsStatus.cipMissing : PastPrimaryCareAppointmentsStatus.loaded,
        hasMore: false,
        isLoadingMore: false,
      );
    } catch (_) {
      if (!ref.mounted) {
        return;
      }
      // Si ya hay páginas pintadas se conserva lo cargado y se corta la
      // paginación, para no vaciar el listado por un fallo al final.
      state = state.copyWith(
        status: state.appointments.isEmpty ? PastPrimaryCareAppointmentsStatus.loadError : PastPrimaryCareAppointmentsStatus.loaded,
        hasMore: false,
        isLoadingMore: false,
      );
    } finally {
      _isFetching = false;
    }
  }
}

final pastPrimaryCareAppointmentsProvider = NotifierProvider.autoDispose<PastPrimaryCareAppointmentsNotifier, PastPrimaryCareAppointmentsState>(
  PastPrimaryCareAppointmentsNotifier.new,
);
