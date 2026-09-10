import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/core/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/2_presentation/providers/agenda_appointments_provider.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/widgets/authenticated_profile_menu.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/0_entity/digital_card.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/2_presentation/digital_card_download_sheet.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/2_presentation/providers/digital_cards_provider.dart';
import 'package:jccm_espacio_ciudadano/features/external_links/2_presentation/external_navigation_confirmation.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/notificacion_estado.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/2_presentation/providers/gestion_notificaciones_provider.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/0_entity/recommendation.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/1_domain/recommendations_repository.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/2_presentation/providers/recommendations_provider.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

bool _isTablet(final BuildContext context) => isTabletLayout(context);

/// Authenticated home screen — Figma node 43716:13302 "Inicio".
///
/// Composed of:
/// - [AppNavBar] (type inicio, logged in, with notifications + avatar)
/// - Content area (light blue-lighter background)
/// - [AppBottomTabBar] (5 tabs: Inicio, Gestión, Mi Carpeta, Agenda, Recomendados)
/// - [AppFab] (ID card icon, bottom-right)
class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  bool _isCardsFabExpanded = false;
  bool _isLoadingDigitalCards = false;
  bool? _hasDigitalCardsAuthorization;
  bool _digitalCardsLoadFailed = false;
  List<DigitalCard> _availableDigitalCards = const [];

  @override
  void initState() {
    super.initState();
    unawaited(
      Future<void>.microtask(() async {
        if (mounted) {
          await _preloadDigitalCards();
        }
      }),
    );
  }

  void _showComingSoon() {
    AppAlertSnackbar.show(
      context,
      message: AppLocalizations.of(context).gestionSectionComingSoon,
    );
  }

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      appBar: AppNavBar(
        type: AppNavBarType.inicio,
        isLoggedIn: true,
        showNotifications: false,
        profileInitials: authenticatedProfileInitials(ref),
        onAvatarTap: () => showAuthenticatedProfileMenu(context: context, ref: ref),
        onNotificationsTap: _goToNotifications,
      ),
      body: _HomeDashboard(onComingSoon: _showComingSoon),
      floatingActionButton: _HomeDigitalCardsFab(
        isExpanded: _isCardsFabExpanded,
        cards: _availableDigitalCards,
        onToggle: _toggleDigitalCardsFab,
        onShowAll: _goToDigitalCards,
        onCardSelected: (final card) => unawaited(_showCardDownload(card)),
      ),
    );
  }

  Future<void> _preloadDigitalCards() async {
    setState(() {
      _isLoadingDigitalCards = true;
      _digitalCardsLoadFailed = false;
    });
    try {
      final isAuthorized = await ref.read(
        digitalCardsAuthorizationProvider.future,
      );
      if (!mounted) {
        return;
      }
      _hasDigitalCardsAuthorization = isAuthorized;
      if (!isAuthorized) {
        return;
      }

      ref.invalidate(digitalCardsProvider);
      final cards = [...await ref.read(digitalCardsProvider.future)]
        ..sort(
          (final a, final b) => _cardOrder(a.type).compareTo(_cardOrder(b.type)),
        );
      if (mounted) {
        setState(() => _availableDigitalCards = cards);
      }
    } catch (_) {
      if (mounted) {
        setState(() => _digitalCardsLoadFailed = true);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoadingDigitalCards = false);
      }
    }
  }

  void _toggleDigitalCardsFab() {
    if (_isCardsFabExpanded) {
      setState(() => _isCardsFabExpanded = false);
      return;
    }
    if (_isLoadingDigitalCards) {
      AppAlertSnackbar.show(
        context,
        message: AppLocalizations.of(context).homeCardsFabLoadingMessage,
      );
      return;
    }
    if (_hasDigitalCardsAuthorization == false) {
      _goToDigitalCards();
      return;
    }
    if (_digitalCardsLoadFailed) {
      AppAlertSnackbar.show(
        context,
        message: AppLocalizations.of(context).homeCardsFabLoadFailedMessage,
        severity: AppAlertSeverity.error,
      );
      return;
    }
    if (_availableDigitalCards.isEmpty) {
      AppAlertSnackbar.show(
        context,
        message: AppLocalizations.of(context).homeCardsFabEmptyMessage,
      );
      return;
    }
    setState(() => _isCardsFabExpanded = true);
  }

  int _cardOrder(final DigitalCardType type) => switch (type) {
    DigitalCardType.youth => 0,
    DigitalCardType.largeFamily => 1,
    DigitalCardType.disability => 2,
  };

  void _goToDigitalCards() {
    setState(() => _isCardsFabExpanded = false);
    context.go(Routes.digitalCards);
  }

  Future<void> _showCardDownload(final DigitalCard card) async {
    setState(() => _isCardsFabExpanded = false);
    await showDigitalCardDownloadSheet(context, ref, card);
  }

  void _goToNotifications() {
    context.go(
      Uri(
        path: Routes.gestionNotificaciones,
        queryParameters: const {'from': 'home'},
      ).toString(),
    );
  }
}

