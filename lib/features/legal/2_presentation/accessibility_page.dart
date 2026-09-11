import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/core/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/features/external_links/1_domain/external_link_launcher.dart';
import 'package:jccm_espacio_ciudadano/features/external_links/2_presentation/external_navigation_confirmation.dart';
import 'package:jccm_espacio_ciudadano/features/external_links/2_presentation/providers/external_links_provider.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Accessibility statement screen from Figma node `44641:24798`.
///
/// The screen is a stack of `TextBlocks/TextBlocks` instances separated by a
/// uniform `M` (16 dp) gap, inside a frame padded `M` horizontally and `L`
/// (24 dp) vertically. Each block carries the vertical padding of its
/// [AppTextBlockVariant]: H1 `8/16`, H2 `8/8`, Leading/Medium `4/8`.
///
/// The design applies no bold anywhere in the body: every run of text is
/// `Leading/Medium` in `Color/Text/primary-dark`. External links keep that same
/// colour and are marked by an underline plus a trailing `⇲` glyph — the
/// underline is a deliberate accessibility addition over the Figma export,
/// which left links visually identical to the surrounding text.
class AccessibilityPage extends ConsumerStatefulWidget {
  const AccessibilityPage({super.key});

  @override
  ConsumerState<AccessibilityPage> createState() => _AccessibilityPageState();
}

class _AccessibilityPageState extends ConsumerState<AccessibilityPage> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  String get _highlightQuery => _isSearching ? _searchController.text.trim() : '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _startSearch() {
    setState(() {
      _isSearching = true;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _searchFocusNode.requestFocus());
  }

  void _closeSearch() {
    setState(() {
      _isSearching = false;
      _searchController.clear();
    });
  }

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundBlueLighter,
      appBar: _AccessibilityAppBar(
        title: l10n.legalAccessibilityTitle,
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
      ),
      // Reserva también espacio cuando el dispositivo comunica un inset nulo
      // o menor que su barra de navegación.
      body: SafeArea(
        top: false,
        maintainBottomViewPadding: true,
        minimum: const EdgeInsets.only(bottom: AppDimensions.space48),
        child: SingleChildScrollView(
          padding: appPagePadding(context, top: AppDimensions.space24, bottom: AppDimensions.space48),
          child: _AccessibilityBody(
            highlightQuery: _highlightQuery,
            onRoyalDecreeTap: () => _openExternalLink('boe_rd_1112_2018'),
            onSiteTap: () => _openExternalLink('espacio_ciudadano'),
            onContactFormTap: () => _openExternalLink('accessibility_contact_form'),
            onOfficesTap: () => _openExternalLink('jccm_offices_oir'),
          ),
        ),
      ),
    );
  }

  Future<void> _openExternalLink(final String id) async {
    final link = ref.read(externalLinkCatalogProvider).findById(id);
    if (link == null) {
      return;
    }

    if (!await confirmExternalNavigation(context) || !mounted) {
      return;
    }
    final result = await ref.read(externalLinkLauncherProvider).launch(link);
    if (!mounted || result is! ExternalLinkLaunchFailure) {
      return;
    }

    AppAlertSnackbar.show(
      context,
      message: AppLocalizations.of(context).externalLinkOpenFailed,
      severity: AppAlertSeverity.error,
    );
  }
}

// ── AppBar con búsqueda ──────────────────────────────────────────────────────

