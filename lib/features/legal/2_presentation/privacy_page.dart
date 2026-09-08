import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/core/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/citizen_endpoint_ids_provider.dart';
import 'package:jccm_espacio_ciudadano/features/consent/2_presentation/controllers/consent_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/external_links/1_domain/external_link_launcher.dart';
import 'package:jccm_espacio_ciudadano/features/external_links/2_presentation/external_navigation_confirmation.dart';
import 'package:jccm_espacio_ciudadano/features/external_links/2_presentation/providers/external_links_provider.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Data-protection information screen from Figma node `41775:12413`.
class PrivacyPage extends ConsumerStatefulWidget {
  const PrivacyPage({
    super.key,
    this.fromHome = false,
    this.isOnboarding = false,
  });

  final bool fromHome;
  final bool isOnboarding;

  @override
  ConsumerState<PrivacyPage> createState() => _PrivacyPageState();
}

class _PrivacyPageState extends ConsumerState<PrivacyPage> {
  late final ScrollController _scrollController;
  late final TextEditingController _searchController;
  late final FocusNode _searchFocusNode;
  final Map<String, GlobalKey> _entryKeys = <String, GlobalKey>{};
  bool _isSearching = false;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    _searchController = TextEditingController()..addListener(_onSearchChanged);
    _searchFocusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((final _) => _onScroll());
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    _searchController
      ..removeListener(_onSearchChanged)
      ..dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() => _searchQuery = _searchController.text);
    WidgetsBinding.instance.addPostFrameCallback((final _) => _scrollToFirstMatch());
  }

  void _onScroll() {
    if (widget.fromHome) {
      return;
    }
    if (!_scrollController.hasClients) {
      return;
    }
    final position = _scrollController.position;
    if (position.pixels < position.maxScrollExtent - AppDimensions.space64) {
      return;
    }
    final idAgente = ref.read(citizenEndpointIdsProvider).idAgente ?? '';
    ref.read(consentProvider(idAgente).notifier).onScrollReachedEnd();
  }

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final idAgente = ref.watch(citizenEndpointIdsProvider).idAgente ?? '';
    final consentState = ref.watch(consentProvider(idAgente));
    final consentNotifier = ref.read(consentProvider(idAgente).notifier);
    final canAccept = consentState.status == ConsentStatus.step1Unlocked;
    final fromHome = widget.fromHome;
    final textColor = fromHome ? AppColors.textPrimary : AppColors.textBase;
    final entries = _contentEntries(
      context: context,
      l10n: l10n,
      textColor: textColor,
      fromHome: fromHome,
    );

    return Scaffold(
      backgroundColor: fromHome ? AppColors.backgroundBlueLighter : AppColors.surface,
      appBar: fromHome
          ? _HomePrivacyAppBar(
              title: l10n.legalPrivacyTitle,
              isSearching: _isSearching,
              searchController: _searchController,
              searchFocusNode: _searchFocusNode,
              onBack: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go(Routes.homeFromDrawer);
                }
              },
              onSearch: _startSearch,
              onCloseSearch: _closeSearch,
            )
          : AppNavBar(
              type: AppNavBarType.detail,
              title: l10n.legalPrivacyTitle,
              showLeading: false,
            ),
      body: SafeArea(
        top: false,
        // Protege tanto el texto como los botones. SafeArea consume el inset
        // para que la barra de consentimiento no vuelva a sumarlo.
        maintainBottomViewPadding: true,
        minimum: const EdgeInsets.only(bottom: AppDimensions.space48),
        child: Column(
          children: [
            Expanded(
              child: NotificationListener<ScrollNotification>(
                onNotification: (final notification) {
                  if (notification.metrics.pixels >= notification.metrics.maxScrollExtent - AppDimensions.space64) {
                    _onScroll();
                  }
                  return false;
                },
                child: SingleChildScrollView(
                  controller: _scrollController,
                  // En la vista informativa no hay barra inferior que reserve
                  // espacio, así que el último bloque —el contacto del delegado
                  // de protección de datos, con su correo— quedaba debajo del
                  // gesto de navegación y no se llegaba a ver.
                  padding: EdgeInsets.only(
                    left: AppDimensions.space16,
                    right: AppDimensions.space16,
                    top: fromHome ? AppDimensions.space24 : AppDimensions.space8,
                    bottom: fromHome ? AppDimensions.space48 : AppDimensions.space8,
                  ),
                  child: _ContentColumn(
                    gap: fromHome ? AppDimensions.space16 : AppDimensions.space8,
                    children: [
                      for (final entry in entries)
                        KeyedSubtree(
                          key: _entryKey(entry.id),
                          child: entry.child,
                        ),
                    ],
                  ),
                ),
              ),
            ),
            if (!fromHome)
              AppStickyBar(
                type: AppStickyBarType.vertical,
                secondaryLabel: l10n.consentRejectButton,
                secondaryHierarchy: AppButtonHierarchy.tertiary,
                secondaryLeadingIcon: AppIcons.cancel,
                onSecondary: () async {
                  await consentNotifier.reject();
                  if (context.mounted) {
                    context.go(Routes.landing);
                  }
                },
                primaryLabel: l10n.consentFinalAcceptButton,
                primaryLeadingIcon: AppIcons.check,
                onPrimary: canAccept
                    ? () {
                        consentNotifier.proceedToStep2();
                        context.go(Routes.consentOnboarding);
                      }
                    : null,
              ),
          ],
        ),
      ),
    );
  }

  bool get _hasActiveSearch => widget.fromHome && _searchQuery.trim().isNotEmpty;

  void _startSearch() {
    setState(() => _isSearching = true);
    _searchFocusNode.requestFocus();
  }

  void _closeSearch() {
    setState(() {
      _isSearching = false;
      _searchController.clear();
      _searchQuery = '';
    });
    _searchFocusNode.unfocus();
  }

  void _scrollToFirstMatch() {
    if (!_hasActiveSearch) {
      return;
    }
    final normalizedQuery = _normalize(_searchQuery);
    String? matchingId;
    for (final entry in _contentEntries(
      context: context,
      l10n: AppLocalizations.of(context),
      textColor: widget.fromHome ? AppColors.textPrimary : AppColors.textBase,
      fromHome: widget.fromHome,
    )) {
      if (_normalize(entry.searchText).contains(normalizedQuery)) {
        matchingId = entry.id;
        break;
      }
    }
    final keyContext = matchingId == null ? null : _entryKeys[matchingId]?.currentContext;
    if (keyContext == null) {
      return;
    }
    unawaited(
      Scrollable.ensureVisible(
        keyContext,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        alignment: 0.12,
      ),
    );
  }

  GlobalKey _entryKey(final String id) => _entryKeys.putIfAbsent(id, GlobalKey.new);

  List<_SearchableEntry> _contentEntries({
    required final BuildContext context,
    required final AppLocalizations l10n,
    required final Color textColor,
    required final bool fromHome,
  }) {
    final bodyStyle = fromHome ? AppTypography.leadingMedium : AppTypography.bodyRegular;
    final responsibleTitle = l10n.privacyResponsibleTitle;
    final responsibleIntro = l10n.privacyResponsibleIntro;
    final responsibleItems = [
      l10n.privacyResponsibleItemProfile,
      l10n.privacyResponsibleItemVisualizations,
      l10n.privacyResponsibleItemRecommendations,
      l10n.privacyResponsibleItemDownloads,
    ];
    final responsibleOrg = l10n.privacyResponsibleOrgParagraph;
    final responsibleContactIntro = l10n.privacyResponsibleContactIntro;
    final responsibleContact = '${l10n.privacyResponsibleContactAddressLabel}${l10n.privacyResponsibleContactAddressValue}';
    final purposeTitle = l10n.privacyPurposeTitle;
    final purposeIntro = l10n.privacyPurposeIntro;
    final purposeItems = [
      l10n.privacyPurposeItemIdentity,
      l10n.privacyPurposeItemVisualizations,
    ];
    final aepdTitle = l10n.privacyAepdTitle;
    final aepdText = '${l10n.privacyAepdTextBeforeLink}https://www.aepd.es/${l10n.privacyAepdTextAfterLink}';
    final securityTitle = l10n.privacySecurityTitle;
    final securityText = l10n.privacySecurityText;
    final profilingTitle = l10n.privacyProfilingTitle;
    final profilingText = l10n.privacyProfilingText;
    final dpoTitle = l10n.privacyDpoTitle;
    final dpoIntro = l10n.privacyDpoIntro;
    final dpoContact = '${l10n.privacyDpoContactAddressLabel}${l10n.privacyDpoContactAddressValue}${l10n.privacyDpoContactEmailLabel}protecciondatos@jccm.es';

    return [
      if (fromHome)
        _SearchableEntry(
          id: 'page-title',
          searchText: l10n.legalPrivacyTitle,
          child: _PageTitle(
            l10n.legalPrivacyTitle,
            color: AppColors.textPrimary,
            highlightQuery: _searchQuery,
          ),
        ),
      _SearchableEntry(
        id: 'responsible-title',
        searchText: responsibleTitle,
        child: _SectionTitle(responsibleTitle, color: textColor, highlightQuery: _searchQuery),
      ),
      _SearchableEntry(
        id: 'responsible-intro',
        searchText: responsibleIntro,
        child: _BodyBlock(responsibleIntro, style: bodyStyle, color: textColor, highlightQuery: _searchQuery),
      ),
      _SearchableEntry(
        id: 'responsible-items',
        searchText: responsibleItems.join(' '),
        child: _BulletList(style: bodyStyle, color: textColor, items: responsibleItems, highlightQuery: _searchQuery),
      ),
      _SearchableEntry(
        id: 'responsible-org',
        searchText: responsibleOrg,
        child: _BodyBlock(responsibleOrg, style: bodyStyle, color: textColor, highlightQuery: _searchQuery),
      ),
      _SearchableEntry(
        id: 'responsible-contact-intro',
        searchText: responsibleContactIntro,
        child: _BodyBlock(responsibleContactIntro, style: bodyStyle, color: textColor, highlightQuery: _searchQuery),
      ),
      _SearchableEntry(
        id: 'responsible-contact',
        searchText: responsibleContact,
        child: _ContactBlock(
          style: bodyStyle,
          color: textColor,
          highlightQuery: _searchQuery,
          children: [
            TextSpan(
              text: l10n.privacyResponsibleContactAddressLabel,
              style: fromHome ? bodyStyle : AppTypography.bodyBold,
            ),
            TextSpan(text: l10n.privacyResponsibleContactAddressValue),
          ],
        ),
      ),
      _SearchableEntry(
        id: 'purpose-title',
        searchText: purposeTitle,
        child: _SectionTitle(purposeTitle, color: textColor, highlightQuery: _searchQuery),
      ),
      _SearchableEntry(
        id: 'purpose-intro',
        searchText: purposeIntro,
        child: _BodyBlock(purposeIntro, style: bodyStyle, color: textColor, highlightQuery: _searchQuery),
      ),
      _SearchableEntry(
        id: 'purpose-items',
        searchText: purposeItems.join(' '),
        child: _BulletList(style: bodyStyle, color: textColor, items: purposeItems, highlightQuery: _searchQuery),
      ),
      _SearchableEntry(
        id: 'aepd-title',
        searchText: aepdTitle,
        child: _SectionTitle(aepdTitle, highlightQuery: _searchQuery),
      ),
      _SearchableEntry(
        id: 'aepd-text',
        searchText: aepdText,
        child: _AepdBlock(
          style: bodyStyle,
          color: textColor,
          highlightQuery: _searchQuery,
          onTap: () => _openAepd(context),
        ),
      ),
      _SearchableEntry(
        id: 'security-title',
        searchText: securityTitle,
        child: _SectionTitle(securityTitle, color: textColor, highlightQuery: _searchQuery),
      ),
      _SearchableEntry(
        id: 'security-text',
        searchText: securityText,
        child: _BodyBlock(securityText, style: bodyStyle, color: textColor, highlightQuery: _searchQuery),
      ),
      _SearchableEntry(
        id: 'profiling-title',
        searchText: profilingTitle,
        child: _SectionTitle(profilingTitle, color: textColor, highlightQuery: _searchQuery),
      ),
      _SearchableEntry(
        id: 'profiling-text',
        searchText: profilingText,
        child: _BodyBlock(profilingText, style: bodyStyle, color: textColor, highlightQuery: _searchQuery),
      ),
      _SearchableEntry(
        id: 'dpo-title',
        searchText: dpoTitle,
        child: _SectionTitle(dpoTitle, color: textColor, highlightQuery: _searchQuery),
      ),
      _SearchableEntry(
        id: 'dpo-intro',
        searchText: dpoIntro,
        child: _BodyBlock(dpoIntro, style: bodyStyle, color: textColor, highlightQuery: _searchQuery),
      ),
      _SearchableEntry(
        id: 'dpo-contact',
        searchText: dpoContact,
        child: _ContactBlock(
          style: bodyStyle,
          color: textColor,
          highlightQuery: _searchQuery,
          children: [
            TextSpan(
              text: l10n.privacyDpoContactAddressLabel,
              style: fromHome ? bodyStyle : AppTypography.bodyBold,
            ),
            TextSpan(text: l10n.privacyDpoContactAddressValue),
            TextSpan(
              text: l10n.privacyDpoContactEmailLabel,
              style: fromHome ? bodyStyle : AppTypography.bodyBold,
            ),
            const TextSpan(text: 'protecciondatos@jccm.es'),
          ],
        ),
      ),
    ];
  }

  String _normalize(final String value) => value.trim().toLowerCase().replaceAll('á', 'a').replaceAll('é', 'e').replaceAll('í', 'i').replaceAll('ó', 'o').replaceAll('ú', 'u').replaceAll('ü', 'u').replaceAll('ñ', 'n');

  Future<void> _openAepd(final BuildContext context) async {
    final catalog = ref.read(externalLinkCatalogProvider);
    final link = catalog.findById('aepd');
    if (link == null) {
      return;
    }

    if (!await confirmExternalNavigation(context) || !context.mounted) {
      return;
    }
    final result = await ref.read(externalLinkLauncherProvider).launch(link);
    if (!context.mounted || result is! ExternalLinkLaunchFailure) {
      return;
    }
    AppAlertSnackbar.show(
      context,
      message: AppLocalizations.of(context).externalLinkOpenFailed,
      severity: AppAlertSeverity.error,
    );
  }
}

