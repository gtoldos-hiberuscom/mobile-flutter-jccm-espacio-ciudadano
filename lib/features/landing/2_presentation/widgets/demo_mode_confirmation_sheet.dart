import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/core/demo/demo_session.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_typography.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_bottom_sheet.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_button.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_input_case.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Hoja de confirmación previa al modo demostración.
///
/// El enlace es visible para todo el mundo —los revisores de las tiendas lo
/// necesitan así—, de modo que un ciudadano puede pulsarlo por curiosidad:
/// antes de entrar se le cuenta qué va a ver (datos ficticios, sin Cl@ve, nada
/// se envía), cómo salir, y se le pide el código de acceso
/// (`DemoSession.accessCode`, el de las notas de revisión). Devuelve `true`
/// sólo si confirma con el código correcto.
///
/// Con `hasPersistedSession` la hoja avisa además de que entrar cerrará la
/// sesión guardada con acceso rápido, y el botón principal lo dice: la demo y
/// esa sesión no pueden convivir (ver `LandingNotifier.enterDemoMode`), y la
/// decisión tiene que tomarse sabiéndolo.
abstract final class DemoModeConfirmationSheet {
  const DemoModeConfirmationSheet._();

  static Future<bool> show(final BuildContext context, {final bool hasPersistedSession = false}) async {
    final confirmed = await AppBottomSheet.show<bool>(
      context: context,
      title: AppLocalizations.of(context).demoConfirmTitle,
      body: _DemoConfirmationBody(hasPersistedSession: hasPersistedSession),
    );
    return confirmed ?? false;
  }
}

class _DemoConfirmationBody extends StatefulWidget {
  const _DemoConfirmationBody({required this.hasPersistedSession});

  final bool hasPersistedSession;

  @override
  State<_DemoConfirmationBody> createState() => _DemoConfirmationBodyState();
}

class _DemoConfirmationBodyState extends State<_DemoConfirmationBody> {
  final _codeController = TextEditingController();
  bool _wrongCode = false;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  /// La comprobación es local a propósito: el código no protege nada (sólo
  /// datos ficticios), así que no hay que llevarlo a ningún caso de uso.
  void _submit() {
    if (_codeController.text.trim() == DemoSession.accessCode) {
      Navigator.of(context).pop(true);
      return;
    }
    setState(() => _wrongCode = true);
  }

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final bodyStyle = AppTypography.bodyRegular.copyWith(color: AppColors.textPrimary);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.space16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.demoConfirmBody, style: bodyStyle),
          if (widget.hasPersistedSession) ...[
            const SizedBox(height: AppDimensions.space16),
            Text(l10n.demoConfirmPersistedSessionBody, style: bodyStyle),
          ],
          const SizedBox(height: AppDimensions.space24),
          AppInputCase(
            label: l10n.demoConfirmCodeLabel,
            controller: _codeController,
            obscureText: true,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            autocorrect: false,
            enableSuggestions: false,
            state: _wrongCode ? AppInputState.error : AppInputState.defaultState,
            errorText: _wrongCode ? l10n.demoConfirmCodeError : null,
            onChanged: (final _) {
              if (_wrongCode) {
                setState(() => _wrongCode = false);
              }
            },
            onSubmitted: (final _) => _submit(),
          ),
          const SizedBox(height: AppDimensions.space24),
          AppButton(
            label: widget.hasPersistedSession ? l10n.demoConfirmCloseSessionAndEnter : l10n.demoConfirmEnter,
            icon: const Icon(Icons.visibility_outlined, size: AppDimensions.iconMedium),
            isExpanded: true,
            onPressed: _submit,
          ),
          const SizedBox(height: AppDimensions.space8),
          AppButton(
            label: l10n.demoConfirmBack,
            hierarchy: AppButtonHierarchy.ghost,
            isExpanded: true,
            onPressed: () => Navigator.of(context).pop(false),
          ),
          const SizedBox(height: AppDimensions.space8),
        ],
      ),
    );
  }
}
