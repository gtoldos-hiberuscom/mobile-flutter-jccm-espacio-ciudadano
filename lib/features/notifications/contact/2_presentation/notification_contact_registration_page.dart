import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/app/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/app/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/core/ui_states/error_state_widget.dart';
import 'package:jccm_espacio_ciudadano/core/ui_states/loading_state_widget.dart';
import 'package:jccm_espacio_ciudadano/features/notifications/contact/0_entity/notification_contact_validation_failure.dart';
import 'package:jccm_espacio_ciudadano/features/notifications/contact/1_domain/notification_contact_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/notifications/contact/2_presentation/widgets/notification_contact_form.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Standalone screen for citizen contact registration (STORY-42).
///
/// Renders the [NotificationContactForm], runs domain validation
/// through the notifier, surfaces validation failures via SnackBar,
/// and on success shows a confirmation SnackBar before navigating
/// back to the notifications center.
class NotificationContactRegistrationPage extends ConsumerStatefulWidget {
  const NotificationContactRegistrationPage({super.key});

  @override
  ConsumerState<NotificationContactRegistrationPage> createState() =>
      _NotificationContactRegistrationPageState();
}

class _NotificationContactRegistrationPageState
    extends ConsumerState<NotificationContactRegistrationPage> {
  bool _isSubmitting = false;

  Future<void> _handleSubmit({final String? phone, final String? email}) async {
    if (_isSubmitting) {
      return;
    }
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final router = GoRouter.of(context);
    setState(() => _isSubmitting = true);
    try {
      await ref
          .read(notificationContactProvider.notifier)
          .register(phone: phone, email: email);
      if (!mounted) {
        return;
      }
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            key: const Key('notification_contact_success_snackbar'),
            content: Text(l10n.notificationContactSuccessMessage),
          ),
        );
      router.go(Routes.notifications);
    } on NotificationContactValidationException catch (failure) {
      if (!mounted) {
        return;
      }
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            key: const Key('notification_contact_validation_snackbar'),
            content: Text(_resolveFailure(l10n, failure.failure)),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  String _resolveFailure(
    final AppLocalizations l10n,
    final NotificationContactValidationFailure failure,
  ) {
    switch (failure) {
      case NotificationContactValidationFailure.phoneInvalid:
        return l10n.notificationContactErrorPhoneInvalid;
      case NotificationContactValidationFailure.emailInvalid:
        return l10n.notificationContactErrorEmailInvalid;
      case NotificationContactValidationFailure.bothEmpty:
        return l10n.notificationContactErrorBothEmpty;
    }
  }

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final asyncContact = ref.watch(notificationContactProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.notificationContactPageTitle)),
      body: asyncContact.when(
        loading: () => LoadingStateWidget(message: l10n.notificationContactLoading),
        error: (final error, final _) => ErrorStateWidget(
          message: l10n.notificationContactErrorLoading,
          onRetry: () =>
              ref.invalidate(notificationContactProvider),
        ),
        data: (final current) => SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.space16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                l10n.notificationContactExplanation,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: AppDimensions.space24),
              NotificationContactForm(
                initialPhone: current?.phoneE164,
                initialEmail: current?.email,
                isSubmitting: _isSubmitting,
                onSubmit: _handleSubmit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
