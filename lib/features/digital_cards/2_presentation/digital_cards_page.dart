import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/core/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/features/consent/1_domain/usecases/resolve_authorization_failure_usecase.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/0_entity/digital_card.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/2_presentation/digital_card_download_sheet.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/2_presentation/providers/digital_cards_provider.dart';
import 'package:jccm_espacio_ciudadano/features/external_links/2_presentation/external_navigation_confirmation.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

class DigitalCardsPage extends ConsumerWidget {
  const DigitalCardsPage({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final authorizationAsync = ref.watch(digitalCardsAuthorizationProvider);
    final isDownloading = ref.watch(digitalCardsDownloadingProvider) != null;

    return Scaffold(
      backgroundColor: AppColors.backgroundBlueLighter,
      appBar: AppNavBar(
        title: l10n.digitalCardsPageTitle,
        onBack: () => context.go(Routes.home),
        leading: IconButton(
          onPressed: () => context.go(Routes.home),
          tooltip: l10n.a11yBack,
          icon: const AppIcon(AppIcons.arrowBack, color: AppColors.textPrimary),
        ),
        actions: [
          IconButton(
            onPressed: () => _showInfo(context),
            tooltip: l10n.a11yInformation,
            icon: const AppIcon(AppIcons.info, color: AppColors.textPrimary),
          ),
        ],
      ),
      body: authorizationAsync.when(
        loading: () => const AppLoadingIndicator(),
        error: (final error, final stackTrace) => _DigitalCardsMessage(
          message: l10n.digitalCardsAuthorizationCheckErrorMessage,
          actionLabel: l10n.errorStateRetry,
          onAction: () => ref.invalidate(digitalCardsAuthorizationProvider),
        ),
        data: (final isAuthorized) {
          if (!isAuthorized) {
            return _UnauthorizedCardsContent(
              onOpenAuthorizations: () => _openAuthorizations(context, ref),
            );
          }
          final cardsAsync = ref.watch(digitalCardsProvider);
          return cardsAsync.when(
            loading: () => const AppLoadingIndicator(),
            // El rechazo por autorización ya está resuelto: si falta la
            // cláusula de la JCCM se ofrece concederla, y si se ha retirado la
            // obligatoria la sesión se está cerrando. Antes ambos casos caían
            // en la lista vacía —"no tienes carnets digitales"— porque el sobre
            // `412.00` entraba por la rama de error de negocio del repositorio.
            error: (final error, final stackTrace) => switch (error) {
              ClauseMissing() => _UnauthorizedCardsContent(
                onOpenAuthorizations: () => _openAuthorizations(context, ref),
              ),
              ConsentRevoked() => _DigitalCardsMessage(message: l10n.authorizationRevokedMessage),
              _ => _DigitalCardsMessage(
                message: l10n.digitalCardsErrorMessage,
                actionLabel: l10n.errorStateRetry,
                onAction: () => ref.invalidate(digitalCardsProvider),
              ),
            },
            data: (final cards) {
              if (cards.isEmpty) {
                return _DigitalCardsMessage(message: l10n.digitalCardsEmptyMessage);
              }

              final isTablet = isTabletLayout(context);
              final orderedCards = [...cards];
              if (isTablet) {
                const order = {
                  DigitalCardType.largeFamily: 0,
                  DigitalCardType.disability: 1,
                  DigitalCardType.youth: 2,
                };
                orderedCards.sort((final a, final b) => order[a.type]!.compareTo(order[b.type]!));
              }

              Widget buildCard(final DigitalCard card) {
                return AppDigitalCard(
                  title: _title(card, l10n),
                  number: card.number,
                  primaryDateLabel: switch (card.type) {
                    DigitalCardType.largeFamily => l10n.digitalCardsIssueDate,
                    DigitalCardType.disability => l10n.digitalCardsEffectiveDate,
                    DigitalCardType.youth => l10n.digitalCardsExpiryDate,
                  },
                  primaryDate: _formatDate(context, card.type == DigitalCardType.youth ? card.expiresAt : card.validFrom),
                  secondaryDateLabel: card.type == DigitalCardType.largeFamily ? l10n.digitalCardsExpiryDate : null,
                  secondaryDate: card.type == DigitalCardType.largeFamily ? _formatDate(context, card.expiresAt) : null,
                  statusLabel: card.isDefinitive ? l10n.digitalCardsDefinitive : null,
                  downloadLabel: l10n.digitalCardDownload,
                  isDownloading: isDownloading,
                  onDownload: () => showDigitalCardDownloadSheet(context, ref, card),
                );
              }

              return SafeArea(
                top: false,
                child: LayoutBuilder(
                  builder: (final context, final constraints) {
                    final horizontalPadding = appPageHorizontalPadding(context);
                    final cardWidth = (constraints.maxWidth - horizontalPadding * 2 - AppDimensions.space16) / 2;
                    return RefreshIndicator(
                      onRefresh: () async => ref.refresh(digitalCardsProvider.future),
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: EdgeInsets.fromLTRB(
                          horizontalPadding,
                          isTablet ? AppDimensions.space16 : AppDimensions.space24,
                          horizontalPadding,
                          AppDimensions.space64,
                        ),
                        child: isTablet
                            ? Wrap(
                                spacing: AppDimensions.space16,
                                runSpacing: AppDimensions.space16,
                                children: [
                                  for (final card in orderedCards) SizedBox(width: cardWidth, child: buildCard(card)),
                                ],
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  for (var index = 0; index < orderedCards.length; index++) ...[
                                    if (index > 0) const SizedBox(height: AppDimensions.space16),
                                    buildCard(orderedCards[index]),
                                  ],
                                ],
                              ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _openAuthorizations(final BuildContext context, final WidgetRef ref) async {
    await context.push<void>(
      Uri(
        path: Routes.consent,
        queryParameters: {
          'mode': 'preferences',
          'returnTo': Routes.digitalCards,
        },
      ).toString(),
    );
    ref
      ..invalidate(digitalCardsAuthorizationProvider)
      ..invalidate(digitalCardsProvider);
  }

  Future<void> _showInfo(final BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    await AppInfoSheet.show(
      context: context,
      title: l10n.digitalCardsInfoSheetTitle,
      bodyText: l10n.digitalCardsInfoSheetBody,
      footerText: l10n.digitalCardsInfoSheetContactHint,
      actionLabel: l10n.digitalCardsInfoSheetContactButton,
      onActionPressed: () => launchExternalUrlWithConfirmation(
        context,
        Uri.parse('https://sanidad.castillalamancha.es/ciudadanos'),
      ),
      actionIcon: Icons.open_in_new,
    );
  }

  String _title(final DigitalCard card, final AppLocalizations l10n) => switch (card.type) {
    DigitalCardType.largeFamily => l10n.digitalCardsTypeFamiliaNumerosa,
    DigitalCardType.youth => l10n.digitalCardsTypeJoven,
    DigitalCardType.disability => l10n.digitalCardsTypeDiscapacidad,
  };

  String? _formatDate(final BuildContext context, final DateTime? value) {
    if (value == null) {
      return null;
    }
    return DateFormat('dd MMM yyyy', Localizations.localeOf(context).languageCode).format(value);
  }
}

class _UnauthorizedCardsContent extends StatelessWidget {
  const _UnauthorizedCardsContent({required this.onOpenAuthorizations});

  final VoidCallback onOpenAuthorizations;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          isTabletLayout(context) ? AppDimensions.space40 : AppDimensions.space20,
          AppDimensions.space24,
          isTabletLayout(context) ? AppDimensions.space40 : AppDimensions.space20,
          AppDimensions.space8,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppIcon(AppIcons.info, color: AppColors.primaryDark),
            const SizedBox(width: AppDimensions.space8),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: AppDimensions.space4),
                child: Text(
                  l10n.digitalCardsAuthorizationRequiredMessage,
                  style: AppTypography.smallRegular.copyWith(color: AppColors.primaryDark),
                ),
              ),
            ),
            const SizedBox(width: AppDimensions.space16),
            SizedBox(
              width: AppDimensions.minTouchTarget,
              height: AppDimensions.minTouchTarget,
              child: AppIconButton(
                icon: AppIcons.settings,
                onPressed: onOpenAuthorizations,
                hierarchy: AppButtonHierarchy.secondary,
                semanticsLabel: l10n.myDataJccmAuthorizationRequiredCta,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DigitalCardsMessage extends StatelessWidget {
  const _DigitalCardsMessage({
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(final BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isTabletLayout(context) ? AppDimensions.space40 : AppDimensions.space24,
          vertical: AppDimensions.space24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTypography.bodyRegular.copyWith(color: AppColors.textPrimary),
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: AppDimensions.space16),
              AppButton(
                label: actionLabel!,
                onPressed: onAction,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