class _ContentColumn extends StatelessWidget {
  const _ContentColumn({
    required this.children,
    this.gap = AppDimensions.space8,
  });

  final List<Widget> children;
  final double gap;

  @override
  Widget build(final BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      for (final (index, child) in children.indexed) ...[
        if (index > 0) SizedBox(height: gap),
        child,
      ],
    ],
  );
}

class _HomePrivacyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _HomePrivacyAppBar({
    required this.title,
    required this.isSearching,
    required this.searchController,
    required this.searchFocusNode,
    required this.onBack,
    required this.onSearch,
    required this.onCloseSearch,
  });

  final String title;
  final bool isSearching;
  final TextEditingController searchController;
  final FocusNode searchFocusNode;
  final VoidCallback onBack;
  final VoidCallback onSearch;
  final VoidCallback onCloseSearch;

  @override
  Size get preferredSize => const Size.fromHeight(AppDimensions.appBarHeight);

  @override
  Widget build(final BuildContext context) => AppNavBar(
    title: isSearching ? null : title,
    titleWidget: isSearching
        ? AppSearchField(
            controller: searchController,
            focusNode: searchFocusNode,
            autofocus: true,
          )
        : null,
    leading: IconButton(
      icon: const AppIcon(
        AppIcons.arrowBack,
        size: AppDimensions.iconLarge,
        color: AppColors.textPrimary,
      ),
      tooltip: MaterialLocalizations.of(context).backButtonTooltip,
      onPressed: onBack,
    ),
    actions: [
      IconButton(
        icon: AppIcon(
          isSearching ? AppIcons.close : AppIcons.search,
          color: AppColors.textPrimary,
        ),
        tooltip: isSearching ? AppLocalizations.of(context).legalSearchCloseTooltip : AppLocalizations.of(context).legalSearchTooltip,
        onPressed: isSearching ? onCloseSearch : onSearch,
      ),
    ],
  );
}

