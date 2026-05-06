import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'token_response_notifier.g.dart';

@Riverpod(keepAlive: true)
class TokenResponseNotifier extends _$TokenResponseNotifier {
  @override
  TokenResponse? build() => null;

  void update(final TokenResponse? session) => state = session;
}
