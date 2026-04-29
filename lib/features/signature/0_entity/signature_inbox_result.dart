import 'package:jccm_espacio_ciudadano/features/signature/0_entity/signature_document.dart';

/// Aggregated result of a single inbox fetch (STORY-45).
///
/// Pure value type — no Flutter / Dio / Riverpod (canon §11). Pending
/// and signed lists are exposed separately so the presentation layer
/// can render them under independent tabs without filtering at render
/// time.
final class SignatureInboxResult {
  const SignatureInboxResult({
    required this.pending,
    required this.signed,
    required this.fetchedAt,
  });

  final List<SignatureDocument> pending;
  final List<SignatureDocument> signed;
  final DateTime fetchedAt;
}
