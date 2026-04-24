import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/core/network/result.dart';
import 'package:jccm_espacio_ciudadano/features/help/0_entity/picked_attachment.dart';
import 'package:jccm_espacio_ciudadano/features/help/0_entity/support_form_state.dart';
import 'package:jccm_espacio_ciudadano/features/help/1_domain/support_form_validator.dart';
import 'package:jccm_espacio_ciudadano/features/help/1_domain/support_repository.dart';
import 'package:jccm_espacio_ciudadano/features/help/3_data/support_repository_provider.dart';

/// Riverpod [Notifier] that owns the support-form UI state (STORY-60).
///
/// ## Responsibilities
/// - Receives field updates from the presentation layer.
/// - Delegates pure validation to [SupportFormValidator].
/// - Calls [SupportRepository.submit] and translates the [Result] into a
///   [SupportSubmissionStatus] transition.
///
/// ## Why a plain [Notifier] (no codegen)?
/// The notifier exposes mutating actions and never has to be re-evaluated
/// based on dependency changes — a hand-written [NotifierProvider] keeps
/// the file self-contained without dragging `build_runner` into a
/// presentation-only feature (canon §15 — explicit screen state).
class SupportFormNotifier extends Notifier<SupportFormState> {
  SupportFormNotifier({final SupportFormValidator? validator})
      : _validator = validator ?? const SupportFormValidator();

  final SupportFormValidator _validator;

  @override
  SupportFormState build() => SupportFormState.initial;

  // ── Field updates ──────────────────────────────────────────────────────────

  void updateName(final String value) =>
      state = state.copyWith(request: state.request.copyWith(name: value));

  void updateEmail(final String value) =>
      state = state.copyWith(request: state.request.copyWith(email: value));

  void updateEmailConfirm(final String value) =>
      state = state.copyWith(emailConfirm: value);

  void updateSubject(final String value) =>
      state = state.copyWith(request: state.request.copyWith(subject: value));

  void updateDescription(final String value) => state = state.copyWith(
        request: state.request.copyWith(description: value),
      );

  void updateConsent(final bool value) => state = state.copyWith(
        request: state.request.copyWith(dataConsent: value),
      );

  // TODO(TASK-63): replace by the real captcha success signal.
  void updateCaptcha(final bool value) => state = state.copyWith(
        request: state.request.copyWith(captchaPassed: value),
      );

  void setAttachment(final PickedAttachment? value) {
    state = state.copyWith(
      request: state.request.copyWith(
        attachment: value,
        clearAttachment: value == null,
      ),
    );
  }

  // ── Public actions ─────────────────────────────────────────────────────────

  /// Runs validation and updates [SupportFormState.errors]. Returns true
  /// when the form is valid.
  bool validate() {
    final errors = _validator.validate(state.request, state.emailConfirm);
    state = state.copyWith(
      errors: errors,
      status: errors.isEmpty
          ? SupportSubmissionStatus.idle
          : SupportSubmissionStatus.validating,
      clearSubmissionError: true,
    );
    return errors.isEmpty;
  }

  /// Validates and, on success, calls the repository.
  ///
  /// Errors are surfaced as [SupportFormState.submissionErrorKey] +
  /// [SupportSubmissionStatus.error]; the UI maps that key to copy.
  Future<void> submit() async {
    if (!validate()) {
      return;
    }
    state = state.copyWith(
      status: SupportSubmissionStatus.submitting,
      clearSubmissionError: true,
    );
    final result =
        await ref.read(supportRepositoryProvider).submit(state.request);
    state = switch (result) {
      Success() => state.copyWith(status: SupportSubmissionStatus.success),
      // We surface a stable locale-independent key — the ARB copy
      // resolution happens in `2_presentation/`. The concrete `error`
      // payload is opaque to the UI here.
      // ignore: unused_local_variable
      Failure(:final error) => state.copyWith(
          status: SupportSubmissionStatus.error,
          submissionErrorKey: 'supportSubmissionGenericError',
        ),
    };
  }

  /// Resets the form to its initial empty state.
  void reset() => state = SupportFormState.initial;
}

/// Public provider exposing [SupportFormNotifier].
///
/// Auto-disposed: the form should start clean each time the user enters
/// `/help/support` (canon §15).
final supportFormProvider =
    NotifierProvider.autoDispose<SupportFormNotifier, SupportFormState>(
  SupportFormNotifier.new,
  name: 'supportFormProvider',
);
