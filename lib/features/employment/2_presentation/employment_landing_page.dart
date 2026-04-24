import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/app/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/core/analytics/analytics_event.dart';
import 'package:jccm_espacio_ciudadano/core/analytics/analytics_provider.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/domain_section.dart';
import 'package:jccm_espacio_ciudadano/core/extensions/date_time_format.dart';
import 'package:jccm_espacio_ciudadano/core/ui_states/empty_state_widget.dart';
import 'package:jccm_espacio_ciudadano/core/ui_states/error_state_widget.dart';
import 'package:jccm_espacio_ciudadano/core/ui_states/loading_state_widget.dart';
import 'package:jccm_espacio_ciudadano/features/employment/0_entity/employment_seeker_status.dart';
import 'package:jccm_espacio_ciudadano/features/employment/0_entity/employment_snapshot.dart';
import 'package:jccm_espacio_ciudadano/features/employment/1_domain/employment_landing_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/external_links/2_presentation/widgets/external_link_card.dart';
import 'package:jccm_espacio_ciudadano/features/external_links/2_presentation/widgets/external_links_section.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Empleo landing (STORY-24).
///
/// Composes the demandante de empleo card (real SEPE shape, mocked in
/// Sprint 3) plus the TASK-27 EXTERNAL_LINK card for "inscripciones en
/// ofertas" (no fake list rendered) and the bottom external-links
/// section pointing to Empleo CLM and Empleo público CLM.
class EmploymentLandingPage extends ConsumerStatefulWidget {
  const EmploymentLandingPage({super.key});

  @override
  ConsumerState<EmploymentLandingPage> createState() => _EmploymentLandingPageState();
}

class _EmploymentLandingPageState extends ConsumerState<EmploymentLandingPage> {
  static const String _domainId = 'employment';
  bool _viewedLogged = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_viewedLogged) {
        return;
      }
      _viewedLogged = true;
      ref.read(analyticsServiceProvider).logEvent(const DomainLandingViewedEvent(domain: _domainId));
    });
  }

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final asyncSnapshot = ref.watch(employmentLandingProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.employmentTitle)),
      body: RefreshIndicator(
        onRefresh: () => ref.read(employmentLandingProvider.notifier).refresh(),
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
                  onRetry: () => ref.read(employmentLandingProvider.notifier).refresh(),
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
    final EmploymentSnapshot snap,
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
                l10n.employmentTitle,
                style: theme.textTheme.headlineSmall,
              ),
              const SizedBox(height: AppDimensions.space8),
              Text(
                l10n.employmentHeaderDescription,
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        DomainSection(
          title: l10n.employmentSeekerTitle,
          subtitle: l10n.employmentSeekerSource,
          child: _SeekerCard(section: snap.seekerStatus),
        ),
        // TASK-27 decision: EXTERNAL_LINK — inscripciones en ofertas
        // ships as an outbound card pointing at Empleo CLM (no fake list,
        // no fake API call). See documentation/discovery/TASK-27-*.md
        DomainSection(
          title: l10n.employmentOffersTitle,
          child: ExternalLinkCard(
            title: l10n.employmentOffersTitle,
            description: l10n.employmentOffersDescription,
            linkId: 'empleo_clm',
          ),
        ),
        const ExternalLinksSection(
          linkIds: <String>[
            'empleo_clm',
            'empleo_publico_clm',
          ],
        ),
      ],
    );
  }
}

class _SeekerCard extends StatelessWidget {
  const _SeekerCard({required this.section});

  final EmploymentSection<EmploymentSeekerStatus> section;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    switch (section.status) {
      case EmploymentSectionStatus.loading:
        return LoadingStateWidget(message: l10n.loadingStateDefault);
      case EmploymentSectionStatus.empty:
        return EmptyStateWidget(message: l10n.employmentSeekerEmpty);
      case EmploymentSectionStatus.error:
        return ErrorStateWidget(message: l10n.employmentSeekerError);
      case EmploymentSectionStatus.loaded:
        final s = section.value!;
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.space16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _LabeledRow(
                  label: l10n.employmentSeekerEstadoLabel,
                  value: _localizeEstado(l10n, s.estado),
                ),
                _LabeledRow(
                  label: l10n.employmentSeekerInscripcionLabel,
                  value: s.fechaInscripcion.formatDdMmYyyy(),
                ),
                _LabeledRow(
                  label: l10n.employmentSeekerContinuidadLabel,
                  value: s.fechaContinuidad.formatDdMmYyyy(),
                ),
              ],
            ),
          ),
        );
    }
  }
}

String _localizeEstado(final AppLocalizations l10n, final String estado) {
  switch (estado) {
    case 'inscrito':
      return l10n.employmentSeekerEstadoInscrito;
    case 'no_inscrito':
      return l10n.employmentSeekerEstadoNoInscrito;
    case 'baja_temporal':
      return l10n.employmentSeekerEstadoBajaTemporal;
    default:
      return estado;
  }
}

class _LabeledRow extends StatelessWidget {
  const _LabeledRow({required this.label, required this.value});
  final String label;
  final String value;
  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.space2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 160,
            child: Text(
              label,
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.outline,
              ),
            ),
          ),
          Expanded(
            child: Text(value, style: theme.textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}
