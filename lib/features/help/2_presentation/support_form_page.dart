import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/app/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/features/help/0_entity/support_form_state.dart';
import 'package:jccm_espacio_ciudadano/features/help/0_entity/support_validation_error.dart';
import 'package:jccm_espacio_ciudadano/features/help/1_domain/support_form_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/help/1_domain/support_form_validator.dart';
import 'package:jccm_espacio_ciudadano/features/help/2_presentation/support_localizations.dart';
import 'package:jccm_espacio_ciudadano/features/help/2_presentation/widgets/attachment_picker_field.dart';
import 'package:jccm_espacio_ciudadano/features/help/2_presentation/widgets/captcha_placeholder.dart';
import 'package:jccm_espacio_ciudadano/features/help/2_presentation/widgets/character_counter.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Soporte técnico form (STORY-60).
///
/// All copy goes through ARB. Validation lives in `1_domain/`. The page
/// is a thin shell that wires `TextFormField`s to the
/// `supportFormProvider` notifier and renders the success / error
/// transitions (canon §15 — explicit screen state).
class SupportFormPage extends ConsumerStatefulWidget {
  const SupportFormPage({super.key});

  @override
  ConsumerState<SupportFormPage> createState() => _SupportFormPageState();
}

class _SupportFormPageState extends ConsumerState<SupportFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _emailConfirmCtrl = TextEditingController();
  final _subjectCtrl = TextEditingController();
  final _descriptionCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _emailConfirmCtrl.dispose();
    _subjectCtrl.dispose();
    _descriptionCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(supportFormProvider);
    final notifier = ref.read(supportFormProvider.notifier);

    // Side effects: success snackbar + error snackbar.
    ref.listen<SupportFormState>(supportFormProvider, (final prev, final next) {
      if (prev?.status != next.status) {
        if (next.status == SupportSubmissionStatus.success) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                key: const Key('support_success_snackbar'),
                content: Text(l10n.supportConfirmationMessage),
              ),
            );
        } else if (next.status == SupportSubmissionStatus.error &&
            next.submissionErrorKey != null) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(
                  resolveSupportSubmissionError(
                    l10n,
                    next.submissionErrorKey!,
                  ),
                ),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
        }
      }
    });

    if (state.isSuccess) {
      return _SuccessScreen(onClose: () {
        notifier.reset();
        _nameCtrl.clear();
        _emailCtrl.clear();
        _emailConfirmCtrl.clear();
        _subjectCtrl.clear();
        _descriptionCtrl.clear();
      });
    }

    return Scaffold(
      appBar: AppBar(title: Text(l10n.supportFormTitle)),
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: ListView(
          padding: const EdgeInsets.all(AppDimensions.space16),
          children: [
            Text(
              l10n.supportFormIntro,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: AppDimensions.space16),
            _buildField(
              key: const Key('support_name_field'),
              controller: _nameCtrl,
              label: l10n.supportFieldName,
              onChanged: notifier.updateName,
              errorText: _errorFor(l10n, state, SupportFormField.name),
              textInputAction: TextInputAction.next,
            ),
            _buildField(
              key: const Key('support_email_field'),
              controller: _emailCtrl,
              label: l10n.supportFieldEmail,
              onChanged: notifier.updateEmail,
              errorText: _errorFor(l10n, state, SupportFormField.email),
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
            ),
            _buildField(
              key: const Key('support_email_confirm_field'),
              controller: _emailConfirmCtrl,
              label: l10n.supportFieldEmailConfirm,
              onChanged: notifier.updateEmailConfirm,
              errorText:
                  _errorFor(l10n, state, SupportFormField.emailConfirm),
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
            ),
            _buildField(
              key: const Key('support_subject_field'),
              controller: _subjectCtrl,
              label: l10n.supportFieldSubject,
              onChanged: notifier.updateSubject,
              errorText: _errorFor(l10n, state, SupportFormField.subject),
              maxLength: SupportFormValidator.subjectDefaultMaxLength,
              textInputAction: TextInputAction.next,
              inputFormatters: [
                LengthLimitingTextInputFormatter(
                  SupportFormValidator.subjectDefaultMaxLength,
                ),
              ],
            ),
            _buildField(
              key: const Key('support_description_field'),
              controller: _descriptionCtrl,
              label: l10n.supportFieldDescription,
              onChanged: notifier.updateDescription,
              errorText:
                  _errorFor(l10n, state, SupportFormField.description),
              maxLines: 6,
              minLines: 4,
              keyboardType: TextInputType.multiline,
            ),
            CharacterCounter(
              current: state.request.description.length,
              max: SupportFormValidator.descriptionDefaultMaxLength,
            ),
            const SizedBox(height: AppDimensions.space16),
            AttachmentPickerField(
              attachment: state.request.attachment,
              onPicked: notifier.setAttachment,
              onCleared: () => notifier.setAttachment(null),
            ),
            const SizedBox(height: AppDimensions.space16),
            CheckboxListTile(
              key: const Key('support_consent_checkbox'),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
              value: state.request.dataConsent,
              onChanged: (final v) => notifier.updateConsent(v ?? false),
              title: Text(l10n.supportConsentLabel),
              subtitle: _errorFor(l10n, state, SupportFormField.consent) ==
                      null
                  ? null
                  : Text(
                      _errorFor(l10n, state, SupportFormField.consent)!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
            ),
            const SizedBox(height: AppDimensions.space12),
            CaptchaPlaceholder(
              value: state.request.captchaPassed,
              onChanged: notifier.updateCaptcha,
              errorText: _errorFor(l10n, state, SupportFormField.captcha),
            ),
            const SizedBox(height: AppDimensions.space24),
            FilledButton(
              key: const Key('support_submit_btn'),
              onPressed: state.isSubmitting ? null : notifier.submit,
              child: state.isSubmitting
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(l10n.supportSubmitButton),
            ),
            const SizedBox(height: AppDimensions.space24),
          ],
        ),
      ),
    );
  }

  String? _errorFor(
    final AppLocalizations l10n,
    final SupportFormState state,
    final SupportFormField field,
  ) {
    final err = state.errors[field];
    if (err == null) {
      return null;
    }
    return resolveSupportValidationError(l10n, err);
  }

  Widget _buildField({
    required final Key key,
    required final TextEditingController controller,
    required final String label,
    required final ValueChanged<String> onChanged,
    required final String? errorText,
    final TextInputType? keyboardType,
    final TextInputAction? textInputAction,
    final int? maxLength,
    final int? maxLines,
    final int? minLines,
    final List<TextInputFormatter>? inputFormatters,
  }) =>
      Padding(
        padding: const EdgeInsets.only(bottom: AppDimensions.space8),
        child: TextFormField(
          key: key,
          controller: controller,
          onChanged: onChanged,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          maxLength: maxLength,
          maxLines: maxLines ?? 1,
          minLines: minLines,
          inputFormatters: inputFormatters,
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
            errorText: errorText,
            counterText: maxLength == null ? '' : null,
          ),
        ),
      );
}

class _SuccessScreen extends StatelessWidget {
  const _SuccessScreen({required this.onClose});
  final VoidCallback onClose;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.supportFormTitle)),
      body: Padding(
        padding: const EdgeInsets.all(AppDimensions.space24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(
              Icons.mark_email_read_outlined,
              size: AppDimensions.iconLarge * 2,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: AppDimensions.space16),
            Text(
              l10n.supportConfirmationTitle,
              style: theme.textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.space12),
            Text(
              l10n.supportConfirmationMessage,
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.space32),
            FilledButton(
              key: const Key('support_success_close_btn'),
              onPressed: onClose,
              child: Text(l10n.supportConfirmationNewRequest),
            ),
          ],
        ),
      ),
    );
  }
}
