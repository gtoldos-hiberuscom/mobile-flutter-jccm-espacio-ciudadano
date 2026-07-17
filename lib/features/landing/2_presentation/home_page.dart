import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/core/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/core/security/biometric_authenticator.dart';
import 'package:jccm_espacio_ciudadano/core/storage/app_storage.dart';
import 'package:jccm_espacio_ciudadano/core/storage/storage_keys.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/2_presentation/providers/agenda_appointments_provider.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/widgets/authenticated_profile_menu.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/0_entity/digital_card.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/2_presentation/digital_card_download_sheet.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/2_presentation/providers/digital_cards_provider.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/2_presentation/providers/gestion_notificaciones_provider.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/0_entity/recommendation.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/2_presentation/providers/recommendations_provider.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

final _biometricQuickAccessPromptShownInSessionProvider = NotifierProvider<_BiometricQuickAccessPromptSessionNotifier, bool>(
  _BiometricQuickAccessPromptSessionNotifier.new,
);

class _BiometricQuickAccessPromptSessionNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void markShown() => state = true;
}

/// Authenticated home screen — Figma node 43716:13302 "Inicio".
///
/// Composed of:
/// - [AppNavBar] (type inicio, logged in, with notifications + avatar)
/// - Content area (light blue-lighter background)
/// - [AppBottomTabBar] (5 tabs: Inicio, Gestión, Mi Carpeta, Agenda, Recomendados)
/// - [AppFab] (ID card icon, bottom-right)
/// - Shows the biometric quick-access dialog on first load.
class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  bool _biometricDialogShown = false;
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_biometricDialogShown) {
      _biometricDialogShown = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          unawaited(_handleInitialPrompts());
        }
      });
    }
  }

  Future<void> _handleInitialPrompts() async {
    await _showBiometricDialog();
  }

  Future<void> _showBiometricDialog() async {
    final appStorage = ref.read(appStorageProvider);
    final enabled = appStorage.read<bool>(StorageKeys.biometricQuickAccessEnabled) ?? false;
    final promptShownInSession = ref.read(_biometricQuickAccessPromptShownInSessionProvider);
    if (enabled || promptShownInSession) {
      return;
    }

    final hasBiometrics = await ref.read(biometricAuthenticatorProvider).canAuthenticateWithBiometrics();
    if (!mounted || !hasBiometrics) {
      return;
    }
    ref.read(_biometricQuickAccessPromptShownInSessionProvider.notifier).markShown();

    final accepted = await AppBiometricAccessDialog.show(context);

    if (!mounted) {
      return;
    }

    if (accepted != true) {
      return;
    }

    await appStorage.write(StorageKeys.biometricQuickAccessEnabled, true);
    if (!mounted) {
      return;
    }

    AppAlertToast.show(
      context,
      message: 'Acceso biométrico activado',
      severity: AppAlertSeverity.success,
    );
  }

  void _showComingSoon() {
    AppAlertSnackbar.show(
      context,
      message: 'Función disponible próximamente',
    );
  }

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      appBar: AppNavBar(
        type: AppNavBarType.inicio,
        isLoggedIn: true,
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
        message: 'Estamos consultando tus carnés digitales.',
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
        message: 'No hemos podido consultar tus carnés digitales.',
        severity: AppAlertSeverity.error,
      );
      return;
    }
    if (_availableDigitalCards.isEmpty) {
      AppAlertSnackbar.show(
        context,
        message: 'No tienes carnés digitales disponibles.',
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (isExpanded) ...[
          ..._cardButtons(),
          _rightAlignedAction(
            _DigitalCardFabAction(
              label: 'Mostrar todos',
              onPressed: onShowAll,
            ),
          ),
          const SizedBox(height: AppDimensions.space8),
        ],
        AppFab(
          iconAsset: AppIconAssets.idCard,
          iconSize: 16,
          onPressed: onToggle,
          semanticsLabel: isExpanded ? 'Cerrar accesos a carnés digitales' : 'Mostrar carnés digitales',
        ),
      ],
    );
  }

  List<Widget> _cardButtons() {
    return [
      for (final card in cards) ...[
        _rightAlignedAction(
          _DigitalCardFabAction(
            label: _cardLabel(card.type),
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

  String _cardLabel(final DigitalCardType type) => switch (type) {
    DigitalCardType.youth => 'Joven',
    DigitalCardType.largeFamily => 'Familia numerosa',
    DigitalCardType.disability => 'Discapacidad',
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
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppColors.backgroundBlueLighter,
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppDimensions.space16,
            AppDimensions.space24,
            AppDimensions.space16,
            112,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _HomeNewsSection(),
              const SizedBox(height: AppDimensions.space24),
              const _SectionTitle(text: 'Accesos “Mis datos”'),
              const SizedBox(height: AppDimensions.space8),
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

  static const _pendingNotificationStatus = 'pendiente';

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle(text: 'Mis novedades'),
        const SizedBox(height: AppDimensions.space8),
        AppSimpleNavCard(
          label: _labelWithCount('Notificaciones', notificationsCount),
          description: 'Consulta tus notificaciones pendientes',
          onTap: () => context.go(
            Uri(
              path: Routes.gestionNotificaciones,
              queryParameters: const {'from': 'home'},
            ).toString(),
          ),
        ),
        if (upcomingAppointmentsCount == null || upcomingAppointmentsCount > 0) ...[
          const SizedBox(height: AppDimensions.space8),
          AppSimpleNavCard(
            label: _labelWithCount('Próximas citas', upcomingAppointmentsCount),
            description: 'Revisa tus citas que tienes agendadas próximamente',
            onTap: () => context.go(Routes.agenda),
          ),
        ],
      ],
    );
  }

  String _labelWithCount(final String label, final int? count) {
    return count == null ? label : '$label ($count)';
  }
}

class _QuickAccessGrid extends StatelessWidget {
  const _QuickAccessGrid({required this.onComingSoon});

  final VoidCallback onComingSoon;

  static const _items = [
    _QuickAccessItem(
      label: 'Salud',
      icon: AppIcons.favorite,
      route: Routes.myDataHealth,
    ),
    _QuickAccessItem(
      label: 'Bienestar Social',
      icon: AppIcons.diversity,
      route: Routes.myDataSocialWelfare,
    ),
    _QuickAccessItem(
      label: 'Empleo',
      icon: AppIcons.work,
      route: Routes.myDataEmployment,
    ),
    _QuickAccessItem(
      label: 'Educación',
      icon: AppIcons.school,
      route: Routes.myDataEducation,
    ),
    _QuickAccessItem(
      label: 'Vivienda',
      icon: AppIcons.cottage,
      route: Routes.myDataHousing,
    ),
    _QuickAccessItem(
      label: 'Vehículos',
      icon: AppIcons.directionsCar,
      route: Routes.myDataVehicles,
    ),
  ];

  @override
  Widget build(final BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: AppDimensions.space8,
        crossAxisSpacing: AppDimensions.space8,
        childAspectRatio: 0.73,
      ),
      itemBuilder: (final context, final index) {
        final item = _items[index];
        return AppQuickAccessCard(
          label: item.label,
          icon: item.icon,
          onTap: () {
            final route = item.route;
            if (route == null) {
              onComingSoon();
              return;
            }
            context.go(
              Uri(
                path: route,
                queryParameters: const {'from': 'home'},
              ).toString(),
            );
          },
        );
      },
    );
  }
}

