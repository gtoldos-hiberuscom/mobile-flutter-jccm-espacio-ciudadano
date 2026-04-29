import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/core/cache/ttl_cache.dart';

/// Sprint 7 / STORY-65 — single shared TTL cache.
///
/// Adopters read from this provider; each feature is responsible for
/// namespacing its keys (e.g., `agenda:list`, `notifications:inbox`).
final Provider<TtlCache> ttlCacheProvider = Provider<TtlCache>(
  (final ref) => TtlCache(),
);
