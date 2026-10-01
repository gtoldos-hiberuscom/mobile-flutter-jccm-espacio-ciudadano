import 'dart:async' show unawaited;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/ui_states/error_state_widget.dart';
import 'package:jccm_espacio_ciudadano/core/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/jwt_claims.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/ciudadanos_endpoint_id_provider.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/jwt_claims_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/preferences/0_entity/notification_contact.dart';
import 'package:jccm_espacio_ciudadano/features/preferences/1_domain/usecases/save_notification_contact_usecase.dart';
import 'package:jccm_espacio_ciudadano/features/preferences/2_presentation/providers/notification_contact_providers.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

class NotificationContactPage extends ConsumerStatefulWidget {
  const NotificationContactPage({
    super.key,
    this.returnTo = Routes.preferences,
  });

  /// Ruta a la que volver al cerrar o guardar. La pantalla se abre desde varias
  /// rutas (Preferencias, Notificaciones…), así que el origen se pasa por query.
  final String returnTo;

  @override
  ConsumerState<NotificationContactPage> createState() => _NotificationContactPageState();
}

class _NotificationContactPageState extends ConsumerState<NotificationContactPage> {
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  String? _formError;
  String? _phoneError;
  String? _emailError;
  bool _initialized = false;
  bool _saving = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    final claims = ref.watch(jwtClaimsProvider);
    final citizenId = ref.watch(ciudadanosEndpointIdProvider);
    final dni = _notificationDni(claims);
    final contactState = ref.watch(notificationContactProvider(citizenId));

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppHeaderBar(
        title: AppLocalizations.of(context).preferencesNotificationContactEditTitle,
        backgroundColor: AppColors.backgroundBlueLighter,
        onBack: _leave,
        onInfo: () => _showInfoSheet(context),
      ),
      body: SafeArea(
        child: contactState.when(
          loading: () => const AppLoadingIndicator(),
          // Nunca el formulario en blanco: guardarlo haría un reemplazo completo
          // que borra el contacto ya registrado. Sin los datos actuales solo
          // cabe error + reintentar.
          error: (final _, final _) => ErrorStateWidget(
            message: AppLocalizations.of(context).domainGenericLoadError,
            onRetry: () => ref.invalidate(notificationContactProvider(citizenId)),
          ),
          data: (final contact) {
            _initialize(contact);
            return AppNotificationContactForm(
              notice: contact == null ? AppLocalizations.of(context).notificationContactNotRegistered : null,
              formError: _formError,
              phoneError: _phoneError,
              emailError: _emailError,
              saving: _saving,
              phoneController: _phoneController,
              emailController: _emailController,
              onClearError: _clearError,
              onLeave: _leave,
              onSave: () => unawaited(_save(citizenId: citizenId, dni: dni)),
            );
          },
        ),
      ),
    );
  }

  void _showInfoSheet(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    // ignore: discarded_futures
    AppBottomSheet.show<void>(
      context: context,
      title: l10n.gestionNotificacionesAltaInfoTitle,
      body: Text(
        l10n.gestionNotificacionesAltaInfoBody,
        style: AppTypography.bodyRegular.copyWith(color: AppColors.textBase),
      ),
    );
  }

  void _initialize(final NotificationContact? contact) {
    if (_initialized) {
      return;
    }
    _initialized = true;
    _phoneController.text = contact?.phone ?? '';
    _emailController.text = contact?.email ?? '';
  }

  void _clearError() {
    if (_formError != null || _phoneError != null || _emailError != null) {
      setState(() {
        _formError = null;
        _phoneError = null;
        _emailError = null;
      });
    }
  }

  Future<void> _save({
    required final String citizenId,
    required final String dni,
  }) async {
    final l10n = AppLocalizations.of(context);
    final phone = _phoneController.text.trim();
    final email = _emailController.text.trim();
    if (phone.isEmpty && email.isEmpty) {
      setState(() => _formError = l10n.gestionNotificacionesAltaErrorAtLeastOne);
      return;
    }
    if (phone.isNotEmpty && phone.replaceAll(RegExp(r'\D'), '').length != 9) {
      setState(() => _phoneError = l10n.gestionNotificacionesAltaErrorPhone);
      return;
    }
    if (email.isNotEmpty && !_isEmail(email)) {
      setState(() => _emailError = l10n.gestionNotificacionesAltaErrorEmail);
      return;
    }
    if (citizenId.isEmpty) {
      setState(() => _formError = l10n.gestionNotificacionesAltaErrorNoCitizenId);
      return;
    }
    if (dni.isEmpty) {
      setState(() => _formError = l10n.gestionNotificacionesAltaErrorNoDni);
      return;
    }

    setState(() => _saving = true);
    final result = await ref
        .read(saveNotificationContactUsecaseProvider)
        .execute(
          citizenId: citizenId,
          dni: dni,
          contact: NotificationContact(
            phone: phone.isEmpty ? null : phone,
            email: email.isEmpty ? null : email,
          ),
        );

    if (!mounted) {
      return;
    }
    setState(() => _saving = false);
    switch (result) {
      case SaveNotificationContactSuccess():
        ref.invalidate(notificationContactProvider(citizenId));
        AppAlertSnackbar.show(
          context,
          message: l10n.gestionNotificacionesAltaSuccessMessage,
          severity: AppAlertSeverity.success,
        );
        context.go(widget.returnTo);
      case SaveNotificationContactFailed(:final reason):
        setState(
          () => _formError = switch (reason) {
            SaveNotificationContactFailureReason.unauthorized => l10n.notificationContactSaveUnauthorizedError,
            SaveNotificationContactFailureReason.invalidData => l10n.notificationContactSaveInvalidDataError,
            SaveNotificationContactFailureReason.unavailable => l10n.notificationContactSaveUnavailableError,
          },
        );
    }
  }

  bool _isEmail(final String email) {
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email);
  }

  void _leave() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(widget.returnTo);
    }
  }
}

/// DNI carried inside the request body (not the URL). Stays the document number.
String _notificationDni(final JwtClaims? claims) {
  return claims?.normalizedPersonIdentifier ?? '';
}
