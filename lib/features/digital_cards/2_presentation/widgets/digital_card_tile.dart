import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/app/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/0_entity/digital_card.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Single tile in the digital cards catalogue.
///
/// Renders the localised card title, the citizen status badge, and the
/// QR / PKPASS / PDF actions. Per the AC, actions are only enabled when
/// the card status is [DigitalCardStatus.available]; otherwise they are
/// disabled and an explicit per-status message is rendered.
///
/// Sprint 4 ships the actions as stub CTAs (snackbar). Live wiring is
/// owned by TASK-53.
class DigitalCardTile extends StatelessWidget {
  const DigitalCardTile({
    required this.card,
    required this.onAction,
    super.key,
  });

  final DigitalCard card;

  /// Invoked when the citizen taps QR/PKPASS/PDF on an available card.
  /// The tile only invokes this callback when [DigitalCard.actionsEnabled]
  /// is true; the page is responsible for the snackbar / disabled message.
  final void Function(DigitalCardAction action) onAction;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final title = _titleFor(l10n, card.type);
    final statusLabel = _statusLabelFor(l10n, card.status);
    final statusMessage = _statusMessageFor(l10n, card.status);
    final enabled = card.actionsEnabled;

    return Card(
      key: ValueKey('digitalCardsTile-${card.id}'),
      margin: const EdgeInsets.symmetric(
        horizontal: AppDimensions.space16,
        vertical: AppDimensions.space8,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.space16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                _StatusBadge(label: statusLabel, status: card.status),
              ],
            ),
            if (card.holderName != null) ...<Widget>[
              const SizedBox(height: AppDimensions.space4),
              Text(
                card.holderName!,
                style: theme.textTheme.bodyMedium,
              ),
            ],
            if (statusMessage != null) ...<Widget>[
              const SizedBox(height: AppDimensions.space4),
              Text(
                statusMessage,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
            const SizedBox(height: AppDimensions.space8),
            Wrap(
              spacing: AppDimensions.space8,
              children: <Widget>[
                _ActionButton(
                  key: ValueKey('digitalCardsAction-qr-${card.id}'),
                  icon: Icons.qr_code_2,
                  label: l10n.digitalCardsActionQr,
                  enabled: enabled,
                  onPressed: () => onAction(DigitalCardAction.qr),
                ),
                _ActionButton(
                  key: ValueKey('digitalCardsAction-pkpass-${card.id}'),
                  icon: Icons.account_balance_wallet_outlined,
                  label: l10n.digitalCardsActionPkpass,
                  enabled: enabled,
                  onPressed: () => onAction(DigitalCardAction.pkpass),
                ),
                _ActionButton(
                  key: ValueKey('digitalCardsAction-pdf-${card.id}'),
                  icon: Icons.picture_as_pdf_outlined,
                  label: l10n.digitalCardsActionPdf,
                  enabled: enabled,
                  onPressed: () => onAction(DigitalCardAction.pdf),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static String _titleFor(
    final AppLocalizations l10n,
    final DigitalCardType type,
  ) {
    switch (type) {
      case DigitalCardType.familiaNumerosa:
        return l10n.digitalCardsTypeFamiliaNumerosa;
      case DigitalCardType.joven:
        return l10n.digitalCardsTypeJoven;
      case DigitalCardType.discapacidad:
        return l10n.digitalCardsTypeDiscapacidad;
    }
  }

  static String _statusLabelFor(
    final AppLocalizations l10n,
    final DigitalCardStatus status,
  ) {
    switch (status) {
      case DigitalCardStatus.available:
        return l10n.digitalCardsStatusAvailable;
      case DigitalCardStatus.notValid:
        return l10n.digitalCardsStatusNotValid;
      case DigitalCardStatus.notDownloadable:
        return l10n.digitalCardsStatusNotDownloadable;
      case DigitalCardStatus.notAvailable:
        return l10n.digitalCardsStatusNotAvailable;
    }
  }

  static String? _statusMessageFor(
    final AppLocalizations l10n,
    final DigitalCardStatus status,
  ) {
    switch (status) {
      case DigitalCardStatus.available:
        return null;
      case DigitalCardStatus.notValid:
        return l10n.digitalCardsMessageNotValid;
      case DigitalCardStatus.notDownloadable:
        return l10n.digitalCardsMessageNotDownloadable;
      case DigitalCardStatus.notAvailable:
        return l10n.digitalCardsMessageNotAvailable;
    }
  }
}

/// Per-tile actions surfaced for the cards catalogue.
enum DigitalCardAction { qr, pkpass, pdf }

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.label, required this.status});

  final String label;
  final DigitalCardStatus status;

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final Color background;
    final Color foreground;
    switch (status) {
      case DigitalCardStatus.available:
        background = scheme.primaryContainer;
        foreground = scheme.onPrimaryContainer;
      case DigitalCardStatus.notValid:
        background = scheme.errorContainer;
        foreground = scheme.onErrorContainer;
      case DigitalCardStatus.notDownloadable:
      case DigitalCardStatus.notAvailable:
        background = scheme.surfaceContainerHighest;
        foreground = scheme.onSurfaceVariant;
    }
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.space8,
        vertical: AppDimensions.space4,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(color: foreground),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.enabled,
    required this.onPressed,
    super.key,
  });

  final IconData icon;
  final String label;
  final bool enabled;
  final VoidCallback onPressed;

  @override
  Widget build(final BuildContext context) => OutlinedButton.icon(
    onPressed: enabled ? onPressed : null,
    icon: Icon(icon, size: 18),
    label: Text(label),
  );
}
