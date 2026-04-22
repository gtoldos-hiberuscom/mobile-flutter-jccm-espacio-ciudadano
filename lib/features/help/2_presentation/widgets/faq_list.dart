/// FAQ list widget with live search filtering and accordion expansion.
library;

import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/app/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/app/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/features/help/0_entity/faq_item.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Renders a searchable list of [FaqItem] entries as expandable accordion tiles.
///
/// The search field filters items case-insensitively against the question text.
/// When no items match, an [_EmptySearchState] is shown instead of the list.
class FaqList extends StatefulWidget {
  const FaqList({required this.faqs, super.key});

  /// Full list of FAQ entries to display (unfiltered).
  final List<FaqItem> faqs;

  @override
  State<FaqList> createState() => _FaqListState();
}

class _FaqListState extends State<FaqList> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() => _query = _searchController.text.toLowerCase());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<FaqItem> get _filtered => widget.faqs
      .where((final item) => item.question.toLowerCase().contains(_query))
      .toList();

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final filtered = _filtered;

    return Column(
      children: [
        // ── Search field ───────────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.all(AppDimensions.space16),
          child: Semantics(
            label: l10n.helpFaqSearch,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: l10n.helpFaqSearch,
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: AppColors.surfaceVariant,
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusLarge),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.space16,
                  vertical: AppDimensions.space12,
                ),
              ),
            ),
          ),
        ),
        // ── List or empty state ────────────────────────────────────────────
        if (filtered.isEmpty)
          _EmptySearchState(query: _query)
        else
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: AppDimensions.space32),
              itemCount: filtered.length,
              itemBuilder: (final context, final index) {
                final item = filtered[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.space16,
                    vertical: AppDimensions.space4,
                  ),
                  child: Card(
                    elevation: 0,
                    color: AppColors.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radiusMedium),
                      side: const BorderSide(color: AppColors.divider),
                    ),
                    child: ExpansionTile(
                      tilePadding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.space16,
                        vertical: AppDimensions.space4,
                      ),
                      title: Text(
                        item.question,
                        style: textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(
                            AppDimensions.space16,
                            0,
                            AppDimensions.space16,
                            AppDimensions.space16,
                          ),
                          child: Text(
                            item.answer,
                            style: textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondary,
                              height: 1.6,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}

// ── Private empty state ──────────────────────────────────────────────────────

class _EmptySearchState extends StatelessWidget {
  const _EmptySearchState({required this.query});

  final String query;

  @override
  Widget build(final BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Expanded(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.space32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.search_off_rounded,
                size: AppDimensions.iconLarge * 2,
                color: AppColors.disabled,
              ),
              const SizedBox(height: AppDimensions.space16),
              Text(
                query.isEmpty
                    ? 'No hay preguntas disponibles'
                    : 'No se encontraron resultados para "$query"',
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.disabled,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
