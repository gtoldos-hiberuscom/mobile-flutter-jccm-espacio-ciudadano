import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/jwt_claims.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/jwt_claims_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/widgets/authenticated_profile_menu.dart';

void main() {
  Future<String?> initialsFor(final WidgetTester tester, final JwtClaims? claims) async {
    String? initials;
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          if (claims != null) jwtClaimsProvider.overrideWith(() => _StubJwtClaimsNotifier(claims)),
        ],
        child: Consumer(
          builder: (final context, final ref, final child) {
            initials = authenticatedProfileInitials(ref);
            return const SizedBox.shrink();
          },
        ),
      ),
    );
    return initials;
  }

  testWidgets('builds the initials from the given name and first surname', (final tester) async {
    final initials = await initialsFor(
      tester,
      const JwtClaims(exp: 0, iat: 0, iss: '', aud: [], sub: 'sub', givenName: 'Ana', firstSurname: 'Pérez'),
    );

    expect(initials, 'AP');
  });

  testWidgets('returns null rather than an empty string without a session', (final tester) async {
    // Es el estado en el que quedan las pantallas autenticadas durante el frame
    // en que se limpia la sesión. `AppNavBar` acepta null pero rompe con ''.
    expect(await initialsFor(tester, null), isNull);
  });

  testWidgets('uses the represented party initials with a representative certificate', (final tester) async {
    final initials = await initialsFor(
      tester,
      const JwtClaims(
        exp: 0,
        iat: 0,
        iss: '',
        aud: [],
        sub: 'sub',
        givenName: 'Titular',
        firstSurname: 'Certificado',
        representedAgentId: 'PJU0349051',
        representedName: 'Entidad Representada',
        representedNif: 'Q0000000J',
      ),
    );

    expect(initials, 'ER');
  });

  testWidgets('returns null when the claims carry no name', (final tester) async {
    final initials = await initialsFor(
      tester,
      const JwtClaims(exp: 0, iat: 0, iss: '', aud: [], sub: 'sub'),
    );

    expect(initials, isNull);
  });
}

final class _StubJwtClaimsNotifier extends JwtClaimsNotifier {
  _StubJwtClaimsNotifier(this._claims);

  final JwtClaims _claims;

  @override
  JwtClaims? build() => _claims;
}
