import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/app/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/core/ui_states/empty_state_widget.dart';
import 'package:jccm_espacio_ciudadano/core/ui_states/error_state_widget.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/0_entity/digital_cards_catalog.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/1_domain/digital_cards_catalog_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/2_presentation/widgets/cip_read_only_mini_card.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/2_presentation/widgets/digital_card_tile.dart';
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
      body: asyncCatalog.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (final _, final stackTrace) => ErrorStateWidget(
          message: l10n.digitalCardsErrorMessage,
          onRetry: () => ref.read(digitalCardsCatalogProvider.notifier).refresh(),
        ),
        data: (final DigitalCardsCatalog catalog) => _CatalogBody(
          catalog: catalog,
          onAction: (final cardId, final action) => _showStubActionSnackbar(context, l10n),
        ),
      ),
    );
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
  const _CatalogBody({required this.catalog, required this.onAction});

  final DigitalCardsCatalog catalog;
  final void Function(String cardId, DigitalCardAction action) onAction;

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
          ),
    ];

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.space8),
      children: children,
    );
  }
}
