import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/app/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/app/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/features/signature/0_entity/certificate_validation.dart';
import 'package:jccm_espacio_ciudadano/features/signature/1_domain/signature_inbox_notifier.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Banner shown above the signature inbox tabs displaying the latest
/// certificate / VEC validation outcome (STORY-45).
class CertificateStatusBanner extends ConsumerWidget {
  const CertificateStatusBanner({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final asyncValidation = ref.watch(certificateValidationProvider);

    return asyncValidation.when(
      loading: () => _BannerShell(
        color: theme.colorScheme.surfaceContainerHighest,
        icon: Icons.hourglass_top_outlined,
        iconColor: theme.colorScheme.outline,
        title: l10n.signatureLoading,
      ),
      error: (final _, final stack) => _BannerShell(
        color: AppColors.error.withValues(alpha: 0.12),
        icon: Icons.error_outline,
        iconColor: AppColors.error,
        title: l10n.signatureCertificateUnknownTitle,
        actionLabel: l10n.signatureCertificateRecheck,
        onAction: () => ref.invalidate(certificateValidationProvider),
      ),
      data: (final validation) => _bannerForValidation(
        context: context,
        l10n: l10n,
        ref: ref,
        validation: validation,
      ),
    );
  }

  Widget _bannerForValidation({
    required final BuildContext context,
    required final AppLocalizations l10n,
    required final WidgetRef ref,
    required final CertificateValidation validation,
  }) {
    final theme = Theme.of(context);
    final state = validation.state;
    final color = _colorFor(theme, state);
    final title = _titleFor(l10n, state);
    final needsRetry = !validation.canSign;
    final subtitle = _subtitleFor(l10n, validation);
    return _BannerShell(
      color: color.withValues(alpha: 0.12),
      icon: _iconFor(state),
      iconColor: color,
      title: title,
      subtitle: subtitle,
      actionLabel: needsRetry ? l10n.signatureCertificateRecheck : null,
      onAction: needsRetry ? () => ref.invalidate(certificateValidationProvider) : null,
    );
  }

  String _titleFor(final AppLocalizations l10n, final CertificateValidationState state) {
    switch (state) {
      case CertificateValidationState.valid:
        return l10n.signatureCertificateValidTitle;
      case CertificateValidationState.missing:
        return l10n.signatureCertificateMissingTitle;
      case CertificateValidationState.expired:
        return l10n.signatureCertificateExpiredTitle;
      case CertificateValidationState.invalid:
        return l10n.signatureCertificateInvalidTitle;
      case CertificateValidationState.vecAvailable:
        return l10n.signatureCertificateVecTitle;
      case CertificateValidationState.unknown:
        return l10n.signatureCertificateUnknownTitle;
    }
  }

  String? _subtitleFor(final AppLocalizations l10n, final CertificateValidation validation) {
    final expiresAt = validation.expiresAt;
    if (expiresAt == null) {
      return validation.message;
    }
    final dd = expiresAt.day.toString().padLeft(2, '0');
    final mm = expiresAt.month.toString().padLeft(2, '0');
    final formatted = '$dd/$mm/${expiresAt.year}';
    return l10n.signatureCertificateExpiresOn(formatted);
  }

  Color _colorFor(final ThemeData theme, final CertificateValidationState state) {
    switch (state) {
      case CertificateValidationState.valid:
        return AppColors.success;
      case CertificateValidationState.vecAvailable:
        return theme.colorScheme.primary;
      case CertificateValidationState.expired:
      case CertificateValidationState.invalid:
        return AppColors.error;
      case CertificateValidationState.missing:
        return AppColors.warning;
      case CertificateValidationState.unknown:
        return theme.colorScheme.outline;
    }
  }

  IconData _iconFor(final CertificateValidationState state) {
    switch (state) {
      case CertificateValidationState.valid:
        return Icons.verified_user_outlined;
      case CertificateValidationState.vecAvailable:
        return Icons.smartphone_outlined;
      case CertificateValidationState.expired:
        return Icons.event_busy_outlined;
      case CertificateValidationState.invalid:
        return Icons.gpp_bad_outlined;
      case CertificateValidationState.missing:
        return Icons.person_off_outlined;
      case CertificateValidationState.unknown:
        return Icons.help_outline;
    }
  }
}

class _BannerShell extends StatelessWidget {
  const _BannerShell({
    required this.color,
    required this.icon,
    required this.iconColor,
    required this.title,
    this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  final Color color;
  final IconData icon;
  final Color iconColor;
  final String title;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(
        AppDimensions.space16,
        AppDimensions.space8,
        AppDimensions.space16,
        AppDimensions.space8,
      ),
      padding: const EdgeInsets.all(AppDimensions.space12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(icon, color: iconColor),
          const SizedBox(width: AppDimensions.space12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (subtitle != null) ...<Widget>[
                  const SizedBox(height: AppDimensions.space4),
                  Text(
                    subtitle!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (onAction != null && actionLabel != null) ...<Widget>[
            const SizedBox(width: AppDimensions.space8),
            TextButton(
              onPressed: onAction,
              child: Text(actionLabel!),
            ),
          ],
        ],
      ),
    );
  }
}
