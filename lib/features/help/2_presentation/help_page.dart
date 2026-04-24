import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/app/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/app/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/core/ui_states/empty_state_widget.dart';
import 'package:jccm_espacio_ciudadano/features/external_links/0_entity/external_link.dart';
import 'package:jccm_espacio_ciudadano/features/external_links/1_domain/external_links_provider.dart';
import 'package:jccm_espacio_ciudadano/features/external_links/2_presentation/widgets/external_link_button.dart';
import 'package:jccm_espacio_ciudadano/features/help/0_entity/faq_entry.dart';
import 'package:jccm_espacio_ciudadano/features/help/0_entity/help_contact.dart';
import 'package:jccm_espacio_ciudadano/features/help/0_entity/help_guide.dart';
import 'package:jccm_espacio_ciudadano/features/help/1_domain/help_provider.dart';
import 'package:jccm_espacio_ciudadano/features/help/2_presentation/help_localizations.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Help center page (STORY-59).
///
/// Layout:
///   - Header + search bar (local filter only — content is bundled).
///   - FAQ list grouped by category, rendered as `ExpansionTile` items.
///   - "Guías" section — text + optional `ExternalLinkButton`.
///   - "Contacto" section — phone/email/url affordances.
///
/// All copy is resolved through ARB; the entities only carry stable keys.
class HelpPage extends ConsumerStatefulWidget {
  const HelpPage({super.key});

  @override
  ConsumerState<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends ConsumerState<HelpPage> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final content = ref.watch(helpContentProvider);

    final filteredFaqs = _filterFaqs(content.faqs, _query, l10n);
    final grouped = _groupByCategory(filteredFaqs);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.helpPageTitle)),
      body: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.space16,
          vertical: AppDimensions.space16,
        ),
        children: [
          _SearchBar(
            controller: _searchController,
            hint: l10n.helpSearchHint,
            onChanged: (final v) => setState(() => _query = v),
          ),
          const SizedBox(height: AppDimensions.space16),
          _SectionHeader(title: l10n.helpFaqSectionTitle),
          if (grouped.isEmpty)
            EmptyStateWidget(
              icon: Icons.search_off,
              message: l10n.helpEmptySearchMessage,
              subtitle: l10n.helpEmptySearchSubtitle,
            )
          else
            ...grouped.entries.map(
              (final entry) => _FaqCategoryBlock(
                categoryLabel: resolveHelpKey(l10n, entry.key),
                entries: entry.value,
              ),
            ),
          const SizedBox(height: AppDimensions.space24),
          _SectionHeader(title: l10n.helpGuidesSectionTitle),
          ...content.guides.map((final g) => _GuideTile(guide: g)),
          const SizedBox(height: AppDimensions.space24),
          _SectionHeader(title: l10n.helpContactSectionTitle),
          ...content.contacts.map((final c) => _ContactTile(contact: c)),
          const SizedBox(height: AppDimensions.space16),
          Center(
            child: FilledButton.icon(
              key: const Key('help_support_cta'),
              icon: const Icon(Icons.support_agent),
              label: Text(l10n.supportCtaFromHelp),
              onPressed: () => context.go(Routes.supportForm),
            ),
          ),
          const SizedBox(height: AppDimensions.space24),
        ],
      ),
    );
  }

  List<FaqEntry> _filterFaqs(
    final List<FaqEntry> source,
    final String query,
    final AppLocalizations l10n,
  ) {
    if (query.trim().isEmpty) {
      return source;
    }
    final needle = query.trim().toLowerCase();
    return source
        .where((final e) {
          final q = resolveHelpKey(l10n, e.questionKey).toLowerCase();
          final a = resolveHelpKey(l10n, e.answerKey).toLowerCase();
          final c = resolveHelpKey(l10n, e.category).toLowerCase();
          return q.contains(needle) || a.contains(needle) || c.contains(needle);
        })
        .toList(growable: false);
  }

  Map<String, List<FaqEntry>> _groupByCategory(final List<FaqEntry> faqs) {
    final result = <String, List<FaqEntry>>{};
    for (final f in faqs) {
      result.putIfAbsent(f.category, () => <FaqEntry>[]).add(f);
    }
    return result;
  }
}

