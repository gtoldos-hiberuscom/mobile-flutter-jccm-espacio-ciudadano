import 'package:jccm_espacio_ciudadano/features/legal/1_domain/legal_repository.dart';
import 'package:jccm_espacio_ciudadano/features/legal/3_data/legal_repository_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'legal_repository_provider.g.dart';

/// Provides the singleton [LegalRepository] implementation.
///
/// Content is entirely bundled — no I/O occurs on creation.
/// `keepAlive` defaults to `false`; the provider auto-disposes when no
/// legal page is open, which is the expected behaviour for static pages.
@riverpod
LegalRepository legalRepository(final Ref ref) => const LegalRepositoryImpl();
