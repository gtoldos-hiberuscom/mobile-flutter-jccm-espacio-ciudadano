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

/// Legal notice screen from Figma node `41853:13694`.
class LegalNoticePage extends ConsumerStatefulWidget {
  const LegalNoticePage({super.key});

  @override
  ConsumerState<LegalNoticePage> createState() => _LegalNoticePageState();
}

class _LegalNoticePageState extends ConsumerState<LegalNoticePage> {
  late final ScrollController _scrollController;
  final _searchController = TextEditingController();
  bool _isSearching = false;
  late final TapGestureRecognizer _decreeRecognizer;
  late final TapGestureRecognizer _siteRecognizer;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _searchController.addListener(() => setState(() {}));
    _decreeRecognizer = TapGestureRecognizer()..onTap = () => _openExternalLink('boe_rd_1112_2018');
    _siteRecognizer = TapGestureRecognizer()..onTap = () => _openExternalLink('espacio_ciudadano');
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _decreeRecognizer.dispose();
    _siteRecognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundBlueLighter,
      appBar: AppNavBar(
        title: _isSearching ? null : l10n.legalNoticeTitle,
        titleWidget: _isSearching ? AppSearchField(controller: _searchController, autofocus: true) : null,
        actions: [
          IconButton(
            icon: AppIcon(_isSearching ? AppIcons.close : AppIcons.search, color: AppColors.textPrimary),
            tooltip: _isSearching ? l10n.legalSearchCloseTooltip : l10n.legalSearchTooltip,
            onPressed: () => setState(() {
              _isSearching = !_isSearching;
              if (!_isSearching) {
                _searchController.clear();
              }
            }),
          ),
        ],
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
      ),
      // `SafeArea` inferior y no un padding fijo: el último bloque quedaba
      // debajo del gesto de navegación del dispositivo y el texto parecía
      // cortado. Igual que en Accesibilidad y Protección de datos.
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          controller: _scrollController,
          padding: const EdgeInsets.only(
            left: AppDimensions.space16,
            right: AppDimensions.space16,
            top: AppDimensions.space32,
            bottom: AppDimensions.space48,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Semantics(
                header: true,
                headingLevel: 1,
                child: Text.rich(
                  TextSpan(
                    children: _legalTextSpans(l10n.legalNoticeHeading, _searchController.text.trim()),
                    style: AppTypography.h1.copyWith(color: AppColors.textPrimary),
                  ),
                  semanticsLabel: l10n.legalNoticeHeading,
                  textScaler: MediaQuery.textScalerOf(context),
                  strutStyle: StrutStyle.fromTextStyle(AppTypography.h1),
                ),
              ),
              const SizedBox(height: AppDimensions.space32),
              _LegalNoticeBody(
                decreeRecognizer: _decreeRecognizer,
                siteRecognizer: _siteRecognizer,
                query: _searchController.text.trim(),
              ),
            ],
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

class _LegalNoticeBody extends StatelessWidget {
  const _LegalNoticeBody({
    required this.decreeRecognizer,
    required this.siteRecognizer,
    required this.query,
  });

  final TapGestureRecognizer decreeRecognizer;
  final TapGestureRecognizer siteRecognizer;
  final String query;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Text.rich(
      TextSpan(
        style: AppTypography.leadingMedium.copyWith(color: AppColors.textPrimary),
        children: [
          ..._legalTextSpans(l10n.accessibilityIntroCommitment, query),
          ..._legalTextSpans('${l10n.accessibilityIntroDecreeLink} ⇲', query, recognizer: decreeRecognizer),
          ..._legalTextSpans(l10n.accessibilityIntroDecreeSuffix, query),
          ..._legalTextSpans(l10n.accessibilityDeclarationScope, query),
          ..._legalTextSpans('https://espaciociudadano.jccm.es/⇲', query, recognizer: siteRecognizer),
          const TextSpan(text: '.'),
        ],
      ),
    );
  }
}

// Text spans let links wrap naturally within the paragraph and remain tappable.
List<TextSpan> _legalTextSpans(
  final String text,
  final String query, {
  final TapGestureRecognizer? recognizer,
}) {
  if (query.isEmpty) {
    return [TextSpan(text: text, recognizer: recognizer)];
  }
  final matches = RegExp(RegExp.escape(query), caseSensitive: false).allMatches(text);
  final spans = <TextSpan>[];
  var start = 0;
  for (final match in matches) {
    if (match.start > start) {
      spans.add(TextSpan(text: text.substring(start, match.start), recognizer: recognizer));
    }
    spans.add(
      TextSpan(
        text: text.substring(match.start, match.end),
        recognizer: recognizer,
        style: TextStyle(backgroundColor: AppColors.secondary.withValues(alpha: 0.3)),
      ),
    );
    start = match.end;
  }
  if (start < text.length) {
    spans.add(TextSpan(text: text.substring(start), recognizer: recognizer));
  }
  return spans;
}
