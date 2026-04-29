import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jccm_espacio_ciudadano/app/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Stateful form widget extracted from the contact-registration page
/// for testability (STORY-42).
///
/// Owns its own controllers and the submit button. Validation and
/// persistence are delegated to the parent through [onSubmit] —
/// `null` means "submission in flight".
class NotificationContactForm extends StatefulWidget {
  const NotificationContactForm({
    required this.onSubmit,
    this.initialPhone,
    this.initialEmail,
    this.isSubmitting = false,
    super.key,
  });

  /// Called when the citizen taps the primary CTA. Receives the raw
  /// (non-trimmed) values; the domain validator handles normalisation.
  final Future<void> Function({String? phone, String? email}) onSubmit;
  final String? initialPhone;
  final String? initialEmail;
  final bool isSubmitting;

  @override
  State<NotificationContactForm> createState() => _NotificationContactFormState();
}

class _NotificationContactFormState extends State<NotificationContactForm> {
  late final TextEditingController _phoneCtrl = TextEditingController(
    text: widget.initialPhone,
  );
  late final TextEditingController _emailCtrl = TextEditingController(
    text: widget.initialEmail,
  );

  @override
  void dispose() {
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    await widget.onSubmit(
      phone: _phoneCtrl.text,
      email: _emailCtrl.text,
    );
  }

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        TextField(
          key: const Key('notification_contact_phone_field'),
          controller: _phoneCtrl,
          keyboardType: TextInputType.phone,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp(r'[\d\s+\-]')),
          ],
          decoration: InputDecoration(
            labelText: l10n.notificationContactPhoneLabel,
            hintText: l10n.notificationContactPhoneHint,
            prefixText: '+34 ',
            helperText: l10n.notificationContactPhoneHelper,
          ),
        ),
        const SizedBox(height: AppDimensions.space16),
        TextField(
          key: const Key('notification_contact_email_field'),
          controller: _emailCtrl,
          keyboardType: TextInputType.emailAddress,
          autocorrect: false,
          decoration: InputDecoration(
            labelText: l10n.notificationContactEmailLabel,
            hintText: l10n.notificationContactEmailHint,
            helperText: l10n.notificationContactEmailHelper,
          ),
        ),
        const SizedBox(height: AppDimensions.space24),
        FilledButton(
          key: const Key('notification_contact_submit_button'),
          onPressed: widget.isSubmitting ? null : _handleSubmit,
          child: widget.isSubmitting
              ? const SizedBox(
                  width: AppDimensions.iconSmall,
                  height: AppDimensions.iconSmall,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(l10n.notificationContactSubmitCta),
        ),
      ],
    );
  }
}
