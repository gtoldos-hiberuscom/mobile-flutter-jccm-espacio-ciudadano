import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Maps the dynamic string keys used by the help-center entities to the
/// generated [AppLocalizations] getters.
///
/// Keeping this resolver in the presentation layer avoids leaking a
/// `BuildContext` or any localization dependency into `0_entity/`,
/// `1_domain/` or `3_data/` (canon §11–§13).
String resolveHelpKey(final AppLocalizations l10n, final String key) {
  switch (key) {
    // Categories
    case 'helpCategoryAccess':
      return l10n.helpCategoryAccess;
    case 'helpCategoryPrivacy':
      return l10n.helpCategoryPrivacy;
    case 'helpCategoryServices':
      return l10n.helpCategoryServices;

    // FAQ
    case 'helpFaqLoginClaveQ':
      return l10n.helpFaqLoginClaveQ;
    case 'helpFaqLoginClaveA':
      return l10n.helpFaqLoginClaveA;
    case 'helpFaqLoginProblemsQ':
      return l10n.helpFaqLoginProblemsQ;
    case 'helpFaqLoginProblemsA':
      return l10n.helpFaqLoginProblemsA;
    case 'helpFaqDataProtectionQ':
      return l10n.helpFaqDataProtectionQ;
    case 'helpFaqDataProtectionA':
      return l10n.helpFaqDataProtectionA;
    case 'helpFaqNotificationsQ':
      return l10n.helpFaqNotificationsQ;
    case 'helpFaqNotificationsA':
      return l10n.helpFaqNotificationsA;
    case 'helpFaqDocumentsQ':
      return l10n.helpFaqDocumentsQ;
    case 'helpFaqDocumentsA':
      return l10n.helpFaqDocumentsA;
    case 'helpFaqOfflineQ':
      return l10n.helpFaqOfflineQ;
    case 'helpFaqOfflineA':
      return l10n.helpFaqOfflineA;

    // Guides
    case 'helpGuideFirstStepsTitle':
      return l10n.helpGuideFirstStepsTitle;
    case 'helpGuideFirstStepsBody':
      return l10n.helpGuideFirstStepsBody;
    case 'helpGuideCarpetaAgeTitle':
      return l10n.helpGuideCarpetaAgeTitle;
    case 'helpGuideCarpetaAgeBody':
      return l10n.helpGuideCarpetaAgeBody;

    // Contacts
    case 'helpContact012PhoneLabel':
      return l10n.helpContact012PhoneLabel;
    case 'helpContactEmailSupportLabel':
      return l10n.helpContactEmailSupportLabel;
    case 'helpContactOfficesUrlLabel':
      return l10n.helpContactOfficesUrlLabel;

    default:
      // Defensive fallback — surfaces missing ARB entries during dev
      // without crashing production.
      assert(false, 'Missing help l10n key: $key');
      return key;
  }
}
