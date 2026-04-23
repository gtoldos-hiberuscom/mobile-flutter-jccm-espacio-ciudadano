import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/app/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/core/analytics/analytics_event.dart';
import 'package:jccm_espacio_ciudadano/core/analytics/analytics_provider.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/domain_section.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/placeholder_controlled_card.dart';
import 'package:jccm_espacio_ciudadano/core/ui_states/empty_state_widget.dart';
import 'package:jccm_espacio_ciudadano/core/ui_states/error_state_widget.dart';
import 'package:jccm_espacio_ciudadano/core/ui_states/loading_state_widget.dart';
import 'package:jccm_espacio_ciudadano/features/education/0_entity/education_snapshot.dart';
import 'package:jccm_espacio_ciudadano/features/education/0_entity/education_title.dart';
import 'package:jccm_espacio_ciudadano/features/education/1_domain/education_landing_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/external_links/2_presentation/widgets/external_links_section.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Educación landing (STORY-23).
///
/// Composes the university and non-university titles sections plus a
/// controlled "Próximamente" card for `condición de becado` (TASK-27
/// PLACEHOLDER_CONTROLLED decision — no fake state, no fake API call;
/// see `documentation/discovery/TASK-27-dashboard-contract-gaps.md`).
class EducationLandingPage extends ConsumerStatefulWidget {
  const EducationLandingPage({super.key});

  @override
  ConsumerState<EducationLandingPage> createState() =>
      _EducationLandingPageState();
}

class _EducationLandingPageState extends ConsumerState<EducationLandingPage> {
  static const String _domainId = 'education';
  bool _viewedLogged = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_viewedLogged) {
        return;
      }
      _viewedLogged = true;
      ref
          .read(analyticsServiceProvider)
          .logEvent(const DomainLandingViewedEvent(domain: _domainId));
    });
  }

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final asyncSnapshot = ref.watch(educationLandingProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.educationTitle)),
      body: RefreshIndicator(
        onRefresh: () =>
            ref.read(educationLandingProvider.notifier).refresh(),
        child: asyncSnapshot.when(
          loading: () => ListView(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.5,
                child: LoadingStateWidget(message: l10n.loadingStateDefault),
              ),
            ],
          ),
          error: (final err, final st) => ListView(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.5,
                child: ErrorStateWidget(
                  message: l10n.domainGenericLoadError,
                  onRetry: () => ref
                      .read(educationLandingProvider.notifier)
                      .refresh(),
                ),
              ),
            ],
          ),
          data: (final snap) => _buildBody(context, snap, l10n),
        ),
      ),
    );
  }

  Widget _buildBody(
    final BuildContext context,
    final EducationSnapshot snap,
    final AppLocalizations l10n,
  ) {
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.space12),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.space16,
            vertical: AppDimensions.space8,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.educationTitle,
                style: theme.textTheme.headlineSmall,
              ),
              const SizedBox(height: AppDimensions.space8),
              Text(
                l10n.educationHeaderDescription,
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        DomainSection(
          title: l10n.educationUniversityTitlesTitle,
          child: _TitlesCard(
            section: snap.universityTitles,
            emptyMessage: l10n.educationUniversityTitlesEmpty,
            errorMessage: l10n.educationUniversityTitlesError,
          ),
        ),
        DomainSection(
          title: l10n.educationNonUniversityTitlesTitle,
          child: _TitlesCard(
            section: snap.nonUniversityTitles,
            emptyMessage: l10n.educationNonUniversityTitlesEmpty,
            errorMessage: l10n.educationNonUniversityTitlesError,
          ),
        ),
        // TASK-27 decision: PLACEHOLDER_CONTROLLED — condición de becado
        // ships as a localized "Próximamente" card with an info tooltip
        // explaining the backend dependency. No fake state, no fake API.
        // See documentation/discovery/TASK-27-dashboard-contract-gaps.md
        DomainSection(
          title: l10n.educationScholarshipTitle,
          child: PlaceholderControlledCard(
            title: l10n.educationScholarshipTitle,
            badge: l10n.domainComingSoonBadge,
            tooltip: l10n.educationScholarshipTooltip,
            description: l10n.educationScholarshipDescription,
          ),
        ),
        const ExternalLinksSection(linkIds: <String>['educamos_clm']),
      ],
    );
  }
}

class _TitlesCard extends StatelessWidget {
  const _TitlesCard({
    required this.section,
    required this.emptyMessage,
    required this.errorMessage,
  });

  final EducationSection<List<EducationTitle>> section;
  final String emptyMessage;
  final String errorMessage;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    switch (section.status) {
      case EducationSectionStatus.loading:
        return LoadingStateWidget(message: l10n.loadingStateDefault);
      case EducationSectionStatus.empty:
        return EmptyStateWidget(message: emptyMessage);
      case EducationSectionStatus.error:
        return ErrorStateWidget(message: errorMessage);
      case EducationSectionStatus.loaded:
        final list = section.value!;
        if (list.isEmpty) {
          return EmptyStateWidget(message: emptyMessage);
        }
        return Column(
          children: [
            for (final t in list)
              Card(
                child: ListTile(
                  title: Text(t.titulacion),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(t.centro),
                      Text(l10n.educationTitleYear(t.year.toString())),
                    ],
                  ),
                ),
              ),
          ],
        );
    }
  }
}
