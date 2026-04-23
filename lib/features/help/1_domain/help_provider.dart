import 'package:jccm_espacio_ciudadano/features/help/0_entity/help_content.dart';
import 'package:jccm_espacio_ciudadano/features/help/1_domain/help_repository.dart';
import 'package:jccm_espacio_ciudadano/features/help/3_data/help_repository_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'help_provider.g.dart';

/// DI composition for the help-center repository.
///
/// `keepAlive: true` because the content is immutable and reused by both
/// the help page and (potentially) the sitemap entry.
@Riverpod(keepAlive: true)
HelpRepository helpRepository(final Ref ref) => const HelpRepositoryImpl();

/// Synchronous provider exposing the help-center [HelpContent].
@Riverpod(keepAlive: true)
HelpContent helpContent(final Ref ref) =>
    ref.watch(helpRepositoryProvider).loadContent();
