import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/features/signature/1_domain/signature_handoff_launcher.dart';
import 'package:jccm_espacio_ciudadano/features/signature/3_data/url_launcher_signature_handoff_launcher.dart';

/// DI composition for [SignatureHandoffLauncher] (STORY-46).
///
/// Tests override this provider with an in-memory fake to assert the
/// controller transitions without touching `url_launcher`.
final signatureHandoffLauncherProvider = Provider<SignatureHandoffLauncher>(
  (final ref) => const UrlLauncherSignatureHandoffLauncher(),
  name: 'signatureHandoffLauncherProvider',
);