class _AccessibilityAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AccessibilityAppBar({
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

// ── Contenido ────────────────────────────────────────────────────────────────

class _AccessibilityBody extends StatefulWidget {
  const _AccessibilityBody({
    required this.onRoyalDecreeTap,
    required this.onSiteTap,
    required this.onContactFormTap,
    required this.onOfficesTap,
    this.highlightQuery = '',
  });

  final VoidCallback onRoyalDecreeTap;
  final VoidCallback onSiteTap;
  final VoidCallback onContactFormTap;
  final VoidCallback onOfficesTap;
  final String highlightQuery;

  @override
  State<_AccessibilityBody> createState() => _AccessibilityBodyState();
}

class _AccessibilityBodyState extends State<_AccessibilityBody> {
  /// Inline links flow with the surrounding text, so they use gesture
  /// recognizers rather than `WidgetSpan`s, which would not wrap.
  late final TapGestureRecognizer _royalDecree;
  late final TapGestureRecognizer _site;
  late final TapGestureRecognizer _contactForm;
  late final TapGestureRecognizer _offices;

  @override
  void initState() {
    super.initState();
    _royalDecree = TapGestureRecognizer()..onTap = () => widget.onRoyalDecreeTap();
    _site = TapGestureRecognizer()..onTap = () => widget.onSiteTap();
    _contactForm = TapGestureRecognizer()..onTap = () => widget.onContactFormTap();
    _offices = TapGestureRecognizer()..onTap = () => widget.onOfficesTap();
  }

  @override
  void dispose() {
    _royalDecree.dispose();
    _site.dispose();
    _contactForm.dispose();
    _offices.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final q = widget.highlightQuery;
    final style = AppTypography.leadingMedium.copyWith(color: AppColors.textPrimary);
    final linkStyle = style.copyWith(
      decoration: TextDecoration.underline,
      decorationColor: AppColors.textPrimary,
    );

    return _ContentColumn(
      children: [
        _A11yHeading1(l10n.accessibilityStatementHeading, highlightQuery: q),
        _A11yBlock(
          child: Text.rich(
            TextSpan(
              style: style,
              children: [
                TextSpan(text: l10n.accessibilityIntroCommitment),
                TextSpan(
                  text: '${l10n.accessibilityIntroDecreeLink}⇲',
                  style: linkStyle,
                  recognizer: _royalDecree,
                ),
                TextSpan(text: l10n.accessibilityIntroDecreeSuffix),
                TextSpan(text: l10n.accessibilityDeclarationScope),
                TextSpan(
                  text: 'https://espaciociudadano.jccm.es/⇲',
                  style: linkStyle,
                  recognizer: _site,
                ),
                const TextSpan(text: '.'),
              ],
            ),
          ),
        ),
        _A11yHeading2(l10n.accessibilityComplianceTitle, highlightQuery: q),
        _A11yBlock(
          child: _HighlightedText(
            text: l10n.accessibilityComplianceText,
            style: style,
            query: q,
          ),
        ),
        _A11yHeading2(l10n.accessibilityNonAccessibleTitle, highlightQuery: q),
        _A11yBlock(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _HighlightedText(
                text: l10n.accessibilityNonAccessibleIntro,
                style: style,
                query: q,
              ),
              _A11yBulletList(
                highlightQuery: q,
                items: [
                  _A11yBullet(l10n.accessibilityNonAccessibleItemNonConformity),
                  _A11yBullet(l10n.accessibilityNonAccessibleItemBurden),
                  _A11yBullet(l10n.accessibilityNonAccessibleItemOutOfScope),
                ],
              ),
            ],
          ),
        ),
        _A11yHeading2(l10n.accessibilityPreparationTitle, highlightQuery: q),
        _A11yBlock(
          child: _HighlightedText(
            text: l10n.accessibilityPreparationText,
            style: style,
            query: q,
          ),
        ),
        _A11yHeading2(l10n.accessibilityContactTitle, highlightQuery: q),
        _A11yBlock(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _HighlightedText(
                text: l10n.accessibilityContactIntro,
                style: style,
                query: q,
              ),
              _A11yBulletList(
                highlightQuery: q,
                items: [
                  _A11yBullet(l10n.accessibilityContactItemReport),
                  _A11yBullet(l10n.accessibilityContactItemDifficulties),
                  _A11yBullet(l10n.accessibilityContactItemSuggestions),
                ],
              ),
              _HighlightedText(text: l10n.accessibilityContactChannelsIntro, style: style, query: q),
              _A11yLinkedBulletList(
                style: style,
                linkStyle: linkStyle,
                contactForm: _contactForm,
                offices: _offices,
              ),
              _HighlightedText(
                text: l10n.accessibilityContactProcessing,
                style: style,
                query: q,
              ),
            ],
          ),
        ),
        _A11yHeading2(l10n.accessibilityEnforcementTitle, highlightQuery: q),
        _A11yBlock(
          child: _HighlightedText(
            text: l10n.accessibilityEnforcementText,
            style: style,
            query: q,
          ),
        ),
        _A11yHeading2(l10n.accessibilityOptionalTitle, highlightQuery: q),
        _A11yBlock(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _HighlightedText(
                text: l10n.accessibilityOptionalText,
                style: style,
                query: q,
              ),
              _A11yBulletList(
                highlightQuery: q,
                items: [
                  _A11yBullet(l10n.accessibilityOptionalItemIncreaseText),
                  _A11yBullet(l10n.accessibilityOptionalItemDecreaseText),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Stacks the `TextBlocks` instances with the frame's `M` gap (node `44641:24799`).
class _ContentColumn extends StatelessWidget {
  const _ContentColumn({required this.children});

  final List<Widget> children;

  @override
  Widget build(final BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      for (final (index, child) in children.indexed) ...[
        if (index > 0) const SizedBox(height: AppDimensions.space16),
        child,
      ],
    ],
  );
}

/// A `Leading/Medium` text block — Figma padding `4` top, `8` bottom.
class _A11yBlock extends StatelessWidget {
  const _A11yBlock({required this.child});

  final Widget child;

  @override
  Widget build(final BuildContext context) => Padding(
    padding: const EdgeInsets.only(
      top: AppDimensions.space4,
      bottom: AppDimensions.space8,
    ),
    child: child,
  );
}

class _A11yHeading1 extends StatelessWidget {
  const _A11yHeading1(this.text, {this.highlightQuery = ''});

  final String text;
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
        style: AppTypography.h1.copyWith(color: AppColors.textPrimary),
        query: highlightQuery,
      ),
    ),
  );
}

class _A11yHeading2 extends StatelessWidget {
  const _A11yHeading2(this.text, {this.highlightQuery = ''});

  final String text;
  final String highlightQuery;

  @override
  Widget build(final BuildContext context) => Semantics(
    header: true,
    headingLevel: 2,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.space8),
      child: _HighlightedText(
        text: text,
        style: AppTypography.h2.copyWith(color: AppColors.textPrimary),
        query: highlightQuery,
      ),
    ),
  );
}

