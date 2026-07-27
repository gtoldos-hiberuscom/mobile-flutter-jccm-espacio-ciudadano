import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/core/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/features/external_links/1_domain/external_link_launcher.dart';
import 'package:jccm_espacio_ciudadano/features/external_links/2_presentation/providers/external_links_provider.dart';
import 'package:jccm_espacio_ciudadano/features/external_links/2_presentation/external_navigation_confirmation.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Legal notice screen from Figma node `41853:13694`.
class LegalNoticePage extends ConsumerStatefulWidget {
  const LegalNoticePage({super.key});

  @override
  ConsumerState<LegalNoticePage> createState() => _LegalNoticePageState();
}

class _LegalNoticePageState extends ConsumerState<LegalNoticePage> {
  late final ScrollController _scrollController;
  late final TextEditingController _searchController;
  late final FocusNode _searchFocusNode;
  bool _isSearching = false;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _searchController = TextEditingController()..addListener(_onSearchChanged);
    _searchFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController
      ..removeListener(_onSearchChanged)
      ..dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundBlueLighter,
      appBar: AppNavBar(
        title: _isSearching ? null : l10n.legalNoticeTitle,
        titleWidget: _isSearching
            ? AppSearchField(
                controller: _searchController,
                focusNode: _searchFocusNode,
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
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(Routes.homeFromDrawer);
            }
          },
        ),
        actions: [
          IconButton(
            icon: AppIcon(
              _isSearching ? AppIcons.close : AppIcons.search,
              color: AppColors.textPrimary,
            ),
            tooltip: _isSearching ? 'Cerrar búsqueda' : 'Buscar',
            onPressed: _isSearching ? _closeSearch : _startSearch,
          ),
        ],
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.space16,
          vertical: AppDimensions.space24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Semantics(
              header: true,
              headingLevel: 1,
              child: Text.rich(
                TextSpan(
                  children: _highlightTextSpans(
                    'Aviso legal (...)',
                    AppTypography.h1.copyWith(color: AppColors.primary),
                    _searchQuery,
                  ),
                ),
                semanticsLabel: 'Aviso legal (...)',
                textScaler: MediaQuery.textScalerOf(context),
                strutStyle: StrutStyle.fromTextStyle(AppTypography.h1),
              ),
            ),
            const SizedBox(height: AppDimensions.space32),
            _LegalNoticeBody(
              searchQuery: _searchQuery,
              onRoyalDecreeTap: () => _openExternalLink('boe_rd_1112_2018'),
              onSiteTap: () => _openExternalLink('espacio_ciudadano'),
            ),
          ],
        ),
      ),
    );
  }

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

  void _onSearchChanged() {
    setState(() => _searchQuery = _searchController.text);
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

class _LegalNoticeBody extends StatelessWidget {
  const _LegalNoticeBody({
    required this.searchQuery,
    required this.onRoyalDecreeTap,
    required this.onSiteTap,
  });

  final String searchQuery;
  final VoidCallback onRoyalDecreeTap;
  final VoidCallback onSiteTap;

  @override
  Widget build(final BuildContext context) {
    final style = AppTypography.leadingMedium.copyWith(color: AppColors.primary);
    final linkStyle = style.copyWith(
      color: AppColors.secondary,
      decoration: TextDecoration.underline,
      decorationColor: AppColors.secondary,
    );

    return Text.rich(
      TextSpan(
        style: style,
        children: [
          ..._highlightTextSpans(
            'La Junta de Comunidades de Castilla-La Mancha se ha comprometido a hacer accesible su sitio web, de conformidad con el ',
            style,
            searchQuery,
          ),
          WidgetSpan(
            alignment: PlaceholderAlignment.baseline,
            baseline: TextBaseline.alphabetic,
            child: InkWell(
              onTap: onRoyalDecreeTap,
              child: Text.rich(
                TextSpan(
                  children: _highlightTextSpans(
                    'Real Decreto 1112/2018, de 7 de septiembre ⇲',
                    linkStyle,
                    searchQuery,
                  ),
                ),
              ),
            ),
          ),
          ..._highlightTextSpans(
            ', sobre accesibilidad de los sitios web y aplicaciones para dispositivos móviles del sector público (en adelante, Real Decreto 1112/2018, de 7 de septiembre).\n\n',
            style,
            searchQuery,
          ),
          ..._highlightTextSpans(
            'La presente declaración de accesibilidad se aplica al sitio web ',
            style,
            searchQuery,
          ),
          WidgetSpan(
            alignment: PlaceholderAlignment.baseline,
            baseline: TextBaseline.alphabetic,
            child: InkWell(
              onTap: onSiteTap,
              child: Text.rich(
                TextSpan(
                  children: _highlightTextSpans(
                    'https://espaciociudadano.jccm.es/⇲',
                    linkStyle,
                    searchQuery,
                  ),
                ),
              ),
            ),
          ),
          ..._highlightTextSpans('.', style, searchQuery),
        ],
      ),
    );
  }
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
  final spans = <TextSpan>[];
  var cursor = 0;
  var searchFrom = 0;

  while (searchFrom < normalizedText.length) {
    final index = normalizedText.indexOf(normalizedQuery, searchFrom);
    if (index == -1) {
      break;
    }
    if (cursor < index) {
      spans.add(TextSpan(text: text.substring(cursor, index), style: style));
    }
    final end = index + normalizedQuery.length;
    spans.add(
      TextSpan(
        text: text.substring(index, end),
        style: style.copyWith(
          backgroundColor: AppColors.warningLight,
          color: AppColors.textBase,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
    cursor = end;
    searchFrom = end;
  }

  if (spans.isEmpty) {
    return [TextSpan(text: text, style: style)];
  }
  if (cursor < text.length) {
    spans.add(TextSpan(text: text.substring(cursor), style: style));
  }
  return spans;
}

String _normalizeSearch(final String value) => value.trim().toLowerCase().replaceAll('á', 'a').replaceAll('é', 'e').replaceAll('í', 'i').replaceAll('ó', 'o').replaceAll('ú', 'u').replaceAll('ü', 'u').replaceAll('ñ', 'n');