class _HomeDigitalCardsFab extends StatelessWidget {
  const _HomeDigitalCardsFab({
    required this.isExpanded,
    required this.cards,
    required this.onToggle,
    required this.onShowAll,
    required this.onCardSelected,
  });

  final bool isExpanded;
  final List<DigitalCard> cards;
  final VoidCallback onToggle;
  final VoidCallback onShowAll;
  final ValueChanged<DigitalCard> onCardSelected;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (isExpanded) ...[
          ..._cardButtons(l10n),
          _rightAlignedAction(
            _DigitalCardFabAction(
              label: l10n.homeCardsFabShowAll,
              onPressed: onShowAll,
            ),
          ),
          const SizedBox(height: AppDimensions.space8),
        ],
        AppFab(
          iconAsset: AppIconAssets.idCard,
          label: isExpanded ? null : l10n.homeCardsFabLabel,
          onPressed: onToggle,
          semanticsLabel: isExpanded ? l10n.homeCardsFabCollapseSemantics : l10n.homeCardsFabExpandSemantics,
        ),
      ],
    );
  }

  List<Widget> _cardButtons(final AppLocalizations l10n) {
    return [
      for (final card in cards) ...[
        _rightAlignedAction(
          _DigitalCardFabAction(
            label: _cardLabel(l10n, card.type),
            onPressed: () => onCardSelected(card),
          ),
        ),
        const SizedBox(height: AppDimensions.space8),
      ],
    ];
  }

  Widget _rightAlignedAction(final Widget child) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [child],
    );
  }

  String _cardLabel(final AppLocalizations l10n, final DigitalCardType type) => switch (type) {
    DigitalCardType.youth => l10n.digitalCardsTypeJoven,
    DigitalCardType.largeFamily => l10n.digitalCardsTypeFamiliaNumerosa,
    DigitalCardType.disability => l10n.digitalCardsTypeDiscapacidad,
  };
}

class _DigitalCardFabAction extends StatelessWidget {
  const _DigitalCardFabAction({
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(final BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(AppDimensions.radiusRound),
        border: Border.all(
          color: AppColors.primary,
          width: 2,
        ),
        boxShadow: AppShadows.medium,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppDimensions.radiusRound),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(AppDimensions.radiusRound),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minWidth: AppDimensions.minTouchTarget,
              minHeight: AppDimensions.minTouchTarget,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.space16,
                vertical: AppDimensions.space8,
              ),
              child: Center(
                child: Text(
                  label,
                  style: AppTypography.bodyRegular.copyWith(
                    color: AppColors.textBlack,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HomeDashboard extends StatelessWidget {
  const _HomeDashboard({required this.onComingSoon});

  final VoidCallback onComingSoon;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppColors.backgroundBlueLighter,
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: appPagePadding(context, top: AppDimensions.space24, bottom: 112),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _HomeNewsSection(),
              _SectionTitle(text: l10n.homeMyDataAccessesTitle),
              SizedBox(height: _isTablet(context) ? AppDimensions.space24 : AppDimensions.space8),
              _QuickAccessGrid(onComingSoon: onComingSoon),
              const SizedBox(height: AppDimensions.space24),
              const _HomeRecommendationsSection(),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.text});

  final String text;

  @override
  Widget build(final BuildContext context) {
    return Text(
      text,
      style: AppTypography.h3.copyWith(color: AppColors.textBlack),
    );
  }
}

class _HomeNewsSection extends ConsumerWidget {
  const _HomeNewsSection();

  static const _pendingNotificationStatus = NotificacionEstado.pendiente;

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final notifications = ref.watch(gestionNotificacionesProvider(_pendingNotificationStatus));
    final agenda = ref.watch(agendaAppointmentsProvider);
    final notificationsCount = notifications.maybeWhen(
      data: (final values) => values.length,
      orElse: () => null,
    );
    final upcomingAppointmentsCount = agenda.maybeWhen(
      data: (final state) {
        final now = DateTime.now();
        return state.appointments
            .where(
              (final appointment) => !appointment.dateTime.isBefore(now),
            )
            .length;
      },
      orElse: () => null,
    );

    final muestraNotificaciones = _isTablet(context) || notificationsCount == null || notificationsCount > 0;
    final muestraCitas = _isTablet(context) || upcomingAppointmentsCount == null || upcomingAppointmentsCount > 0;

    if (!muestraNotificaciones && !muestraCitas) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle(text: l10n.homeNewsSectionTitle),
        SizedBox(height: _isTablet(context) ? AppDimensions.space24 : AppDimensions.space8),
        if (muestraNotificaciones)
          AppSimpleNavCard(
            label: _labelWithCount(l10n, l10n.homeNewsNotificationsTitle, notificationsCount),
            description: l10n.homeNewsNotificationsDescription,
            onTap: () => context.go(
              Uri(
                path: Routes.gestionNotificaciones,
                queryParameters: const {'from': 'home'},
              ).toString(),
            ),
          ),
        if (muestraCitas) ...[
          if (muestraNotificaciones) SizedBox(height: _isTablet(context) ? AppDimensions.space16 : AppDimensions.space8),
          AppSimpleNavCard(
            label: _labelWithCount(l10n, l10n.homeNewsAppointmentsTitle, upcomingAppointmentsCount),
            description: l10n.homeNewsAppointmentsDescription,
            onTap: () => context.go(Routes.agenda),
          ),
        ],
        const SizedBox(height: AppDimensions.space24),
      ],
    );
  }

