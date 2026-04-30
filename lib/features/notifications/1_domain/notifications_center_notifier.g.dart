// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notifications_center_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Owns the notifications center screen state (STORY-41).
///
/// On `build()` it requests page 0 with no status filter (all statuses).
/// `setFilters` resets paging to the first page; `loadMore` appends the
/// next page; `refresh` reloads the first page preserving the active
/// filter set. Errors do not blank the previously loaded items — they
/// surface through `hasError` so the user can keep browsing what is
/// already on screen and retry the failing page.

@ProviderFor(NotificationsCenterNotifier)
const notificationsCenterProvider = NotificationsCenterNotifierProvider._();

/// Owns the notifications center screen state (STORY-41).
///
/// On `build()` it requests page 0 with no status filter (all statuses).
/// `setFilters` resets paging to the first page; `loadMore` appends the
/// next page; `refresh` reloads the first page preserving the active
/// filter set. Errors do not blank the previously loaded items — they
/// surface through `hasError` so the user can keep browsing what is
/// already on screen and retry the failing page.
final class NotificationsCenterNotifierProvider
    extends
        $AsyncNotifierProvider<
          NotificationsCenterNotifier,
          NotificationsCenterState
        > {
  /// Owns the notifications center screen state (STORY-41).
  ///
  /// On `build()` it requests page 0 with no status filter (all statuses).
  /// `setFilters` resets paging to the first page; `loadMore` appends the
  /// next page; `refresh` reloads the first page preserving the active
  /// filter set. Errors do not blank the previously loaded items — they
  /// surface through `hasError` so the user can keep browsing what is
  /// already on screen and retry the failing page.
  const NotificationsCenterNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notificationsCenterProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notificationsCenterNotifierHash();

  @$internal
  @override
  NotificationsCenterNotifier create() => NotificationsCenterNotifier();
}

String _$notificationsCenterNotifierHash() =>
    r'0ca7d813cbe90aec03032f34244817fb93602299';

/// Owns the notifications center screen state (STORY-41).
///
/// On `build()` it requests page 0 with no status filter (all statuses).
/// `setFilters` resets paging to the first page; `loadMore` appends the
/// next page; `refresh` reloads the first page preserving the active
/// filter set. Errors do not blank the previously loaded items — they
/// surface through `hasError` so the user can keep browsing what is
/// already on screen and retry the failing page.

abstract class _$NotificationsCenterNotifier
    extends $AsyncNotifier<NotificationsCenterState> {
  FutureOr<NotificationsCenterState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<
              AsyncValue<NotificationsCenterState>,
              NotificationsCenterState
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<NotificationsCenterState>,
                NotificationsCenterState
              >,
              AsyncValue<NotificationsCenterState>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
