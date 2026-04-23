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
  String get loadingStateDefault => 'Loading…';

  @override
  String get emptyStateDefault => 'No items';

  @override
  String get errorStateDefault => 'An error occurred';

  @override
  String get errorStateRetry => 'Retry';

  @override
  String get blockedStateDefault => 'Access not available';

  @override
  String get documentOpen => 'Open document';

  @override
  String get documentDownload => 'Download document';

  @override
  String get documentShare => 'Share document';

  @override
  String get loadMoreItems => 'Load more items';

  @override
  String get pullToRefresh => 'Pull to refresh';

  @override
  String userGreeting(String name) {
    return 'Hello, $name';
  }

  @override
  String get userMenuProfile => 'My profile';

  @override
  String get userMenuNotifications => 'Notifications';

  @override
  String get userMenuSettings => 'Settings';

  @override
  String get userMenuLogout => 'Log out';

  @override
  String get maintenanceTitle => 'Service under maintenance';

  @override
  String get maintenanceSubtitle => 'The service is temporarily unavailable.';

  @override
  String get maintenanceRetry => 'Retry';

  @override
  String get homeGreetingFallback => 'Welcome to Espacio Ciudadano';

  @override
  String homeCitizenId(String id) {
    return 'Citizen ID: $id';
  }

  @override
  String get homeBlockEducationTitle => 'Education';

  @override
  String get homeBlockEmploymentTitle => 'Employment';

  @override
  String get homeBlockSocialWelfareTitle => 'Social welfare';

  @override
  String get homeBlockStateAffairsTitle => 'State and other affairs';

  @override
  String get homeBlockAgendaTitle => 'Agenda';

  @override
  String get homeBlockUpcomingEventsTitle => 'Upcoming events';

  @override
  String get homeBlockCaseworkTitle => 'My casework';

  @override
  String get homeBlockNotificationsTitle => 'My notifications';

  @override
  String get homeBlockDigitalCardsTitle => 'My digital cards';

  @override
  String get homeBlockRecommendationsTitle => 'Recommendations';

  @override
  String get homeBlockEmpty => 'Nothing to show';

  @override
  String get homeBlockError => 'This block could not be loaded';

  @override
  String homeBlockCount(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString items',
      one: '1 item',
      zero: 'No items',
    );
    return '$_temp0';
  }

  @override
  String homeBlockLastUpdated(String time) {
    return 'Updated at $time';
  }

  @override
  String get homeBlockLastUpdatedUnknown => 'No update info';
}
