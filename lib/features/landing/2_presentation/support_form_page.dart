import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/core/logger/logger.dart';
import 'package:jccm_espacio_ciudadano/core/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/jwt_claims_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/external_links/1_domain/external_link_launcher.dart';
import 'package:jccm_espacio_ciudadano/features/external_links/2_presentation/external_navigation_confirmation.dart';
import 'package:jccm_espacio_ciudadano/features/external_links/2_presentation/providers/external_links_provider.dart';
import 'package:jccm_espacio_ciudadano/features/landing/0_entity/support_request.dart';
import 'package:jccm_espacio_ciudadano/features/landing/1_domain/usecases/submit_support_request_usecase.dart';
import 'package:jccm_espacio_ciudadano/features/landing/2_presentation/providers/support_form_providers.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

class SupportFormPage extends ConsumerStatefulWidget {
  const SupportFormPage({super.key});

  @override
  ConsumerState<SupportFormPage> createState() => _SupportFormPageState();
}

class _SupportFormPageState extends ConsumerState<SupportFormPage> {
  static const _maxAttachmentBytes = 20 * 1024 * 1024;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _emailConfirmController = TextEditingController();
  final _subjectController = TextEditingController();
  final _descriptionController = TextEditingController();

  XFile? _attachment;
  int? _attachmentBytes;
  bool _consentAccepted = false;
  bool _submitted = false;
  bool _sent = false;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _emailConfirmController.dispose();
    _subjectController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isAuthenticated = ref.watch(jwtClaimsProvider) != null;

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppNavBar(
        type: AppNavBarType.detail,
        title: l10n.supportFormPageTitle,
        onClose: _goBack,
      ),
      body: SafeArea(
        child: _sent
            ? AppConfirmationState(
                title: l10n.supportConfirmationTitle,
                message: l10n.supportConfirmationMessage,
                actionLabel: l10n.supportConfirmationNewRequest,
                onAction: _resetForm,
              )
            : _FormView(
                nameController: _nameController,
                emailController: _emailController,
                emailConfirmController: _emailConfirmController,
                subjectController: _subjectController,
                descriptionController: _descriptionController,
                nameError: _nameError,
                emailError: _emailError,
                emailConfirmError: _emailConfirmError,
                subjectError: _subjectError,
                descriptionError: _descriptionError,
                consentAccepted: _consentAccepted,
                consentError: _consentError,
                attachment: _attachment,
                attachmentBytes: _attachmentBytes,
                showNameField: !isAuthenticated,
                showConsent: !isAuthenticated,
                onChanged: _refreshValidation,
                onConsentChanged: (final value) => setState(() => _consentAccepted = value),
                onPickAttachment: _pickAttachment,
                onRemoveAttachment: _removeAttachment,
                onOpenPrivacyInfo: _openPrivacyInfo,
              ),
      ),
      bottomNavigationBar: _sent
          ? null
          : AppStickybar(
              children: [
                AppButton(
                  label: l10n.supportCancelButton,
                  hierarchy: AppButtonHierarchy.tertiary,
                  onPressed: _isSubmitting ? null : _goBack,
                  isExpanded: true,
                ),
                AppButton(
                  label: l10n.supportAcceptButton,
                  onPressed: _submit,
                  isExpanded: true,
                  leadingIcon: AppIcons.check,
                  isLoading: _isSubmitting,
                ),
              ],
            ),
    );
  }

  void _refreshValidation() {
    if (_submitted) {
      setState(() {});
    }
  }

  void _goBack() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(Routes.helpContact);
    }
  }

  Future<void> _pickAttachment() async {
    final file = await openFile();
    if (!mounted || file == null) {
      return;
    }
    final bytes = await file.length();
    if (!mounted) {
      return;
    }
    setState(() {
      _attachment = file;
      _attachmentBytes = bytes;
    });
  }

  Future<void> _openPrivacyInfo() async {
    final link = ref.read(externalLinkCatalogProvider).findById('support_form_privacy_info');
    if (link == null) {
      return;
    }

    if (!await confirmExternalNavigation(context) || !mounted) {
      return;
    }
    final result = await ref.read(externalLinkLauncherProvider).launch(link);
    if (!mounted || result is! ExternalLinkLaunchFailure) {
      return;
    }

    AppAlertSnackbar.show(
      context,
      message: AppLocalizations.of(context).externalLinkOpenFailed,
      severity: AppAlertSeverity.error,
    );
  }

  void _removeAttachment() {
    setState(() {
      _attachment = null;
      _attachmentBytes = null;
    });
  }

  Future<void> _submit() async {
    if (_isSubmitting) {
      return;
    }
    setState(() => _submitted = true);
    final validationError = _firstValidationError;
    if (validationError != null) {
      logger.d('[SUPPORT] Submission blocked by form validation: $validationError');
      AppAlertSnackbar.show(
        context,
        message: validationError,
        severity: AppAlertSeverity.error,
      );
      return;
    }
    if (_attachmentBytes != null && _attachmentBytes! > _maxAttachmentBytes) {
      AppAlertSnackbar.show(
        context,
        message: AppLocalizations.of(context).supportErrorAttachmentTooLarge,
        severity: AppAlertSeverity.error,
      );
      return;
    }
    FocusScope.of(context).unfocus();
    setState(() => _isSubmitting = true);

    late final SupportRequest request;
    try {
      request = await _buildSupportRequest();
    } on Object {
      if (!mounted) {
        return;
      }
      setState(() => _isSubmitting = false);
      AppAlertSnackbar.show(
        context,
        message: AppLocalizations.of(context).supportErrorAttachmentUnreadable,
        severity: AppAlertSeverity.error,
      );
      return;
    }

    logger.d(
      '[SUPPORT] Sending support request '
      '(attachment: ${request.attachment != null})',
    );
    final result = await ref.read(submitSupportRequestUsecaseProvider).execute(request);
    if (!mounted) {
      return;
    }

    switch (result) {
      case SubmitSupportRequestSuccess():
        logger.d('[SUPPORT] Support request sent successfully');
        setState(() {
          _sent = true;
          _isSubmitting = false;
        });
      case SubmitSupportRequestFailed(:final reason, :final cause):
        logger.e('[SUPPORT] Support request failed: ${reason.name}', error: cause);
        setState(() => _isSubmitting = false);
        AppAlertSnackbar.show(
          context,
          message: switch (reason) {
            SubmitSupportRequestFailureReason.unauthorized => AppLocalizations.of(context).supportErrorSubmitUnauthorized,
            SubmitSupportRequestFailureReason.invalidData => AppLocalizations.of(context).supportErrorSubmitInvalidData,
            SubmitSupportRequestFailureReason.unavailable => AppLocalizations.of(context).supportErrorSubmitUnavailable,
          },
          severity: AppAlertSeverity.error,
        );
    }
  }

  Future<SupportRequest> _buildSupportRequest() async {
    final attachment = _attachment;
    final isAuthenticated = ref.read(jwtClaimsProvider) != null;
    return SupportRequest(
      name: isAuthenticated ? '' : _nameController.text.trim(),
      email: _emailController.text.trim(),
      subject: _subjectController.text.trim(),
      message: _descriptionController.text.trim(),
      privacyConsentAccepted: _consentAccepted,
      attachment: attachment == null
          ? null
          : SupportRequestAttachment(
              fileName: attachment.name,
              bytes: await attachment.readAsBytes(),
            ),
    );
  }

  void _resetForm() {
    setState(() {
      _nameController.clear();
      _emailController.clear();
      _emailConfirmController.clear();
      _subjectController.clear();
      _descriptionController.clear();
      _attachment = null;
      _attachmentBytes = null;
      _consentAccepted = false;
      _submitted = false;
      _sent = false;
      _isSubmitting = false;
    });
  }

  String? get _firstValidationError => _nameError ?? _emailError ?? _emailConfirmError ?? _subjectError ?? _descriptionError ?? _consentError;

  bool get _requiresPublicVerification => ref.read(jwtClaimsProvider) == null;

  String? get _nameError {
    if (!_submitted || !_requiresPublicVerification) {
      return null;
    }
    return _nameController.text.trim().isEmpty ? AppLocalizations.of(context).supportErrorNameRequired : null;
  }

  String? get _emailError {
    if (!_submitted) {
      return null;
    }
    final value = _emailController.text.trim();
    if (value.isEmpty) {
      return AppLocalizations.of(context).supportErrorEmailRequired;
    }
    final isValid = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value);
    return isValid ? null : AppLocalizations.of(context).supportErrorEmailInvalid;
  }

  String? get _emailConfirmError {
    if (!_submitted) {
      return null;
    }
    final value = _emailConfirmController.text.trim();
    if (value.isEmpty) {
      return AppLocalizations.of(context).supportErrorEmailConfirmRequired;
    }
    return value == _emailController.text.trim() ? null : AppLocalizations.of(context).supportErrorEmailMismatch;
  }

  String? get _subjectError {
    if (!_submitted) {
      return null;
    }
    final value = _subjectController.text.trim();
    if (value.isEmpty) {
      return AppLocalizations.of(context).supportErrorSubjectRequired;
    }
    return value.length <= 1000 ? null : AppLocalizations.of(context).supportErrorSubjectOverLimit;
  }

  String? get _descriptionError {
    if (!_submitted) {
      return null;
    }
    final value = _descriptionController.text.trim();
    if (value.isEmpty) {
      return AppLocalizations.of(context).supportErrorDescriptionRequired;
    }
    return value.length <= 2000 ? null : AppLocalizations.of(context).supportErrorDescriptionTooLong;
  }

  String? get _consentError {
    if (!_submitted || !_requiresPublicVerification || _consentAccepted) {
      return null;
    }
    return AppLocalizations.of(context).supportErrorConsentRequired;
  }
}

