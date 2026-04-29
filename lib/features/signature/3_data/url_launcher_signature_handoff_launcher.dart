import 'package:flutter/foundation.dart';
import 'package:jccm_espacio_ciudadano/features/signature/1_domain/signature_handoff_launcher.dart';
import 'package:url_launcher/url_launcher.dart';

/// `url_launcher`-backed [SignatureHandoffLauncher] (STORY-46).
///
/// Lives in `3_data/` because it depends on `package:url_launcher`,
/// which is a platform / infrastructure concern. The domain layer only
/// sees the abstract [SignatureHandoffLauncher] interface.
///
// TODO(future-sprint): replace stub Afirma URL builder with the real
// /afirma/* endpoint contract. The current presentation-layer URL
// (`https://afirma.jccm.es/sign?docId=…&returnTo=…`) is a deliberate
// placeholder until the Afirma integration team publishes the real
// hand-off scheme, certificate handling and signed-payload exchange.
class UrlLauncherSignatureHandoffLauncher implements SignatureHandoffLauncher {
  const UrlLauncherSignatureHandoffLauncher();

  @override
  Future<bool> launchExternal(final Uri externalUri) async {
    try {
      return await launchUrl(
        externalUri,
        mode: LaunchMode.externalApplication,
      );
    } on Exception catch (error, stack) {
      // Stay quiet in release; surface the failure during local /
      // automated runs so the controller can transition to `error`.
      debugPrintStack(
        label: 'UrlLauncherSignatureHandoffLauncher: launch failed: $error',
        stackTrace: stack,
      );
      return false;
    }
  }
}
