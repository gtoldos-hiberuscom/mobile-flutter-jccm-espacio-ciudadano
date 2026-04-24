import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/app/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Mock antibot widget for the support-form MVP (STORY-60).
///
/// Renders a clearly-labelled "I am not a robot" checkbox and an explicit
/// "MOCK" badge so QA / code review can't mistake it for a real captcha.
///
// TODO(TASK-63): replace by a real captcha SDK (e.g. hCaptcha,
/// reCAPTCHA Enterprise) behind a feature flag. The contract toward the
/// notifier (`updateCaptcha(bool)`) stays the same.
class CaptchaPlaceholder extends StatelessWidget {
  const CaptchaPlaceholder({
    required this.value,
    required this.onChanged,
    this.errorText,
    super.key,
  });

  final bool value;
  final ValueChanged<bool> onChanged;
  final String? errorText;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final borderColor = errorText != null ? theme.colorScheme.error : theme.colorScheme.outline;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: borderColor),
            borderRadius: BorderRadius.circular(AppDimensions.space8),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.space12,
            vertical: AppDimensions.space8,
          ),
          child: Row(
            children: [
              Checkbox(
                key: const Key('support_captcha_checkbox'),
                value: value,
                onChanged: (final v) => onChanged(v ?? false),
              ),
              Expanded(child: Text(l10n.supportCaptchaLabel)),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.space8,
                  vertical: AppDimensions.space4,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(AppDimensions.space4),
                ),
                child: Text(
                  l10n.supportCaptchaMockBadge,
                  style: theme.textTheme.labelSmall,
                ),
              ),
            ],
          ),
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(
              top: AppDimensions.space4,
              left: AppDimensions.space12,
            ),
            child: Text(
              errorText!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ),
      ],
    );
  }
}
