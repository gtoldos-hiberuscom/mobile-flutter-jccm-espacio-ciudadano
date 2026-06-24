import 'dart:async' show unawaited;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/core/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/jwt_claims.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/jwt_claims_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/preferences/0_entity/notification_contact.dart';
import 'package:jccm_espacio_ciudadano/features/preferences/1_domain/usecases/save_notification_contact_usecase.dart';
import 'package:jccm_espacio_ciudadano/features/preferences/2_presentation/providers/notification_contact_providers.dart';

class NotificationContactPage extends ConsumerStatefulWidget {
  const NotificationContactPage({super.key});

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
    final citizenId = _notificationCitizenId(claims);
    final dni = _notificationDni(claims);
    final contactState = ref.watch(notificationContactProvider(citizenId));

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppHeaderBar(
        title: 'Editar datos de contacto',
        backgroundColor: AppColors.backgroundBlueLighter,
        onBack: _leave,
        onInfo: () => AppAlertSnackbar.show(
          context,
          message: 'Indica un teléfono móvil o un correo electrónico para recibir avisos de notificaciones.',
        ),
      ),
      body: SafeArea(
        child: contactState.when(
          loading: () => const AppLoadingIndicator(),
          error: (final _, final _) => AppNotificationContactForm(
            formError: null,
            phoneError: null,
            emailError: null,
            saving: _saving,
            phoneController: _phoneController,
            emailController: _emailController,
            onClearError: _clearError,
            onLeave: _leave,
            onSave: () => unawaited(_save(citizenId: citizenId, dni: dni)),
          ),
          data: (final contact) {
            _initialize(contact);
            return AppNotificationContactForm(
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
    final phone = _phoneController.text.trim();
    final email = _emailController.text.trim();
    if (phone.isEmpty && email.isEmpty) {
      setState(() => _formError = 'Debes indicar al menos un teléfono móvil o un correo electrónico.');
      return;
    }
    if (phone.isNotEmpty && phone.replaceAll(RegExp(r'\D'), '').length != 9) {
      setState(() => _phoneError = 'Introduce un teléfono móvil válido.');
      return;
    }
    if (email.isNotEmpty && !_isEmail(email)) {
      setState(() => _emailError = 'Introduce un correo electrónico válido.');
      return;
    }
    if (citizenId.isEmpty) {
      setState(() => _formError = 'No hemos podido identificar al ciudadano.');
      return;
    }
    if (dni.isEmpty) {
      setState(() => _formError = 'No hemos podido obtener el DNI del ciudadano.');
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
          message: 'Datos de contacto guardados',
          severity: AppAlertSeverity.success,
        );
        context.go(Routes.preferences);
      case SaveNotificationContactFailed(:final message):
        setState(() => _formError = message);
    }
  }

  bool _isEmail(final String email) {
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email);
  }

  void _leave() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(Routes.preferences);
    }
  }
}

String _notificationCitizenId(final JwtClaims? claims) {
  return claims?.normalizedPersonIdentifier ?? '';
}

String _notificationDni(final JwtClaims? claims) {
  return claims?.normalizedPersonIdentifier ?? '';
}
