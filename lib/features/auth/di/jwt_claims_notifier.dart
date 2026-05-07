import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/jwt_claims.dart';

class JwtClaimsNotifier extends Notifier<JwtClaims?> {
  @override
  JwtClaims? build() => null;

  void update(final JwtClaims? user) => state = user;
}

final jwtClaimsProvider = NotifierProvider<JwtClaimsNotifier, JwtClaims?>(JwtClaimsNotifier.new);
