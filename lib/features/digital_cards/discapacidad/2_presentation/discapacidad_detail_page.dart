/// Carnet Discapacidad (EPIC-7 / STORY-51) — full-page presentation.
///
/// Per-card detail page reachable via `Routes.cardDiscapacidadDetail`.
/// Unlike the carnet joven, the discapacidad surface only ships PKPass
/// (no QR/PDF endpoints) and must surface three explicit branches:
/// vigente, no vigente / no disponible, parse-error.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/app/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/core/connectivity/offline_banner.dart';
import 'package:jccm_espacio_ciudadano/core/ui_states/error_state_widget.dart';
import 'package:jccm_espacio_ciudadano/core/ui_states/loading_state_widget.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/0_entity/digital_card.dart' show DigitalCardStatus;
import 'package:jccm_espacio_ciudadano/features/digital_cards/discapacidad/0_entity/discapacidad_card.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/discapacidad/1_domain/discapacidad_detail_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/discapacidad/1_domain/discapacidad_repository.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/discapacidad/2_presentation/discapacidad_grado_badge.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/discapacidad/3_data/discapacidad_repository_provider.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/exporters/0_entity/binary_artifact.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/exporters/0_entity/binary_artifact_kind.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/exporters/0_entity/wallet_capability.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/exporters/1_domain/wallet_action_controller.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/exporters/1_domain/wallet_action_result.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/exporters/2_presentation/widgets/wallet_action_bar.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Static seed used by `WalletActionController` to derive the
/// deterministic file-name short-hash. Replace with the hashed citizen
/// DNI once TASK-53 follow-up exposes it at this layer.
const String _kFileNameDniSeed = 'discapacidad-mock';

/// Capabilities advertised for the carnet de discapacidad PKPass
/// pipeline. `appleWallet` triggers the PassKit branch on iOS;
/// `shareFallback` keeps a sensible affordance on Android while
/// Google Wallet is not yet wired (see TASK-53).
const Set<WalletCapability> _kPkpassCapabilities = <WalletCapability>{
  WalletCapability.appleWallet,
  WalletCapability.shareFallback,
};