class _SearchableEntry {
  const _SearchableEntry({
    required this.id,
    required this.searchText,
    required this.child,
  });

  final String id;
  final String searchText;
  final Widget child;
}

class _PageTitle extends StatelessWidget {
  const _PageTitle(
    this.text, {
    required this.color,
    this.highlightQuery = '',
  });

  final String text;
  final Color color;
  final String highlightQuery;

  @override
  Widget build(final BuildContext context) => Semantics(
    header: true,
    headingLevel: 1,
    child: Padding(
      padding: const EdgeInsets.only(
        top: AppDimensions.space8,
        bottom: AppDimensions.space16,
      ),
      child: _HighlightedText(
        text: text,
        style: AppTypography.h1.copyWith(color: color),
        query: highlightQuery,
      ),
    ),
  );
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(
    this.text, {
    this.color = AppColors.textBase,
    this.highlightQuery = '',
  });

  final String text;
  final Color color;
  final String highlightQuery;

  @override
  Widget build(final BuildContext context) => Semantics(
    header: true,
    headingLevel: 2,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.space8),
      child: _HighlightedText(
        text: text,
        style: AppTypography.h2.copyWith(color: color),
        query: highlightQuery,
      ),
    ),
  );
}

class _BodyBlock extends StatelessWidget {
  const _BodyBlock(
    this.text, {
    this.color = AppColors.textBase,
    this.style = AppTypography.bodyRegular,
    this.highlightQuery = '',
  });