class _A11yBullet {
  const _A11yBullet(this.text);

  final String text;
}

class _A11yBulletList extends StatelessWidget {
  const _A11yBulletList({required this.items, this.highlightQuery = ''});

  final List<_A11yBullet> items;
  final String highlightQuery;

  @override
  Widget build(final BuildContext context) {
    final style = AppTypography.leadingMedium.copyWith(color: AppColors.textPrimary);

    return Padding(
      padding: const EdgeInsets.only(top: AppDimensions.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final item in items)
            Padding(
              padding: const EdgeInsets.only(left: AppDimensions.space8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('• ', style: style),
                  Expanded(
                    child: _HighlightedText(
                      text: item.text,
                      style: style,
                      query: highlightQuery,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _A11yLinkedBulletList extends StatelessWidget {
  const _A11yLinkedBulletList({
    required this.style,
    required this.linkStyle,
    required this.contactForm,
    required this.offices,
  });

  final TextStyle style;
  final TextStyle linkStyle;
  final GestureRecognizer contactForm;
  final GestureRecognizer offices;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.only(top: AppDimensions.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _linkedBullet(
            children: [
              TextSpan(
                text: '${l10n.accessibilityContactFormLink}⇲',
                style: linkStyle,
                recognizer: contactForm,
              ),
              const TextSpan(text: ','),
            ],
          ),
          _linkedBullet(
            children: [
              TextSpan(text: l10n.accessibilityOfficesPrefix),
              TextSpan(
                text: '${l10n.accessibilityOfficesLink}⇲',
                style: linkStyle,
                recognizer: offices,
              ),
              TextSpan(text: l10n.accessibilityOfficesSuffix),
            ],
          ),
        ],
      ),
    );
  }

  Widget _linkedBullet({required final List<InlineSpan> children}) => Padding(
    padding: const EdgeInsets.only(left: AppDimensions.space8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('• ', style: style),
        Expanded(
          child: Text.rich(
            TextSpan(
              style: style,
              children: children,
            ),
          ),
        ),
      ],
    ),
  );
}

// ── _HighlightedText ─────────────────────────────────────────────────────────

/// Renders [text] with any occurrences of [query] highlighted.
class _HighlightedText extends StatelessWidget {
  const _HighlightedText({
    required this.text,
    required this.style,
    this.query = '',
  });

  final String text;
  final TextStyle style;
  final String query;

  @override
  Widget build(final BuildContext context) {
    if (query.isEmpty) {
      return Text(text, style: style);
    }

    final lowerText = text.toLowerCase();
    final lowerQuery = query.toLowerCase();
    final spans = <InlineSpan>[];
    int start = 0;

    while (true) {
      final index = lowerText.indexOf(lowerQuery, start);
      if (index == -1) {
        spans.add(TextSpan(text: text.substring(start)));
        break;
      }
      if (index > start) {
        spans.add(TextSpan(text: text.substring(start, index)));
      }
      spans.add(
        TextSpan(
          text: text.substring(index, index + query.length),
          style: style.copyWith(
            backgroundColor: AppColors.secondary.withValues(alpha: 0.3),
            fontWeight: FontWeight.w700,
          ),
        ),
      );
      start = index + query.length;
    }

    return Text.rich(TextSpan(style: style, children: spans));
  }
}
