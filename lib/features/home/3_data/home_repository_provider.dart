import 'package:jccm_espacio_ciudadano/features/home/1_domain/home_dashboard_repository.dart';
import 'package:jccm_espacio_ciudadano/features/home/3_data/home_dashboard_repository_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_repository_provider.g.dart';

/// Provides the [HomeDashboardRepository] implementation.
///
/// Not kept alive on purpose: the repository (and any cached state inside
/// it) is dropped when the home view is no longer in scope — the dashboard
/// is expected to refresh whenever the user navigates back.
@riverpod
HomeDashboardRepository homeDashboardRepository(final Ref ref) =>
    const HomeDashboardRepositoryImpl();
