import 'package:jccm_espacio_ciudadano/core/analytics/analytics_provider.dart';
import 'package:jccm_espacio_ciudadano/features/external_links/1_domain/external_link_catalog.dart';
import 'package:jccm_espacio_ciudadano/features/external_links/1_domain/external_link_launcher.dart';
import 'package:jccm_espacio_ciudadano/features/external_links/3_data/external_link_catalog_impl.dart';
import 'package:jccm_espacio_ciudadano/features/external_links/3_data/url_launcher_external_link_launcher.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'external_links_provider.g.dart';

/// Provides the application-wide [ExternalLinkCatalog] (allow-list of
/// outbound destinations).
///
/// `keepAlive: true` because the catalog is immutable and reused from
/// many places (home dashboard, landings, sitemap). The DI composition
/// happens here — presentation widgets must not import the
/// `3_data/` implementation directly (canon §13).
@Riverpod(keepAlive: true)
ExternalLinkCatalog externalLinkCatalog(final Ref ref) => const ExternalLinkCatalogImpl();

/// Provides the application-wide [ExternalLinkLauncher].
///
/// Composed against the catalog and analytics service. Tests can override
/// this provider with a fake implementation that does not touch the real
/// `url_launcher` plugin.
@Riverpod(keepAlive: true)
ExternalLinkLauncher externalLinkLauncher(final Ref ref) => UrlLauncherExternalLinkLauncher(
  catalog: ref.watch(externalLinkCatalogProvider),
  analytics: ref.watch(analyticsServiceProvider),
);
