// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'aportacion_session_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Owns the third-party aportación wizard state (STORY-37).
///
/// Each method advances at most one step and is the only mutator of
/// [AportacionSession]. The notifier never touches Flutter, navigation
/// or storage — UI side-effects remain in the presentation layer.

@ProviderFor(AportacionSessionNotifier)
const aportacionSessionProvider = AportacionSessionNotifierProvider._();

/// Owns the third-party aportación wizard state (STORY-37).
///
/// Each method advances at most one step and is the only mutator of
/// [AportacionSession]. The notifier never touches Flutter, navigation
/// or storage — UI side-effects remain in the presentation layer.
final class AportacionSessionNotifierProvider
    extends $NotifierProvider<AportacionSessionNotifier, AportacionSession> {
  /// Owns the third-party aportación wizard state (STORY-37).
  ///
  /// Each method advances at most one step and is the only mutator of
  /// [AportacionSession]. The notifier never touches Flutter, navigation
  /// or storage — UI side-effects remain in the presentation layer.
  const AportacionSessionNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'aportacionSessionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$aportacionSessionNotifierHash();

  @$internal
  @override
  AportacionSessionNotifier create() => AportacionSessionNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AportacionSession value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AportacionSession>(value),
    );
  }
}

String _$aportacionSessionNotifierHash() =>
    r'217807127bfcce3150d8daeb370aecb3eb60391c';

/// Owns the third-party aportación wizard state (STORY-37).
///
/// Each method advances at most one step and is the only mutator of
/// [AportacionSession]. The notifier never touches Flutter, navigation
/// or storage — UI side-effects remain in the presentation layer.

abstract class _$AportacionSessionNotifier
    extends $Notifier<AportacionSession> {
  AportacionSession build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AportacionSession, AportacionSession>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AportacionSession, AportacionSession>,
              AportacionSession,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
