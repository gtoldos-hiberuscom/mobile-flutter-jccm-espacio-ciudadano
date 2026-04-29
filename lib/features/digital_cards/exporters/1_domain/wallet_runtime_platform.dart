/// Digital cards exporters (EPIC-7 / STORY-52) — domain.
library;

import 'dart:io' show Platform;

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'wallet_runtime_platform.g.dart';

/// Coarse runtime platform classification used by the wallet pipeline
/// to gate Apple-Wallet only branches. Tests override the provider
/// instead of stubbing `dart:io`.
enum WalletRuntimePlatform { ios, android, other }

@riverpod
WalletRuntimePlatform walletRuntimePlatform(final Ref ref) {
  try {
    if (Platform.isIOS) {
      return WalletRuntimePlatform.ios;
    }
    if (Platform.isAndroid) {
      return WalletRuntimePlatform.android;
    }
  } on Object {
    // Fall through — non-dart:io environments (e.g. web).
  }
  return WalletRuntimePlatform.other;
}
