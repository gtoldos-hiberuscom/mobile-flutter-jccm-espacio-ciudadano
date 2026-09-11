import 'package:jccm_espacio_ciudadano/features/landing/0_entity/landing_content.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Builds the static [LandingContent] for the public landing screen.
///
/// Content is hardcoded for this sprint — no network call is required. Texts
/// come from [AppLocalizations], so callers must invoke this where a
/// localization instance is available (e.g. from a widget's `BuildContext`).
LandingContent landingContent(final AppLocalizations l10n) {
  return LandingContent(
    appTitle: l10n.landingTitle,
    tagline: l10n.landingContentTagline,
    features: [
      LandingFeatureItem(
        icon: 'notifications',
        title: l10n.landingFeatureNotificationsTitle,
        description: l10n.landingFeatureNotificationsDescription,
      ),
      LandingFeatureItem(
        icon: 'health',
        title: l10n.landingFeatureHealthTitle,
        description: l10n.landingFeatureHealthDescription,
      ),
      LandingFeatureItem(
        icon: 'work',
        title: l10n.landingFeatureEmploymentTitle,
        description: l10n.landingFeatureEmploymentDescription,
      ),
      LandingFeatureItem(
        icon: 'assignment',
        title: l10n.landingFeatureProceduresTitle,
        description: l10n.landingFeatureProceduresDescription,
      ),
      LandingFeatureItem(
        icon: 'badge',
        title: l10n.landingFeatureDigitalCardsTitle,
        description: l10n.landingFeatureDigitalCardsDescription,
      ),
      LandingFeatureItem(
        icon: 'map',
        title: l10n.landingFeatureCadastreTitle,
        description: l10n.landingFeatureCadastreDescription,
      ),
    ],
    accessSteps: [
      LandingAccessStep(
        stepNumber: 1,
        title: l10n.landingAccessStep1Title,
        description: l10n.landingAccessStep1Description,
      ),
      LandingAccessStep(
        stepNumber: 2,
        title: l10n.landingAccessStep2Title,
        description: l10n.landingAccessStep2Description,
      ),
      LandingAccessStep(
        stepNumber: 3,
        title: l10n.landingAccessStep3Title,
        description: l10n.landingAccessStep3Description,
      ),
    ],
    links: const LandingLinks(
      helpUrl: 'https://www.jccm.es/ciudadanos/ayuda',
      accessibilityUrl: 'https://www.jccm.es/accesibilidad',
      legalUrl: 'https://www.jccm.es/aviso-legal',
      privacyUrl: 'https://www.jccm.es/proteccion-datos',
    ),
  );
}
