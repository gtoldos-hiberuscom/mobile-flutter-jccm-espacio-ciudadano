/// Familia numerosa carnet (EPIC-7 / STORY-49) — presentation.
///
/// Per-card detail page. Reuses [WalletActionBar] +
/// [WalletActionController] from the shared exporters package; never
/// duplicates persist/share/open logic.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/app/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/core/ui_states/error_state_widget.dart';
import 'package:jccm_espacio_ciudadano/core/ui_states/loading_state_widget.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/0_entity/digital_card.dart' show DigitalCardStatus;
import 'package:jccm_espacio_ciudadano/features/digital_cards/exporters/0_entity/binary_artifact.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/exporters/0_entity/binary_artifact_kind.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/exporters/0_entity/wallet_capability.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/exporters/1_domain/wallet_action_controller.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/exporters/1_domain/wallet_action_result.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/exporters/2_presentation/widgets/wallet_action_bar.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/familia_numerosa/0_entity/familia_numerosa_card.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/familia_numerosa/0_entity/familia_numerosa_member.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/familia_numerosa/1_domain/familia_numerosa_detail_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/familia_numerosa/1_domain/familia_numerosa_repository.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/familia_numerosa/2_presentation/widgets/familia_numerosa_categoria_badge.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/familia_numerosa/2_presentation/widgets/familia_numerosa_member_tile.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/familia_numerosa/3_data/familia_numerosa_repository_provider.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Static seed used by `WalletActionController` to derive the
/// deterministic file-name short-hash. The DNI itself is not yet
/// available at this layer — once the auth/profile feature exposes it
/// (TASK-53 follow-up) this constant must be replaced by the hashed
/// citizen DNI.
const String _kFileNameDniSeed = 'familia-numerosa-mock';

/// Capabilities advertised to the [WalletActionController] for the
/// three carnet exports. The controller selects the appropriate branch
/// (Apple Wallet / open-external / share fallback) based on the
/// runtime platform and artifact kind.
const Set<WalletCapability> _kAllCapabilities = <WalletCapability>{
  WalletCapability.openExternal,
  WalletCapability.shareFallback,
  WalletCapability.appleWallet,
};

class FamiliaNumerosaDetailPage extends ConsumerWidget {
  const FamiliaNumerosaDetailPage({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final asyncCard = ref.watch(familiaNumerosaDetailNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.familiaNumerosaDetailTitle)),
      body: asyncCard.when(
        loading: () => const LoadingStateWidget(),
        error: (final error, final _) {
          if (error is FamiliaNumerosaUnavailable) {
            return _UnavailableBody(l10n: l10n);
          }
          return ErrorStateWidget(
            message: l10n.familiaNumerosaErrorMessage,
            retryLabel: l10n.familiaNumerosaRetry,
            onRetry: () => ref.read(familiaNumerosaDetailNotifierProvider.notifier).refresh(),
          );
        },
        data: (final card) => _DetailBody(card: card),
      ),
    );
  }
}

class _UnavailableBody extends StatelessWidget {
  const _UnavailableBody({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      key: const ValueKey('familiaNumerosaUnavailableBody'),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.space32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(Icons.info_outline, size: AppDimensions.iconLarge, color: theme.colorScheme.onSurfaceVariant),
            const SizedBox(height: AppDimensions.space16),
            Text(
              l10n.familiaNumerosaUnavailableTitle,
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.space8),
            Text(
              l10n.familiaNumerosaUnavailableMessage,
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailBody extends ConsumerWidget {
  const _DetailBody({required this.card});

  final FamiliaNumerosaCard card;

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final materialL10n = MaterialLocalizations.of(context);
    final expiryLabel = card.expiryDate == null
        ? null
        : l10n.familiaNumerosaExpiresOn(materialL10n.formatCompactDate(card.expiryDate!));

    return ListView(
      key: const ValueKey('familiaNumerosaDetailBody'),
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.space8),
      children: <Widget>[
        // Hero header.
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.space16,
            vertical: AppDimensions.space8,
          ),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.space16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          card.holderName,
                          style: theme.textTheme.titleLarge,
                        ),
                      ),
                      FamiliaNumerosaCategoriaBadge(categoria: card.categoria),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.space4),
                  Text(
                    l10n.familiaNumerosaCardNumberLabel(card.cardNumber),
                    style: theme.textTheme.bodyMedium,
                  ),
                  if (expiryLabel != null) ...<Widget>[
                    const SizedBox(height: AppDimensions.space4),
                    Text(
                      expiryLabel,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),

        // Members section.
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppDimensions.space16,
            AppDimensions.space16,
            AppDimensions.space16,
            AppDimensions.space4,
          ),
          child: Text(
            l10n.familiaNumerosaMembersTitle,
            style: theme.textTheme.titleMedium,
          ),
        ),
        for (final FamiliaNumerosaMember member in card.members)
          FamiliaNumerosaMemberTile(
            key: ValueKey('familiaNumerosaMember-${member.dni ?? member.name}'),
            member: member,
          ),

