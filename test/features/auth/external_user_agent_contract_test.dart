import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_test/flutter_test.dart';

/// Contract guard for the vendored flutter_appauth fork
/// (`packages/flutter_appauth`, see CHANGELOG_JCCM.md).
///
/// The fork's Android side interprets the `externalUserAgent` value that the
/// platform interface serialises as the ENUM INDEX over the MethodChannel:
/// index 1 must be `ephemeralAsWebAuthenticationSession`, or ephemeral
/// sessions would silently stop being requested on Android. If this test
/// fails after upgrading `flutter_appauth_platform_interface`, update the
/// `EPHEMERAL_EXTERNAL_USER_AGENT` constant in the fork's
/// FlutterAppauthPlugin.java and this test together.
void main() {
  test('ExternalUserAgent indexes match the vendored fork contract', () {
    expect(ExternalUserAgent.asWebAuthenticationSession.index, 0);
    expect(ExternalUserAgent.ephemeralAsWebAuthenticationSession.index, 1);
  });
}
