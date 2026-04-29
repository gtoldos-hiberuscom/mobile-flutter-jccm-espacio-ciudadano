import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/features/signature/1_domain/signature_repository.dart';
import 'package:jccm_espacio_ciudadano/features/signature/3_data/signature_repository_impl.dart';

/// DI composition for [SignatureRepository] (STORY-45).
///
/// Kept alive so the mock catalog is built once per session — the real
/// Dio adapters (deferred) will benefit from this lifetime when wired
/// against `/afirma/milistardocumentosreq`, `/afirma/mivecreq` and
/// `/publicacion/midocfirmados`.
///
/// NOTE on Riverpod codegen: see `signatureInboxProvider` — STORY-45
/// uses plain `Provider` to avoid hand-rolling brittle `*.g.dart`
/// internals. A follow-up can swap to `@Riverpod(keepAlive: true)` when
/// the codegen pipeline is re-run repo-wide.
final signatureRepositoryProvider = Provider<SignatureRepository>(
  (final ref) => SignatureRepositoryImpl(),
  name: 'signatureRepositoryProvider',
);