  final String text;
  final Color color;
  final TextStyle style;
  final String highlightQuery;

  @override
  Widget build(final BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: AppDimensions.space4),
    child: _HighlightedText(
      text: text,
      style: style.copyWith(color: color),
      query: highlightQuery,
    ),
  );
}

class _ContactBlock extends StatelessWidget {
  const _ContactBlock({
    required this.children,
    this.color = AppColors.textBase,
    this.style = AppTypography.bodyRegular,
    this.highlightQuery = '',
  });

  final List<InlineSpan> children;
  final Color color;
  final TextStyle style;
  final String highlightQuery;

  @override
  Widget build(final BuildContext context) => Padding(
    padding: const EdgeInsets.all(AppDimensions.space4),
    child: RichText(
      text: TextSpan(
        children: _highlightInlineSpans(
          children,
          style.copyWith(color: color),
          highlightQuery,
        ),
      ),
    ),
  );
}

class _BulletList extends StatelessWidget {
  const _BulletList({
    required this.items,
    this.color = AppColors.textBase,
    this.style = AppTypography.bodyRegular,
    this.highlightQuery = '',
  });

  final List<String> items;
  final Color color;
  final TextStyle style;
  final String highlightQuery;

  @override
  Widget build(final BuildContext context) => Padding(
    padding: const EdgeInsets.all(AppDimensions.space4),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final item in items)
          Semantics(
            label: item,
            child: ExcludeSemantics(
              child: Padding(
                padding: const EdgeInsets.only(left: AppDimensions.space8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '• ',
                      style: style.copyWith(color: color),
                    ),
                    Expanded(
                      child: _HighlightedText(
                        text: item,
                        style: style.copyWith(color: color),
                        query: highlightQuery,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    ),
  );
}

class _AepdBlock extends StatelessWidget {
  const _AepdBlock({
    required this.onTap,
    this.color = AppColors.textBase,
    this.style = AppTypography.bodyRegular,
    this.highlightQuery = '',
  });

  final VoidCallback onTap;
  final Color color;
  final TextStyle style;
  final String highlightQuery;

  @override
  Widget build(final BuildContext context) => Padding(
    padding: const EdgeInsets.all(AppDimensions.space4),
    child: Text.rich(
      TextSpan(
        style: style.copyWith(color: color),
        children: [
          ..._highlightTextSpans(
            AppLocalizations.of(context).privacyAepdTextBeforeLink,
            style.copyWith(color: color),
            highlightQuery,
          ),
          WidgetSpan(
            alignment: PlaceholderAlignment.baseline,
            baseline: TextBaseline.alphabetic,
            child: Semantics(
              link: true,
              button: true,
              label: 'https://www.aepd.es/',
              child: InkWell(
                onTap: onTap,
                child: Text(
                  'https://www.aepd.es/ ⇲',
                  style: style.copyWith(
                    decoration: TextDecoration.underline,
                    color: color,
                  ),
                ),
              ),
            ),
          ),
          ..._highlightTextSpans(
            AppLocalizations.of(context).privacyAepdTextAfterLink,
            style.copyWith(color: color),
            highlightQuery,
          ),
        ],
      ),
    ),
  );
}

class _HighlightedText extends StatelessWidget {
  const _HighlightedText({
    required this.text,
    required this.style,
    required this.query,
  });

  final String text;
  final TextStyle style;
  final String query;

  @override
  Widget build(final BuildContext context) => RichText(
    text: TextSpan(
      style: style,
      children: _highlightTextSpans(text, style, query),
    ),
  );
}

List<InlineSpan> _highlightInlineSpans(
  final List<InlineSpan> spans,
  final TextStyle baseStyle,
  final String query,
) {
  final highlighted = <InlineSpan>[];
  for (final span in spans) {
    if (span is TextSpan) {
      final text = span.text;
      final style = baseStyle.merge(span.style);
      if (text != null && text.isNotEmpty) {
        highlighted.addAll(_highlightTextSpans(text, style, query));
      }
      if (span.children != null) {
        highlighted.addAll(_highlightInlineSpans(span.children!, style, query));
      }
    } else {
      highlighted.add(span);
    }
  }
  return highlighted;
}

List<TextSpan> _highlightTextSpans(
  final String text,
  final TextStyle style,
  final String query,
) {
  final normalizedQuery = _normalizeSearch(query);
  if (normalizedQuery.isEmpty) {
    return [TextSpan(text: text, style: style)];
  }

  final normalizedText = _normalizeSearch(text);
  final ranges = <({int start, int end})>[];
  var searchFrom = 0;
  while (searchFrom < normalizedText.length) {
    final index = normalizedText.indexOf(normalizedQuery, searchFrom);
    if (index == -1) {
      break;
    }
    ranges.add((start: index, end: index + normalizedQuery.length));
    searchFrom = index + normalizedQuery.length;
  }
  if (ranges.isEmpty) {
    return [TextSpan(text: text, style: style)];
  }

  final spans = <TextSpan>[];
  var cursor = 0;
  for (final range in ranges) {
    if (cursor < range.start) {
      spans.add(TextSpan(text: text.substring(cursor, range.start), style: style));
    }
    spans.add(
      TextSpan(
        text: text.substring(range.start, range.end),
        style: style.copyWith(
          backgroundColor: AppColors.warningLight,
          color: AppColors.textBase,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
    cursor = range.end;
  }
  if (cursor < text.length) {
    spans.add(TextSpan(text: text.substring(cursor), style: style));
  }
  return spans;
}

String _normalizeSearch(final String value) => value.trim().toLowerCase().replaceAll('á', 'a').replaceAll('é', 'e').replaceAll('í', 'i').replaceAll('ó', 'o').replaceAll('ú', 'u').replaceAll('ü', 'u').replaceAll('ñ', 'n');
