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
import 'package:jccm_espacio_ciudadano/core/ui_states/paginated_list_view.dart';
import 'package:jccm_espacio_ciudadano/features/external_links/2_presentation/widgets/external_links_section.dart';
import 'package:jccm_espacio_ciudadano/features/state_affairs/0_entity/cadastral_property.dart';
import 'package:jccm_espacio_ciudadano/features/state_affairs/0_entity/residence_data.dart';
import 'package:jccm_espacio_ciudadano/features/state_affairs/0_entity/state_affairs_snapshot.dart';
import 'package:jccm_espacio_ciudadano/features/state_affairs/0_entity/vehicle.dart';
import 'package:jccm_espacio_ciudadano/features/state_affairs/1_domain/state_affairs_landing_notifier.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Estado y otros temas de interés landing (STORY-26).
///
/// Composes the residence (INE), cadastral (Catastro) and vehicles
/// (DGT) sections with per-section UI states and an external-links
/// section sourced from the external-link catalog. Sprint-3 baseline
/// ships against mocked repository data — real Dio wiring is owned by
/// a follow-up story.
class StateAffairsLandingPage extends ConsumerStatefulWidget {
  const StateAffairsLandingPage({super.key});

  @override
  ConsumerState<StateAffairsLandingPage> createState() =>
      _StateAffairsLandingPageState();
}

class _StateAffairsLandingPageState
    extends ConsumerState<StateAffairsLandingPage> {
  static const String _domainId = 'state_affairs';
  static const int _propertiesPageSize = 5;

  bool _viewedLogged = false;
  int _propertiesVisible = _propertiesPageSize;

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
    final asyncSnapshot = ref.watch(stateAffairsLandingProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.stateAffairsTitle)),
      body: RefreshIndicator(
        onRefresh: () => ref
            .read(stateAffairsLandingProvider.notifier)
            .refresh(),
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
                      .read(stateAffairsLandingProvider.notifier)
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
    final StateAffairsSnapshot snap,
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
                l10n.stateAffairsTitle,
                style: theme.textTheme.headlineSmall,
              ),
              const SizedBox(height: AppDimensions.space8),
              Text(
                l10n.stateAffairsHeaderDescription,
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        DomainSection(
          title: l10n.stateAffairsResidenceTitle,
          subtitle: l10n.stateAffairsResidenceSource,
          child: _ResidenceCard(section: snap.residence),
        ),
        DomainSection(
          title: l10n.stateAffairsPropertiesTitle,
          subtitle: l10n.stateAffairsPropertiesSource,
          child: _PropertiesCard(
            section: snap.properties,
            visibleCount: _propertiesVisible,
            onLoadMore: () => setState(
              () => _propertiesVisible += _propertiesPageSize,
            ),
          ),
        ),
        DomainSection(
          title: l10n.stateAffairsVehiclesTitle,
          subtitle: l10n.stateAffairsVehiclesSource,
          child: _VehiclesCard(section: snap.vehicles),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.space16,
            vertical: AppDimensions.space8,
          ),
          child: Text(
            l10n.stateAffairsDataDisclaimer,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.outline,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
        const ExternalLinksSection(linkIds: <String>[
          'sede_dgt',
          'carpeta_ciudadana_age',
        ]),
      ],
    );
  }
}

class _ResidenceCard extends StatelessWidget {
  const _ResidenceCard({required this.section});