  String _labelWithCount(final AppLocalizations l10n, final String label, final int? count) {
    return count == null ? label : l10n.homeNewsLabelWithCount(label, count);
  }
}

class _QuickAccessGrid extends StatelessWidget {
  const _QuickAccessGrid({required this.onComingSoon});

  final VoidCallback onComingSoon;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final items = [
      _QuickAccessItem(
        label: l10n.myDataHealthTitle,
        iconAsset: AppIconAssets.heartCheck,
        route: Routes.myDataHealth,
      ),
      _QuickAccessItem(
        label: l10n.myDataSocialWelfareTitle,
        iconAsset: AppIconAssets.personCelebrate,
        route: Routes.myDataSocialWelfare,
      ),
      _QuickAccessItem(
        label: l10n.myDataEmploymentTitle,
        icon: AppIcons.work,
        route: Routes.myDataEmployment,
      ),
      _QuickAccessItem(
        label: l10n.myDataEducationTitle,
        icon: AppIcons.school,
        route: Routes.myDataEducation,
      ),
      _QuickAccessItem(
        label: l10n.myDataHousingTitle,
        icon: AppIcons.cottage,
        route: Routes.myDataHousing,
      ),
      _QuickAccessItem(
        label: l10n.myDataVehiclesTitle,
        icon: AppIcons.directionsCar,
        route: Routes.myDataVehicles,
      ),
    ];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _isTablet(context) ? 6 : 3,
        mainAxisExtent: _isTablet(context) ? 180 + (MediaQuery.textScalerOf(context).scale(16) - 16) * 4 : null,
        mainAxisSpacing: AppDimensions.space8,
        crossAxisSpacing: AppDimensions.space8,
        childAspectRatio: 0.73,
      ),
      itemBuilder: (final context, final index) {
        final item = items[index];
        return AppQuickAccessCard(
          label: item.label,
          icon: item.icon,
          iconAsset: item.iconAsset,
          onTap: () {
            final route = item.route;
            if (route == null) {
              onComingSoon();
              return;
            }
            unawaited(
              context.push(
                Uri(
                  path: route,
                  queryParameters: const {'from': 'home'},
                ).toString(),
              ),
            );
          },
        );
      },
    );
  }
}

class _HomeRecommendationsSection extends ConsumerStatefulWidget {
  const _HomeRecommendationsSection();

  @override
  ConsumerState<_HomeRecommendationsSection> createState() => _HomeRecommendationsSectionState();
}

