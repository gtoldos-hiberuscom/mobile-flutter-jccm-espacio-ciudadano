import 'package:jccm_espacio_ciudadano/features/help/1_domain/help_repository.dart';
import 'package:jccm_espacio_ciudadano/features/help/3_data/help_repository_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'help_repository_provider.g.dart';

/// Provides the singleton [HelpRepository] implementation.
///
/// Content is entirely bundled — no I/O occurs on creation.
/// Auto-disposes when no help page is open.
@riverpod
HelpRepository helpRepository(final Ref ref) => const HelpRepositoryImpl();
