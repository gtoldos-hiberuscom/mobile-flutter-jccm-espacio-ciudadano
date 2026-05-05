import 'package:jccm_espacio_ciudadano/core/config/app_config.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_config_provider.g.dart';

/// Provides the [AppConfig] that was resolved at application startup.
///
/// This provider is intentionally left unimplemented here and **must** be
/// overridden at the `ProviderScope` level inside `bootstrap` so that all
/// descendant providers can read the correct configuration without requiring
/// a `BuildContext`.
///
/// ```dart
/// ProviderScope(
///   overrides: [
///     appConfigProvider.overrideWithValue(config),
///   ],
///   child: App(config: config),
/// )
/// ```
@Riverpod(keepAlive: true)
AppConfig appConfig(final Ref ref) => throw UnimplementedError(
  'appConfigProvider must be overridden in ProviderScope at bootstrap.',
);
