import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/demo/demo_session.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/authentication_level.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/jwt_decoder.dart';
import 'package:jccm_espacio_ciudadano/features/auth/3_data/demo_auth_repository.dart';

void main() {
  test('la elevación demo devuelve a la misma persona con nivel alto', () async {
    final session = await const DemoAuthRepository().login(extraParameters: const {'prompt': 'login'});
    final claims = JwtDecoder.decode(session.accessToken!);

    expect(DemoSession.isDemo(claims), isTrue);
    expect(claims.idAgente, DemoSession.idAgente);
    expect(claims.effectivePersonIdentifier, DemoSession.personIdentifier);
    expect(AuthenticationLevelReading.parse(claims.authNLevelRaw).meets(AuthenticationLevel.substantial), isTrue);
  });
}
