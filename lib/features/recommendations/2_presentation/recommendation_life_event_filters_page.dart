import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/2_presentation/providers/recommendations_provider.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

final class RecommendationLifeEventFiltersArgs {
  const RecommendationLifeEventFiltersArgs({
    required this.events,
    required this.selectedIds,
  });

  final List<RecommendationLifeEventOption> events;
  final Set<int> selectedIds;
}

class RecommendationLifeEventFiltersPage extends StatefulWidget {
  const RecommendationLifeEventFiltersPage({
    required this.args,
    super.key,
  });

  final RecommendationLifeEventFiltersArgs args;

  @override
  State<RecommendationLifeEventFiltersPage> createState() => _RecommendationLifeEventFiltersPageState();
}

class _RecommendationLifeEventFiltersPageState extends State<RecommendationLifeEventFiltersPage> {
  late Set<int> _selectedIds;

  bool get _hasSelectionChanges => !setEquals(_selectedIds, widget.args.selectedIds);

  @override
  void initState() {
    super.initState();
    _selectedIds = Set<int>.from(widget.args.selectedIds);
  }

  void _toggle(final int id) {
    setState(() {
      if (!_selectedIds.remove(id)) {
        _selectedIds.add(id);
      }
    });
  }

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColors.backgroundBlueLighter,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.backgroundBlueLighter,
        surfaceTintColor: Colors.transparent,
        elevation: 1,
        shadowColor: const Color(0x1F000000),
        toolbarHeight: 64,
        titleSpacing: 0,
        shape: const Border(
          bottom: BorderSide(color: AppColors.backgroundBlueMutedLight),
        ),
        title: Row(
          children: [
            IconButton(
              icon: const AppIcon(AppIcons.close, size: AppDimensions.iconLarge, color: AppColors.textPrimary),
              onPressed: context.pop,
              tooltip: l10n.a11yClose,
            ),
            const SizedBox(width: AppDimensions.space8),
            Expanded(
              child: Text(
                l10n.recommendationsFilterPageTitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.h3.copyWith(color: AppColors.textPrimary),
              ),
            ),
          ],
        ),
      ),
      body: ListView(
        padding: appPagePadding(context, top: AppDimensions.space24, bottom: AppDimensions.space24),
        children: [
          Text(
            l10n.recommendationsFilterIntro,
            style: AppTypography.smallRegular.copyWith(color: AppColors.textPrimary),
          ),
          const SizedBox(height: AppDimensions.space24),
          for (final event in widget.args.events) ...[
            AppSelectableFilterChip(
              label: event.label,
              isSelected: _selectedIds.contains(event.id),
              onTap: () => _toggle(event.id),
            ),
            const SizedBox(height: AppDimensions.space16),
          ],
        ],
      ),
      bottomNavigationBar: AppFilterActionsBar(
        clearLabel: l10n.lifeEventsClearAllAction,
        onClear: _selectedIds.isEmpty ? null : () => setState(_selectedIds.clear),
        onApply: _hasSelectionChanges ? () => context.pop(Set<int>.from(_selectedIds)) : null,
      ),
    );
  }
}
