import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/app/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/app/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/core/connectivity/offline_banner.dart';
import 'package:jccm_espacio_ciudadano/core/ui_states/empty_state_widget.dart';
import 'package:jccm_espacio_ciudadano/core/ui_states/error_state_widget.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/0_entity/digital_card.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/0_entity/digital_cards_catalog.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/1_domain/digital_cards_catalog_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/2_presentation/widgets/cip_read_only_mini_card.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/2_presentation/widgets/digital_card_tile.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/joven/2_presentation/joven_detail_modal.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Cards catalogue surface (STORY-48).
///
/// Layout (vertical list):
///   1. CIP read-only mini-card at the top (TASK-71 CIP_REUSE).
///   2. One [DigitalCardTile] per federated card (familia numerosa,
///      joven, discapacidad). Per-status copy and disabled actions.
///
/// Loading / empty / error use the shared `core/ui_states/` widgets so
/// the surface is consistent with the rest of the application
/// (canon §15 explicit screen state).
class DigitalCardsCatalogPage extends ConsumerWidget {
  const DigitalCardsCatalogPage({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final asyncCatalog = ref.watch(digitalCardsCatalogProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.digitalCardsPageTitle)),
      body: OfflineBanner(
        child: asyncCatalog.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (final _, final stackTrace) => ErrorStateWidget(
          message: l10n.digitalCardsErrorMessage,
          onRetry: () => ref.read(digitalCardsCatalogProvider.notifier).refresh(),
        ),
        data: (final DigitalCardsCatalog catalog) => _CatalogBody(
          catalog: catalog,
          onAction: (final cardId, final action) => _showStubActionSnackbar(context, l10n),
          onCardTap: (final card) => _handleCardTap(context, card),
        ),
      ),
      ),
    );
  }

  /// Routes the citizen to the per-card detail page when one exists.
  ///
  /// Sprint 5 ships only `DigitalCardType.familiaNumerosa` (STORY-49).
  /// Sibling stories own the missing detail screens — we leave the
  /// fallback snackbar in place so the user always gets feedback.
  static void _handleCardTap(final BuildContext context, final DigitalCard card) {
    switch (card.type) {
      case DigitalCardType.familiaNumerosa:
        context.go(Routes.cardFamiliaNumerosaDetail);
      case DigitalCardType.joven:
        // STORY-50: the catalogue uses the modal variant per AC.
        // The full-page surface at `Routes.cardJovenDetail` is reserved
        // for deep links and future home/menu shortcuts.
        // TODO(future-sprint): wire a home shortcut entry point that
        //   navigates to `Routes.cardJovenDetail` when product asks
        //   for the full-page surface from outside the catalogue.
        unawaited(JovenDetailModal.show(context));
      case DigitalCardType.discapacidad:
        // STORY-51: full-page detail surface (no modal variant — this
        // carnet only ships PKPass when vigente, no QR/PDF). Mirrors
        // the navigation pattern used by STORY-49 (familia numerosa).
        context.go(Routes.cardDiscapacidadDetail);
    }
  }

  static void _showStubActionSnackbar(
    final BuildContext context,
    final AppLocalizations l10n,
  ) {
    // TODO(TASK-53): replace stub snackbar with the real QR/PKPASS/PDF
    //   download flows once the `/carnet-digital/*` payload contracts
    //   are validated.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.digitalCardsActionComingSoon)),
    );
  }
}

class _CatalogBody extends StatelessWidget {
  const _CatalogBody({
    required this.catalog,
    required this.onAction,
    required this.onCardTap,
  });

  final DigitalCardsCatalog catalog;
  final void Function(String cardId, DigitalCardAction action) onAction;
  final void Function(DigitalCard card) onCardTap;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);

    if (catalog.state == DigitalCardsCatalogState.error) {
      return ErrorStateWidget(message: l10n.digitalCardsErrorMessage);
    }

    final children = <Widget>[
      const CipReadOnlyMiniCard(),
      if (catalog.state == DigitalCardsCatalogState.empty || catalog.cards.isEmpty)
        Padding(
          padding: const EdgeInsets.all(AppDimensions.space16),
          child: EmptyStateWidget(message: l10n.digitalCardsEmptyMessage),
        )
      else
        for (final card in catalog.cards)
          DigitalCardTile(
            card: card,
            onAction: (final action) => onAction(card.id, action),
            onCardTap: () => onCardTap(card),
          ),
    ];

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.space8),
      children: children,
    );
  }
}