        // Actions — only when the carnet is vigente.
        if (card.status == DigitalCardStatus.available)
          const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppDimensions.space16,
              vertical: AppDimensions.space16,
            ),
            child: _FormatActionsSection(),
          )
        else
          Padding(
            padding: const EdgeInsets.all(AppDimensions.space16),
            child: Text(
              l10n.familiaNumerosaUnavailableMessage,
              style: theme.textTheme.bodyMedium,
            ),
          ),
      ],
    );
  }
}

/// Renders one action bar per format (QR, PDF, PKPass) and bridges
/// each user gesture to `WalletActionController.persistAndAct(...)`.
class _FormatActionsSection extends ConsumerStatefulWidget {
  const _FormatActionsSection();

  @override
  ConsumerState<_FormatActionsSection> createState() => _FormatActionsSectionState();
}

class _FormatActionsSectionState extends ConsumerState<_FormatActionsSection> {
  /// Format currently being processed by `persistAndAct` — used to gate
  /// the spinner state on the matching action bar.
  BinaryArtifactKind? _inFlight;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _formatRow(
          context: context,
          theme: theme,
          label: l10n.digitalCardsActionQr,
          icon: Icons.qr_code_2,
          kind: BinaryArtifactKind.qrText,
          keyPrefix: 'qr',
        ),
        const SizedBox(height: AppDimensions.space16),
        _formatRow(
          context: context,
          theme: theme,
          label: l10n.digitalCardsActionPdf,
          icon: Icons.picture_as_pdf_outlined,
          kind: BinaryArtifactKind.pdf,
          keyPrefix: 'pdf',
        ),
        const SizedBox(height: AppDimensions.space16),
        _formatRow(
          context: context,
          theme: theme,
          label: l10n.digitalCardsActionPkpass,
          icon: Icons.account_balance_wallet_outlined,
          kind: BinaryArtifactKind.pkpass,
          keyPrefix: 'pkpass',
        ),
      ],
    );
  }

  Widget _formatRow({
    required final BuildContext context,
    required final ThemeData theme,
    required final String label,
    required final IconData icon,
    required final BinaryArtifactKind kind,
    required final String keyPrefix,
  }) {
    final isLoading = _inFlight == kind;
    return Column(
      key: ValueKey('familiaNumerosaFormat-$keyPrefix'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Icon(icon, size: AppDimensions.iconSmall),
            const SizedBox(width: AppDimensions.space8),
            Text(label, style: theme.textTheme.titleSmall),
          ],
        ),
        const SizedBox(height: AppDimensions.space8),
        WalletActionBar(
          key: ValueKey('familiaNumerosaActionBar-$keyPrefix'),
          kind: kind,
          capabilities: _kAllCapabilities,
          isLoading: isLoading,
          onAction: (final _) => _runAction(kind),
        ),
      ],
    );
  }

  Future<void> _runAction(final BinaryArtifactKind kind) async {
    if (_inFlight != null) {
      return;
    }
    setState(() => _inFlight = kind);
    final messenger = ScaffoldMessenger.of(context);
    final l10n = AppLocalizations.of(context);
    try {
      final repo = ref.read(familiaNumerosaRepositoryProvider);
      final BinaryArtifact artifact = switch (kind) {
        BinaryArtifactKind.qrText => await repo.requestQr(),
        BinaryArtifactKind.pdf => await repo.requestPdf(),
        BinaryArtifactKind.pkpass => await repo.requestPkpass(),
        BinaryArtifactKind.png => await repo.requestQr(), // unreachable in current spec
      };
      final WalletActionResult result = await ref.read(walletActionControllerProvider.notifier).persistAndAct(
        artifact: artifact,
        dniHashSeed: _kFileNameDniSeed,
        requested: _kAllCapabilities,
      );
      if (!mounted) {
        return;
      }
      if (!result.success) {
        messenger.showSnackBar(
          SnackBar(content: Text(l10n.familiaNumerosaErrorMessage)),
        );
      }
    } on Object {
      if (!mounted) {
        return;
      }
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.familiaNumerosaErrorMessage)),
      );
    } finally {
      if (mounted) {
        setState(() => _inFlight = null);
      }
    }
  }
}
