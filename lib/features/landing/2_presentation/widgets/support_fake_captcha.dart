import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Casilla "No soy un robot" del formulario de soporte público.
///
/// No hay verificación real detrás: es una comprobación de interacción
/// mínima para que el envío anónimo exija un gesto explícito del ciudadano.
/// Al pulsarla muestra un breve estado de comprobación y después queda
/// marcada; la página desactiva el botón de envío hasta que [verified] sea
/// `true`.
class SupportFakeCaptcha extends StatefulWidget {
  const SupportFakeCaptcha({
    required this.verified,
    required this.onVerified,
    super.key,
    this.isError = false,
    this.errorText,
    this.verificationDelay = const Duration(milliseconds: 900),
  });

  final bool verified;
  final VoidCallback onVerified;
  final bool isError;
  final String? errorText;

  /// Tiempo que se muestra el indicador de comprobación antes de marcar la
  /// casilla. Los tests lo bajan a cero.
  final Duration verificationDelay;

  @override
  State<SupportFakeCaptcha> createState() => _SupportFakeCaptchaState();
}

class _SupportFakeCaptchaState extends State<SupportFakeCaptcha> {
  bool _checking = false;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _onTap() {
    if (widget.verified || _checking) {
      return;
    }
    setState(() => _checking = true);
    _timer = Timer(widget.verificationDelay, () {
      if (!mounted) {
        return;
      }
      setState(() => _checking = false);
      widget.onVerified();
    });
  }

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final borderColor = widget.isError ? AppColors.borderError : AppColors.blueMuted500;
    final statusLabel = widget.verified
        ? l10n.supportCaptchaVerifiedSemantics
        : _checking
        ? l10n.supportCaptchaCheckingSemantics
        : l10n.supportCaptchaPendingSemantics;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Semantics(
          container: true,
          button: !widget.verified,
          checked: widget.verified,
          enabled: !widget.verified && !_checking,
          label: '${l10n.supportCaptchaLabel}, $statusLabel${widget.isError && widget.errorText != null ? ', ${widget.errorText}' : ''}',
          validationResult: widget.isError ? SemanticsValidationResult.invalid : SemanticsValidationResult.none,
          onTap: widget.verified || _checking ? null : _onTap,
          child: ExcludeSemantics(
            child: Material(
              color: AppColors.backgroundBlueLighter,
              borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
              child: InkWell(
                onTap: widget.verified || _checking ? null : _onTap,
                borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                child: Container(
                  constraints: const BoxConstraints(minHeight: AppDimensions.space64),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.space16,
                    vertical: AppDimensions.space12,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: borderColor, width: widget.isError ? 2 : 1),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                  ),
                  child: Row(
                    children: [
                      _CaptchaBox(verified: widget.verified, checking: _checking, isError: widget.isError),
                      const SizedBox(width: AppDimensions.space12),
                      Expanded(
                        child: Text(
                          l10n.supportCaptchaLabel,
                          style: AppTypography.leadingMedium.copyWith(color: AppColors.primary),
                        ),
                      ),
                      const SizedBox(width: AppDimensions.space12),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            AppIcons.verified,
                            size: AppDimensions.iconLarge,
                            color: widget.verified ? AppColors.successDark : AppColors.blueMuted700,
                          ),
                          const SizedBox(height: AppDimensions.space2),
                          Text(
                            l10n.supportCaptchaBadge,
                            style: AppTypography.captionRegular.copyWith(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        if (widget.isError && widget.errorText != null) ...[
          const SizedBox(height: AppDimensions.space4),
          ExcludeSemantics(
            child: Text(
              widget.errorText!,
              style: AppTypography.captionRegular.copyWith(color: AppColors.error),
            ),
          ),
        ],
      ],
    );
  }
}

class _CaptchaBox extends StatelessWidget {
  const _CaptchaBox({required this.verified, required this.checking, required this.isError});

  final bool verified;
  final bool checking;
  final bool isError;

  @override
  Widget build(final BuildContext context) {
    const size = AppDimensions.iconLarge;
    if (checking) {
      return const SizedBox(
        width: size,
        height: size,
        child: Padding(
          padding: EdgeInsets.all(AppDimensions.space4),
          child: CircularProgressIndicator(strokeWidth: 2.5, color: AppColors.primary),
        ),
      );
    }
    if (verified) {
      return const Icon(AppIcons.checkCircle, size: size, color: AppColors.successDark);
    }
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        border: Border.all(color: isError ? AppColors.error : AppColors.neutral400, width: 2),
        borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
      ),
    );
  }
}