class _HomeRecommendationsSectionState extends ConsumerState<_HomeRecommendationsSection> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollBy(final double direction, final double step) {
    if (!_scrollController.hasClients) {
      return;
    }
    final target = (_scrollController.offset + direction * step).clamp(0.0, _scrollController.position.maxScrollExtent);
    unawaited(_scrollController.animateTo(target, duration: const Duration(milliseconds: 250), curve: Curves.easeOut));
  }

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(
      recommendationsProvider(RecommendationsSegment.all),
    );
    return state.maybeWhen(
      data: (final data) {
        if (!data.hasLifeEventsConsent || data.recommendations.isEmpty) {
          return const SizedBox.shrink();
        }

        final recommendations = data.recommendations.take(5).toList(growable: false);
        return LayoutBuilder(
          builder: (final context, final constraints) {
            final tablet = _isTablet(context);
            final cardWidth = tablet ? (constraints.maxWidth - AppDimensions.space16) / 2 : 288.0;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SectionTitle(text: l10n.homeRecommendedProceduresTitle),
                SizedBox(height: tablet ? AppDimensions.space24 : AppDimensions.space8),
                SingleChildScrollView(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  clipBehavior: tablet ? Clip.hardEdge : Clip.none,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (var index = 0; index < recommendations.length; index++) ...[
                        SizedBox(
                          width: cardWidth,
                          child: _RecommendedProcedureCard(recommendation: recommendations[index]),
                        ),
                        if (index < recommendations.length - 1) const SizedBox(width: AppDimensions.space16),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: AppDimensions.space8),
                Row(
                  children: [
                    SizedBox(
                      width: tablet ? cardWidth : constraints.maxWidth - 112,
                      child: DecoratedBox(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(AppDimensions.radiusXs)),
                          boxShadow: AppShadows.low,
                        ),
                        child: AppButton(
                          label: l10n.homeGoToRecommendationsButton,
                          hierarchy: AppButtonHierarchy.secondary,
                          isExpanded: true,
                          onPressed: () => context.go(Routes.recommendations),
                        ),
                      ),
                    ),
                    SizedBox(width: tablet ? AppDimensions.space16 : AppDimensions.space8),
                    _carouselArrow(context, forward: false, step: cardWidth + AppDimensions.space16),
                    const SizedBox(width: AppDimensions.space8),
                    _carouselArrow(context, forward: true, step: cardWidth + AppDimensions.space16),
                  ],
                ),
              ],
            );
          },
        );
      },
      orElse: () => const SizedBox.shrink(),
    );
  }

  Widget _carouselArrow(final BuildContext context, {required final bool forward, required final double step}) => DecoratedBox(
    decoration: const BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(AppDimensions.radiusXs)),
      boxShadow: AppShadows.low,
    ),
    child: Material(
      color: AppColors.backgroundLightBlue,
      borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
      child: IconButton(
        tooltip: forward ? MaterialLocalizations.of(context).nextPageTooltip : MaterialLocalizations.of(context).previousPageTooltip,
        onPressed: () => _scrollBy(forward ? 1 : -1, step),
        constraints: const BoxConstraints.tightFor(width: 48, height: 48),
        icon: AppIcon(forward ? AppIcons.arrowForward : AppIcons.arrowBack, color: AppColors.textPrimary),
      ),
    ),
  );
}

class _RecommendedProcedureCard extends StatelessWidget {
  const _RecommendedProcedureCard({required this.recommendation});

  final Recommendation recommendation;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final lifeEventName = recommendation.lifeEventName.trim();
    return AppRecommendationCard(
      onTap: () => unawaited(_openRecommendationDetail(context, recommendation)),
      title: recommendation.title,
      titleMaxLines: _isTablet(context) ? 3 : null,
      categoryLabels: _categoryLabels(context, recommendation.badges),
      detailLabel: l10n.recommendationsAssociatedLifeEventsLabel,
      detailText: lifeEventName.isEmpty ? l10n.homeBlockLastUpdatedUnknown : lifeEventName,
    );
  }
}

List<String> _categoryLabels(
  final BuildContext context,
  final Set<RecommendationBadge> badges,
) {
  final l10n = AppLocalizations.of(context);
  return [
    if (badges.contains(RecommendationBadge.recent)) l10n.recommendationsTabRecent,
    if (badges.contains(RecommendationBadge.news)) l10n.recommendationsTabNew,
    if (badges.contains(RecommendationBadge.immediate)) l10n.recommendationsImmediateBadge,
  ];
}

Future<void> _openRecommendationDetail(
  final BuildContext context,
  final Recommendation recommendation,
) async {
  final l10n = AppLocalizations.of(context);
  final url = recommendation.detailUrl;
  if (url == null || !url.hasScheme) {
    AppAlertSnackbar.show(context, message: l10n.recommendationsDetailUnavailable);
    return;
  }

  await launchExternalUrlWithConfirmation(context, url);
}

class _QuickAccessItem {
  const _QuickAccessItem({
    required this.label,
    this.icon,
    this.iconAsset,
    this.route,
  }) : assert(
         (icon == null) != (iconAsset == null),
         'Provide exactly one of icon or iconAsset',
       );

  final String label;
  final IconData? icon;
  final String? iconAsset;
  final String? route;
}
