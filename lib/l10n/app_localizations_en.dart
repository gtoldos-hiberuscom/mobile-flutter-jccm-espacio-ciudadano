// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Citizen Space CLM';

  @override
  String get landingTitle => 'Citizen Space';

  @override
  String get landingTagline => 'Your public information in one place';

  @override
  String get landingCtaButton => 'Access with Cl@ve';

  @override
  String get landingWhatYouFindTitle => 'What you\'ll find';

  @override
  String get landingHowToAccessTitle => 'How to access';

  @override
  String get landingFooterHelp => 'Help';

  @override
  String get landingFooterAccessibility => 'Accessibility';

  @override
  String get landingFooterLegal => 'Legal notice';

  @override
  String get landingFooterPrivacy => 'Data protection';

  @override
  String get loginPageTitle => 'Signing in with Cl@ve';

  @override
  String get loginPageLoading => 'Starting authentication...';

  @override
  String get loginPageError => 'Sign-in error';

  @override
  String get loginRetryButton => 'Try again';

  @override
  String get logoutConfirm => 'Sign out?';

  @override
  String get sessionExpired => 'Your session has expired';

  @override
  String get consentPageTitle => 'Terms of Use';

  @override
  String get consentPageSubtitle => 'Personal data protection';

  @override
  String get consentPageBody => 'In accordance with Regulation (EU) 2016/679 of the European Parliament and of the Council (GDPR) and Organic Law 3/2018 on Personal Data Protection and guarantee of digital rights (LOPDGDD), the Government of Castilla-La Mancha informs you that the personal data collected through this application will be processed under the responsibility of the Government of Castilla-La Mancha, in order to provide you with the e-government services included in the Citizen Space.\n\nIn accordance with Law 3/2017 of the Government of Castilla-La Mancha, you have the right to access, rectify and delete your data, as well as to exercise the other rights recognised in applicable regulations, by writing to the Secretary General of the Government of Castilla-La Mancha.\n\nTo continue using the application you must accept these terms of use and data protection conditions. If you do not accept, the application will close.';

  @override
  String get consentPagePrivacyLink => 'View full privacy policy';

  @override
  String get consentAcceptButton => 'Accept and continue';

  @override
  String get consentRejectButton => 'Reject and exit';

  @override
  String get consentPageSemantics => 'Terms of use acceptance screen';

  @override
  String legalPageLastUpdated(String date) {
    return 'Last updated: $date';
  }

  @override
  String get legalTermsTitle => 'Terms of use';

  @override
  String get legalPrivacyTitle => 'Privacy policy';

  @override
  String get legalAccessibilityTitle => 'Accessibility';

  @override
  String get legalNoticeTitle => 'Legal notice';

  @override
  String get legalContentSemantics => 'Legal content';

  @override
  String get helpPageTitle => 'Help';

  @override
  String get helpTabFaq => 'FAQ';

  @override
  String get helpTabGuides => 'Guides';

  @override
  String get helpTabContact => 'Contact';

  @override
  String get helpFaqSearch => 'Search FAQ…';

  @override
  String get helpGuideExternalLink => 'View external resource';

  @override
  String get helpContactCall => 'Call';

  @override
  String get helpContactEmail => 'Send email';

  @override
  String get helpContactVisit => 'Visit';
}
