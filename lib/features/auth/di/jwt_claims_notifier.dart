import 'package:jccm_espacio_ciudadano/features/auth/0_entity/jwt_claims.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'jwt_claims_notifier.g.dart';

@Riverpod(keepAlive: true)
class JwtClaimsNotifier extends _$JwtClaimsNotifier {
  @override
  JwtClaims? build() => null;

  void update(final JwtClaims? user) => state = user;
}
