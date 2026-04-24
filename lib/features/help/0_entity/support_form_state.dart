import 'package:jccm_espacio_ciudadano/features/help/0_entity/support_request.dart';
import 'package:jccm_espacio_ciudadano/features/help/0_entity/support_validation_error.dart';
import 'package:meta/meta.dart';

/// Lifecycle of the support-form submission.
///
/// Tracked separately from validation errors so the UI can render
/// progress / success / error overlays without re-deriving them from
/// other fields (canon §15 — explicit screen state).
enum SupportSubmissionStatus {
  idle,
  validating,
  submitting,
  success,
  error,
}

/// Aggregate UI state for the support form.
///
/// Pure value object — no Flutter, no controllers. The notifier
/// (`1_domain/support_form_notifier.dart`) is the single owner.
@immutable
final class SupportFormState {
  const SupportFormState({
    required this.request,
    required this.emailConfirm,
    required this.status,
    required this.errors,
    this.submissionErrorKey,
  });

  /// Current values for the request payload.
  final SupportRequest request;

  /// Mirror of the `email` field used to enforce confirmation.
  /// Lives in the state — not in [SupportRequest] — because it's a
  /// presentation-only artefact that never reaches the backend.
  final String emailConfirm;

  /// Submission lifecycle.
  final SupportSubmissionStatus status;

  /// Per-field validation errors. Empty map means "valid".
  final Map<SupportFormField, SupportValidationError> errors;

  /// Locale-independent key describing the most recent submission failure.
  /// `null` while idle / submitting / success.
  final String? submissionErrorKey;

  static const SupportFormState initial = SupportFormState(
    request: SupportRequest.empty,
    emailConfirm: '',
    status: SupportSubmissionStatus.idle,
    errors: <SupportFormField, SupportValidationError>{},
  );

  bool get isValid => errors.isEmpty;

  bool get isSubmitting => status == SupportSubmissionStatus.submitting;

  bool get isSuccess => status == SupportSubmissionStatus.success;

  SupportFormState copyWith({
    final SupportRequest? request,
    final String? emailConfirm,
    final SupportSubmissionStatus? status,
    final Map<SupportFormField, SupportValidationError>? errors,
    final String? submissionErrorKey,
    final bool clearSubmissionError = false,
  }) =>
      SupportFormState(
        request: request ?? this.request,
        emailConfirm: emailConfirm ?? this.emailConfirm,
        status: status ?? this.status,
        errors: errors ?? this.errors,
        submissionErrorKey: clearSubmissionError
            ? null
            : (submissionErrorKey ?? this.submissionErrorKey),
      );
}