class _HomeRecommendationsSection extends ConsumerWidget {
  const _HomeRecommendationsSection();

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final state = ref.watch(recommendationsProvider);
    return state.maybeWhen(
      data: (final data) {
        if (!data.hasLifeEventsConsent || data.recommendations.isEmpty) {
          return const SizedBox.shrink();
        }

        final recommendations = data.recommendations.take(5).toList(growable: false);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SectionTitle(text: 'Trámites recomendados'),
            const SizedBox(height: AppDimensions.space8),
            SizedBox(
              height: 304,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                clipBehavior: Clip.none,
                itemCount: recommendations.length,
                separatorBuilder: (final context, final index) => const SizedBox(width: AppDimensions.space16),
                itemBuilder: (final context, final index) => SizedBox(
                  width: 288,
                  child: _RecommendedProcedureCard(recommendation: recommendations[index]),
                ),
              ),
            ),
          ],
        );
      },
      orElse: () => const SizedBox.shrink(),
    );
  }
}

class _RecommendedProcedureCard extends StatelessWidget {
  const _RecommendedProcedureCard({required this.recommendation});

  final Recommendation recommendation;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final responsibleUnit = recommendation.responsibleUnit;
    final deadline = _deadlineText(recommendation);
    final lifeEventName = recommendation.lifeEventName.trim();
    return AppRecommendationCard(
      onTap: () => unawaited(_openRecommendationDetail(context, recommendation)),
      title: recommendation.title,
      badge: _RecommendationBadge(badge: recommendation.badge),
      detailLabel: l10n.recommendationsAssociatedLifeEventsLabel,
      detailText: lifeEventName.isEmpty ? l10n.homeBlockLastUpdatedUnknown : lifeEventName,
      responsibleUnitText: responsibleUnit == null ? null : '${l10n.recommendationsResponsibleUnitPrefix} $responsibleUnit',
      deadlineText: deadline == null ? null : '${l10n.recommendationsDeadlinePrefix} $deadline',
    );
  }
}

class _RecommendationBadge extends StatelessWidget {
  const _RecommendationBadge({required this.badge});

  final RecommendationBadge badge;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return switch (badge) {
      RecommendationBadge.recent => AppTag(
        status: AppTagStatus.warning,
        label: l10n.recommendationsTabRecent,
        icon: AppIcons.hourglass,
        showIcon: false,
      ),
      RecommendationBadge.news => AppTag(
        status: AppTagStatus.infoActive,
        label: l10n.recommendationsTabNew,
        icon: AppIcons.autorenew,
        showIcon: false,
      ),
      RecommendationBadge.immediate => AppTag(
        status: AppTagStatus.success,
        label: l10n.recommendationsImmediateBadge,
        icon: AppIcons.check,
        showIcon: false,
      ),
    };
  }
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

  final accepted = await launchUrl(url, mode: LaunchMode.externalApplication);
  if (!context.mounted || accepted) {
    return;
  }
  AppAlertSnackbar.show(context, message: l10n.externalLinkOpenFailed);
}

String? _deadlineText(final Recommendation recommendation) {
  final start = recommendation.submissionStartDate;
  final end = recommendation.submissionEndDate;
  if (start == null && end == null) {
    return null;
  }
  if (start != null && end != null) {
    return '${_formatShortDate(start)} - ${_formatShortDate(end)}';
  }
  if (start != null) {
    return 'desde ${_formatShortDate(start)}';
  }
  return 'hasta ${_formatShortDate(end!)}';
}

String _formatShortDate(final DateTime date) {
  final day = date.day.toString().padLeft(2, '0');
  final month = date.month.toString().padLeft(2, '0');
  return '$day/$month/${date.year}';
}

class _QuickAccessItem {
  const _QuickAccessItem({
    required this.label,
    required this.icon,
    this.route,
  });

  final String label;
  final IconData icon;
  final String? route;
}