  final StateAffairsSection<ResidenceData> section;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    switch (section.status) {
      case StateAffairsSectionStatus.loading:
        return LoadingStateWidget(message: l10n.loadingStateDefault);
      case StateAffairsSectionStatus.empty:
        return EmptyStateWidget(message: l10n.domainGenericLoadError);
      case StateAffairsSectionStatus.error:
        return ErrorStateWidget(message: l10n.domainGenericLoadError);
      case StateAffairsSectionStatus.loaded:
        final r = section.value!;
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.space16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _LabeledRow(
                  label: l10n.stateAffairsResidenceMunicipio,
                  value: r.municipio,
                ),
                _LabeledRow(
                  label: l10n.stateAffairsResidenceProvincia,
                  value: r.provincia,
                ),
                _LabeledRow(
                  label: l10n.stateAffairsResidenceComunidad,
                  value: r.comunidadAutonoma,
                ),
                if (r.direccion != null)
                  _LabeledRow(
                    label: l10n.stateAffairsResidenceDireccion,
                    value: r.direccion!,
                  ),
                if (r.codigoPostal != null)
                  _LabeledRow(
                    label: l10n.stateAffairsResidenceCp,
                    value: r.codigoPostal!,
                  ),
                const SizedBox(height: AppDimensions.space8),
                Text(
                  l10n.stateAffairsResidenceLastUpdated(
                    r.lastUpdatedAt.formatDdMmYyyy(),
                  ),
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ],
            ),
          ),
        );
    }
  }
}

class _PropertiesCard extends StatelessWidget {
  const _PropertiesCard({
    required this.section,
    required this.visibleCount,
    required this.onLoadMore,
  });

  final StateAffairsSection<List<CadastralProperty>> section;
  final int visibleCount;
  final VoidCallback onLoadMore;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    switch (section.status) {
      case StateAffairsSectionStatus.loading:
        return LoadingStateWidget(message: l10n.loadingStateDefault);
      case StateAffairsSectionStatus.empty:
        return EmptyStateWidget(message: l10n.stateAffairsPropertiesEmpty);
      case StateAffairsSectionStatus.error:
        return ErrorStateWidget(message: l10n.stateAffairsPropertiesError);
      case StateAffairsSectionStatus.loaded:
        final list = section.value!;
        if (list.isEmpty) {
          return EmptyStateWidget(message: l10n.stateAffairsPropertiesEmpty);
        }
        final visible = list.take(visibleCount).toList(growable: false);
        final hasMore = list.length > visibleCount;
        // Use PaginatedListView for >5 entries (STORY-26 AC: paginación).
        return PaginatedListView<CadastralProperty>(
          items: visible,
          hasMore: hasMore,
          onLoadMore: onLoadMore,
          padding: EdgeInsets.zero,
          itemBuilder: (final context, final p, final index) =>
              _PropertyTile(property: p),
        );
    }
  }
}

class _PropertyTile extends StatelessWidget {
  const _PropertyTile({required this.property});

  final CadastralProperty property;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Card(
      child: ListTile(
        title: Text(property.direccion),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.stateAffairsPropertiesTitularidad(property.titularidad)),
            Text(l10n.stateAffairsPropertiesSurface(
              property.superficieM2.toStringAsFixed(0),
            )),
            if (property.referenciaCatastral != null)
              Text(l10n.stateAffairsPropertiesReference(
                property.referenciaCatastral!,
              )),
          ],
        ),
      ),
    );
  }
}

class _VehiclesCard extends StatelessWidget {
  const _VehiclesCard({required this.section});

  final StateAffairsSection<List<Vehicle>> section;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    switch (section.status) {
      case StateAffairsSectionStatus.loading:
        return LoadingStateWidget(message: l10n.loadingStateDefault);
      case StateAffairsSectionStatus.empty:
        return EmptyStateWidget(message: l10n.stateAffairsVehiclesEmpty);
      case StateAffairsSectionStatus.error:
        return ErrorStateWidget(message: l10n.stateAffairsVehiclesError);
      case StateAffairsSectionStatus.loaded:
        final list = section.value!;
        if (list.isEmpty) {
          return EmptyStateWidget(message: l10n.stateAffairsVehiclesEmpty);
        }
        return Column(
          children: [
            for (final v in list)
              Card(
                child: ListTile(
                  title: Text('${v.marca} ${v.modelo}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.stateAffairsVehiclesPlate(v.matricula)),
                      Text(l10n.stateAffairsVehiclesFuel(v.combustible)),
                    ],
                  ),
                ),
              ),
          ],
        );
    }
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
            width: 140,
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
