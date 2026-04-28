// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upload_session_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Owns the lifecycle of an [UploadSession] for STORY-38.

@ProviderFor(UploadSessionNotifier)
const uploadSessionProvider = UploadSessionNotifierProvider._();

/// Owns the lifecycle of an [UploadSession] for STORY-38.
final class UploadSessionNotifierProvider
    extends $NotifierProvider<UploadSessionNotifier, UploadSession> {
  /// Owns the lifecycle of an [UploadSession] for STORY-38.
  const UploadSessionNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'uploadSessionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$uploadSessionNotifierHash();

  @$internal
  @override
  UploadSessionNotifier create() => UploadSessionNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UploadSession value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UploadSession>(value),
    );
  }
}

String _$uploadSessionNotifierHash() =>
    r'36d8d1600aa36fffc9650728ecb287b23e743286';

/// Owns the lifecycle of an [UploadSession] for STORY-38.

abstract class _$UploadSessionNotifier extends $Notifier<UploadSession> {
  UploadSession build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<UploadSession, UploadSession>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<UploadSession, UploadSession>,
              UploadSession,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
