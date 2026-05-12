import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TokenResponseNotifier extends Notifier<TokenResponse?> {
  @override
  TokenResponse? build() => null;

  // ignore: use_setters_to_change_properties
  void update(final TokenResponse? session) => state = session;
}

final tokenResponseProvider = NotifierProvider<TokenResponseNotifier, TokenResponse?>(TokenResponseNotifier.new);
