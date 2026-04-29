/// Carnet Joven (EPIC-7 / STORY-50) — modal variant.
///
/// Bottom-sheet surface used from the digital cards catalogue (STORY-48
/// tapping a `DigitalCardType.joven` tile). It watches the same
/// `jovenDetailNotifierProvider` as `JovenDetailPage` so both surfaces
/// stay in sync — refreshing one updates the other.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/app/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/joven/2_presentation/joven_detail_body.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Draggable bottom-sheet variant of the Carnet Joven detail.
///
/// Use [JovenDetailModal.show] to display it. The widget itself is
/// exported so it remains testable with `tester.pumpWidget`.
class JovenDetailModal extends ConsumerWidget {
  const JovenDetailModal({super.key});

  /// Shows the modal as a draggable, scrollable bottom sheet.
  ///
  /// Returns the bottom-sheet route (resolves when the sheet is
  /// dismissed) so callers can `await` if they need to react to the
  /// closure.
  static Future<void> show(final BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: false, // we render our own with semantics.
      builder: (final BuildContext sheetContext) => const JovenDetailModal(),
    );
  }

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return DraggableScrollableSheet(
      key: const ValueKey('jovenDetailModalSheet'),
      initialChildSize: 0.85,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      expand: false,
      builder: (final BuildContext sheetContext, final ScrollController scrollController) {
        return Material(
          color: theme.colorScheme.surface,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(AppDimensions.space16)),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _ModalHeader(l10n: l10n),
                const JovenDetailBody(),
                const SizedBox(height: AppDimensions.space16),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Drag handle + title + close action — the modal-only chrome.
class _ModalHeader extends StatelessWidget {
  const _ModalHeader({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.space16,
        AppDimensions.space8,
        AppDimensions.space8,
        AppDimensions.space8,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Semantics(
            label: l10n.jovenModalDragHandleSemantic,
            container: true,
            child: Center(
              child: Container(
                key: const ValueKey('jovenDetailModalDragHandle'),
                width: AppDimensions.space32,
                height: AppDimensions.space4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(AppDimensions.space4),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.space8),
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  l10n.jovenDetailTitle,
                  style: theme.textTheme.titleMedium,
                ),
              ),
              IconButton(
                key: const ValueKey('jovenDetailModalCloseButton'),
                tooltip: l10n.jovenModalCloseAction,
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).maybePop(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
