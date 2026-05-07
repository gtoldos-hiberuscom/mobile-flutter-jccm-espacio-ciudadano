import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/core/config/app_config.dart';

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
final appConfigProvider = Provider<AppConfig>((ref) => throw UnimplementedError(
  'appConfigProvider must be overridden in ProviderScope at bootstrap.',
));