// ── Sections ─────────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});
  final String title;

  @override
  Widget build(final BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: AppDimensions.space8),
    child: Text(
      title,
      style: Theme.of(context).textTheme.titleLarge,
    ),
  );
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({
    required this.controller,
    required this.hint,
    required this.onChanged,
  });

  final TextEditingController controller;
  final String hint;
  final ValueChanged<String> onChanged;

  @override
  Widget build(final BuildContext context) => TextField(
    controller: controller,
    onChanged: onChanged,
    decoration: InputDecoration(
      prefixIcon: const Icon(Icons.search),
      hintText: hint,
      border: const OutlineInputBorder(),
    ),
  );
}

class _FaqCategoryBlock extends StatelessWidget {
  const _FaqCategoryBlock({
    required this.categoryLabel,
    required this.entries,
  });

  final String categoryLabel;
  final List<FaqEntry> entries;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.space16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppDimensions.space8),
            child: Text(
              categoryLabel,
              style: theme.textTheme.titleMedium,
            ),
          ),
          ...entries.map(
            (final e) => Card(
              margin: const EdgeInsets.symmetric(
                vertical: AppDimensions.space4,
              ),
              child: ExpansionTile(
                title: Text(resolveHelpKey(l10n, e.questionKey)),
                childrenPadding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.space16,
                  vertical: AppDimensions.space8,
                ),
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(resolveHelpKey(l10n, e.answerKey)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GuideTile extends ConsumerWidget {
  const _GuideTile({required this.guide});
  final HelpGuide guide;

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final ExternalLink? link = guide.externalLinkId == null ? null : ref.watch(externalLinkCatalogProvider).findById(guide.externalLinkId!);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: AppDimensions.space4),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.space16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              resolveHelpKey(l10n, guide.titleKey),
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: AppDimensions.space8),
            Text(resolveHelpKey(l10n, guide.bodyKey)),
            if (link != null) ...[
              const SizedBox(height: AppDimensions.space12),
              Align(
                alignment: Alignment.centerLeft,
                child: ExternalLinkButton(
                  link: link,
                  label: _resolveExternalLabel(l10n, link.displayKey),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ContactTile extends ConsumerWidget {
  const _ContactTile({required this.contact});
  final HelpContact contact;

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final IconData icon = switch (contact.type) {
      HelpContactType.phone => Icons.call_outlined,
      HelpContactType.email => Icons.mail_outline,
      HelpContactType.url => Icons.public,
    };

    final ExternalLink? link = contact.externalLinkId == null ? null : ref.watch(externalLinkCatalogProvider).findById(contact.externalLinkId!);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: AppDimensions.space4),
      child: ListTile(
        leading: Icon(icon),
        title: Text(resolveHelpKey(l10n, contact.labelKey)),
        subtitle: Text(contact.value),
        trailing: link == null
            ? null
            : IconButton(
                icon: const Icon(Icons.open_in_new),
                tooltip: l10n.externalLinkA11yHint,
                onPressed: () {
                  // Delegated to ExternalLinkButton elsewhere. Keep
                  // the icon as a visual affordance only here.
                },
              ),
      ),
    );
  }
}

String _resolveExternalLabel(final AppLocalizations l10n, final String key) {
  switch (key) {
    case 'externalLinkEducamosClmLabel':
      return l10n.externalLinkEducamosClmLabel;
    case 'externalLinkEmpleoClmLabel':
      return l10n.externalLinkEmpleoClmLabel;
    case 'externalLinkEmpleoPublicoClmLabel':
      return l10n.externalLinkEmpleoPublicoClmLabel;
    case 'externalLinkSedeDgtLabel':
      return l10n.externalLinkSedeDgtLabel;
    case 'externalLinkCarpetaCiudadanaAgeLabel':
      return l10n.externalLinkCarpetaCiudadanaAgeLabel;
    case 'externalLinkHistoriaSocialUnicaLabel':
      return l10n.externalLinkHistoriaSocialUnicaLabel;
    case 'externalLinkInfanciaFamiliasLabel':
      return l10n.externalLinkInfanciaFamiliasLabel;
    default:
      return key;
  }
}
