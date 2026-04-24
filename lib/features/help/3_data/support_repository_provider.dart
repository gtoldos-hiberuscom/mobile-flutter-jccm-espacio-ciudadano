import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/core/logging/app_logger.dart';
import 'package:jccm_espacio_ciudadano/core/logging/logger_provider.dart';
import 'package:jccm_espacio_ciudadano/core/network/result.dart';
import 'package:jccm_espacio_ciudadano/features/help/0_entity/support_request.dart';
import 'package:jccm_espacio_ciudadano/features/help/1_domain/support_repository.dart';

/// Mock implementation of [SupportRepository] for STORY-60.
///
/// Always returns [Success] after a 500 ms delay so the UI can be
/// integrated end-to-end without a backend.
///
// TODO(TASK-63): wire real backend channel (operator inbox + email
/// confirmation). Until then, this implementation only logs the request
/// metadata — never the email body or attachment bytes — through the
/// `AppLogger` so PII surfaces stay redacted (canon §26).
final class SupportRepositoryImpl implements SupportRepository {
  const SupportRepositoryImpl({required this.logger});

  final AppLogger logger;

  @override
  Future<Result<void>> submit(final SupportRequest request) async {
    // PII-safe context — log lengths / flags, never raw values.
    logger.info(
      'support_form.submit',
      context: <String, Object?>{
        'subjectLength': request.subject.length,
        'descriptionLength': request.description.length,
        'hasAttachment': request.attachment != null,
        'attachmentSizeBytes': request.attachment?.sizeBytes,
        'dataConsent': request.dataConsent,
        'captchaPassed': request.captchaPassed,
      },
    );
    // TODO(TASK-63): wire real backend channel — for now we simulate a
    // small network round-trip so the UI exercises the loading state.
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return const Success<void>(null);
  }
}

/// DI provider exposing the concrete [SupportRepository].
///
/// Kept alive for the app lifetime: the mock has no per-session state
/// and the form may be opened multiple times.
final supportRepositoryProvider = Provider<SupportRepository>(
  (final ref) => SupportRepositoryImpl(logger: ref.watch(appLoggerProvider)),
  name: 'supportRepositoryProvider',
);
