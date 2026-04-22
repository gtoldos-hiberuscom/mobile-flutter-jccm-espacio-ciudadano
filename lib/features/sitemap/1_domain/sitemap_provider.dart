import 'package:jccm_espacio_ciudadano/features/sitemap/0_entity/sitemap_entry.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sitemap_provider.g.dart';

/// Provides the static sitemap entries for the app.
///
/// Content is hardcoded — no network call is required.
/// Auto-disposed when no longer watched.
@riverpod
List<SitemapEntry> sitemap(final Ref ref) {
  return const [
    SitemapEntry(
      label: 'Inicio',
      route: '/',
    ),
    SitemapEntry(
      label: 'Servicios',
      route: '/home',
      children: [
        SitemapEntry(label: 'Agenda', route: '/agenda'),
        SitemapEntry(label: 'Trámites', route: '/casework'),
        SitemapEntry(label: 'Mi Carpeta', route: '/home'),
      ],
    ),
    SitemapEntry(
      label: 'Global',
      route: '',
      children: [
        SitemapEntry(label: 'Ayuda', route: '/help'),
        SitemapEntry(label: 'Accesibilidad', route: '/legal/accessibility'),
        SitemapEntry(label: 'Protección de datos', route: '/legal/privacy'),
        SitemapEntry(label: 'Aviso legal', route: '/legal/notice'),
        SitemapEntry(label: 'Condiciones de uso', route: '/legal/terms'),
        SitemapEntry(
          label: 'Portal JCCM',
          route: 'https://www.jccm.es',
          isExternal: true,
        ),
      ],
    ),
  ];
}
