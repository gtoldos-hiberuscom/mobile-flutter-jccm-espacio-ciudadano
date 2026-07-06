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
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Pantalla de activación de notificaciones (alta de datos de contacto).
/// Figma node 41683:13935.
class GestionNotificacionesAltaPage extends ConsumerStatefulWidget {
  const GestionNotificacionesAltaPage({super.key});

  @override
  ConsumerState<GestionNotificacionesAltaPage> createState() => _GestionNotificacionesAltaPageState();
}

class _GestionNotificacionesAltaPageState extends ConsumerState<GestionNotificacionesAltaPage> {
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  String? _formError;
  String? _phoneError;
  String? _emailError;
  bool _saving = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
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

  void _showInfoSheet(final BuildContext context, final AppLocalizations l10n) {
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

  Future<void> _save({
    required final String citizenId,
    required final String dni,
    required final AppLocalizations l10n,
  }) async {
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
        context.go(Routes.gestion);
      case SaveNotificationContactFailed(:final message):
        setState(() => _formError = message);
    }
  }

  bool _isEmail(final String email) {
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email);
  }

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final claims = ref.watch(jwtClaimsProvider);
    final citizenId = _citizenId(claims);
    final dni = _dni(claims);

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.backgroundWhite,
          border: Border(top: BorderSide(color: AppColors.borderNeutralLight)),
          boxShadow: AppShadows.low,
        ),
        padding: const EdgeInsets.fromLTRB(
          AppDimensions.space16,
          AppDimensions.space16,
          AppDimensions.space16,
          AppDimensions.space24,
        ),
        child: AppButton(
          label: l10n.gestionNotificacionesAltaSaveButton,
          isExpanded: true,
          leadingIcon: AppIcons.check,
          isLoading: _saving,
          onPressed: _saving ? null : () => unawaited(_save(citizenId: citizenId, dni: dni, l10n: l10n)),
        ),
      ),
      appBar: AppNavBar(
        type: AppNavBarType.level2,
        title: l10n.gestionNotificacionesAltaTitle,
        onBack: () => context.go(Routes.gestion),
        actions: [
          IconButton(
            icon: const Icon(AppIcons.info),
            tooltip: 'Más información',
            onPressed: () => _showInfoSheet(context, l10n),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.space16,
            vertical: AppDimensions.space24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.gestionNotificacionesAltaIntro,
                style: AppTypography.bodyRegular.copyWith(color: AppColors.textBase),
              ),
              const SizedBox(height: AppDimensions.space16),
              Text(
                l10n.gestionNotificacionesAltaRequiredNote,
                style: AppTypography.smallRegular.copyWith(color: AppColors.textBase),
              ),
              if (_formError != null) ...[
                const SizedBox(height: AppDimensions.space16),
                AppAlertBanner(
                  message: _formError!,
                  title: 'Error',
                  severity: AppAlertSeverity.error,
                  onDismiss: _clearError,
                ),
              ],
              const SizedBox(height: AppDimensions.space24),
              _SectionLabel(text: l10n.gestionNotificacionesAltaPhoneLabel),
              const SizedBox(height: AppDimensions.space8),
              AppPhoneInputCase(
                label: l10n.gestionNotificacionesAltaPhoneLabel,
                controller: _phoneController,
                hint: l10n.gestionNotificacionesAltaPhoneHint,
                errorText: _phoneError,
                helperText: _phoneError == null ? l10n.gestionNotificacionesAltaPhoneHelper : null,
                keyboardType: TextInputType.phone,
                onChanged: (_) => _clearError(),
              ),
              const SizedBox(height: AppDimensions.space24),
              _SectionLabel(text: l10n.gestionNotificacionesAltaEmailLabel),
              const SizedBox(height: AppDimensions.space8),
              AppInputCase(
                label: l10n.gestionNotificacionesAltaEmailLabel,
                hint: l10n.gestionNotificacionesAltaEmailHint,
                controller: _emailController,
                state: _emailError == null ? AppInputState.defaultState : AppInputState.error,
                errorText: _emailError,
                helperText: _emailError == null ? l10n.gestionNotificacionesAltaEmailHelper : null,
                keyboardType: TextInputType.emailAddress,
                prefixIcon: const Icon(AppIcons.alternateEmail, color: AppColors.textPrimary),
                onChanged: (_) => _clearError(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.text});

  final String text;

  @override
  Widget build(final BuildContext context) {
    return Text(
      text,
      style: AppTypography.captionUppercase.copyWith(color: AppColors.borderBlueMutedBase),
    );
  }
}

String _citizenId(final JwtClaims? claims) => claims?.normalizedPersonIdentifier ?? '';

String _dni(final JwtClaims? claims) => claims?.normalizedPersonIdentifier ?? '';
