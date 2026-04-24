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
import 'package:jccm_espacio_ciudadano/features/external_links/2_presentation/widgets/external_link_card.dart';
import 'package:jccm_espacio_ciudadano/features/external_links/2_presentation/widgets/external_links_section.dart';
import 'package:jccm_espacio_ciudadano/features/social_welfare/0_entity/family_numerosa_title.dart';
import 'package:jccm_espacio_ciudadano/features/social_welfare/0_entity/social_welfare_snapshot.dart';
import 'package:jccm_espacio_ciudadano/features/social_welfare/1_domain/social_welfare_landing_notifier.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Bienestar Social landing (STORY-25).
///
/// Composes the familia numerosa card (real /ccaa/familia-numerosa
/// shape, mocked in Sprint 3) plus three TASK-27 EXTERNAL_LINK cards
/// for termalismo, tarjeta de estacionamiento and atención a la
/// dependencia. Real backend wiring for those three is not in scope:
/// they ship as outbound entries through the [ExternalLinkCatalog]
/// (STORY-28).
class SocialWelfareLandingPage extends ConsumerStatefulWidget {
  const SocialWelfareLandingPage({super.key});

  @override
  ConsumerState<SocialWelfareLandingPage> createState() => _SocialWelfareLandingPageState();
}

class _SocialWelfareLandingPageState extends ConsumerState<SocialWelfareLandingPage> {
  static const String _domainId = 'social_welfare';
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
    final asyncSnapshot = ref.watch(socialWelfareLandingProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.socialWelfareTitle)),
      body: RefreshIndicator(
        onRefresh: () => ref.read(socialWelfareLandingProvider.notifier).refresh(),
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
                  onRetry: () => ref.read(socialWelfareLandingProvider.notifier).refresh(),
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
    final SocialWelfareSnapshot snap,
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
                l10n.socialWelfareTitle,
                style: theme.textTheme.headlineSmall,
              ),
              const SizedBox(height: AppDimensions.space8),
              Text(
                l10n.socialWelfareHeaderDescription,
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        DomainSection(
          title: l10n.socialWelfareFamilyTitle,
          subtitle: l10n.socialWelfareFamilySource,
          child: _FamilyNumerosaCard(section: snap.familyNumerosa),
        ),
        // TASK-27 EXTERNAL_LINK — termalismo / balnearios
        DomainSection(
          title: l10n.socialWelfareTermalismoTitle,
          child: ExternalLinkCard(
            title: l10n.socialWelfareTermalismoTitle,
            description: l10n.socialWelfareTermalismoDescription,
            linkId: 'bienestar_social_clm',
          ),
        ),
        // TASK-27 EXTERNAL_LINK — tarjeta de estacionamiento.
        // TODO(product): confirm the canonical sede electrónica JCCM URL
        // for this trámite. Sprint-3 fallback uses Carpeta Ciudadana AGE.
        DomainSection(
          title: l10n.socialWelfareParkingTitle,
          child: ExternalLinkCard(
            title: l10n.socialWelfareParkingTitle,
            description: l10n.socialWelfareParkingDescription,
            linkId: 'carpeta_ciudadana_age',
          ),
        ),
        // TASK-27 EXTERNAL_LINK — atención a la dependencia.
        // TODO(product): confirm the canonical Atención a la Dependencia
        // landing. Sprint-3 currently routes through the JCCM Bienestar
        // Social portal entry added to the catalog as bienestar_social_clm.
        DomainSection(
          title: l10n.socialWelfareDependenciaTitle,
          child: ExternalLinkCard(
            title: l10n.socialWelfareDependenciaTitle,
            description: l10n.socialWelfareDependenciaDescription,
            linkId: 'bienestar_social_clm',
          ),
        ),
        const ExternalLinksSection(
          linkIds: <String>[
            'historia_social_unica',
            'infancia_familias',
          ],
        ),
      ],
    );
  }
}

class _FamilyNumerosaCard extends StatelessWidget {
  const _FamilyNumerosaCard({required this.section});

  final SocialWelfareSection<FamilyNumerosaTitle> section;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    switch (section.status) {
      case SocialWelfareSectionStatus.loading:
        return LoadingStateWidget(message: l10n.loadingStateDefault);
      case SocialWelfareSectionStatus.empty:
        return EmptyStateWidget(message: l10n.socialWelfareFamilyEmpty);
      case SocialWelfareSectionStatus.error:
        return ErrorStateWidget(message: l10n.socialWelfareFamilyError);
      case SocialWelfareSectionStatus.loaded:
        final t = section.value!;
        final theme = Theme.of(context);
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.space16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _LabeledRow(
                  label: l10n.socialWelfareFamilyNumberLabel,
                  value: t.numero,
                ),
                _LabeledRow(
                  label: l10n.socialWelfareFamilyCategoriaLabel,
                  value: _localizeCategoria(l10n, t.categoria),
                ),
                _LabeledRow(
                  label: l10n.socialWelfareFamilyCaducidadLabel,
                  value: t.fechaCaducidad.formatDdMmYyyy(),
                ),
                const SizedBox(height: AppDimensions.space12),
                Text(
                  l10n.socialWelfareFamilyBeneficiariosTitle,
                  style: theme.textTheme.titleSmall,
                ),
                const SizedBox(height: AppDimensions.space4),
                for (final b in t.beneficiarios)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppDimensions.space2,
                    ),
                    child: Text(
                      l10n.socialWelfareFamilyBeneficiarioLine(
                        _localizeRelacion(l10n, b.relacion),
                        b.fechaNacimiento.formatDdMmYyyy(),
                      ),
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
              ],
            ),
          ),
        );
    }
  }
}

String _localizeCategoria(final AppLocalizations l10n, final String value) {
  switch (value) {
    case 'general':
      return l10n.socialWelfareFamilyCategoriaGeneral;
    case 'especial':
      return l10n.socialWelfareFamilyCategoriaEspecial;
    default:
      return value;
  }
}

String _localizeRelacion(final AppLocalizations l10n, final String value) {
  switch (value) {
    case 'titular':
      return l10n.socialWelfareFamilyRelacionTitular;
    case 'conyuge':
      return l10n.socialWelfareFamilyRelacionConyuge;
    case 'hijo':
      return l10n.socialWelfareFamilyRelacionHijo;
    default:
      return value;
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
