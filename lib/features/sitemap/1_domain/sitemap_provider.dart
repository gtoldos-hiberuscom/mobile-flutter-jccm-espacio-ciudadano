import 'package:jccm_espacio_ciudadano/features/external_links/1_domain/external_links_provider.dart';
import 'package:jccm_espacio_ciudadano/features/sitemap/1_domain/sitemap_repository.dart';
import 'package:jccm_espacio_ciudadano/features/sitemap/3_data/sitemap_repository_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sitemap_provider.g.dart';

/// DI composition for the sitemap repository.
///
/// Reads the external-links catalog so the tree's external nodes stay
/// authoritative — STORY-62 must not re-hard-code outbound URLs that
/// already live in `ExternalLinkCatalog` (STORY-28 contract).
@Riverpod(keepAlive: true)
SitemapRepository sitemapRepository(final Ref ref) => SitemapRepositoryImpl(catalog: ref.watch(externalLinkCatalogProvider));
