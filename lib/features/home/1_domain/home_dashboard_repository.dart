import 'package:jccm_espacio_ciudadano/features/home/0_entity/home_dashboard_snapshot.dart';

/// Domain contract for retrieving the authenticated home dashboard payload.
///
/// Implementations live in `3_data/`. This interface must not import any
/// Flutter, Riverpod, Dio or concrete storage class — only entities
/// (canon §13, repository ownership).
///
/// The method does NOT return a `Result` because partial errors are encoded
/// per block inside the returned snapshot. A thrown exception is reserved
/// for unrecoverable failures (e.g. dependency injection misconfiguration)
/// and will surface as an `AsyncValue.error` on the notifier.
abstract interface class HomeDashboardRepository {
  /// Resolves a fresh dashboard snapshot for the currently authenticated user.
  Future<HomeDashboardSnapshot> loadDashboard();
}