class DiscapacidadDetailPage extends ConsumerWidget {
  const DiscapacidadDetailPage({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final asyncCard = ref.watch(discapacidadDetailNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.discapacidadDetailTitle)),
      body: OfflineBanner(
        child: asyncCard.when(
          loading: () => const LoadingStateWidget(),
          error: (final error, final _) {
            if (error is DiscapacidadUnavailable) {
              return _UnavailableBody(l10n: l10n);
            }
            return ErrorStateWidget(
              key: const ValueKey('discapacidadErrorBody'),
              message: l10n.discapacidadParseErrorMessage,
              retryLabel: l10n.discapacidadRetry,
              onRetry: () => ref.read(discapacidadDetailNotifierProvider.notifier).refresh(),
            );
          },
          data: (final card) => _DetailBody(card: card),
        ),
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
      key: const ValueKey('discapacidadUnavailableBody'),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.space32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(Icons.info_outline, size: AppDimensions.iconLarge, color: theme.colorScheme.onSurfaceVariant),
            const SizedBox(height: AppDimensions.space16),
            Text(
              l10n.discapacidadUnavailableTitle,
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.space8),
            Text(
              l10n.discapacidadUnavailableMessage,
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _NotValidBody extends StatelessWidget {
  const _NotValidBody({required this.card, required this.l10n});

  final DiscapacidadCard card;
  final AppLocalizations l10n;

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      key: const ValueKey('discapacidadNotValidBody'),
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.space8),
      children: <Widget>[
        _HeroHeader(card: card),
        Padding(
          padding: const EdgeInsets.all(AppDimensions.space16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(Icons.warning_amber_outlined, color: theme.colorScheme.error),
                  const SizedBox(width: AppDimensions.space8),
                  Expanded(
                    child: Text(
                      l10n.discapacidadNotValidTitle,
                      style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.error),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.space8),
              Text(
                l10n.discapacidadNotValidMessage,
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _NoDataBody extends StatelessWidget {
  const _NoDataBody({required this.card, required this.l10n});

  final DiscapacidadCard card;
  final AppLocalizations l10n;

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      key: const ValueKey('discapacidadNoDataBody'),
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.space8),
      children: <Widget>[
        _HeroHeader(card: card),
        Padding(
          padding: const EdgeInsets.all(AppDimensions.space16),
          child: Text(
            l10n.discapacidadUnavailableMessage,
            style: theme.textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}

class _DetailBody extends ConsumerWidget {
  const _DetailBody({required this.card});

  final DiscapacidadCard card;

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    switch (card.status) {
      case DigitalCardStatus.notValid:
        return _NotValidBody(card: card, l10n: l10n);
      case DigitalCardStatus.notAvailable:
      case DigitalCardStatus.notDownloadable:
        return _NoDataBody(card: card, l10n: l10n);
      case DigitalCardStatus.available:
        return _AvailableBody(card: card);
    }
  }
}

class _AvailableBody extends ConsumerStatefulWidget {
  const _AvailableBody({required this.card});

  final DiscapacidadCard card;

  @override
  ConsumerState<_AvailableBody> createState() => _AvailableBodyState();
}

class _AvailableBodyState extends ConsumerState<_AvailableBody> {
  bool _inFlight = false;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return ListView(
      key: const ValueKey('discapacidadAvailableBody'),
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.space8),
      children: <Widget>[
        _HeroHeader(card: widget.card),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.space16,
            vertical: AppDimensions.space16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  const Icon(Icons.account_balance_wallet_outlined, size: AppDimensions.iconSmall),
                  const SizedBox(width: AppDimensions.space8),
                  Text(l10n.discapacidadActionPkpass, style: theme.textTheme.titleSmall),
                ],
              ),
              const SizedBox(height: AppDimensions.space8),
              WalletActionBar(
                key: const ValueKey('discapacidadActionBar-pkpass'),
                kind: BinaryArtifactKind.pkpass,
                capabilities: _kPkpassCapabilities,
                isLoading: _inFlight,
                onAction: (final _) => _runPkpassAction(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _runPkpassAction() async {
    if (_inFlight) {
      return;
    }
    setState(() => _inFlight = true);
    final messenger = ScaffoldMessenger.of(context);
    final l10n = AppLocalizations.of(context);
    try {
      final BinaryArtifact artifact = await ref.read(discapacidadRepositoryProvider).requestPkpass();
      final WalletActionResult result = await ref
          .read(walletActionControllerProvider.notifier)
          .persistAndAct(
            artifact: artifact,
            dniHashSeed: _kFileNameDniSeed,
            requested: _kPkpassCapabilities,
          );
      if (!mounted) {
        return;
      }
      if (!result.success) {
        messenger.showSnackBar(
          SnackBar(content: Text(l10n.discapacidadErrorMessage)),
        );
      }
    } on Object {
      if (!mounted) {
        return;
      }
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.discapacidadErrorMessage)),
      );
    } finally {
      if (mounted) {
        setState(() => _inFlight = false);
      }
    }
  }
}

/// Hero header reused by the three branches: holder name, expiry row
/// (when present) and the grado badge (or the "no disponible"
/// fallback).
class _HeroHeader extends StatelessWidget {
  const _HeroHeader({required this.card});

  final DiscapacidadCard card;

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final materialL10n = MaterialLocalizations.of(context);

    final expiryLabel = card.expiryDate == null ? null : l10n.discapacidadExpiresOn(materialL10n.formatCompactDate(card.expiryDate!));

    return Padding(
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
              Text(
                card.holderName ?? l10n.discapacidadDetailTitle,
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: AppDimensions.space8),
              DiscapacidadGradoBadge(
                grado: card.grado,
                rawLabel: card.gradoLabel,
              ),
              if (expiryLabel != null) ...<Widget>[
                const SizedBox(height: AppDimensions.space8),
                Text(expiryLabel, style: theme.textTheme.bodyMedium),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
