import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Resolves a sitemap node's [titleKey] (and the external-link display
/// keys it may reference) into a localised string.
///
/// Kept in the presentation layer so entities/domain/data never depend
/// on a `BuildContext` (canon §11–§13).
String resolveSitemapKey(final AppLocalizations l10n, final String key) {
  switch (key) {
    // groups
    case 'sitemapGroupAuthenticated':
      return l10n.sitemapGroupAuthenticated;
    case 'sitemapGroupThematic':
      return l10n.sitemapGroupThematic;
    case 'sitemapGroupHelpLegal':
      return l10n.sitemapGroupHelpLegal;
    case 'sitemapGroupExternal':
      return l10n.sitemapGroupExternal;
    // authenticated
    case 'sitemapHome':
      return l10n.sitemapHome;
    case 'sitemapAgenda':
      return l10n.sitemapAgenda;
    case 'sitemapCasework':
      return l10n.sitemapCasework;
    case 'sitemapNotifications':
      return l10n.sitemapNotifications;
    case 'sitemapCards':
      return l10n.sitemapCards;
    case 'sitemapRecommendations':
      return l10n.sitemapRecommendations;
    case 'sitemapSupport':
      return l10n.sitemapSupport;
    case 'sitemapProfile':
      return l10n.sitemapProfile;
    // thematic
    case 'sitemapEducation':
      return l10n.sitemapEducation;
    case 'sitemapEmployment':
      return l10n.sitemapEmployment;
    case 'sitemapSocialWelfare':
      return l10n.sitemapSocialWelfare;
    case 'sitemapStateAffairs':
      return l10n.sitemapStateAffairs;
    // help / legal
    case 'sitemapHelp':
      return l10n.sitemapHelp;
    case 'legalTermsTitle':
      return l10n.legalTermsTitle;
    case 'legalPrivacyTitle':
      return l10n.legalPrivacyTitle;
    case 'legalAccessibilityTitle':
      return l10n.legalAccessibilityTitle;
    case 'legalNoticeTitle':
      return l10n.legalNoticeTitle;
    // external display keys
    case 'externalLinkEducamosClmLabel':
      return l10n.externalLinkEducamosClmLabel;
    case 'externalLinkEmpleoClmLabel':
      return l10n.externalLinkEmpleoClmLabel;
    case 'externalLinkEmpleoPublicoClmLabel':
      return l10n.externalLinkEmpleoPublicoClmLabel;
    case 'externalLinkSedeDgtLabel':
      return l10n.externalLinkSedeDgtLabel;
    case 'externalLinkCarpetaCiudadanaAgeLabel':
      return l10n.externalLinkCarpetaCiudadanaAgeLabel;
    case 'externalLinkHistoriaSocialUnicaLabel':
      return l10n.externalLinkHistoriaSocialUnicaLabel;
    case 'externalLinkBienestarSocialClmLabel':
      return l10n.externalLinkBienestarSocialClmLabel;
    case 'externalLinkInfanciaFamiliasLabel':
      return l10n.externalLinkInfanciaFamiliasLabel;
    default:
      return key;
  }
}
