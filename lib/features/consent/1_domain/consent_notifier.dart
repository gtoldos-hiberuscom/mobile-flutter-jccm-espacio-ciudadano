import 'package:flutter_riverpod/flutter_riverpod.dart' show AsyncNotifier;
import 'package:jccm_espacio_ciudadano/core/network/result.dart';
import 'package:jccm_espacio_ciudadano/features/consent/0_entity/consent_state.dart';
import 'package:jccm_espacio_ciudadano/features/consent/1_domain/consent_repository.dart' show ConsentRepository;
import 'package:jccm_espacio_ciudadano/features/consent/3_data/consent_repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'consent_notifier.g.dart';

/// Riverpod [AsyncNotifier] that manages the full consent lifecycle.
///
/// ## Lifecycle
/// On `build()`, reads the persisted consent status from [ConsentRepository]
/// and resolves to:
/// - [ConsentAccepted] — consent was previously given; show home directly.
/// - [ConsentPending]  — consent has not been given; show the consent screen.
///
/// ## Actions
/// - [accept]  — persists acceptance and transitions to [ConsentAccepted].
/// - [reject]  — persists rejection and transitions to [ConsentRejected].
///
/// Kept alive for the full app lifetime so the router guard always reads a
/// stable, up-to-date consent state without recreating the notifier.
@Riverpod(keepAlive: true)
class ConsentNotifier extends _$ConsentNotifier {
  @override
  Future<ConsentState> build() async {
    final result = await ref.read(consentRepositoryProvider).checkConsentAccepted();
    return switch (result) {
      Success(:final value) => value,
      Failure() => const ConsentPending(),
    };
  }

  // ── Public actions ─────────────────────────────────────────────────────────

  /// Persists acceptance and transitions to [ConsentAccepted].
  ///
  /// On storage failure the notifier stays in [ConsentPending] so that the
  /// user can retry rather than being silently let through.
  Future<void> accept() async {
    final result = await ref.read(consentRepositoryProvider).acceptConsent();
    state = switch (result) {
      Success() => const AsyncValue.data(ConsentAccepted()),
      Failure(:final error) => AsyncValue.error(error, StackTrace.current),
    };
  }

  /// Persists rejection and transitions to [ConsentRejected].
  Future<void> reject() async {
    final result = await ref.read(consentRepositoryProvider).rejectConsent();
    state = switch (result) {
      Success() => const AsyncValue.data(ConsentRejected()),
      Failure(:final error) => AsyncValue.error(error, StackTrace.current),
    };
  }
}