class _FormView extends StatelessWidget {
  const _FormView({
    required this.nameController,
    required this.emailController,
    required this.emailConfirmController,
    required this.subjectController,
    required this.descriptionController,
    required this.nameError,
    required this.emailError,
    required this.emailConfirmError,
    required this.subjectError,
    required this.descriptionError,
    required this.consentAccepted,
    required this.consentError,
    required this.attachment,
    required this.attachmentBytes,
    required this.showNameField,
    required this.showConsent,
    required this.onChanged,
    required this.onConsentChanged,
    required this.onPickAttachment,
    required this.onRemoveAttachment,
    required this.onOpenPrivacyInfo,
  });

  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController emailConfirmController;
  final TextEditingController subjectController;
  final TextEditingController descriptionController;
  final String? nameError;
  final String? emailError;
  final String? emailConfirmError;
  final String? subjectError;
  final String? descriptionError;
  final bool consentAccepted;
  final String? consentError;
  final XFile? attachment;
  final int? attachmentBytes;
  final bool showNameField;
  final bool showConsent;
  final VoidCallback onChanged;
  final ValueChanged<bool> onConsentChanged;
  final VoidCallback onPickAttachment;
  final VoidCallback onRemoveAttachment;
  final VoidCallback onOpenPrivacyInfo;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.space16,
        AppDimensions.space16,
        AppDimensions.space16,
        AppDimensions.space32,
      ),
      children: [
        Text(
          l10n.supportRequiredFieldsNote,
          style: AppTypography.bodyRegular.copyWith(color: AppColors.primary),
        ),
        const SizedBox(height: AppDimensions.space24),
        if (showNameField) ...[
          AppInputCase(
            label: l10n.supportFieldFullName,
            hint: l10n.supportFieldFullNameHint,
            controller: nameController,
            isRequired: true,
            state: _inputState(nameError),
            errorText: nameError,
            onChanged: (_) => onChanged(),
          ),
          const SizedBox(height: AppDimensions.space24),
        ],
        AppInputCase(
          label: l10n.supportFieldEmail,
          hint: l10n.supportFieldEmailHint,
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          isRequired: true,
          state: _inputState(emailError),
          errorText: emailError,
          onChanged: (_) => onChanged(),
        ),
        const SizedBox(height: AppDimensions.space24),
        AppInputCase(
          label: l10n.supportFieldConfirmEmail,
          hint: l10n.supportFieldEmailHint,
          controller: emailConfirmController,
          keyboardType: TextInputType.emailAddress,
          isRequired: true,
          state: _inputState(emailConfirmError),
          errorText: emailConfirmError,
          onChanged: (_) => onChanged(),
        ),
        const SizedBox(height: AppDimensions.space24),
        AppInputCase(
          label: l10n.supportFieldSubject,
          hint: l10n.supportFieldSubjectHint,
          controller: subjectController,
          isRequired: true,
          state: _inputState(subjectError),
          errorText: subjectError,
          onChanged: (_) => onChanged(),
        ),
        const SizedBox(height: AppDimensions.space8),
        AppDescriptionText(
          text: l10n.supportFieldSubjectHelper,
        ),
        const SizedBox(height: AppDimensions.space24),
        AppInputCase(
          label: l10n.supportFieldMessage,
          controller: descriptionController,
          isRequired: true,
          state: _inputState(descriptionError),
          errorText: descriptionError,
          keyboardType: TextInputType.multiline,
          maxLines: 6,
          onChanged: (_) => onChanged(),
        ),
        const SizedBox(height: AppDimensions.space32),
        AppAttachmentField(
          label: l10n.supportAttachmentSectionLabel,
          hint: l10n.supportAttachmentUploadHint,
          pickLabel: l10n.supportAttachmentPickDocuments,
          changeLabel: l10n.supportAttachmentChangeDocument,
          fileName: attachment?.name,
          fileBytes: attachmentBytes,
          isExpanded: true,
          hintAfterButton: true,
          onPick: onPickAttachment,
          onRemove: onRemoveAttachment,
        ),
        const SizedBox(height: AppDimensions.space32),
        if (showConsent) ...[
          AppCheckbox(
            label: l10n.supportConsentDataUseLabel,
            value: consentAccepted,
            isError: consentError != null,
            errorText: consentError,
            onChanged: (final value) => onConsentChanged(value ?? false),
          ),
          const SizedBox(height: AppDimensions.space24),
          AppPrivacyInfoText(
            description: l10n.supportPrivacyInfoDescription,
            linkText: 'https://rat.castillalamancha.es/detalle/2309',
            onTap: onOpenPrivacyInfo,
          ),
        ],
      ],
    );
  }

  AppInputState _inputState(final String? error) => error == null ? AppInputState.defaultState : AppInputState.error;
}
