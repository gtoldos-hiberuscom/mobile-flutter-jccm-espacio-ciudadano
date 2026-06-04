import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/features/design_system/2_presentation/pages/design_system_catalog_page.dart';

/// GoRouter routes provider for the design_system catalog feature.
///
/// Registers `/design-system` as the entry point. The catalog is a developer
/// and designer tool — accessible without authentication so it can be linked
/// from landing or settings.
final designSystemRoutesProvider = Provider<List<RouteBase>>((final ref) {
  return [
    GoRoute(
      path: '/design-system',
      name: 'design-system-catalog',
      builder: (final context, final state) =>
          const DesignSystemCatalogPage(),
    ),
  ];
});
