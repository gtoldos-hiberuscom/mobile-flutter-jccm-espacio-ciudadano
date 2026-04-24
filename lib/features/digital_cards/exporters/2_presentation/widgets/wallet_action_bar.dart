/// Digital cards exporters (EPIC-7 / STORY-52) — presentation.
library;

import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/app/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/exporters/0_entity/binary_artifact_kind.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/exporters/0_entity/wallet_capability.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Action surfaced by [WalletActionBar] — distinct from the underlying
/// [WalletCapability] so the UI can label the affordances per kind
/// (e.g. "Abrir PDF" vs "Compartir QR").
enum WalletActionBarAction { openExternal, share, addToWallet }

/// Row of action buttons (Open / Share / Add-to-Wallet) gated by the
/// available capabilities + by the artifact kind.
///
/// The widget is purely presentational — it does not own state, run
/// side effects or read providers. The owning page wires each callback
/// to `WalletActionController.persistAndAct(...)` and surfaces results
/// via SnackBar (no `BuildContext` ever leaks into the domain layer).
class WalletActionBar extends StatelessWidget {
  const WalletActionBar({
    required this.kind,
    required this.capabilities,
    required this.onAction,
    this.isLoading = false,
    this.disabledReason,
    super.key,
  });

  /// Kind of artifact rendered next to the action bar.
  final BinaryArtifactKind kind;

  /// Capabilities supported by the runtime; missing capabilities hide
  /// the corresponding button.
  final Set<WalletCapability> capabilities;

  /// Invoked with the action selected by the user. The owning page is
  /// responsible for translating it into a wallet-controller call.
  final ValueChanged<WalletActionBarAction> onAction;

  /// When `true`, all buttons render as disabled and a progress
  /// indicator replaces the leading icon. Used while the controller's
  /// `persistAndAct` future is in flight.
  final bool isLoading;

  /// Optional localised reason rendered below the bar when validation
  /// failed. When `null` the bar is fully enabled.
  final String? disabledReason;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final disabled = isLoading || disabledReason != null;
    final children = <Widget>[];

    if (kind != BinaryArtifactKind.pkpass &&
        capabilities.contains(WalletCapability.openExternal)) {
      children.add(
        _BarButton(
          key: const ValueKey('walletActionBar.open'),
          icon: Icons.open_in_new,
          label: l10n.walletActionOpen,
          loading: isLoading,
          onPressed: disabled
              ? null
              : () => onAction(WalletActionBarAction.openExternal),
        ),
      );
    }

    if (capabilities.contains(WalletCapability.shareFallback) ||
        capabilities.contains(WalletCapability.googleWallet)) {
      children.add(
        _BarButton(
          key: const ValueKey('walletActionBar.share'),
          icon: Icons.share,
          label: l10n.walletActionShare,
          loading: isLoading,
          onPressed: disabled
              ? null
              : () => onAction(WalletActionBarAction.share),
        ),
      );
    }

    if (kind == BinaryArtifactKind.pkpass &&
        capabilities.contains(WalletCapability.appleWallet)) {
      children.add(
        _BarButton(
          key: const ValueKey('walletActionBar.addToWallet'),
          icon: Icons.account_balance_wallet,
          label: l10n.walletActionAddToWallet,
          loading: isLoading,
          onPressed: disabled
              ? null
              : () => onAction(WalletActionBarAction.addToWallet),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Wrap(
          spacing: AppDimensions.space8,
          runSpacing: AppDimensions.space8,
          children: children,
        ),
        if (disabledReason != null) ...<Widget>[
          const SizedBox(height: AppDimensions.space8),
          Text(
            disabledReason!,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.error,
            ),
          ),
        ],
      ],
    );
  }
}

class _BarButton extends StatelessWidget {
  const _BarButton({
    required this.icon,
    required this.label,
    required this.loading,
    required this.onPressed,
    super.key,
  });

  final IconData icon;
  final String label;
  final bool loading;
  final VoidCallback? onPressed;

  @override
  Widget build(final BuildContext context) => OutlinedButton.icon(
    onPressed: onPressed,
    icon: loading
        ? const SizedBox(
            width: AppDimensions.iconSmall,
            height: AppDimensions.iconSmall,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        : Icon(icon, size: AppDimensions.iconSmall),
    label: Text(label),
  );
}
