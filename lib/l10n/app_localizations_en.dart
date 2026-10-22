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
  String get landingTagline => 'Access and consult the procedures and services available to the citizens of Castilla-La Mancha digitally.';

  @override
  String get landingTaglinePrefix => 'Access and consult the procedures and services available to the citizens of ';

  @override
  String get landingTaglineHighlight => 'Castilla-La Mancha digitally.';

  @override
  String landingAccessStepLabel(int stepNumber) {
    return 'Step $stepNumber';
  }

  @override
  String get landingCtaButton => 'Access your space';

  @override
  String get landingAboutButton => 'Learn more about Citizen Space';

  @override
  String get landingHelpLink => 'How to access?';

  @override
  String get landingDemoButton => 'Try the demo';

  @override
  String get demoConfirmTitle => 'Demo mode';

  @override
  String get demoConfirmBody => 'You will see the app with the fictitious data of an invented person, without signing in with Cl@ve. Nothing you do is sent to or stored in any real service. Sign out to leave.';

  @override
  String get demoConfirmEnter => 'Enter the demo';

  @override
  String get demoConfirmBack => 'Back';

  @override
  String get demoConfirmPersistedSessionBody => 'There is a session saved on this device with quick access. Entering the demo will close it first: to go back to your space you will need to sign in with Cl@ve again.';

  @override
  String get demoConfirmCloseSessionAndEnter => 'Close the saved session and enter';

  @override
  String get demoConfirmCodeLabel => 'Access code';

  @override
  String get demoConfirmCodeError => 'Incorrect code. Check the demo access code.';

  @override
  String get demoBannerLabel => 'DEMO';

  @override
  String get demoPersistedSessionNotice => 'There is a session saved on this device. Sign in with quick access and sign out before using the demo.';

  @override
  String get landingHelpPageTitle => 'How to access';

  @override
  String get landingHelpTitle => 'How to access';

  @override
  String get landingHelpBody1 => 'To access Citizen Space you must identify yourself with Cl@ve, the access system for public services. You can use Cl@ve Mobile, Cl@ve Permanent, electronic ID or an electronic certificate (personal or representative).';

  @override
  String get landingHelpAccessButton => 'Access my Citizen Space';

  @override
  String get landingHelpExternalLink => 'External link';

  @override
  String get landingAboutPageTitle => 'Learn more about Citizen Space';

  @override
  String get landingAboutTitle => 'Citizen space';

  @override
  String get landingAboutBodyPrefix => 'is the digital area where relevant information will appear with the aim of';

  @override
  String get landingAboutBodyBold => 'facilitating and improving your relationship with the regional Administration';

  @override
  String get landingAboutBodySuffix => 'in the procedures and processes in which you are involved or that may be of interest to you.';

  @override
  String get landingAboutBody => 'Citizen Space is a digital space where you can check your procedures, find others that may interest you, and access information and services that make it easier to interact with the Administration.';

  @override
  String get landingAboutWhatYouFindTitle => 'What can I check?';

  @override
  String get landingAboutWhatYouFindIntro => 'In Citizen Space you will find:';

  @override
  String get landingAboutBullet1 => 'Your personal information.';

  @override
  String get landingAboutBullet2 => 'Your cases and their processing status.';

  @override
  String get landingAboutBullet3 => 'Your notifications.';

  @override
  String get landingAboutBullet4 => 'Your digital cards.';

  @override
  String get landingAboutBullet5 => 'Your appointments and events.';

  @override
  String get landingAboutBullet6 => 'Personalized recommendations based on your interests.';

  @override
  String get landingAboutHelpLink => 'Show Help and contact information';

  @override
  String get landingAboutAccessButton => 'Access my Citizen Space';

  @override
  String get landingAboutExternalLink => 'External link';

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
  String get loginPageLoadingDescription => 'We are validating your identity and preparing your data. This may take a few seconds.';

  @override
  String get loginTimeoutError => 'Sign-in is taking too long. Please try again.';

  @override
  String get loginPageError => 'Sign-in error';

  @override
  String get logoutConfirm => 'Sign out?';

  @override
  String get sessionExpired => 'Your session has expired';

  @override
  String get consentPageTitle => 'Terms of Use';

  @override
  String get consentPageSubtitle => 'Personal data protection';

  @override
  String get consentPageBody => 'In accordance with Regulation (EU) 2016/679 of the European Parliament and of the Council (GDPR) and Organic Law 3/2018 on Personal Data Protection and guarantee of digital rights (LOPDGDD), the Government of Castilla-La Mancha informs you that the personal data collected through this application will be processed under the responsibility of the Government of Castilla-La Mancha, in order to provide you with the e-government services included in the Citizen Space.\n\nIn accordance with Law 3/2017 of the Government of Castilla-La Mancha, you have the right to access, rectify and delete your data, as well as to exercise the other rights recognised in applicable regulations, by writing to the Secretary General of the Government of Castilla-La Mancha.\n\nTo continue using the application you must accept these terms of use and data protection conditions. If you do not accept, your session will be closed and you will need to identify yourself again.';

  @override
  String get consentPagePrivacyLink => 'View full privacy policy';

  @override
  String get consentAcceptButton => 'Continue';

  @override
  String get consentRejectButton => 'Exit';

  @override
  String get consentPageSemantics => 'Terms of use acceptance screen';

  @override
  String get consentStep1FullTitle => 'Terms of use and authorisations';

  @override
  String get consentFinalAcceptButton => 'Continue';

  @override
  String get consentSaveError => 'Could not save your consent. Please try again.';

  @override
  String get consentClausesUnavailableError => 'The authorisations could not be loaded. Check your connection and try again.';

  @override
  String get consentClausesLoadError => 'The authorisations could not be loaded.';

  @override
  String get consentScrollHint => 'Scroll to the end to continue';

  @override
  String get consentLegalInfoSnackBar => 'Read the information about data processing and protection before continuing';

  @override
  String get consentInfoButtonSemantics => 'View full legal information';

  @override
  String get consentCloseButtonSemantics => 'Close and reject conditions';

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

  @override
  String get externalLinkA11yHint => 'Opens in external browser';

  @override
  String get externalLinkVisibleNotice => 'External link · Opens outside the application';

  @override
  String get externalLinkOpenFailed => 'The link could not be opened. Please try again later.';

  @override
  String get externalNavigationDialogTitle => 'You are about to leave the application';

  @override
  String get drawerElectronicOfficeDialogTitle => 'We are going to redirect you to the Electronic Office';

  @override
  String get externalNavigationDialogBody => 'The content will open in a browser window';

  @override
  String get externalNavigationDialogCancel => 'Go back';

  @override
  String get externalNavigationDialogContinue => 'Continue';

  @override
  String get externalLinkEducamosClmLabel => 'Educamos CLM';

  @override
  String get externalLinkEducacionClmLabel => 'Castilla-La Mancha Education';

  @override
  String get externalLinkEmpleoClmLabel => 'Castilla-La Mancha Employment';

  @override
  String get externalLinkEmpleoPublicoClmLabel => 'Castilla-La Mancha Public Employment';

  @override
  String get externalLinkSedeDgtLabel => 'DGT e-office';

  @override
  String get externalLinkCarpetaCiudadanaAgeLabel => 'Citizen Folder (AGE)';

  @override
  String get externalLinkHistoriaSocialUnicaLabel => 'Unified Social History';

  @override
  String get externalLinkBienestarSocialClmLabel => 'Social Welfare CLM';

  @override
  String get externalLinkInfanciaFamiliasLabel => 'Childhood and families';

  @override
  String get externalLinkAepdLabel => 'Spanish Data Protection Agency';

  @override
  String get helpPageTitle => 'Help center';

  @override
  String get helpSearchHint => 'Search frequently asked questions';

  @override
  String get helpFaqSectionTitle => 'Frequently asked questions';

  @override
  String get helpGuidesSectionTitle => 'Guides';

  @override
  String get helpContactSectionTitle => 'Contact';

  @override
  String get helpEmptySearchMessage => 'No results';

  @override
  String get helpEmptySearchSubtitle => 'Try different search terms.';

  @override
  String get helpCategoryAccess => 'Access and authentication';

  @override
  String get helpCategoryPrivacy => 'Privacy and data';

  @override
  String get helpCategoryServices => 'Services and features';

  @override
  String get helpFaqLoginClaveQ => 'How do I sign in with Cl@ve?';

  @override
  String get helpFaqLoginClaveA => 'Tap \"Sign in with Cl@ve\" on the welcome screen. The official identification system opens; once authenticated you return to the app.';

  @override
  String get helpFaqLoginProblemsQ => 'I can\'t sign in, what should I do?';

  @override
  String get helpFaqLoginProblemsA => 'Check your connection and that your Cl@ve credential is still valid. If the issue persists, contact 012.';

  @override
  String get helpFaqDataProtectionQ => 'What happens with my personal data?';

  @override
  String get helpFaqDataProtectionA => 'Your data is processed under GDPR and LOPDGDD. See the privacy policy for purposes, retention and your rights.';

  @override
  String get helpFaqNotificationsQ => 'How do I receive notifications?';

  @override
  String get helpFaqNotificationsA => 'Enable alerts in your profile and allow system notifications. You will be notified of changes in your case files.';

  @override
  String get helpFaqDocumentsQ => 'Can I download official documents?';

  @override
  String get helpFaqDocumentsA => 'Yes. From each case file detail you can download or share the available documents.';

  @override
  String get helpFaqOfflineQ => 'Does the app work offline?';

  @override
  String get helpFaqOfflineA => 'Some features (cards and legal content) work offline. Anything that needs fresh data requires connectivity.';

  @override
  String get helpGuideFirstStepsTitle => 'First steps';

  @override
  String get helpGuideFirstStepsBody => 'Learn how to navigate Home, Case files, Notifications and Cards. Personalise your profile for a tailored experience.';

  @override
  String get helpGuideCarpetaAgeTitle => 'State Citizen Folder';

  @override
  String get helpGuideCarpetaAgeBody => 'If your case depends on the Spanish State Administration, open the AGE Citizen Folder directly.';

  @override
  String get helpContact012PhoneLabel => '012 phone support';

  @override
  String get helpContactEmailSupportLabel => 'Support email';

  @override
  String get helpContactOfficesUrlLabel => 'Information and registry offices';

  @override
  String get legalTermsTitle => 'Terms of use';

  @override
  String get legalPrivacyTitle => 'Data protection';

  @override
  String get legalAccessibilityTitle => 'Accessibility';

  @override
  String get legalNoticeTitle => 'Legal notice';

  @override
  String get legalNotFoundTitle => 'Document not found';

  @override
  String get legalNotFoundMessage => 'The requested document could not be loaded.';

  @override
  String get sitemapPageTitle => 'Sitemap';

  @override
  String get sitemapGroupAuthenticated => 'My space';

  @override
  String get sitemapGroupThematic => 'Thematic areas';

  @override
  String get sitemapGroupHelpLegal => 'Help and legal';

  @override
  String get sitemapGroupExternal => 'External resources';

  @override
  String get sitemapHome => 'Home';

  @override
  String get sitemapAgenda => 'Agenda';

  @override
  String get sitemapCasework => 'Case files';

  @override
  String get sitemapNotifications => 'Notifications';

  @override
  String get sitemapCards => 'Cards';

  @override
  String get sitemapRecommendations => 'Recommendations';

  @override
  String get sitemapSupport => 'Support';

  @override
  String get sitemapProfile => 'Profile';

  @override
  String get sitemapEducation => 'Education';

  @override
  String get sitemapEmployment => 'Employment';

  @override
  String get sitemapSocialWelfare => 'Social welfare';

  @override
  String get sitemapStateAffairs => 'State and other';

  @override
  String get sitemapHelp => 'Help center';

  @override
  String get footerHelp => 'Help';

  @override
  String get footerSitemap => 'Sitemap';

  @override
  String get footerTerms => 'Terms';

  @override
  String get footerPrivacy => 'Privacy';

  @override
  String get footerAccessibility => 'Accessibility';

  @override
  String get footerLegalNotice => 'Legal notice';

  @override
  String get agendaRefreshFailedMessage => 'We could not refresh your agenda with the source systems. Showing the latest available data.';

  @override
  String get agendaPageTitle => 'Agenda';

  @override
  String get agendaPendingAppointmentsTitle => 'Pending appointments';

  @override
  String get agendaFilterAll => 'All';

  @override
  String get agendaFilterNext7Days => 'Next 7 days';

  @override
  String get agendaFilterNext30Days => 'Next 30 days';

  @override
  String get agendaFilterNext365Days => 'Next 365 days';

  @override
  String get agendaFilterPast => 'Past';

  @override
  String get agendaViewList => 'List';

  @override
  String get agendaViewCalendar => 'Calendar';

  @override
  String get agendaEmpty => 'No events for the selected period.';

  @override
  String get agendaError => 'We couldn\'t load your agenda.';

  @override
  String get agendaHealthAppointmentsUnavailable => 'No hemos podido cargar tus citas sanitarias.';

  @override
  String get agendaHealthCipMissing => 'There is no health identification number (CIP) linked to your identity in the SESCAM service. We may therefore be unable to display this information. Please try again later.';

  @override
  String get agendaEventsUnavailable => 'No hemos podido cargar los eventos de tu agenda.';

  @override
  String get agendaInfoTooltip => 'Saber más sobre Agenda';

  @override
  String get agendaInfoSheetTitle => 'Saber más sobre Agenda';

  @override
  String get agendaInfoSheetBody => 'Consulta tus citas de atención primaria y hospitalaria, los avisos de tus notificaciones y de la caducidad de tus carnets.\n\nPara mostrarte las citas hospitalarias, necesitamos que verifiques tu identidad con un método de seguridad alta que garantice la protección de estos datos.\n\nEs posible que algunas citas o avisos no aparezcan, porque todavía no están disponibles.';

  @override
  String get agendaInfoSheetFooter => 'Si alguno de tus datos es incorrecto o no está actualizado, contacta con la Junta de Comunidades de Castilla-La Mancha (JCCM).';

  @override
  String get agendaInfoSheetMoreInformation => 'Consultar más información';

  @override
  String get agendaHospitalLockedTitle => 'Citas hospitalarias ocultas';

  @override
  String get agendaHospitalLockedBody => 'Tus datos hospitalarios están protegidos. Verifica tu identidad para consultar estas citas.';

  @override
  String get agendaHospitalLockedAction => 'Verificar';

  @override
  String agendaLastUpdated(String timestamp) {
    return 'Last updated: $timestamp';
  }

  @override
  String get agendaCategorySalud => 'Health';

  @override
  String get agendaCategoryAdministrativo => 'Administrative';

  @override
  String get agendaCategoryEducacion => 'Education';

  @override
  String get agendaCategoryOtros => 'Other';

  @override
  String get agendaPreviousMonth => 'Previous month';

  @override
  String get agendaNextMonth => 'Next month';

  @override
  String get agendaClearDay => 'Clear day filter';

  @override
  String get agendaDetailBack => 'Back';

  @override
  String get agendaDetailNotFound => 'The requested event is no longer available.';

  @override
  String get agendaDetailLocation => 'Location';

  @override
  String get agendaDetailWhen => 'Date';

  @override
  String get agendaDetailCentro => 'Facility';

  @override
  String get agendaDetailProfesional => 'Professional';

  @override
  String get agendaDetailTipo => 'Type';

  @override
  String get agendaDetailDescription => 'Description';

  @override
  String get agendaDetailJustificante => 'View attendance proof';

  @override
  String get agendaJustificanteUnavailable => 'The proof will open once the external link is enabled.';

  @override
  String get agendaTileExpand => 'Show more details';

  @override
  String get agendaTileCollapse => 'Hide details';

  @override
  String get agendaTileOpenDetail => 'Open full detail';

  @override
  String get agendaParseErrorTitle => 'We couldn\'t read your agenda';

  @override
  String get agendaParseErrorDetail => 'There was a problem interpreting the service response. Please try again in a few minutes.';

  @override
  String get agendaParseErrorRetry => 'Try again';

  @override
  String get agendaPartialBanner => 'Some events couldn\'t be loaded. Showing the ones available.';

  @override
  String get stateAffairsTitle => 'State and other matters of interest';

  @override
  String get stateAffairsHeaderDescription => 'Information from national registries (INE/Padrón, Catastro, DGT). Data may not be updated in real time.';

  @override
  String get stateAffairsResidenceTitle => 'Residence';

  @override
  String get stateAffairsResidenceSource => 'Source: INE / municipal census';

  @override
  String get stateAffairsResidenceMunicipio => 'Municipality';

  @override
  String get stateAffairsResidenceProvincia => 'Province';

  @override
  String get stateAffairsResidenceComunidad => 'Autonomous community';

  @override
  String get stateAffairsResidenceDireccion => 'Address';

  @override
  String get stateAffairsResidenceCp => 'Postal code';

  @override
  String stateAffairsResidenceLastUpdated(String timestamp) {
    return 'Updated: $timestamp';
  }

  @override
  String get stateAffairsPropertiesTitle => 'Real-estate assets';

  @override
  String get stateAffairsPropertiesSource => 'Source: Catastro';

  @override
  String get stateAffairsPropertiesEmpty => 'No real-estate assets are registered under your name.';

  @override
  String get stateAffairsPropertiesError => 'We could not load Catastro data.';

  @override
  String stateAffairsPropertiesTitularidad(String value) {
    return 'Ownership: $value';
  }

  @override
  String stateAffairsPropertiesSurface(String m2) {
    return 'Surface: $m2 m²';
  }

  @override
  String stateAffairsPropertiesReference(String value) {
    return 'Cadastral reference: $value';
  }

  @override
  String get stateAffairsVehiclesTitle => 'Vehicles';

  @override
  String get stateAffairsVehiclesSource => 'Source: DGT';

  @override
  String get stateAffairsVehiclesEmpty => 'No vehicles are registered under your name.';

  @override
  String get stateAffairsVehiclesError => 'We could not load DGT data.';

  @override
  String stateAffairsVehiclesPlate(String value) {
    return 'Plate: $value';
  }

  @override
  String stateAffairsVehiclesFuel(String value) {
    return 'Fuel: $value';
  }

  @override
  String get stateAffairsDataDisclaimer => 'Data is sourced from DGT, INE and Catastro and may not be updated in real time.';

  @override
  String get domainExternalLinksTitle => 'External links';

  @override
  String get domainGenericLoadError => 'We could not load the requested information.';

  @override
  String get domainComingSoonBadge => 'Coming soon';

  @override
  String get educationTitle => 'Education';

  @override
  String get educationHeaderDescription => 'Check your academic titles and reach the official Castilla-La Mancha education services.';

  @override
  String get educationUniversityTitlesTitle => 'University titles';

  @override
  String get educationUniversityTitlesEmpty => 'No university titles are registered under your name.';

  @override
  String get educationUniversityTitlesError => 'We could not load your university titles.';

  @override
  String get educationUniversityTitlesInfoTitle => 'About your university degrees';

  @override
  String get educationUniversityTitlesInfoBody => 'Check the data of degrees listed in the National Register of Official University Graduates of the Ministry of Science, Innovation and Universities.\nIf your degree is prior to 1996, your data may not be automatically displayed.';

  @override
  String get educationUniversityTitlesInfoFooter => 'If any of your data is incorrect or not updated, contact the Universities e-Office.';

  @override
  String get educationUniversityTitlesInfoContactButton => 'Contact';

  @override
  String get educationNonUniversityTitlesInfoTitle => 'About your non-university qualifications';

  @override
  String get educationNonUniversityTitlesInfoBody => 'Check the details of the non-university qualifications on record.';

  @override
  String get educationNonUniversityTitlesInfoFooter => 'If any of your data is incorrect or not updated, contact the Ministry of Education, Vocational Training and Sports.';

  @override
  String get educationTitlesInfoMoreInformation => 'Consultar más información';

  @override
  String get educationNonUniversityTitlesTitle => 'Non-university titles';

  @override
  String get educationNonUniversityTitlesEmpty => 'No non-university titles are registered under your name.';

  @override
  String get educationNonUniversityTitlesError => 'We could not load your non-university titles.';

  @override
  String educationTitleYear(String year) {
    return 'Year: $year';
  }

  @override
  String get educationScholarshipTitle => 'Scholarship status';

  @override
  String get educationScholarshipDescription => 'This information will be available soon. It depends on an additional service that is not yet integrated.';

  @override
  String get educationScholarshipTooltip => 'Capability pending a specific scholarship endpoint. Awaiting contract validation (TASK-27).';

  @override
  String get employmentTitle => 'Employment';

  @override
  String get employmentHeaderDescription => 'Check your job-seeker status and reach the official Empleo CLM portals.';

  @override
  String get employmentSeekerTitle => 'Job-seeker status';

  @override
  String get employmentSeekerSource => 'Source: SEPE';

  @override
  String get employmentSeekerEmpty => 'No job-seeker records are registered under your name.';

  @override
  String get employmentSeekerError => 'We could not load your job-seeker status.';

  @override
  String get employmentSeekerEstadoLabel => 'Current status';

  @override
  String get employmentSeekerInscripcionLabel => 'Registration date';

  @override
  String get employmentSeekerContinuidadLabel => 'Continuity date';

  @override
  String get employmentSeekerEstadoInscrito => 'Registered';

  @override
  String get employmentSeekerEstadoNoInscrito => 'Not registered';

  @override
  String get employmentSeekerEstadoBajaTemporal => 'Temporary leave';

  @override
  String get employmentOffersTitle => 'Offer subscriptions';

  @override
  String get employmentOffersDescription => 'Browsing and managing your offer subscriptions takes place directly on the Empleo CLM portal.';

  @override
  String get socialWelfareTitle => 'Social Welfare';

  @override
  String get socialWelfareHeaderDescription => 'Check your familia numerosa title and reach the official Castilla-La Mancha social welfare services.';

  @override
  String get socialWelfareScreenTitle => 'Social welfare';

  @override
  String get socialWelfareDataTab => 'Social welfare data';

  @override
  String get socialWelfareServicesTab => 'Information and services';

  @override
  String get socialWelfareInterestLinksTitle => 'Links of interest';

  @override
  String get socialWelfareSuggestedProceduresTitle => 'Procedures that may interest you';

  @override
  String get socialWelfareDisabilityRecognitionProcedure => 'Recognition of disability degree';

  @override
  String get socialWelfareEarlyCareProcedure => 'Access to early care service';

  @override
  String get socialWelfareTemporaryResidentialStayProcedure => 'Place for temporary stays in residential centres for older people';

  @override
  String get socialWelfareInfoSheetTitle => 'About Social welfare data';

  @override
  String get socialWelfareInfoSheetDescription => 'Check the information for your Social Welfare files and access the services available from the Government of Castilla-La Mancha.';

  @override
  String get myDataJccmAuthorizationRequiredMessage => 'You must authorise the consultation of administrative facts held by the JCCM from your preferences.';

  @override
  String get authorizationCheckFailedMessage => 'We could not check your authorisations. Please try again.';

  @override
  String get myDataJccmAuthorizationRequiredCta => 'Go to Terms of use and authorizations';

  @override
  String get myDataAgeAuthorizationRequiredMessage => 'You must authorise the consultation of data held about you by the General State Administration from your preferences.';

  @override
  String get socialWelfareFamilyTitle => 'Large family';

  @override
  String get socialWelfareFamilyNavDescription => 'Title details and beneficiaries';

  @override
  String get socialWelfareDisabilityTitle => 'Disability';

  @override
  String get socialWelfareDisabilityNavDescription => 'Disability title details';

  @override
  String get socialWelfareDisabilityInfoSheetTitle => 'Learn more about My disability title';

  @override
  String get socialWelfareDisabilityInfoSheetDescription => 'Check the details of your disability title.';

  @override
  String get socialWelfareDisabilityTitleSection => 'My disability title';

  @override
  String get socialWelfareDisabilityEffectiveDateLabel => 'Effective date';

  @override
  String get socialWelfareDisabilityPermanentValidityLabel => 'Permanent validity';

  @override
  String get socialWelfareDisabilityFileNumberLabel => 'File number';

  @override
  String get socialWelfareDisabilityBirthDateLabel => 'Birth date';

  @override
  String get socialWelfareDisabilityMobilityLabel => 'Reduced mobility applies';

  @override
  String get socialWelfareDisabilityThirdPersonLabel => 'Third-person assistance recognized';

  @override
  String get socialWelfareDisabilityRoyalDecreeLabel => 'Royal decree used to grant the degree';

  @override
  String get socialWelfareFamilySource => 'Source: Junta de Comunidades de Castilla-La Mancha';

  @override
  String get socialWelfareFamilyEmpty => 'No large-family title is registered under your name.';

  @override
  String get socialWelfareFamilyError => 'We could not load your large-family title.';

  @override
  String get socialWelfareFamilyNumberLabel => 'Title number';

  @override
  String get socialWelfareFamilyCategoriaLabel => 'Category';

  @override
  String get socialWelfareFamilyCaducidadLabel => 'Expiration date';

  @override
  String get socialWelfareFamilyCategoriaGeneral => 'General';

  @override
  String get socialWelfareFamilyCategoriaEspecial => 'Special';

  @override
  String get socialWelfareFamilyBeneficiariosTitle => 'Beneficiaries';

  @override
  String get socialWelfareFamilyRelacionTitular => 'Title holder';

  @override
  String get socialWelfareFamilyRelacionConyuge => 'Spouse';

  @override
  String get socialWelfareFamilyRelacionHijo => 'Child';

  @override
  String socialWelfareFamilyBeneficiarioLine(String relacion, String fecha) {
    return '$relacion — born on $fecha';
  }

  @override
  String get socialWelfareTermalismoTitle => 'Thermal-spa programs';

  @override
  String get socialWelfareTermalismoNavTitle => 'Thermal spas';

  @override
  String get socialWelfareTermalismoNavDescription => 'Assigned spa resort';

  @override
  String get socialWelfareTermalismoInfoSheetTitle => 'Learn more about Thermal spas';

  @override
  String get socialWelfareTermalismoInfoSheetDescription => 'Check the details of the latest spa resort definitively assigned to you in the Castilla-La Mancha Thermal Spa Programme.';

  @override
  String get socialWelfareTermalismoAwardTitle => 'Latest assigned spa resort';

  @override
  String get socialWelfareTermalismoSpaNameLabel => 'Spa resort name';

  @override
  String get socialWelfareTermalismoStartDateLabel => 'Start date';

  @override
  String get socialWelfareTermalismoEndDateLabel => 'End date';

  @override
  String get socialWelfareTermalismoUnavailableMessage => 'We could not find thermal-spa information associated with your data. Please try again later.';

  @override
  String get socialWelfareTermalismoErrorMessage => 'Your thermal-spa information could not be loaded.';

  @override
  String get socialWelfareTermalismoDescription => 'The Castilla-La Mancha thermal-spa program is managed through the official Social Welfare portal.';

  @override
  String get socialWelfareParkingTitle => 'Parking card';

  @override
  String get socialWelfareParkingNavTitle => 'Parking card';

  @override
  String get socialWelfareParkingNavDescription => 'Your parking card details';

  @override
  String get socialWelfareParkingInfoSheetTitle => 'Learn more about My parking card';

  @override
  String get socialWelfareParkingInfoSheetDescription => 'Check the details of your current parking card for people with disabilities and reduced mobility in Castilla-La Mancha.';

  @override
  String get socialWelfareParkingCardTitle => 'My parking card';

  @override
  String get socialWelfareParkingCodeLabel => 'Card code';

  @override
  String get socialWelfareParkingModalityLabel => 'Modality';

  @override
  String get socialWelfareParkingValidFromLabel => 'Valid from';

  @override
  String get socialWelfareParkingValidUntilLabel => 'Valid until';

  @override
  String get socialWelfareParkingUnavailableMessage => 'We could not find parking card information associated with your data. Please try again later.';

  @override
  String get socialWelfareParkingErrorMessage => 'Your parking card could not be loaded.';

  @override
  String get socialWelfareParkingDescription => 'Requesting and managing the disability parking card is handled in the corresponding e-office.';

  @override
  String get socialWelfareDependenciaTitle => 'Dependency support';

  @override
  String get socialWelfareDependenciaNavDescription => 'Current situation and benefits';

  @override
  String get socialWelfareDependenciaInfoSheetTitle => 'Learn more about Dependency care';

  @override
  String get socialWelfareDependenciaInfoSheetDescription => 'Check the details of your current situation and dependency care benefits.';

  @override
  String get socialWelfareDependenciaCurrentStatusTitle => 'My current situation';

  @override
  String get socialWelfareDependenciaRequestDateLabel => 'Request date';

  @override
  String get socialWelfareDependenciaResolutionDateLabel => 'Resolution date';

  @override
  String get socialWelfareDependenciaRecognizedDegreeLabel => 'Recognized degree';

  @override
  String get socialWelfareDependenciaBaremoLabel => 'Scale';

  @override
  String get socialWelfareDependenciaBenefitsTitle => 'Benefits';

  @override
  String get socialWelfareDependenciaBenefitResolutionDateLabel => 'Resolution date';

  @override
  String get socialWelfareDependenciaBenefitEffectiveDateLabel => 'Effective date';

  @override
  String get socialWelfareDependenciaBenefitAmountLabel => 'Amount (€)';

  @override
  String get socialWelfareDependenciaUnavailableMessage => 'We could not find dependency care information associated with your data. Please try again later.';

  @override
  String get socialWelfareDependenciaErrorMessage => 'Your dependency care information could not be loaded.';

  @override
  String get socialWelfareDependenciaDescription => 'Information and procedures for the Dependency Act are managed on the official Castilla-La Mancha Social Welfare portal.';

  @override
  String get socialWelfareServicesEmpty => 'Social welfare information and services will be available soon.';

  @override
  String get supportFormTitle => 'Technical support';

  @override
  String get supportFormIntro => 'Tell us what happened. Our team will get back to you by e-mail.';

  @override
  String get supportCtaFromHelp => 'Contact support';

  @override
  String get supportFieldName => 'Name';

  @override
  String get supportFieldEmail => 'E-mail';

  @override
  String get supportFieldEmailConfirm => 'Confirm e-mail';

  @override
  String get supportFieldSubject => 'Subject';

  @override
  String get supportFieldDescription => 'Description';

  @override
  String get supportAttachmentLabel => 'Attachment (optional)';

  @override
  String get supportAttachmentHint => 'You may attach a single file (screenshots, documents).';

  @override
  String get supportAttachmentPick => 'Pick file';

  @override
  String get supportAttachmentChange => 'Change file';

  @override
  String get supportAttachmentRemove => 'Remove attachment';

  @override
  String get supportConsentLabel => 'I authorise the processing of my data to handle my request.';

  @override
  String get supportCaptchaLabel => 'I am not a robot';

  @override
  String get supportSubmitButton => 'Send request';

  @override
  String get supportConfirmationTitle => 'Request sent';

  @override
  String get supportConfirmationMessage => 'We\'ve received your request. We\'ll confirm by e-mail.';

  @override
  String get supportConfirmationNewRequest => 'Send another request';

  @override
  String get supportSubmissionError => 'We couldn\'t send your request. Please try again.';

  @override
  String get supportErrorNameRequired => 'Please enter your name.';

  @override
  String get supportErrorEmailRequired => 'Please enter your e-mail.';

  @override
  String get supportErrorEmailInvalid => 'Please enter a valid e-mail address.';

  @override
  String get supportErrorEmailConfirmRequired => 'Please confirm your e-mail.';

  @override
  String get supportErrorEmailMismatch => 'E-mails don\'t match.';

  @override
  String get supportErrorSubjectRequired => 'Please add a subject.';

  @override
  String get supportErrorSubjectTooLong => 'Subject can\'t exceed 100 characters.';

  @override
  String get supportErrorDescriptionRequired => 'Please describe your request.';

  @override
  String get supportErrorDescriptionTooLong => 'Description exceeds the allowed length.';

  @override
  String get supportErrorConsentRequired => 'You must authorise the processing of your data.';

  @override
  String get supportErrorCaptchaRequired => 'Please confirm you are not a robot.';

  @override
  String get cipCardTitle => 'Health card (CIP)';

  @override
  String get cipCardCopyTooltip => 'Copy CIP';

  @override
  String get cipCardCopied => 'CIP copied to clipboard';

  @override
  String get cipCardReadOnlySubtitle => 'Read-only — the health card cannot be downloaded from the app.';

  @override
  String get cipCardContractGap => 'Other health capabilities (visits, prescriptions) are subject to contract confirmation.';

  @override
  String get cipCardEmpty => 'No health card is associated with your profile yet.';

  @override
  String get cipCardError => 'We couldn\'t load your health card.';

  @override
  String get cipCardParseError => 'We couldn\'t read the health card response.';

  @override
  String get saludSurfaceTitle => 'Health';

  @override
  String get saludSurfaceCta => 'View agenda';

  @override
  String get homeNoNewsMessage => 'You have no pending notifications or upcoming appointments.';

  @override
  String get homeUpcomingEventsTitle => 'Upcoming events';

  @override
  String get homeUpcomingEventsEmpty => 'You have no upcoming events.';

  @override
  String get caseworkWorkspaceTitle => 'My casework';

  @override
  String get caseworkWorkspaceLoadError => 'We could not load your casework.';

  @override
  String get caseworkBreadcrumbHome => 'Home';

  @override
  String get caseworkTabExpedientes => 'My files';

  @override
  String get caseworkTabEntradasRegistro => 'My registry inbox';

  @override
  String get caseworkTabSalidasRegistro => 'My registry outbox';

  @override
  String get caseworkExpedientesEmpty => 'No casework files registered under your name.';

  @override
  String get caseworkEntradasRegistroEmpty => 'No registry entries are registered under your name.';

  @override
  String get caseworkSalidasRegistroEmpty => 'No registry exits are registered under your name.';

  @override
  String get caseworkExpedientesError => 'We could not load your casework files.';

  @override
  String get caseworkEntradasRegistroError => 'We could not load your registry entries.';

  @override
  String get caseworkSalidasRegistroError => 'We could not load your registry exits.';

  @override
  String get caseworkStatusEnTramite => 'In progress';

  @override
  String get caseworkStatusFinalizado => 'Completed';

  @override
  String get caseworkStatusPendiente => 'Pending';

  @override
  String get caseworkStatusRechazado => 'Rejected';

  @override
  String caseworkItemDateLabel(String date) {
    return 'Date: $date';
  }

  @override
  String get caseworkSearchTitle => 'Search casework files and registry entries';

  @override
  String get caseworkSearchOpenCta => 'Search casework files and registry entries';

  @override
  String get caseworkSearchIntro => 'Fill at least one field to find your casework file or registry entry.';

  @override
  String get caseworkSearchFieldIdentificationLabel => 'ID document (NIF / NIE / Passport)';

  @override
  String get caseworkSearchFieldIdentificationHelper => 'E.g. 12345678Z, X1234567A or alphanumeric passport.';

  @override
  String get caseworkSearchFieldExpedienteLabel => 'Casework file number';

  @override
  String get caseworkSearchFieldExpedienteHelper => 'E.g. EXP/2025/00123';

  @override
  String get caseworkSearchFieldRegistroLabel => 'Registry number';

  @override
  String get caseworkSearchFieldRegistroHelper => 'E.g. REG/E/45612';

  @override
  String get caseworkSearchSubmit => 'Search';

  @override
  String get caseworkSearchAnother => 'Search something else';

  @override
  String get caseworkSearchAportar => 'Submit documents to this result';

  @override
  String get caseworkSearchAportarPending => 'Document submission will be enabled by STORY-37 / STORY-38.';

  @override
  String get caseworkSearchErrorAtLeastOne => 'Please fill at least one of the three fields.';

  @override
  String get caseworkSearchErrorInvalidIdentification => 'Invalid format. Use NIF (8 digits + letter), NIE (X/Y/Z + 7 digits + letter) or alphanumeric passport (6–9 chars).';

  @override
  String get caseworkSearchErrorInvalidNumber => 'Invalid format. Only letters, digits, dashes and slashes are allowed.';

  @override
  String get caseworkSearchNoResults => 'No matches';

  @override
  String get caseworkSearchNoResultsHint => 'Check the data you entered and try again.';

  @override
  String get caseworkSearchError => 'We could not complete the search. Please try again.';

  @override
  String caseworkSearchResultsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count results',
      one: '1 result',
    );
    return '$_temp0';
  }

  @override
  String get caseworkExpedienteDetailTitle => 'Casework file detail';

  @override
  String get caseworkExpedienteDetailBack => 'Back to my casework';

  @override
  String get caseworkExpedienteDetailLoading => 'Loading casework detail…';

  @override
  String get caseworkExpedienteDetailErrorTitle => 'We could not load this casework file.';

  @override
  String get caseworkExpedienteDetailErrorBody => 'Please try again in a few minutes.';

  @override
  String get caseworkExpedienteDetailMetadataTitle => 'File information';

  @override
  String get caseworkExpedienteDetailNumero => 'File number';

  @override
  String get caseworkExpedienteDetailAsuntoCodigo => 'Subject code';

  @override
  String get caseworkExpedienteDetailAsunto => 'Subject';

  @override
  String get caseworkExpedienteDetailConsejeria => 'Department';

  @override
  String get caseworkExpedienteDetailOficina => 'Processing office';

  @override
  String get caseworkExpedienteDetailProcedimiento => 'Procedure';

  @override
  String get caseworkExpedienteDetailFechaInicio => 'Start date';

  @override
  String get caseworkExpedienteDetailFechaActualizacion => 'Last update';

  @override
  String get caseworkExpedienteDetailEstadoLabel => 'State';

  @override
  String get caseworkExpedienteDetailEstadoAbierto => 'Open';

  @override
  String get caseworkExpedienteDetailEstadoCerrado => 'Closed';

  @override
  String get caseworkExpedienteDetailEstadoUnknown => 'Unknown state';

  @override
  String get caseworkExpedienteDetailFilesTitle => 'Associated files';

  @override
  String get caseworkExpedienteDetailFilesEmpty => 'No files are associated with this casework file.';

  @override
  String get caseworkExpedienteDetailFicheroDownloadTooltip => 'Download file';

  @override
  String get caseworkExpedienteDetailFicheroDownloadStub => 'File download will be enabled in a future release.';

  @override
  String get caseworkExpedienteDetailOperationsTitle => 'Submit documentation';

  @override
  String get caseworkExpedienteDetailClosedBanner => 'This casework file is closed; submissions are no longer accepted.';

  @override
  String get digitalCardsPageTitle => 'My digital cards';

  @override
  String get digitalCardsTypeFamiliaNumerosa => 'Large Family';

  @override
  String get digitalCardsTypeJoven => 'Youth card';

  @override
  String get digitalCardsTypeDiscapacidad => 'Disability';

  @override
  String get digitalCardsIssueDate => 'Issue date';

  @override
  String get digitalCardsEffectiveDate => 'Effective date';

  @override
  String get digitalCardsExpiryDate => 'Expiry date';

  @override
  String get digitalCardsDefinitive => 'PERMANENT';

  @override
  String get digitalCardTitleLabel => 'Title / Card';

  @override
  String get digitalCardNumberLabel => 'Card number';

  @override
  String get digitalCardDownload => 'Download';

  @override
  String get digitalCardsStatusAvailable => 'Available';

  @override
  String get digitalCardsStatusNotValid => 'Not valid';

  @override
  String get digitalCardsStatusNotDownloadable => 'Not downloadable';

  @override
  String get digitalCardsStatusNotAvailable => 'Not available';

  @override
  String get digitalCardsMessageNotValid => 'This card is not valid. QR, PKPASS and PDF aren\'t available.';

  @override
  String get digitalCardsMessageNotDownloadable => 'This card can\'t be downloaded right now.';

  @override
  String get digitalCardsMessageNotAvailable => 'You don\'t have this card available.';

  @override
  String get digitalCardsActionQr => 'Show QR';

  @override
  String get digitalCardsActionPkpass => 'Add to Wallet';

  @override
  String get digitalCardsActionPdf => 'Download PDF';

  @override
  String get digitalCardsActionComingSoon => 'Coming soon.';

  @override
  String get digitalCardsPartialErrorMessage => 'We could not check all your cards. Showing the available ones.';

  @override
  String get digitalCardsEmptyMessage => 'You don\'t have any digital cards yet.';

  @override
  String get digitalCardsErrorMessage => 'We couldn\'t load your digital cards.';

  @override
  String get digitalCardsCipMiniTitle => 'Health card (CIP)';

  @override
  String get digitalCardsCipMiniReadOnly => 'Read only';

  @override
  String get digitalCardsCipMiniOpenAction => 'Open health card';

  @override
  String get lifeEventsTitle => 'My life events';

  @override
  String get lifeEventsHeaderDescription => 'Select the life events that best describe your situation to receive personalized recommendations.';

  @override
  String get lifeEventsOnboardingTitle => 'Personalized recommendations';

  @override
  String get lifeEventsOnboardingDescription => 'Select the situations, interests, or needs that best match you to receive personalized recommendations.';

  @override
  String get lifeEventsCompleteLaterAction => 'Complete later';

  @override
  String get lifeEventsIntroHeading => 'Select the topics you would like to receive information about';

  @override
  String get lifeEventsIntroBody => 'Select the topics you would like to receive information about in the recommendations section';

  @override
  String get lifeEventsSaveAction => 'Save';

  @override
  String get lifeEventsAcceptAction => 'Accept';

  @override
  String get lifeEventsFillLaterAction => 'Fill in later';

  @override
  String get lifeEventsClearAllAction => 'Deselect all';

  @override
  String get lifeEventsResetAction => 'Reset preferences';

  @override
  String get lifeEventsResetConfirmTitle => 'Reset your preferences';

  @override
  String get lifeEventsResetConfirmBody => 'All selected life events will be removed. This action cannot be undone.';

  @override
  String get lifeEventsResetConfirm => 'Reset';

  @override
  String get lifeEventsResetCancel => 'Cancel';

  @override
  String get lifeEventsSavedFeedback => 'Your preferences have been saved.';

  @override
  String get lifeEventsErrorFeedback => 'We couldn\'t save your preferences. Please try again.';

  @override
  String get lifeEventsResetSuccessFeedback => 'Your preferences have been cleared.';

  @override
  String get lifeEventsResetErrorFeedback => 'We couldn\'t clear your preferences. Please try again.';

  @override
  String get lifeEventsLoadError => 'We couldn\'t load the life events.';

  @override
  String get lifeEventsEmpty => 'There are no life events available at the moment.';

  @override
  String get lifeEventsDiscardConfirmTitle => 'Discard changes';

  @override
  String get lifeEventsDiscardConfirmBody => 'You have unsaved changes. If you leave now, your changes will be lost.';

  @override
  String get lifeEventsDiscardStay => 'Keep editing';

  @override
  String get lifeEventsDiscardAction => 'Discard';

  @override
  String get lifeEventsCategoryFamilia => 'Family';

  @override
  String get lifeEventsCategorySalud => 'Health';

  @override
  String get lifeEventsCategoryEmpleo => 'Employment';

  @override
  String get lifeEventsCategoryVivienda => 'Housing';

  @override
  String get lifeEventsCategoryEducacion => 'Education';

  @override
  String get dataConsentTitle => 'My authorizations';

  @override
  String get dataConsentHeaderDescription => 'Manage which data can be used to offer you personalized services and recommendations. You can change your decision at any time.';

  @override
  String get dataConsentSaveAction => 'Save';

  @override
  String get dataConsentRevokeAction => 'Revoke all authorizations';

  @override
  String get dataConsentRevokeConfirmTitle => 'Revoke your authorizations';

  @override
  String get dataConsentRevokeConfirmBody => 'All your authorizations will be removed and we will stop personalizing content until you accept them again.';

  @override
  String get dataConsentRevokeConfirm => 'Revoke';

  @override
  String get dataConsentRevokeCancel => 'Cancel';

  @override
  String get dataConsentSavedFeedback => 'Your authorizations have been updated successfully.';

  @override
  String get dataConsentErrorFeedback => 'We could not update your authorizations. Please try again.';

  @override
  String get dataConsentLoadError => 'We could not load your authorizations.';

  @override
  String get dataConsentEmpty => 'There are no authorizations available at this time.';

  @override
  String get dataConsentTypeJccmTitle => 'Data from the Government of Castilla-La Mancha';

  @override
  String get dataConsentTypeJccmSubtitle => 'Allow JCCM to use your administrative data to offer you personalized services and procedures.';

  @override
  String get dataConsentTypeOtrasAdminTitle => 'Data from other public administrations';

  @override
  String get dataConsentTypeOtrasAdminSubtitle => 'Allow us to consult data from other public administrations so you don\'t have to provide it manually.';

  @override
  String get dataConsentTypePerfiladoTitle => 'Profiling for recommendations';

  @override
  String get dataConsentTypePerfiladoSubtitle => 'Allow us to analyze your activity to recommend procedures, grants and relevant content.';

  @override
  String get dataConsentPrivacyReferenceTitle => 'Data protection information';

  @override
  String get dataConsentPrivacyReferenceBody => 'These authorizations are based on the data protection information accepted when you signed in.';

  @override
  String get dataConsentPrivacyReferenceCta => 'View data protection information';

  @override
  String get dataConsentNavCta => 'My authorizations';

  @override
  String get caseworkUploadPageTitle => 'Submit documentation';

  @override
  String get caseworkUploadPickerCta => 'Attach files';

  @override
  String get caseworkUploadSelectFilesCta => 'Select files';

  @override
  String get caseworkUploadDropZoneSemantic => 'Drop area for attachments. You can also tap to pick files.';

  @override
  String caseworkUploadLimitHint(int maxFiles, int maxMb) {
    return 'Up to $maxFiles files, $maxMb MB each.';
  }

  @override
  String caseworkUploadRemainingHint(int remaining) {
    String _temp0 = intl.Intl.pluralLogic(
      remaining,
      locale: localeName,
      other: 'You can attach $remaining more files.',
      one: 'You can attach 1 more file.',
      zero: 'You cannot attach more files.',
    );
    return '$_temp0';
  }

  @override
  String get caseworkUploadEmptyList => 'No files attached yet.';

  @override
  String get caseworkUploadRemoveFile => 'Remove file';

  @override
  String get caseworkUploadUploadAllCta => 'Upload all';

  @override
  String get caseworkUploadFinalizeCta => 'Finish and request receipt';

  @override
  String get caseworkUploadStatusSelected => 'Selected';

  @override
  String get caseworkUploadStatusValidating => 'Validating';

  @override
  String get caseworkUploadStatusHashed => 'Hash computed';

  @override
  String get caseworkUploadStatusUploading => 'Uploading';

  @override
  String get caseworkUploadStatusUploaded => 'Uploaded';

  @override
  String get caseworkUploadStatusFailed => 'Error';

  @override
  String get fileUploadCancel => 'Cancel';

  @override
  String get fileUploadCompleted => 'Completed';

  @override
  String get fileUploadDelete => 'Delete file';

  @override
  String get fileUploadRetry => 'Retry';

  @override
  String a11yFileUpload(String fileName, String fileInfo, String status) {
    return 'File: $fileName, $fileInfo. Status: $status';
  }

  @override
  String get caseworkUploadErrorUnsupportedMime => 'Unsupported file format.';

  @override
  String get caseworkUploadErrorTooLarge => 'The file exceeds the maximum size.';

  @override
  String get caseworkUploadErrorTooManyFiles => 'You have reached the maximum number of files.';

  @override
  String get caseworkUploadErrorEmptyFile => 'The file is empty.';

  @override
  String get caseworkUploadErrorHashMismatch => 'The file fingerprint does not match.';

  @override
  String get caseworkUploadErrorGeneric => 'There was an error with the file.';

  @override
  String get caseworkUploadJustificantePending => 'The receipt will be generated once you finish the submission.';

  @override
  String get caseworkUploadJustificanteUnavailable => 'The receipt is not available yet.';

  @override
  String caseworkUploadJustificanteUnavailableReason(String reason) {
    return 'Reason: $reason';
  }

  @override
  String get caseworkUploadJustificanteAvailable => 'Your receipt is ready.';

  @override
  String get caseworkUploadJustificanteDownloadCta => 'Download receipt';

  @override
  String get caseworkUploadJustificanteDownloadStub => 'Receipt download will be enabled once the backend confirms the format.';

  @override
  String get caseworkRegistroDetailTitleEntrada => 'Registry entry detail';

  @override
  String get caseworkRegistroDetailTitleSalida => 'Registry exit detail';

  @override
  String get caseworkRegistroDetailBreadcrumbHome => 'Home';

  @override
  String get caseworkRegistroDetailBreadcrumbCasework => 'My files';

  @override
  String get caseworkRegistroDetailKindEntrada => 'Registry inbox';

  @override
  String get caseworkRegistroDetailKindSalida => 'Registry outbox';

  @override
  String get caseworkRegistroDetailBackToList => 'Back to list';

  @override
  String get caseworkRegistroDetailLoadError => 'We could not load the registry detail.';

  @override
  String get caseworkRegistroDetailFieldNumero => 'Registry number';

  @override
  String get caseworkRegistroDetailFieldFecha => 'Date';

  @override
  String get caseworkRegistroDetailFieldConsejeria => 'Destination department';

  @override
  String get caseworkRegistroDetailFieldOficina => 'Registry office';

  @override
  String get caseworkRegistroDetailFieldAsunto => 'Subject';

  @override
  String get caseworkRegistroDetailFieldObservaciones => 'Notes';

  @override
  String get caseworkRegistroDetailFicherosTitle => 'Attached documentation';

  @override
  String get caseworkRegistroDetailFicherosEmpty => 'This registry entry has no attached files.';

  @override
  String get caseworkRegistroDetailReadOnlyBanner => 'This screen shows the registry entry in read-only mode. You cannot submit documentation from here.';

  @override
  String get caseworkAportacionOpenCta => 'Submit documentation';

  @override
  String get caseworkAportacionTitle => 'Submit documentation';

  @override
  String get caseworkAportacionBreadcrumb => 'Submission';

  @override
  String get caseworkAportacionBack => 'Previous step';

  @override
  String get caseworkAportacionExit => 'Exit flow';

  @override
  String caseworkAportacionStepIndicator(int current, int total) {
    return 'Step $current of $total';
  }

  @override
  String get caseworkAportacionStepIntro => 'Introduction';

  @override
  String get caseworkAportacionStepIdentificacion => 'Identification';

  @override
  String get caseworkAportacionStepSearch => 'Search';

  @override
  String get caseworkAportacionStepDetail => 'Detail';

  @override
  String get caseworkAportacionStepComplete => 'Confirmation';

  @override
  String get caseworkAportacionIntroHeadline => 'Submit documentation to a file';

  @override
  String get caseworkAportacionIntroBody => 'This flow lets you submit additional documentation to an open file on behalf of the interested person. Identify yourself, locate the file and attach the documents.';

  @override
  String get caseworkAportacionIntroRestrictionsTitle => 'Before you continue';

  @override
  String get caseworkAportacionIntroRestriction1 => 'You can only submit documentation to files that are open.';

  @override
  String get caseworkAportacionIntroRestriction2 => 'You need the file number or its associated registry number.';

  @override
  String get caseworkAportacionIntroRestriction3 => 'Submitted documents are linked to the interested person you identify.';

  @override
  String get caseworkAportacionIntroContinueCta => 'Continue';

  @override
  String get caseworkAportacionIdentificationHeadline => 'Identify the interested person';

  @override
  String get caseworkAportacionIdentificationBody => 'Provide the document type and number of the file owner.';

  @override
  String get caseworkAportacionIdentificationTypeLabel => 'Document type';

  @override
  String get caseworkAportacionIdentificationTypeNif => 'NIF';

  @override
  String get caseworkAportacionIdentificationTypeNie => 'NIE';

  @override
  String get caseworkAportacionIdentificationTypePassport => 'Passport';

  @override
  String get caseworkAportacionIdentificationTypeCif => 'CIF';

  @override
  String get caseworkAportacionIdentificationNumberLabel => 'Document number';

  @override
  String get caseworkAportacionIdentificationNumberHint => 'e.g. 12345678A';

  @override
  String get caseworkAportacionIdentificationNextCta => 'Next';

  @override
  String get caseworkAportacionSearchHeadline => 'Locate the file';

  @override
  String get caseworkAportacionSearchBody => 'Search by file number or by its associated registry number.';

  @override
  String get caseworkAportacionSearchTabExpediente => 'By file no.';

  @override
  String get caseworkAportacionSearchTabRegistro => 'By registry no.';

  @override
  String get caseworkAportacionSearchExpedienteLabel => 'File number';

  @override
  String get caseworkAportacionSearchExpedienteHint => 'e.g. EXP/2025/00123';

  @override
  String get caseworkAportacionSearchRegistroLabel => 'Registry number';

  @override
  String get caseworkAportacionSearchRegistroHint => 'e.g. REG/E/45612';

  @override
  String get caseworkAportacionSearchSubmitCta => 'Search';

  @override
  String get caseworkAportacionFailureInvalidIdentification => 'The document number is not valid for the selected type.';

  @override
  String get caseworkAportacionFailureNotFound => 'We could not find any file matching that input.';

  @override
  String get caseworkAportacionFailureNetworkError => 'We could not complete the search. Please try again later.';

  @override
  String get caseworkAportacionCompleteHeadline => 'Submission completed';

  @override
  String caseworkAportacionCompleteBody(String expediente) {
    return 'Your documentation has been submitted to file $expediente. Keep the receipt for your records.';
  }

  @override
  String get caseworkAportacionCompleteHomeCta => 'Back to my files';

  @override
  String get notificationsCenterTitle => 'My notifications';

  @override
  String get notificationsLoading => 'Loading notifications…';

  @override
  String get notificationsErrorMessage => 'We could not load your notifications.';

  @override
  String get notificationsLoadMoreError => 'We could not load more notifications. Please try again.';

  @override
  String get notificationsEmptyTitle => 'No notifications';

  @override
  String get notificationsEmptySubtitle => 'We did not find notifications matching the active filters.';

  @override
  String get notificationsFilterAll => 'All';

  @override
  String get notificationsItemHasDocuments => 'Has attached documents';

  @override
  String notificationsPaginationFooter(int loaded, int total) {
    return 'Showing $loaded of $total';
  }

  @override
  String get notificationStatusPendiente => 'Pending';

  @override
  String get notificationStatusAceptada => 'Accepted';

  @override
  String get notificationStatusRechazada => 'Rejected';

  @override
  String get notificationStatusCaducada => 'Expired';

  @override
  String get notificationStatusUnknown => 'Unclassified';

  @override
  String get notificationDetailTitle => 'Notification detail';

  @override
  String get notificationDetailLoading => 'Loading notification…';

  @override
  String get notificationDetailErrorMessage => 'We couldn\'t load the notification detail.';

  @override
  String get notificationDetailRetry => 'Retry';

  @override
  String notificationDetailHeaderOrganismo(String organismo) {
    return 'Issued by: $organismo';
  }

  @override
  String notificationDetailHeaderEmittedOn(String date) {
    return 'Issued on: $date';
  }

  @override
  String notificationDetailHeaderExpediente(String ref) {
    return 'File reference: $ref';
  }

  @override
  String notificationDetailHeaderProcedimiento(String procedimiento) {
    return 'Procedure: $procedimiento';
  }

  @override
  String notificationDetailHeaderDeadline(String date) {
    return 'Decision deadline: $date';
  }

  @override
  String get notificationDetailDescriptionTitle => 'Description';

  @override
  String get notificationDetailAcceptCta => 'Accept';

  @override
  String get notificationDetailRejectCta => 'Reject';

  @override
  String get notificationDetailRejectDialogTitle => 'Confirm rejection';

  @override
  String get notificationDetailRejectDialogBody => 'If you reject this notification, the administration will have a formal record of the rejection and the notification will be considered served. This action is irreversible.';

  @override
  String get notificationDetailRejectDialogConfirm => 'Reject permanently';

  @override
  String get notificationDetailRejectDialogCancel => 'Cancel';

  @override
  String get notificationDetailDecisionAcceptedToast => 'You have accepted the notification.';

  @override
  String get notificationDetailDecisionRejectedToast => 'You have rejected the notification.';

  @override
  String get notificationDetailConflictToast => 'This notification can no longer be modified. We have refreshed its status.';

  @override
  String get notificationDetailDecisionInFlight => 'Submitting your decision…';

  @override
  String notificationDetailReadOn(String date) {
    return 'Read on $date';
  }

  @override
  String get notificationDetailDocumentsTitle => 'Associated documents';

  @override
  String get notificationDetailDocumentsEmpty => 'There are no documents associated with this notification.';

  @override
  String get notificationDetailDocumentDownload => 'Download document';

  @override
  String get notificationDetailDocumentUnavailableChip => 'Unavailable';

  @override
  String notificationDetailDocumentSizeKb(num kb) {
    final intl.NumberFormat kbNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String kbString = kbNumberFormat.format(kb);

    return '$kbString KB';
  }

  @override
  String notificationDetailDocumentSizeMb(num mb) {
    final intl.NumberFormat mbNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String mbString = mbNumberFormat.format(mb);

    return '$mbString MB';
  }

  @override
  String get notificationDetailDocumentSizeUnknown => 'Unknown size';

  @override
  String get notificationDetailDocumentDownloadSuccessToast => 'Document ready';

  @override
  String get notificationDetailDocumentDownloadUnavailableToast => 'Document not available';

  @override
  String get notificationDetailDocumentDownloadErrorToast => 'We could not download the document';

  @override
  String get notificationDetailVariantAceptadaBanner => 'You have accepted this notification. You can consult the associated documents.';

  @override
  String get notificationDetailVariantRechazadaBanner => 'You have rejected this notification. The rejection acknowledgement is preserved.';

  @override
  String get notificationDetailVariantCaducadaBanner => 'The decision window for this notification has expired.';

  @override
  String get notificationContactPageTitle => 'Contact details';

  @override
  String get notificationContactExplanation => 'We need a mobile phone number or an email address to alert you about the electronic notifications you receive. We will only use this data to send you notification-related alerts.';

  @override
  String get notificationContactPhoneLabel => 'Mobile phone';

  @override
  String get notificationContactPhoneHint => '600 123 456';

  @override
  String get notificationContactPhoneHelper => 'Use the international prefix if the number is not from Spain.';

  @override
  String get notificationContactEmailLabel => 'Email address';

  @override
  String get notificationContactEmailHint => 'example@email.com';

  @override
  String get notificationContactEmailHelper => 'We will only use this email for notification alerts.';

  @override
  String get notificationContactSubmitCta => 'Register';

  @override
  String get notificationContactLoading => 'Loading contact details…';

  @override
  String get notificationContactErrorLoading => 'We couldn\'t load your contact details.';

  @override
  String get notificationContactNotRegistered => 'You are not registered for the notification service. Enter your details to register.';

  @override
  String get notificationContactErrorPhoneInvalid => 'Enter a valid mobile phone number.';

  @override
  String get notificationContactErrorEmailInvalid => 'Enter a valid email address.';

  @override
  String get notificationContactErrorBothEmpty => 'Provide at least a mobile phone or an email address.';

  @override
  String get notificationContactSuccessMessage => 'Your contact details have been registered.';

  @override
  String get notificationContactGateBannerMessage => 'Set up your contact details to receive notifications.';

  @override
  String get notificationContactGateBannerCta => 'Set up now';

  @override
  String get walletActionOpen => 'Open';

  @override
  String get walletActionShare => 'Share';

  @override
  String get walletActionAddToWallet => 'Add to Wallet';

  @override
  String get walletPreviewPdfPlaceholder => 'PDF document';

  @override
  String get walletPreviewPkpassPlaceholder => 'Wallet pass';

  @override
  String get walletPreviewQrUnavailable => 'QR preview not available';

  @override
  String get walletPreviewQrImageSemantic => 'QR code image';

  @override
  String get walletPreviewQrTextSemantic => 'QR code textual content';

  @override
  String get walletErrorInvalidArtifact => 'The file received is not valid. Please try again.';

  @override
  String get walletErrorSystem => 'We could not complete the action. Please try again.';

  @override
  String get walletErrorNoCapability => 'This action is not available on your device.';

  @override
  String get walletErrorEmptyPayload => 'The file is empty.';

  @override
  String get walletErrorTooLarge => 'The file exceeds the allowed size.';

  @override
  String get walletErrorUnsupportedSource => 'The received format is not supported.';

  @override
  String get signatureInboxTitle => 'Document signing';

  @override
  String get signatureTabPending => 'Pending';

  @override
  String get signatureTabHistory => 'History';

  @override
  String get signatureLoading => 'Loading documents…';

  @override
  String get signatureEmptyPendingTitle => 'No pending documents';

  @override
  String get signatureEmptyPendingSubtitle => 'You don\'t have any documents waiting for your signature.';

  @override
  String get signatureEmptyHistoryTitle => 'You haven\'t signed any documents yet';

  @override
  String get signatureEmptyHistorySubtitle => 'When you sign a document it will appear here.';

  @override
  String get signatureErrorMessage => 'We couldn\'t load your documents to sign.';

  @override
  String get signatureRetry => 'Try again';

  @override
  String get signatureSignAction => 'Sign';

  @override
  String get signatureHandoffPendingToast => 'We\'ve taken you to Afirma. Come back here when you\'re done.';

  @override
  String get signatureHandoffSignedToast => 'Document signed';

  @override
  String get signatureHandoffCancelledToast => 'You cancelled the signature.';

  @override
  String get signatureHandoffErrorToast => 'We couldn\'t complete the signature. Please try again.';

  @override
  String get signatureHandoffLaunchFailedToast => 'We couldn\'t open Afirma. Please try again.';

  @override
  String get signatureAfirmaReturnTitle => 'Returning from Afirma';

  @override
  String get signatureAfirmaReturnProcessing => 'Processing signature…';

  @override
  String get signatureCertificateValidTitle => 'Valid certificate';

  @override
  String get signatureCertificateMissingTitle => 'You need to install your certificate';

  @override
  String get signatureCertificateExpiredTitle => 'Your certificate has expired';

  @override
  String get signatureCertificateInvalidTitle => 'Your certificate is not valid';

  @override
  String get signatureCertificateVecTitle => 'Available via VEC';

  @override
  String get signatureCertificateUnknownTitle => 'We couldn\'t validate your certificate';

  @override
  String get signatureCertificateRecheck => 'Re-validate';

  @override
  String get signatureStatusPendiente => 'Pending';

  @override
  String get signatureStatusFirmado => 'Signed';

  @override
  String get signatureStatusExpirado => 'Expired';

  @override
  String get signatureStatusError => 'With errors';

  @override
  String get signatureStatusUnknown => 'Unclassified';

  @override
  String signatureDocumentSize(String size) {
    return '$size';
  }

  @override
  String signatureCertificateExpiresOn(String date) {
    return 'Expires on $date';
  }

  @override
  String get notificationDetailPlaceholderTitle => 'Notification detail';

  @override
  String notificationDetailPlaceholderBody(String id) {
    return 'Notification $id';
  }

  @override
  String get notificationDetailPlaceholderPending => 'Detail screen will be enabled in STORY-44.';

  @override
  String get familiaNumerosaDetailTitle => 'Large family';

  @override
  String get familiaNumerosaInfoSheetTitle => 'About Large family';

  @override
  String get familiaNumerosaInfoSheetDescription => 'Check the details of your large family title.';

  @override
  String get familiaNumerosaTitleSection => 'My large family title';

  @override
  String get familiaNumerosaRegionLabel => 'Autonomous community';

  @override
  String get familiaNumerosaTitleNumberLabel => 'Title number';

  @override
  String get familiaNumerosaCategoryGeneral => 'General';

  @override
  String get familiaNumerosaCategoryEspecial => 'Special';

  @override
  String get familiaNumerosaCategoryLabel => 'Category';

  @override
  String get familiaNumerosaValidLabel => 'Valid';

  @override
  String get familiaNumerosaIssueDateLabel => 'Issue date';

  @override
  String get familiaNumerosaExpiryDateLabel => 'Expiry date';

  @override
  String get familiaNumerosaChildrenCountLabel => 'Number of children in the title';

  @override
  String get familiaNumerosaBeneficiariesTitle => 'Beneficiaries';

  @override
  String familiaNumerosaBeneficiaryTitle(int index) {
    return 'Beneficiary $index';
  }

  @override
  String get familiaNumerosaDocumentNumberLabel => 'Document number';

  @override
  String get familiaNumerosaBirthDateLabel => 'Birth date';

  @override
  String get familiaNumerosaFullNameLabel => 'Full name';

  @override
  String get familiaNumerosaHolderLabel => 'Holder';

  @override
  String get familiaNumerosaYes => 'Yes';

  @override
  String get familiaNumerosaNo => 'No';

  @override
  String get familiaNumerosaNoDataMessage => 'We could not find large family information associated with your data in the JCCM lookup service.\n\nIf this situation is not correct or not up to date, contact the Social Welfare Department of Castilla-La Mancha.';

  @override
  String get familiaNumerosaNoDataContactHint => 'Si esta información es incorrecta o no está actualizada, contacta con la Consejería de Bienestar Social de Castilla-La Mancha.';

  @override
  String get familiaNumerosaContactListButton => 'Consultar el listado de contactos';

  @override
  String get familiaNumerosaContactHint => 'If any of your data is incorrect or not up to date, contact the Social Welfare Department of Castilla-La Mancha.';

  @override
  String get familiaNumerosaOfficeContactsButton => 'Contact';

  @override
  String get familiaNumerosaMoreInformation => 'Consultar más información';

  @override
  String familiaNumerosaCardNumberLabel(String number) {
    return 'Card number: $number';
  }

  @override
  String get familiaNumerosaCategoriaGeneral => 'General';

  @override
  String get familiaNumerosaCategoriaEspecial => 'Special';

  @override
  String get familiaNumerosaCategoriaUnknown => 'Unclassified';

  @override
  String familiaNumerosaExpiresOn(String date) {
    return 'Expires on $date';
  }

  @override
  String get familiaNumerosaMembersTitle => 'Card members';

  @override
  String get familiaNumerosaMemberFallbackName => 'No name';

  @override
  String get familiaNumerosaParentescoTitular => 'Holder';

  @override
  String get familiaNumerosaParentescoConyuge => 'Spouse';

  @override
  String get familiaNumerosaParentescoHijo => 'Son';

  @override
  String get familiaNumerosaParentescoHija => 'Daughter';

  @override
  String get familiaNumerosaParentescoOtro => 'Other';

  @override
  String get familiaNumerosaUnavailableTitle => 'Card not available';

  @override
  String get familiaNumerosaUnavailableMessage => 'Your large-family card is not valid or could not be retrieved.';

  @override
  String get familiaNumerosaErrorMessage => 'Your large-family card could not be loaded.';

  @override
  String get familiaNumerosaServiceUnavailableMessage => 'The service for consulting your large-family title is unavailable. You can reload the information or try again later.';

  @override
  String get myDataServiceUnavailableUpdate => 'Refresh';

  @override
  String get myDataNoDataContact => 'Contact';

  @override
  String get myDataNoDataOfficeContacts => 'Contact';

  @override
  String get discapacidadNoDataMessage => 'We could not find disability information associated with your details in the JCCM consultation service.\n\nIf this is incorrect or outdated, contact the Social Welfare Department of Castilla-La Mancha.';

  @override
  String get socialWelfareParkingNoDataMessage => 'We could not find parking-card information associated with your details in the JCCM consultation service.\n\nIf this is incorrect or outdated, contact the Social Welfare Department of Castilla-La Mancha.';

  @override
  String get socialWelfareThermalSpaNoDataMessage => 'We could not find thermal-spa information associated with your details in the JCCM consultation service.\n\nIf this is incorrect or outdated, contact the Social Welfare Department of Castilla-La Mancha.';

  @override
  String get socialWelfareDependencyNoDataMessage => 'We could not find dependency-care information associated with your details in the JCCM consultation service.\n\nIf this is incorrect or outdated, contact the Social Welfare Department of Castilla-La Mancha.';

  @override
  String get educationUniversityTitlesNoDataMessage => 'We could not find university titles associated with your details in the consultation service.\n\nIf this is incorrect or outdated, contact the Ministry responsible for universities.';

  @override
  String get educationNonUniversityTitlesNoDataMessage => 'We could not find non-university titles associated with your details in the consultation service.\n\nIf this is incorrect or outdated, contact the Ministry of Education.';

  @override
  String get myDataVehiclesNoDataMessage => 'We could not find vehicles associated with your details in the DGT consultation service.\n\nIf this is incorrect or outdated, contact the Directorate-General for Traffic.';

  @override
  String get myDataHousingAddressNoDataMessage => 'We could not find address information associated with your details in the municipal-register consultation service.\n\nIf this is incorrect or outdated, contact your local council.';

  @override
  String get myDataHousingRealEstateNoDataMessage => 'We could not find real-estate assets associated with your details in the Cadastre consultation service.\n\nIf this is incorrect or outdated, contact the Directorate-General for Cadastre.';

  @override
  String get myDataHealthAppointmentsNoDataMessage => 'We could not find primary-care appointments associated with your details in the SESCAM consultation service.\n\nIf this is incorrect or outdated, contact your health centre.';

  @override
  String get myDataHealthHospitalAppointmentsNoDataMessage => 'We could not find any hospital appointments linked to your data in the SESCAM query service.\n\nIf this is not correct or up to date, contact your hospital.';

  @override
  String get myDataEmploymentDemandNoDataMessage => 'We could not find job-seeker information associated with your details in the consultation service.\n\nIf this is incorrect or outdated, contact an employment office in Castilla-La Mancha.';

  @override
  String get myDataEmploymentOffersNoDataMessage => 'You have not registered for any offer yet.\n\nIf this information is incorrect or out of date, check your personal area in the Castilla-La Mancha Employment Portal.';

  @override
  String get myDataEmploymentOffersAuthorizationRequiredMessage => 'Authorise the use of your data in Preferences to view your employment offer registrations.';

  @override
  String get myDataEmploymentDemandAuthorizationRequiredMessage => 'Authorise the use of your data in Preferences to check the status of your job-seeker registration.';

  @override
  String get myDataHealthAppointmentsAuthorizationRequiredMessage => 'Authorise the use of your data in Preferences to view your primary-care appointments.';

  @override
  String get discapacidadServiceUnavailableMessage => 'The service for consulting your disability title is unavailable. You can reload the information or try again later.';

  @override
  String get socialWelfareParkingServiceUnavailableMessage => 'The service for consulting your parking card is unavailable. You can reload the information or try again later.';

  @override
  String get socialWelfareThermalSpaServiceUnavailableMessage => 'The service for consulting your thermal-spa information is unavailable. You can reload the information or try again later.';

  @override
  String get socialWelfareDependencyServiceUnavailableMessage => 'The service for consulting your dependency care information is unavailable. You can reload the information or try again later.';

  @override
  String get educationUniversityTitlesServiceUnavailableMessage => 'The service for consulting your university titles is unavailable. You can reload the information or try again later.';

  @override
  String get educationNonUniversityTitlesServiceUnavailableMessage => 'The service for consulting your non-university titles is unavailable. You can reload the information or try again later.';

  @override
  String get myDataVehiclesServiceUnavailableMessage => 'The service for consulting your vehicles is unavailable. You can reload the information or try again later.';

  @override
  String get myDataHousingAddressServiceUnavailableMessage => 'The service for consulting your address details is unavailable. You can reload the information or try again later.';

  @override
  String get myDataHousingRealEstateServiceUnavailableMessage => 'The service for consulting your real-estate assets is unavailable. You can reload the information or try again later.';

  @override
  String get myDataHealthAppointmentsServiceUnavailableMessage => 'The primary care appointments service is currently unavailable. Please try again later.';

  @override
  String get myDataHealthHospitalAppointmentsServiceUnavailableMessage => 'The hospital appointments service is currently unavailable. Please try again later.';

  @override
  String get familiaNumerosaRetry => 'Retry';

  @override
  String get jovenDetailTitle => 'Youth card';

  @override
  String jovenCodigoLabel(String code) {
    return 'Code: $code';
  }

  @override
  String jovenExpiresOn(String date) {
    return 'Valid until $date';
  }

  @override
  String get jovenSubtitle => 'Prove your youth status and unlock discounts on culture, transport and leisure across Castilla-La Mancha.';

  @override
  String get jovenUnavailableTitle => 'Card not available';

  @override
  String get jovenUnavailableMessage => 'Your youth card is not valid or could not be retrieved.';

  @override
  String get jovenErrorMessage => 'Your youth card could not be loaded.';

  @override
  String get jovenRetry => 'Retry';

  @override
  String get jovenModalDragHandleSemantic => 'Drag to resize the youth card detail';

  @override
  String get jovenModalCloseAction => 'Close';

  @override
  String get discapacidadDetailTitle => 'Disability card';

  @override
  String get discapacidadGradoLabel => 'Disability degree';

  @override
  String discapacidadGradoBadge(int grado) {
    return '$grado%';
  }

  @override
  String get discapacidadGradoUnknown => 'Degree not available';

  @override
  String discapacidadExpiresOn(String date) {
    return 'Valid until $date';
  }

  @override
  String get discapacidadValidBadge => 'Valid';

  @override
  String get discapacidadNotValidTitle => 'Card not valid';

  @override
  String get discapacidadNotValidMessage => 'Your disability card is no longer valid. The Wallet pass cannot be generated.';

  @override
  String get discapacidadUnavailableTitle => 'No data available';

  @override
  String get discapacidadUnavailableMessage => 'We could not find any disability card data for you. Please try again later.';

  @override
  String get discapacidadParseErrorMessage => 'We could not interpret the disability card response.';

  @override
  String get discapacidadErrorMessage => 'Your disability card could not be loaded.';

  @override
  String get discapacidadRetry => 'Retry';

  @override
  String get discapacidadActionPkpass => 'Add to Wallet';

  @override
  String get recommendationsTitle => 'My Recommendations';

  @override
  String get recommendationsTabAll => 'All';

  @override
  String get recommendationsTabRecent => 'Recent';

  @override
  String get recommendationsTabNew => 'New';

  @override
  String get recommendationsTabImmediate => 'Immediate processing';

  @override
  String get recommendationsImmediateBadge => 'Immediate processing';

  @override
  String get recommendationsDeadlinePrefix => 'Deadline:';

  @override
  String get recommendationsResponsibleUnitPrefix => 'Unit:';

  @override
  String get recommendationsLifeEventPrefix => 'Life event:';

  @override
  String get recommendationsAssociatedLifeEventsLabel => 'Associated life events';

  @override
  String get recommendationsStatusLabel => 'Status';

  @override
  String get appCardReferenceLabel => 'Ref. no.';

  @override
  String get appCardExpiryLabel => 'Expiry';

  @override
  String get appProgressLabel => 'Progress';

  @override
  String get appProgressIndeterminateValue => 'In progress';

  @override
  String appProgressPercentage(int percentage) {
    return '$percentage%';
  }

  @override
  String get appAvatarLabel => 'Avatar';

  @override
  String get appAvatarAvailableStatus => 'Available';

  @override
  String appPhoneCallLabel(String number, String subtitle) {
    return 'Call $number. $subtitle';
  }

  @override
  String get appPhoneCallHint => 'Starts a phone call';

  @override
  String get a11yBack => 'Back';

  @override
  String get a11yClose => 'Close';

  @override
  String get a11yHelp => 'Help';

  @override
  String get a11yAppName => 'Citizen Space';

  @override
  String get a11yCancel => 'Cancel';

  @override
  String get a11yInformation => 'Information';

  @override
  String get recommendationsLoadMore => 'Load more';

  @override
  String get recommendationsEmptyUnconfiguredTitle => 'You don\'t have personalised recommendations yet';

  @override
  String get recommendationsEmptyUnconfiguredBody => 'Tell us about your current life situation so we can suggest the procedures and services that matter to you.';

  @override
  String get recommendationsEmptyUnconfiguredPrimaryCta => 'Set up my preferences';

  @override
  String get recommendationsEmptyUnconfiguredSecondaryCta => 'View my life events';

  @override
  String get recommendationsEmptyUnauthorisedTitle => 'Authorisation pending for your preferences';

  @override
  String get recommendationsEmptyUnauthorisedBody => 'To show personalised recommendations we need your consent to process your data.';

  @override
  String get recommendationsEmptyUnauthorisedPrimaryCta => 'Review consents';

  @override
  String get recommendationsEmptyConfiguredTitle => 'All set — no news right now';

  @override
  String get recommendationsEmptyConfiguredBody => 'When new recommendations are available for you they\'ll appear here. Meanwhile, try a different filter.';

  @override
  String get recommendationsEmptyConfiguredSecondaryCta => 'See all';

  @override
  String get recommendationsLifeEventsComingSoon => 'My life events will be available soon';

  @override
  String get recommendationsLoadingError => 'We couldn\'t load your recommendation information. Please try again later.';

  @override
  String get recommendationsLoadingErrorRetry => 'Refresh';

  @override
  String get recommendationsDetailUnavailable => 'Details coming soon';

  @override
  String get offlineBannerMessage => 'Offline. Showing cached data.';

  @override
  String get a11yStickybarLabel => 'Main actions';

  @override
  String get a11yLandingH1Label => 'Citizen Space of Castilla-La Mancha';

  @override
  String get a11yCastillaLogoLabel => 'Regional Government of Castilla-La Mancha';

  @override
  String get a11yLoading => 'Loading';

  @override
  String get a11yContentLoaded => 'Content loaded';

  @override
  String a11yFieldError(String field, String error) {
    return 'Error, $field: $error';
  }

  @override
  String a11yExpandTextArea(String field) {
    return 'Expand $field';
  }

  @override
  String a11yCollapseTextArea(String field) {
    return 'Collapse $field';
  }

  @override
  String a11ySelectPhoneCountryCode(String countryCode) {
    return 'Select phone country code, current $countryCode';
  }

  @override
  String a11yFilterButtonActiveCount(String label, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count active filters',
      one: '1 active filter',
    );
    return '$label, $_temp0';
  }

  @override
  String get a11yFilterActions => 'Filter actions';

  @override
  String get listFilterClear => 'Clear filters';

  @override
  String get listFilterApply => 'Apply filters';

  @override
  String get listFilterSelectDateRange => 'Select date range';

  @override
  String get listFilterSelectStartDate => 'Select the start date.';

  @override
  String get listFilterSelectEndDate => 'Select the end date.';

  @override
  String get listFilterRangeSelected => 'Date range selected.';

  @override
  String get listFilterRemoveRange => 'Remove range';

  @override
  String get listFilterConfirmRange => 'Select range';

  @override
  String a11yListFilterDateRange(String label, String startDate, String endDate) {
    return '$label. From $startDate to $endDate';
  }

  @override
  String a11yErrorState(String message) {
    return 'Error: $message';
  }

  @override
  String a11yEmptyState(String message) {
    return 'No content: $message';
  }

  @override
  String a11yBlockedState(String message) {
    return 'Access unavailable: $message';
  }

  @override
  String a11yAlert(String title, String message) {
    return '$title: $message';
  }

  @override
  String get a11yAlertNeutral => 'System notice';

  @override
  String get a11yAlertSuccess => 'Success';

  @override
  String get a11yAgendaTypeNotification => 'Notification';

  @override
  String get a11yAgendaTypeHealth => 'Healthcare appointment';

  @override
  String get a11yAgendaTypeCredential => 'Credential expiry';

  @override
  String a11yAgendaCard(String type, String details) {
    return '$type: $details';
  }

  @override
  String a11yAttachmentField(String label, String hint) {
    return '$label. $hint';
  }

  @override
  String a11yRequiredAttachmentField(String label, String hint) {
    return '$label, required. $hint';
  }

  @override
  String a11yAttachmentSelected(String fileName, String fileInfo) {
    return 'Attached file: $fileName, $fileInfo';
  }

  @override
  String get a11yBottomSheet => 'Bottom sheet';

  @override
  String get a11yBottomSheetClose => 'Close';

  @override
  String get a11yCalendar => 'Calendar';

  @override
  String a11yCalendarMonth(String monthYear) {
    return 'Displayed month: $monthYear';
  }

  @override
  String a11ySelectCalendarMonthYear(String monthYear) {
    return 'Select month and year, current $monthYear';
  }

  @override
  String a11yMonthYear(String month, String year) {
    return '$month $year';
  }

  @override
  String get a11yCalendarHasEvent => 'has event';

  @override
  String get a11yCalendarOutsideMonth => 'outside displayed month';

  @override
  String a11yCaptcha(String label, String badge) {
    return '$label, $badge verification';
  }

  @override
  String get a11yCaptchaVerified => 'Captcha verified';

  @override
  String get a11yAlertWarning => 'Warning';

  @override
  String get a11yAlertError => 'Error';

  @override
  String get preferencesResetError => 'We could not delete your preferences. Please try again.';

  @override
  String get preferencesLoadError => 'We could not load your preferences. Please try again later.';

  @override
  String get preferencesLoadRetry => 'Refresh';

  @override
  String get drawerPreferences => 'Preferences';

  @override
  String drawerGreeting(String userName) {
    return 'Hello, $userName';
  }

  @override
  String get drawerLogout => 'Sign out';

  @override
  String get drawerHelpAndContact => 'Help & Contact';

  @override
  String get drawerCloseMenu => 'Close menu';

  @override
  String get drawerGoToSedeElectronica => 'Go to eGovernment Portal';

  @override
  String get myDataTitle => 'My data';

  @override
  String get myDataIntro => 'Check the information available about you in the Administration and access services and procedures linked to each area.';

  @override
  String get representativeUnavailableTitle => 'Information unavailable';

  @override
  String get representativeUnavailableMessage => 'The identification method used to sign in does not allow you to view this information. If you have another way to identify yourself, you can try again.';

  @override
  String get myDataHealthTitle => 'Health';

  @override
  String get myDataHealthDescription => 'SESCAM and health services';

  @override
  String get myDataSocialWelfareTitle => 'Social Welfare';

  @override
  String get myDataSocialWelfareDescription => 'Available services';

  @override
  String get myDataEmploymentTitle => 'Employment';

  @override
  String get myDataEmploymentDescription => 'Employment demand and services';

  @override
  String get myDataEmploymentInfoSheetTitle => 'Learn more about Employment demand';

  @override
  String get myDataEmploymentInfoSheetDescription => 'Check your current situation as a job seeker.';

  @override
  String get myDataEmploymentInfoSheetFooter => 'If any of your data is incorrect or out of date, contact the State Public Employment Service (SEPE).';

  @override
  String get myDataEmploymentInfoSheetOfficeContactsButton => 'More information';

  @override
  String get myDataEmploymentDataTab => 'My Employment data';

  @override
  String get myDataEmploymentServicesTab => 'Information and services';

  @override
  String get myDataEmploymentDemandTitle => 'My employment demand';

  @override
  String get myDataEmploymentDemandUnavailableStatus => 'Registration inactive';

  @override
  String get myDataEmploymentRegistrationDateLabel => 'Uninterrupted registration date';

  @override
  String get myDataEmploymentDemandEmpty => 'No employment demand data is registered.';

  @override
  String get myDataEmploymentDemandError => 'We could not load your employment demand.';

  @override
  String get myDataEmploymentServiceUnavailableTitle => 'Service unavailable';

  @override
  String get myDataEmploymentServiceUnavailableMessage => 'The Employment demand service is currently unavailable. You can reload the information or try again later.';

  @override
  String get myDataEmploymentServiceUnavailableReload => 'Reload page';

  @override
  String get myDataEmploymentOffersServiceUnavailableMessage => 'We could not load your employment offer registrations. Please try again later.';

  @override
  String get myDataEmploymentAuthorizationDialogTitle => 'You have not authorised data lookup in your profile';

  @override
  String get myDataEmploymentAuthorizationDialogBody => 'To view your offer registrations, you must first authorize data lookup in “Terms of use and authorizations” in your profile.';

  @override
  String get myDataEmploymentAuthorizationDialogAuthorizationsCta => 'Go to Terms of use and authorizations';

  @override
  String get myDataEmploymentAuthorizationDialogBack => 'Back';

  @override
  String get myDataEmploymentOffersTitle => 'Offer registrations';

  @override
  String get myDataEmploymentOffersDescription => 'History of job offers you have applied for';

  @override
  String get myDataEmploymentOffersPageTitle => 'Employment offer registration';

  @override
  String get myDataEmploymentOffersPortalLink => 'Employability Portal of the Regional Government of Castilla-La Mancha';

  @override
  String get myDataEmploymentOffersInfoSheetTitle => 'Learn more about employment offer registration';

  @override
  String get myDataEmploymentOffersInfoSheetFooter => 'If any of your data is incorrect or out of date, check your personal area in the Castilla-La Mancha Employment Portal.';

  @override
  String get myDataEmploymentOffersInfoSheetDescription => 'Check your latest employment offer registrations.';

  @override
  String get myDataEmploymentOffersEmptyMessage => 'You have not registered for any offer yet. If you think this is incorrect or not up to date, contact the Lirem ipsum service.';

  @override
  String get myDataEmploymentOffersLoadError => 'We could not load your offer registrations.';

  @override
  String get myDataEmploymentOfferPublicationDateLabel => 'Publication date';

  @override
  String get myDataEmploymentOfferRegistrationDateLabel => 'Registration date';

  @override
  String get myDataEmploymentOfferSelectionEndDateLabel => 'Selection process end date';

  @override
  String get myDataEmploymentOfferApplicationStatusLabel => 'Application status';

  @override
  String get myDataEmploymentProceduresTitle => 'Procedures that may interest you';

  @override
  String get myDataEmploymentProcedureProfessionalCertificate => 'Professional certificate issuance';

  @override
  String get myDataEmploymentProcedureJobSeekerRegistration => 'Registration as a job seeker at employment and entrepreneurship offices';

  @override
  String get myDataEmploymentProcedureVirtualOfficeCredentials => 'Request access credentials for the Employment and Economy virtual office for individuals, legal entities and self-employed workers.';

  @override
  String get myDataEmploymentInterestLinksTitle => 'Links of interest';

  @override
  String get myDataEmploymentLinkEmploymentClm => 'Employment CLM';

  @override
  String get myDataEmploymentLinkPublicEmploymentClm => 'Public Employment CLM';

  @override
  String get myDataEducationTitle => 'Education';

  @override
  String get myDataEducationDescription => 'Training qualifications';

  @override
  String get myDataHousingTitle => 'Housing';

  @override
  String get myDataHousingDescription => 'Property ownership';

  @override
  String get myDataHousingInfoSheetTitle => 'About My Housing data';

  @override
  String get myDataHousingInfoSheetDescription => 'Check the information about your real estate, your home and your current address details.';

  @override
  String get myDataHousingDataTab => 'My Housing data';

  @override
  String get myDataHousingServicesTab => 'Information and services';

  @override
  String get myDataHousingRealEstateTitle => 'Real estate';

  @override
  String get myDataHousingRealEstateDescription => 'Property cadastral information';

  @override
  String get myDataHousingRealEstateInfoSheetTitle => 'Learn more about Real estate';

  @override
  String get myDataHousingRealEstateInfoSheetDescription => 'Check the cadastral information for the properties registered in your name with the Cadastre.';

  @override
  String get myDataHousingRealEstateInfoSheetFooter => 'If any of your data is incorrect or out of date, contact the Cadastre e-office.';

  @override
  String get myDataHousingRealEstateFilterAll => 'All';

  @override
  String get myDataHousingRealEstateFilterUrban => 'Urban';

  @override
  String get myDataHousingRealEstateFilterRustic => 'Rustic';

  @override
  String myDataHousingRealEstateReferenceTitle(String value) {
    return 'Cadastral reference $value';
  }

  @override
  String get myDataHousingRealEstateDetailClose => 'Close';

  @override
  String get myDataHousingRealEstateDetailHomeDataTitle => 'Housing data';

  @override
  String get myDataHousingRealEstateReferenceLabel => 'Cadastral reference';

  @override
  String get myDataHousingRealEstateAddressLabel => 'Address';

  @override
  String get myDataHousingRealEstateUseLabel => 'Use';

  @override
  String get myDataHousingRealEstateCadastralValueLabel => 'Cadastral value';

  @override
  String get myDataHousingRealEstateLandValueLabel => 'Land value';

  @override
  String get myDataHousingRealEstateConstructionValueLabel => 'Construction value';

  @override
  String get myDataHousingRealEstateStatusLabel => 'Status';

  @override
  String get myDataHousingRealEstateShowCartography => 'Show cartography';

  @override
  String get myDataHousingRealEstateHoldersTitle => 'Holders';

  @override
  String get myDataHousingRealEstateHoldersEmpty => 'No holders are registered for this real-estate asset.';

  @override
  String get myDataHousingRealEstateDetailEmpty => 'We could not find the selected real-estate asset.';

  @override
  String get myDataHousingRealEstateEmpty => 'No real-estate assets are registered under your name.';

  @override
  String get myDataHousingRealEstateFilteredEmpty => 'There are no real-estate assets for this filter.';

  @override
  String get myDataHousingRealEstateError => 'We could not load Catastro data.';

  @override
  String get myDataHousingAddressTitle => 'Address in Castilla-La Mancha';

  @override
  String get myDataHousingAddressDescription => 'Municipal-register information';

  @override
  String get myDataHousingAddressInfoSheetTitle => 'Learn more about Address in Castilla-La Mancha';

  @override
  String get myDataHousingAddressInfoSheetDescription => 'Check your registration details recorded by the National Statistics Institute (INE). This information comes from Castilla-La Mancha municipal registers and is updated monthly with data sent by local councils.\n\nIf you have recently changed your registration, this information may not yet be up to date.';

  @override
  String get myDataHousingAddressInfoSheetFooter => 'If any of your data is incorrect or out of date, contact the relevant local council.';

  @override
  String get myDataHousingAddressDataTitle => 'Address data';

  @override
  String get myDataHousingAddressRegistrationDataTitle => 'Registration-related data';

  @override
  String get myDataHousingAddressLabel => 'Address';

  @override
  String get myDataHousingAddressPostalCodeLabel => 'Postal code';

  @override
  String get myDataHousingAddressMunicipalityLabel => 'Municipality';

  @override
  String get myDataHousingAddressProvinceLabel => 'Province';

  @override
  String get myDataHousingAddressCollectiveEntityLabel => 'Collective entity';

  @override
  String get myDataHousingAddressSingleEntityLabel => 'Single entity';

  @override
  String get myDataHousingAddressPopulationUnitLabel => 'Population unit';

  @override
  String get myDataHousingAddressVariationTypeLabel => 'Variation type';

  @override
  String get myDataHousingAddressVariationDateLabel => 'Variation date';

  @override
  String get myDataHousingAddressEmpty => 'No address data is registered in Castilla-La Mancha.';

  @override
  String get myDataHousingAddressError => 'We could not load your address data.';

  @override
  String get myDataHousingLinksTitle => 'Links of interest';

  @override
  String get myDataHousingLinkClmHousing => 'Castilla-La Mancha Housing Portal';

  @override
  String get myDataHousingLinkCadastre => 'Cadastre e-office';

  @override
  String get myDataHousingProceduresTitle => 'Procedures that may interest you';

  @override
  String get myDataHousingProcedureRentalHousingAid => 'Housing rental aid';

  @override
  String get myDataHousingProcedureProtectedHousingRegister => 'Registration in the Housing Applicants Register';

  @override
  String get myDataHousingProcedureSocialEmergencyAid => 'Social emergency aid';

  @override
  String get myDataVehiclesTitle => 'Vehicles';

  @override
  String get myDataVehiclesDescription => 'Your registered vehicles';

  @override
  String get myDataVehiclesInfoSheetTitle => 'Learn more about Vehicles';

  @override
  String get myDataVehiclesInfoSheetDescription => 'Check the information for vehicles registered in your name with the General Directorate of Traffic (DGT).';

  @override
  String get myDataVehiclesInfoSheetFooter => 'If any of your data is incorrect or out of date, contact the General Directorate of Traffic (DGT).';

  @override
  String get myDataVehiclesInfoSheetContactButton => 'More information';

  @override
  String get myDataVehiclesDataTab => 'My Vehicles data';

  @override
  String get myDataVehiclesServicesTab => 'Information and services';

  @override
  String get myDataVehiclesSectionTitle => 'My vehicles';

  @override
  String get myDataVehiclesLicensePlateLabel => 'Vehicle registration number';

  @override
  String get myDataVehiclesEmpty => 'There are no vehicles registered in your name.';

  @override
  String get myDataVehiclesError => 'We could not load your vehicles.';

  @override
  String get myDataVehiclesServicesEmpty => 'Vehicles information and services will be available soon.';

  @override
  String get myDataVehiclesLinksTitle => 'Links of interest';

  @override
  String get myDataVehiclesLinkDgt => 'DGT electronic office';

  @override
  String get myDataVehiclesLinkAge => 'AGE Citizen Folder';

  @override
  String get myDataVehiclesProceduresTitle => 'Procedures that may interest you';

  @override
  String get myDataVehiclesProcedureMoves3Vehicle => 'MOVES III aid application for electric vehicle acquisition';

  @override
  String get myDataVehiclesProcedureMoves3Infrastructure => 'MOVES III aid application for electric vehicle charging infrastructure implementation';

  @override
  String get myDataVehiclesProcedureCap => 'Homologation of driver training courses (CAP)';

  @override
  String myDataSectionComingSoon(String section) {
    return '$section will be available soon';
  }

  @override
  String get myDataHealthInfoMessage => 'Check your health data and available appointments.';

  @override
  String get myDataEducationInfoSheetTitle => 'About My Education data';

  @override
  String get myDataEducationInfoSheetDescription => 'Check your information and access related education services in Castilla-La Mancha.';

  @override
  String get myDataEducationDataTab => 'My Education data';

  @override
  String get myDataEducationServicesTab => 'Information and services';

  @override
  String get myDataEducationUniversityTitles => 'University degrees';

  @override
  String get myDataEducationNonUniversityTitles => 'Non-university qualifications';

  @override
  String get myDataEducationTitlesDescription => 'Public and private universities';

  @override
  String get myDataEducationNonUniversityTitlesDescription => 'Formación profesional y otras titulaciones';

  @override
  String get myDataEducationServicesEmpty => 'Education information and services will be available soon.';

  @override
  String get myDataEducationProceduresTitle => 'Procedures you may be interested in';

  @override
  String get myDataEducationProcedureEquivalence => 'Request study equivalence with official qualifications';

  @override
  String get myDataEducationProcedureScholarships => 'Scholarships and grants for post-compulsory students';

  @override
  String get myDataEducationProcedureSecondaryDegree => 'Open tests to obtain the compulsory secondary education graduate qualification for > 18 years old';

  @override
  String get myDataEducationInterestLinksTitle => 'Links of interest';

  @override
  String get myDataEducationLinkEducationPortal => 'Castilla-La Mancha Education Portal';

  @override
  String get myDataEducationLinkTeachingStaff => 'Teaching staff';

  @override
  String get myDataEducationLinkScholarships => 'Grants and scholarships for students';

  @override
  String get myDataHealthInfoSheetTitle => 'About My Health data';

  @override
  String get myDataHealthInfoSheetDescription => 'Check the information about your Primary Care appointments from the Castilla-La Mancha Health Service (SESCAM).';

  @override
  String get myDataHealthInfoSheetContactHint => 'If any data is incorrect or out of date, contact your Health Centre.';

  @override
  String get myDataHealthInfoSheetMoreInformation => 'Consultar más información';

  @override
  String get myDataHealthDataTab => 'My Health data';

  @override
  String get myDataHealthServicesTab => 'Information and services';

  @override
  String get myDataHealthProceduresTitle => 'Procedures you may be interested in';

  @override
  String get myDataHealthProcedureComplaints => 'Claims and complaints related to SESCAM';

  @override
  String get myDataHealthProcedureHealthCard => 'Request a card for Healthcare in SESCAM';

  @override
  String get myDataHealthProcedureSpecializedCare => 'Free choice in Specialized Care';

  @override
  String get myDataHealthInterestLinksTitle => 'Links of interest';

  @override
  String get myDataHealthLinkSescam => 'Castilla-La Mancha Health Service (SESCAM)';

  @override
  String get myDataHealthLinkDigitalHealth => 'My Digital Health';

  @override
  String get myDataHealthLinkClinicalHistory => 'Digital Clinical History (National Health System)';

  @override
  String get myDataHealthAppointmentsTitle => 'Primary Care appointments';

  @override
  String myDataHealthCipLabel(String cip) {
    return 'Código de Identificación Personal (CIP): $cip';
  }

  @override
  String get myDataHealthAppointmentsEmpty => 'There are no appointments to show.';

  @override
  String get myDataHealthAppointmentsError => 'We couldn\'t load your health appointments.';

  @override
  String get myDataHealthPendingTab => 'Pending';

  @override
  String get myDataHealthPastTab => 'Past';

  @override
  String get myDataHealthScopePrimaryCare => 'Primary care';

  @override
  String get myDataHealthScopeHospital => 'Hospital';

  @override
  String get myDataHealthHospitalAppointmentsTitle => 'Hospital care appointments';

  @override
  String get myDataHealthPrimaryCareNavTitle => 'Primary care appointments';

  @override
  String get myDataHealthHospitalNavTitle => 'Hospital care appointments';

  @override
  String get myDataHealthHospitalNavVerificationRequired => 'Your hospital data is protected. Verify your identity to access it.';

  @override
  String get myDataHealthHospitalLinkTitle => 'My hospital appointments';

  @override
  String get myDataHealthHospitalLinkDescription => 'Check the information about your SESCAM hospital appointments.';

  @override
  String get myDataHealthHospitalContactHint => 'If any of the data is out of date, you must contact SESCAM.';

  @override
  String get myDataHealthHospitalPendingTab => 'Upcoming appointments';

  @override
  String get myDataHealthHospitalPastTab => 'Past appointments';

  @override
  String get myDataHealthHospitalPendingEmpty => 'You have no upcoming hospital appointments.';

  @override
  String get myDataHealthHospitalPastEmpty => 'You have no past hospital appointments.';

  @override
  String get myDataHealthHospitalFieldService => 'Service';

  @override
  String get myDataHealthHospitalFieldProvision => 'Provision';

  @override
  String get myDataHealthHospitalFieldRoom => 'Room';

  @override
  String get myDataHealthHospitalFieldCenter => 'Centre';

  @override
  String get myDataHealthHospitalFieldAgenda => 'Agenda';

  @override
  String get myDataHealthHospitalFieldDateTime => 'Date and time';

  @override
  String myDataHealthHospitalDateTimeValue(String date, String time) {
    return '$date, $time';
  }

  @override
  String get myDataHealthCipUnavailable => 'CIP unavailable';

  @override
  String get identityVerificationDialogTitle => 'Identity verification';

  @override
  String get identityVerificationDialogBody => 'This query requires a higher security level and you need to identify yourself again.';

  @override
  String get identityVerificationDialogDoNotShowAgain => 'Do not show again';

  @override
  String get identityVerificationDialogBack => 'Back';

  @override
  String get identityVerificationDialogContinue => 'Go to Cl@ve';

  @override
  String get identityVerificationCompletedMessage => 'Verification completed';

  @override
  String get myDataHealthLevelRequiredMessage => 'Your current access level does not meet the application security policy. Press \"Continue\" to restart the session with the required higher access level.';

  @override
  String get myDataHealthLevelUnverifiedMessage => 'Your access level could not be verified, so your hospital appointments cannot be shown. Press \"Continue\" to restart the session.';

  @override
  String get myDataHealthLevelElevateAction => 'Continue';

  @override
  String get myDataHealthLevelStillInsufficientMessage => 'The identification method used does not reach the required access level. Press \"Continue\" and identify yourself with a digital certificate or your electronic ID card.';

  @override
  String get myDataHealthLevelElevationFailedMessage => 'Your access level could not be raised. Please try again.';

  @override
  String get myDataHealthLoadMoreAppointments => 'Load more appointments';

  @override
  String get myDataHealthYear => '2026';

  @override
  String get myDataHealthDecember => 'December';

  @override
  String get myDataHealthOctober => 'October';

  @override
  String get myDataHealthAppointmentDayNumber => '12';

  @override
  String get myDataHealthAppointmentWeekday => 'Thursday';

  @override
  String get myDataHealthAppointmentTime => '17:35h';

  @override
  String get myDataHealthAppointmentType => 'PHONE';

  @override
  String get myDataHealthAppointmentDescription => 'Primary Care appointment';

  @override
  String get myDataHealthAppointmentModality => 'On-demand teleconsultation';

  @override
  String get gestionTitle => 'Procedures';

  @override
  String get gestionExpedientesTitle => 'My cases';

  @override
  String get gestionExpedientesDescription => 'View the information and status of the cases you have started with the Regional Government of Castilla-La Mancha.';

  @override
  String get gestionRegistrosTitle => 'My registry entries';

  @override
  String get gestionRegistrosDescription => 'Access your incoming and outgoing registry entries';

  @override
  String get gestionAportacionTitle => 'Submit documents to a third party\'s case';

  @override
  String get gestionAportacionDescription => 'Attach documents to other people\'s cases';

  @override
  String get gestionNotificacionesTitle => 'My notifications';

  @override
  String get gestionNotificacionesDescription => 'Manage your electronic notifications';

  @override
  String get gestionSectionComingSoon => 'Feature coming soon';

  @override
  String get gestionExpedientesPageTitle => 'My cases';

  @override
  String get gestionExpedientesNumExpedienteLabel => 'CASE NO.';

  @override
  String get gestionExpedientesFechaInicioLabel => 'START DATE';

  @override
  String get gestionExpedientesEstadoLabel => 'STATUS';

  @override
  String get gestionExpedientesLoadError => 'We could not load your cases';

  @override
  String get gestionExpedientesEmpty => 'You have no active cases';

  @override
  String get gestionExpedientesDetalleTitle => 'Case details';

  @override
  String get gestionExpedientesDatosExpedienteTitle => 'Case information';

  @override
  String get gestionExpedientesEstadoTramitacionTitle => 'Processing status';

  @override
  String get gestionExpedientesConsejeriaLabel => 'REGIONAL MINISTRY';

  @override
  String get gestionExpedientesOficinaTramitadoraLabel => 'PROCESSING OFFICE';

  @override
  String get gestionExpedientesFechaCierreLabel => 'CLOSING DATE';

  @override
  String get gestionExpedientesAportarDocumentacionButton => 'Submit documents';

  @override
  String get gestionExpedientesDetalleLoadError => 'We could not load the case details';

  @override
  String get gestionAportarDocumentacionTitle => 'Submit documents';

  @override
  String get gestionAportarDocumentacionHelperText => 'You can attach up to 5 files of a maximum of 20 MB each. PDF, DOC, DOCX, ZIP, XLS and XLSX files are supported.';

  @override
  String get gestionAportarDocumentacionInfoTitle => 'Learn more about submitting documents';

  @override
  String get gestionAportarDocumentacionInfoBody => 'Submitted documents will only be available for consultation by the Administration and cannot be viewed from the case file.';

  @override
  String get gestionAportarDocumentacionCancelarButton => 'Cancel';

  @override
  String get gestionAportarDocumentacionSeleccionarButton => 'Select documents';

  @override
  String get gestionAportarDocumentacionRegistrarButton => 'Send documents';

  @override
  String get gestionAportarDocumentacionMaxFilesError => 'You cannot attach more than 5 files.';

  @override
  String get gestionAportarDocumentacionMaxSizeError => 'Each file must be 20MB at most.';

  @override
  String get gestionAportarDocumentacionInvalidTypeError => 'File format not allowed.';

  @override
  String get gestionAportarDocumentacionDuplicateError => 'That file has already been added.';

  @override
  String get gestionAportarDocumentacionNoFilesError => 'Select at least one file before registering.';

  @override
  String get gestionAportarDocumentacionRegistroSuccess => 'Documents registered successfully.';

  @override
  String get gestionAportarDocumentacionRegistroError => 'We could not register the documents. Please try again.';

  @override
  String get gestionAportarDocumentacionUploadIncompleto => 'Some files have not been sent yet. Registering again will send all of them once more.';

  @override
  String get gestionAportarDocumentacionUploadErrorParcial => 'Some files could not be sent. You can try again.';

  @override
  String get gestionAportarDocumentacionExitoTitulo => 'Documents sent. Download the submission receipt.';

  @override
  String get gestionAportarDocumentacionExitoDescripcion => 'Your documents have been sent successfully and the submission has been registered.\n\nDownload the receipt now to keep a copy of the submission. You will not be able to download it again later.';

  @override
  String get gestionAportarDocumentacionCerrarSinDescargarButton => 'Close without downloading';

  @override
  String get gestionAportarDocumentacionDescargarJustificanteButton => 'Download receipt';

  @override
  String get gestionAportarDocumentacionJustificanteDescargado => 'Submission receipt downloaded';

  @override
  String get gestionAportarDocumentacionJustificanteError => 'The receipt could not be saved. Please try again.';

  @override
  String get gestionAportarDocumentacionFinalizacionError => 'The documents were uploaded but the registration could not be completed. You can try again.';

  @override
  String get gestionRegistrosPageTitle => 'My registry entries';

  @override
  String get gestionRegistrosEntradasTab => 'Incoming entries';

  @override
  String get gestionRegistrosEntradasDescription => 'View the communication records you have sent to the Regional Government of Castilla-La Mancha (JCCM).';

  @override
  String get gestionRegistrosSalidasTab => 'Outgoing entries';

  @override
  String get gestionRegistrosSalidasDescription => 'View the communication records you have received from the Regional Government of Castilla-La Mancha (JCCM).';

  @override
  String get gestionRegistrosNumRegistroLabel => 'REGISTRY NO.';

  @override
  String get gestionRegistrosFechaLabel => 'DATE';

  @override
  String get gestionRegistrosCardDateLabel => 'REGISTRATION DATE';

  @override
  String get gestionRegistrosConsejeriaOrigenLabel => 'ORIGIN REGIONAL MINISTRY';

  @override
  String get gestionRegistrosConsejeriaDestinoLabel => 'DESTINATION REGIONAL MINISTRY';

  @override
  String get gestionRegistrosDatosRegistroTitle => 'Registry entry information';

  @override
  String get gestionRegistrosEntradasLoadError => 'We could not load your incoming registry entries';

  @override
  String get gestionRegistrosSalidasLoadError => 'We could not load your outgoing registry entries';

  @override
  String get gestionRegistrosEntradasEmpty => 'You have no incoming registry entries';

  @override
  String get gestionRegistrosSalidasEmpty => 'You have no outgoing registry entries';

  @override
  String get gestionRegistrosDetalleEntradaTitle => 'Incoming registry entry details';

  @override
  String get gestionRegistrosDetalleSalidaTitle => 'Outgoing registry entry details';

  @override
  String get gestionAportacionTipoIdLabel => 'Identification type and number';

  @override
  String get gestionAportacionTipoIdShortLabel => 'Identification type';

  @override
  String get gestionAportacionExpedienteIdentifierTypeLabel => 'Identification type';

  @override
  String get gestionAportacionRegistroOption => 'Registration number';

  @override
  String get gestionAportacionCodigoOption => 'Case number';

  @override
  String get gestionAportacionTipoIdHint => '000000000A';

  @override
  String get gestionAportacionTipoIdHelper => 'The number must be a valid NIF, CIF, Passport, NIE or CEE';

  @override
  String get gestionAportacionIntroText => 'Look up the case you want to submit documents to';

  @override
  String get gestionAportacionPersonaLabel => 'IDENTIFY THE INTERESTED PERSON NAMED IN THE CASE';

  @override
  String get gestionAportacionExpedienteLabel => 'SPECIFY THE CASE THE DOCUMENTS ARE SUBMITTED TO';

  @override
  String get gestionAportacionExpedienteNote => '*Fill in only one of the two fields';

  @override
  String get gestionAportacionNumRegistroLabel => 'CASE REGISTRATION NUMBER';

  @override
  String get gestionAportacionNumRegistroHint => 'Registration number';

  @override
  String get gestionAportacionNumRegistroHelper => 'This number is provided when the case is filed';

  @override
  String get gestionAportacionCodIdentificadorLabel => 'CASE IDENTIFIER CODE';

  @override
  String get gestionAportacionCodIdentificadorHint => 'Case number';

  @override
  String get gestionAportacionCodIdentificadorHelper => 'You can find this number in the case documentation';

  @override
  String get gestionAportacionInfoHeading => 'Learn more about submitting documents to a case';

  @override
  String get gestionAportacionInfoBody => 'You can submit documents to a case only if you are an authorised person and the procedure is still in progress and has not yet reached a final decision. To submit documents to one of your own cases, go to My cases.';

  @override
  String get gestionAportacionInfoBullet1 => 'The interested person';

  @override
  String get gestionAportacionInfoBullet2 => 'Their legal representative';

  @override
  String get gestionAportacionInfoBullet3 => 'An authorized person';

  @override
  String get gestionAportacionSeleccionarTipo => 'Select document type';

  @override
  String get gestionAportacionDni => 'DNI';

  @override
  String get gestionAportacionNie => 'NIE';

  @override
  String get gestionAportacionCif => 'CIF';

  @override
  String get gestionAportacionPasaporte => 'Passport';

  @override
  String get gestionAportacionCee => 'CEE';

  @override
  String get gestionAportacionFindButton => 'Search case';

  @override
  String get gestionAportacionDocNumberRequiredError => 'Enter the interested person\'s document number.';

  @override
  String get gestionAportacionOwnExpedienteError => 'Este trámite es solo para aportación de documentos por terceros. Si deseas aportar documentación a tus expedientes, tienes que acceder a Mis expedientes.';

  @override
  String get gestionAportacionCamposExpedienteError => 'Fill in either the case registration number or the case identifier code (only one of the two).';

  @override
  String get gestionNotificacionesContextualMessage => 'Enter your contact details to enable alerts and receive them when you have a new notification.';

  @override
  String get gestionNotificacionesContextualAction => 'Enter details and enable alerts';

  @override
  String get gestionNotificacionesAltaTitle => 'My notifications';

  @override
  String get gestionNotificacionesAltaIntro => 'Register your contact details to start receiving notifications from the Regional Government of Castilla-La Mancha.';

  @override
  String get gestionNotificacionesAltaRequiredNote => 'You must complete at least one of the fields marked with (*)';

  @override
  String get gestionNotificacionesAltaPhoneLabel => 'Mobile phone';

  @override
  String get gestionNotificacionesAltaPhoneHint => 'Example: 000 000 000';

  @override
  String get gestionNotificacionesAltaPhoneHelper => 'Receive notifications by SMS on your mobile phone.';

  @override
  String get gestionNotificacionesAltaEmailLabel => 'Email address';

  @override
  String get gestionNotificacionesAltaEmailHint => 'Example: mperez@mail.com';

  @override
  String get gestionNotificacionesAltaEmailHelper => 'To receive the notifications in your email inbox';

  @override
  String get gestionNotificacionesAltaSaveButton => 'Activate';

  @override
  String get gestionNotificacionesAltaInfoTitle => 'Contact details';

  @override
  String get gestionNotificacionesAltaInfoBody => 'Provide a mobile phone number or an email address to receive notification alerts.';

  @override
  String get gestionNotificacionesAltaErrorAtLeastOne => 'You must provide at least a mobile phone number or an email address.';

  @override
  String get gestionNotificacionesAltaErrorPhone => 'Enter a valid mobile phone number.';

  @override
  String get gestionNotificacionesAltaErrorEmail => 'Enter a valid email address.';

  @override
  String get gestionNotificacionesAltaErrorNoCitizenId => 'We could not identify the citizen.';

  @override
  String get gestionNotificacionesAltaSuccessMessage => 'Contact details saved';

  @override
  String get gestionNotificacionesPageTitle => 'My notifications';

  @override
  String get gestionNotificacionesTabTodo => 'All';

  @override
  String get gestionNotificacionesTabPendientes => 'Pending';

  @override
  String get gestionNotificacionesTabAceptadas => 'Accepted';

  @override
  String get gestionNotificacionesTabExpiradas => 'Expired';

  @override
  String get gestionNotificacionesProcedimientoLabel => 'Procedure';

  @override
  String get gestionNotificacionesFechaCaducidadLabel => 'Expiry date';

  @override
  String get gestionNotificacionesTagPendiente => 'Pending';

  @override
  String get gestionNotificacionesTagAceptada => 'Accepted';

  @override
  String get gestionNotificacionesTagRechazada => 'Rejected';

  @override
  String get gestionNotificacionesTagExpirada => 'Expired';

  @override
  String get gestionNotificacionesEmpty => 'You have no notifications at the moment';

  @override
  String get gestionNotificacionesLoadError => 'The notifications could not be loaded';

  @override
  String get consentRevokedSessionClosed => 'You have withdrawn the authorization to access your data, so we have closed your session. Sign in again to grant it once more.';

  @override
  String get authorizationRevokedMessage => 'You no longer have authorization for this query. We are closing your session so you can grant it again when you sign back in.';

  @override
  String get mainTabHome => 'Home';

  @override
  String get mainTabGestion => 'Procedures';

  @override
  String get mainTabMyData => 'My data';

  @override
  String get mainTabAgenda => 'Calendar';

  @override
  String get mainTabRecommendations => 'Recommended';

  @override
  String get notFoundPageTitle => 'Page not found';

  @override
  String get notFoundPageMessage => '404 — The requested page does not exist.';

  @override
  String get appNotificationContactFormTitle => 'Contact details for electronic notifications';

  @override
  String get appNotificationContactFormRequiredNoteSemantic => 'Required: fill in at least one of the contact methods';

  @override
  String get appNotificationContactFormRequiredNote => '* At least one of the contact methods is required';

  @override
  String get appNotificationContactFormSaveButton => 'Save changes';

  @override
  String get appPreferenceEditAction => 'Edit';

  @override
  String get appPreferenceStatusDisabled => 'Disabled';

  @override
  String get appPreferenceStatusPending => 'Pending';

  @override
  String get appPreferenceStatusEnabled => 'Enabled';

  @override
  String get appPreferenceStatusUnavailable => 'Unavailable';

  @override
  String get appPreferenceStatusUnavailableDescription => 'We could not load this information. Please try again later.';

  @override
  String get appPreferenceStatusActive => 'Active';

  @override
  String get appNotificationContactCardTitle => 'Notification contact details';

  @override
  String get appNotificationContactCardEditAction => 'Edit details';

  @override
  String get appQrCodeLabel => 'QR code';

  @override
  String get appQrDownloadFormatTitle => 'Would you like to save the card?';

  @override
  String get appQrDownloadFormatDescription => 'Choose how you want to download it:';

  @override
  String get appQrDownloadWalletLabelAndroid => 'Wallet';

  @override
  String get appQrDownloadWalletLabelIos => 'Wallet';

  @override
  String appQrDownloadFormatLabel(String format) {
    return 'Download $format';
  }

  @override
  String appQrDownloadingFormatLabel(String format) {
    return 'Downloading $format';
  }

  @override
  String get appCalendarPreviousYearTooltip => 'Previous year';

  @override
  String get appCalendarNextYearTooltip => 'Next year';

  @override
  String get appSearchFieldHint => 'Search';

  @override
  String commonWeekdayName(String weekday) {
    String _temp0 = intl.Intl.selectLogic(
      weekday,
      {
        'monday': 'Monday',
        'tuesday': 'Tuesday',
        'wednesday': 'Wednesday',
        'thursday': 'Thursday',
        'friday': 'Friday',
        'saturday': 'Saturday',
        'sunday': 'Sunday',
        'other': '',
      },
    );
    return '$_temp0';
  }

  @override
  String commonMonthName(String month) {
    String _temp0 = intl.Intl.selectLogic(
      month,
      {
        'january': 'January',
        'february': 'February',
        'march': 'March',
        'april': 'April',
        'may': 'May',
        'june': 'June',
        'july': 'July',
        'august': 'August',
        'september': 'September',
        'october': 'October',
        'november': 'November',
        'december': 'December',
        'other': '',
      },
    );
    return '$_temp0';
  }

  @override
  String commonMonthShortName(String month) {
    String _temp0 = intl.Intl.selectLogic(
      month,
      {
        'january': 'Jan',
        'february': 'Feb',
        'march': 'Mar',
        'april': 'Apr',
        'may': 'May',
        'june': 'Jun',
        'july': 'Jul',
        'august': 'Aug',
        'september': 'Sep',
        'october': 'Oct',
        'november': 'Nov',
        'december': 'Dec',
        'other': '',
      },
    );
    return '$_temp0';
  }

  @override
  String commonUpdatedAt(Object day, Object month, Object time, Object year) {
    return 'Updated on $day $month $year at $time';
  }

  @override
  String agendaFilterDays(Object days) {
    return '$days days';
  }

  @override
  String get agendaRefreshTooltip => 'Refresh agenda';

  @override
  String get agendaEmptyAppointments => 'There are no appointments for the selected period.';

  @override
  String get agendaChannelPhone => 'phone';

  @override
  String get agendaChannelInPerson => 'in person';

  @override
  String get preferencesInfoSheetBody => 'Manage your authorizations and alerts.';

  @override
  String get consentAuthorizationsInfoTitle => 'Learn more about Terms of use and authorization';

  @override
  String get consentAuthorizationsInfoBody => 'If you do not authorize the use of your data, public administrations will not be able to show you the information they hold about you.';

  @override
  String get consentAuthorizationsInfoClose => 'Close';

  @override
  String get preferencesLifeEventsInactiveDescription => 'Accept the use of your life-event data in Terms of use and authorizations so you can select them and receive personalized recommendations.';

  @override
  String get preferencesLifeEventsPendingDescription => 'Select the situations, interests, or needs that best suit you to receive personalized recommendations.';

  @override
  String get preferencesLifeEventsActiveDescription => 'You have life events selected to receive personalized recommendations.';

  @override
  String get preferencesSelectAction => 'Select';

  @override
  String get preferencesNotificationContactTitle => 'Contact details for notification alerts';

  @override
  String get preferencesNotificationContactInactiveDescription => 'Enter a mobile phone number or email address to receive alerts when you have new notifications.';

  @override
  String get preferencesNotificationContactPendingDescription => 'Manage the contact method for receiving electronic notification alerts.';

  @override
  String get preferencesNotificationContactActiveDescription => 'You have at least one alert contact method set up for receiving electronic notifications.';

  @override
  String get preferencesManageAction => 'Manage';

  @override
  String get preferencesAddContactAction => 'Add details';

  @override
  String get preferencesBiometricTitle => 'Biometric access';

  @override
  String get preferencesBiometricInactiveDescription => 'Enable fingerprint or facial recognition access to enter the application more quickly.';

  @override
  String get preferencesBiometricActiveDescription => 'Biometric access to the application is enabled.';

  @override
  String get preferencesBiometricEnableAction => 'Enable';

  @override
  String get preferencesBiometricDisableAction => 'Disable';

  @override
  String get preferencesRevokeDialogTitle => 'You are about to delete your preferences';

  @override
  String get preferencesRevokeDialogDescription => 'Deleting your preferences will remove the authorizations you granted the organization to access your personal data.\n\nIf you access the application again, you will need to complete the authentication process and accept the Terms of use and authorizations again.';

  @override
  String get preferencesRevokeDialogConfirm => 'Delete';

  @override
  String get preferencesMissingUserIdError => 'The user identifier could not be found.';

  @override
  String get preferencesResetAuthorizationsError => 'We could not delete your authorizations. Please try again.';

  @override
  String get preferencesNotificationContactEditTitle => 'Edit contact details';

  @override
  String get gestionNotificacionesAltaErrorNoDni => 'We could not retrieve the citizen\'s ID number (DNI).';

  @override
  String myDataEducationTitleNumberLabel(Object number) {
    return 'DEGREE NO.: $number';
  }

  @override
  String get myDataEducationExpeditionDateLabel => 'DATE OF ISSUE';

  @override
  String get myDataEducationCompletionDateLabel => 'COMPLETION DATE';

  @override
  String get myDataEducationProvinceLabel => 'PROVINCE';

  @override
  String myDataEducationBookLabel(Object value) {
    return 'BOOK: $value';
  }

  @override
  String myDataEducationOrderLabel(Object value) {
    return 'ORDER: $value';
  }

  @override
  String myDataEducationFolioLabel(Object value) {
    return 'FOLIO: $value';
  }

  @override
  String myDataHealthActiveFiltersTooltip(Object count) {
    return 'Active search criteria: $count';
  }

  @override
  String get myDataHealthSearchAppointmentsTooltip => 'Search appointments';

  @override
  String get myDataHealthFilterPrimaryCareTitle => 'Filter primary care appointments';

  @override
  String get myDataHealthFilterHospitalTitle => 'Filter hospital appointments';

  @override
  String get myDataHealthFilterDateLabel => 'Appointment date';

  @override
  String get recommendationsFilterPageTitle => 'Filter by life events';

  @override
  String get recommendationsFilterInfoMessage => 'Select the life events you want to use to filter your recommendations.';

  @override
  String get recommendationsFilterIntro => 'Select the life events you want to use to filter recommendations. You can expand the list and add new life events from your preferences.';

  @override
  String get recommendationsFilterByLifeEvents => 'Filter by life events';

  @override
  String get recommendationsPreferencesHint => 'Personalize your recommendations by editing your life events in Preferences whenever you want.';

  @override
  String get recommendationsEmptyNoMatches => 'There are currently no recommendations for you. You can change your current life-event selection in Preferences or wait for new updates.';

  @override
  String get recommendationsEditLifeEventsCta => 'Go to Preferences';

  @override
  String get recommendationsEmptyFiltered => 'There are currently no recommendations for the selected filters. You can change the filter selection or wait for new updates.';

  @override
  String get recommendationsResetFilterCta => 'Restart filter';

  @override
  String recommendationsDeadlineFrom(Object date) {
    return 'from $date';
  }

  @override
  String recommendationsDeadlineUntil(Object date) {
    return 'until $date';
  }

  @override
  String get digitalCardsAuthorizationCheckErrorMessage => 'We could not verify the authorization required to display your digital cards.';

  @override
  String get digitalCardsInfoSheetTitle => 'Learn more about My digital cards';

  @override
  String get digitalCardsInfoSheetBody => 'View and download the digital cards linked to your profile and use them to complete your formalities at any time.';

  @override
  String get digitalCardsAuthorizationRequiredMessage => 'To view and download your digital cards, you must authorize the use of this data in ‘Terms of use and authorizations’.';

  @override
  String digitalCardsSaveDialogTitle(Object format) {
    return 'Save $format';
  }

  @override
  String digitalCardsDownloadSuccess(Object format) {
    return '$format saved successfully.';
  }

  @override
  String get digitalCardsPkPassAddedToWallet => 'Card downloaded and added to Wallet.';

  @override
  String digitalCardsDownloadError(Object format) {
    return 'We could not download $format.';
  }

  @override
  String get drawerDefaultUserName => 'Citizen';

  @override
  String get drawerIdentifierFallbackLabel => 'Identifier';

  @override
  String get gestionNotificacionDetalleAcceptedReloadError => 'You have accepted the notification, but we could not load the updated details.';

  @override
  String get gestionNotificacionDetalleConfirmTitle => 'Confirm notification acceptance';

  @override
  String get gestionNotificacionDetalleConfirmDescription => 'Are you sure you want to accept the notification?';

  @override
  String get gestionNotificacionDetalleConfirmCancel => 'No';

  @override
  String get gestionNotificacionDetalleConfirmAccept => 'Yes, I am sure';

  @override
  String get gestionNotificacionDetalleAcceptError => 'We could not accept the notification. Please try again.';

  @override
  String get gestionNotificacionDetalleDocumentoDescargado => 'Document downloaded.';

  @override
  String get gestionNotificacionDetalleDocumentoDescargaError => 'We could not download the document. Please try again.';

  @override
  String get gestionNotificacionDetalleDatosExpedienteTitle => 'Case information';

  @override
  String get gestionNotificacionDetalleOrganismoEmisorLabel => 'Issuing body';

  @override
  String get gestionNotificacionDetalleNumExpedienteLabel => 'Case No.';

  @override
  String get gestionNotificacionDetalleEstadoTitle => 'Notification status';

  @override
  String get gestionNotificacionDetalleFechaPuestaDisposicionLabel => 'Date made available';

  @override
  String get gestionNotificacionesFechaExpiracionLabel => 'Expiration date';

  @override
  String get gestionNotificacionDetalleFechaLecturaLabel => 'Read date';

  @override
  String get gestionNotificacionDetalleDocumentosTitle => 'Documents';

  @override
  String get gestionNotificacionDetalleAcuseRecibo => 'Acknowledgement of receipt.pdf';

  @override
  String get gestionNotificacionDetalleAceptarButton => 'Accept notification';

  @override
  String get gestionNotificacionesBuscarTooltip => 'Search notifications';

  @override
  String get gestionNotificacionesConfigurarTooltip => 'Configure notifications';

  @override
  String get gestionNotificacionesFiltrarTitle => 'Filter notifications';

  @override
  String get gestionNotificacionesFiltroDescripcionLabel => 'Notification description';

  @override
  String get gestionNotificacionesFiltrosAnterioresTooltip => 'Show previous filters';

  @override
  String get gestionRegistrosBuscarEntradasTooltip => 'Search incoming registry entries';

  @override
  String get gestionRegistrosBuscarSalidasTooltip => 'Search outgoing registry entries';

  @override
  String get gestionRegistrosFiltrarEntradasTitle => 'Filter incoming registry entries';

  @override
  String get gestionRegistrosFiltrarSalidasTitle => 'Filter outgoing registry entries';

  @override
  String get gestionRegistrosFiltroDescripcionEntradaLabel => 'Entry description';

  @override
  String get gestionRegistrosFiltroDescripcionSalidaLabel => 'Outgoing entry description';

  @override
  String get gestionRegistrosFiltroFechaEntradaLabel => 'Entry date';

  @override
  String get gestionRegistrosFiltroFechaSalidaLabel => 'Outgoing date';

  @override
  String gestionExpedientesFiltrosActivosTooltip(Object count) {
    return 'Active search criteria: $count';
  }

  @override
  String get gestionExpedientesBuscarTooltip => 'Search cases';

  @override
  String get gestionExpedientesFiltrarTitle => 'Filter cases';

  @override
  String get gestionExpedientesFiltroDescripcionLabel => 'Case description';

  @override
  String get gestionExpedientesFiltroFechaCierreLabel => 'Closing date';

  @override
  String get gestionFiltroNumeroHint => 'Enter the number';

  @override
  String get gestionFiltroDescripcionHint => 'Enter words from the description';

  @override
  String get gestionMasInformacionTooltip => 'More information';

  @override
  String get gestionAportacionPasaporteHint => 'Passport number';

  @override
  String get gestionAportacionCeeHint => 'CEE number';

  @override
  String get homeNewsSectionTitle => 'My updates';

  @override
  String get homeMyDataAccessesTitle => '“My data” shortcuts';

  @override
  String get homeNewsNotificationsTitle => 'Notifications';

  @override
  String get homeNewsNotificationsDescription => 'Check your pending notifications';

  @override
  String get homeNewsNotificationsEmptyDescription => 'You have no pending notifications';

  @override
  String get homeNewsAppointmentsTitle => 'Upcoming appointments';

  @override
  String get homeNewsAppointmentsDescription => 'Check your upcoming appointments and events';

  @override
  String get homeNewsAppointmentsEmptyDescription => 'You have no upcoming appointments or events';

  @override
  String homeNewsLabelWithCount(String label, int count) {
    return '$label ($count)';
  }

  @override
  String homeNewsLabelWithMinimumCount(String label, int count) {
    return '$label (+$count)';
  }

  @override
  String get homeRecommendedProceduresTitle => 'Recommended procedures';

  @override
  String get homeGoToRecommendationsButton => 'Go to recommendations';

  @override
  String get homeCardsFabLabel => 'Cards';

  @override
  String get homeCardsFabShowAll => 'Show all';

  @override
  String get homeCardsFabExpandSemantics => 'Show digital cards';

  @override
  String get homeCardsFabCollapseSemantics => 'Close digital card shortcuts';

  @override
  String get homeCardsFabLoadingMessage => 'We are checking your digital cards.';

  @override
  String get homeCardsFabLoadFailedMessage => 'We could not check your digital cards.';

  @override
  String get homeCardsFabEmptyMessage => 'You have no digital cards available.';

  @override
  String homeRecommendationDeadlineFrom(String date) {
    return 'from $date';
  }

  @override
  String homeRecommendationDeadlineUntil(String date) {
    return 'until $date';
  }

  @override
  String get helpContactPageTitle => 'Help and contact';

  @override
  String get helpContactGuidesTitle => 'Help guides';

  @override
  String get helpFaqIntro => 'Find answers to the most common questions about Citizen Space.';

  @override
  String get faqCategoryAccess => 'Access';

  @override
  String get faqCategoryMyData => 'My data';

  @override
  String get faqCategoryManagements => 'My requests and notifications';

  @override
  String get faqCategoryAgenda => 'Calendar';

  @override
  String get faqCategoryPopulation => 'Population register';

  @override
  String get helpContactGuidesIntro => 'Browse the available guides to resolve your questions step by step.';

  @override
  String get helpContactShowAllGuides => 'Show all guides';

  @override
  String get helpContactGoToJccmPortal => 'Go to the Castilla-La Mancha portal';

  @override
  String get helpContactInfoHeading => 'Contact information';

  @override
  String get helpContactPhonesIntro => 'For general inquiries or administrative information, you can contact the Citizen Service.';

  @override
  String get helpContactPhonesIntroBold1 => 'general inquiries or administrative information';

  @override
  String get helpContactPhonesIntroBold2 => 'Citizen Service';

  @override
  String get helpContactCallCitizenService => 'Call the Citizen Service line';

  @override
  String get helpContactExpedienteIntro => 'For more details about a case file, contact the processing office or the responsible regional ministry.';

  @override
  String get helpContactExpedienteIntroBold => 'know more details about a case file';

  @override
  String get helpContactOfficesListTitle => 'List of Information and Registry Offices';

  @override
  String get helpContactSupportIntro => 'If you need technical assistance, you can contact the technical support team through a form.';

  @override
  String get helpContactSupportIntroBold => 'technical assistance';

  @override
  String get helpContactSupportFormButton => 'Complete support form';

  @override
  String get faqQuestion1 => 'What is Citizen Space and what can I view?';

  @override
  String get faqAnswer1 => 'Citizen Space brings together information and services of the Government of Castilla-La Mancha in a single place. You can check your data, case files, notifications, appointments, and other available services.';

  @override
  String get faqQuestion2 => 'What do I need to access my Citizen Space?';

  @override
  String get faqAnswer2 => 'You need to identify yourself with Cl@ve, an electronic certificate, or the enabled access system. You can use Cl@ve Móvil, Cl@ve Permanente, electronic ID, or an electronic certificate.';

  @override
  String get faqQuestion3 => 'What personal data is stored?';

  @override
  String get faqAnswer3 => 'The data needed to provide the services available in the app is displayed.';

  @override
  String get faqQuestion4 => 'How can I correct incorrect data?';

  @override
  String get faqAnswer4 => 'Contact the body responsible for the procedure or case file to request the correction.';

  @override
  String get faqQuestion5 => 'Which case files and procedures can I view?';

  @override
  String get faqAnswer5 => 'You can view available case files and procedures associated with your identity and the services integrated into Citizen Space.';

  @override
  String get faqQuestion6 => 'Which events will appear in my agenda?';

  @override
  String get faqAnswer6 => 'Appointments, notices, and administrative events related to your services are shown.';

  @override
  String get supportFormPageTitle => 'Support form';

  @override
  String get supportCancelButton => 'Cancel';

  @override
  String get supportAcceptButton => 'Accept';

  @override
  String get supportRequiredFieldsNote => 'Fields marked with (*) are required';

  @override
  String get supportFieldFullName => 'First and last name';

  @override
  String get supportFieldFullNameHint => 'Example: María Pérez';

  @override
  String get supportFieldEmailHint => 'Example: mariaperez@email.com';

  @override
  String get supportFieldConfirmEmail => 'Confirm your email address';

  @override
  String get supportFieldSubjectHint => 'Example: Question about a notification';

  @override
  String get supportFieldSubjectHelper => 'Reason for your inquiry. 1000-character limit';

  @override
  String get supportFieldMessage => 'Message';

  @override
  String get supportFieldMessageHint => 'Describe the details of your query';

  @override
  String get supportAttachmentSectionLabel => 'ATTACH SUPPORTING DOCUMENTS';

  @override
  String get supportAttachmentUploadHint => 'You can upload a single file or image of up to 20 MB in GIF, JPEG, JPG, PNG, TXT, PDF, DOC, or DOCX format to help identify the problem.';

  @override
  String get supportAttachmentPickDocuments => 'Select documents';

  @override
  String get supportAttachmentChangeDocument => 'Change document';

  @override
  String get supportConsentDataUseLabel => 'I authorize the use and management of my data';

  @override
  String get supportCaptchaBadge => 'Verification';

  @override
  String get supportCaptchaPendingSemantics => 'not verified, tap to verify';

  @override
  String get supportCaptchaCheckingSemantics => 'verifying';

  @override
  String get supportCaptchaVerifiedSemantics => 'verified';

  @override
  String get supportPrivacyInfoDescription => 'The data protection information applicable to this form is published at';

  @override
  String get supportErrorSubjectOverLimit => 'The subject cannot exceed 1000 characters.';

  @override
  String get supportErrorAttachmentTooLarge => 'The file exceeds the maximum allowed size.';

  @override
  String get supportErrorAttachmentUnreadable => 'We could not read the selected file.';

  @override
  String get landingContentTagline => 'Your public information in one place';

  @override
  String get landingFeatureNotificationsTitle => 'Notifications';

  @override
  String get landingFeatureNotificationsDescription => 'Receive alerts and notices from the administration directly on your device.';

  @override
  String get landingFeatureHealthTitle => 'Health';

  @override
  String get landingFeatureHealthDescription => 'Check your medical history, appointments, and health card.';

  @override
  String get landingFeatureEmploymentTitle => 'Employment';

  @override
  String get landingFeatureEmploymentDescription => 'Manage your employment status and access public employment offers.';

  @override
  String get landingFeatureProceduresTitle => 'Procedures';

  @override
  String get landingFeatureProceduresDescription => 'Complete administrative procedures without traveling.';

  @override
  String get landingFeatureDigitalCardsTitle => 'Digital Cards';

  @override
  String get landingFeatureDigitalCardsDescription => 'Access your official cards and documents in digital format.';

  @override
  String get landingFeatureCadastreTitle => 'Cadastre';

  @override
  String get landingFeatureCadastreDescription => 'Check cadastral data for your properties.';

  @override
  String get landingAccessStep1Title => 'Tap \"Sign in\"';

  @override
  String get landingAccessStep1Description => 'Tap the button to start the secure authentication process.';

  @override
  String get landingAccessStep2Title => 'Authenticate with Cl@ve';

  @override
  String get landingAccessStep2Description => 'Use Cl@ve PIN or Cl@ve Permanente to identify yourself securely.';

  @override
  String get landingAccessStep3Title => 'Access all your information';

  @override
  String get landingAccessStep3Description => 'Check and manage your public information from a single place.';

  @override
  String get legalSearchTooltip => 'Search';

  @override
  String get legalSearchCloseTooltip => 'Close search';

  @override
  String get privacyResponsibleTitle => 'Who is the data controller?';

  @override
  String get privacyDocumentTitle => 'Information on personal data processing in Espacio Ciudadano';

  @override
  String get privacyEmailCopied => 'No email application is available. The address has been copied to the clipboard.';

  @override
  String get privacyResponsibleIntro => '1. The Management Directorate of the Castilla-La Mancha Digital Transformation Agency is the controller of data processed for services provided directly through Espacio Ciudadano, which are the following:';

  @override
  String get privacyResponsibleItemProfile => 'Display of notifications and the registry';

  @override
  String get privacyResponsibleItemVisualizations => 'Display of selected data from the Regional Administration and the General State Administration';

  @override
  String get privacyResponsibleItemRecommendations => 'Recommendations made on the basis of the life events selected.';

  @override
  String get privacyResponsibleItemDownloads => 'Downloads of the selected cards';

  @override
  String get privacyResponsibleItemAgenda => 'Display of the agenda';

  @override
  String get privacyResponsibleOrgParagraph => 'Once each of the options provided by Espacio Ciudadano is selected, the data controller will be each of the bodies and organizations with competence over that administrative procedure or event.';

  @override
  String get privacyResponsibleContactIntro => 'The contact details of this controller are the following:';

  @override
  String get privacyResponsibleContactAddressLabel => 'Postal Address:\n';

  @override
  String get privacyResponsibleContactAddressValue => 'Management Directorate of the Castilla-La Mancha Digital Transformation Agency\nCEMAR Building\nPlaza de Grecia, S/N\n45071 Toledo\n\nEmail address: direcciongerenciaatd@jccm.es';

  @override
  String get privacyPurposeTitle => 'What is the name and purpose of the processing?';

  @override
  String get privacyPopulationControllerText => '2. The Castilla-La Mancha Data Office is the controller for Population Register data. Its contact address is C/ Cabriel, 12 – Edificio CIE III, 45071 Toledo, and its email address is oficinadeldato@jccm.es.';

  @override
  String get privacyPurposeIntro => 'The purposes of the processing of personal data carried out directly within the Espacio Ciudadano processing activity are the following:';

  @override
  String get privacyPurposeItemIdentity => 'Management of Espacio Ciudadano as a tool for citizens to interact with the Regional Administration and its autonomous bodies:\n\n• Managing citizens\' contact details for electronic-notification alerts.\n• Managing information on ongoing proceedings, their status and notifications.\n• Displaying selected education, health, social welfare, employment, housing and vehicle data.\n• Managing authorizations and consent.\n• Managing recommendations based exclusively on selected life events and creating a profile for this purpose.\n• Displaying agenda events.';

  @override
  String get privacyPurposeItemVisualizations => 'The purposes of Population Register processing are:\n\n• Producing official statistics.\n• Communication between JCCM bodies and citizens.\n• Evaluating the quality of services provided.';

  @override
  String get privacyLegalBasisTitle => 'What is the legal basis for this processing?';

  @override
  String get privacyLegalBasisText => 'The legal bases for Espacio Ciudadano processing are legal obligation and performance of a task carried out in the public interest (Article 6.1(c) and (e) GDPR), including Law 39/2015, Royal Decree 203/2021 and Law 4/2025. Processing of State Administration information, recommendations, events and selected cards is based on consent, which may be withdrawn in the user profile.\n\nFor the Population Register, telephone and email processing is based on consent (Article 6.1(a)); other data is processed in the public interest (Article 6.1(e), Law 10/2002 on Castilla-La Mancha Statistics).';

  @override
  String get privacyTransfersTitle => 'Are data transferred?';

  @override
  String get privacyTransfersText => 'Personal data is not transferred as part of Espacio Ciudadano processing.\n\nPopulation Register data may be transferred to other regional Administration bodies for communication with citizens, after assessing purpose compatibility under Article 6.4 GDPR.';

  @override
  String get privacyRetentionTitle => 'How long will the data be retained?';

  @override
  String get privacyRetentionText => 'Data will be retained for as long as necessary to fulfil the purpose for which it was collected and to determine any liabilities arising from that purpose and processing. Archives and documentation rules will apply.';

  @override
  String get privacyRightsTitle => 'How can data-protection rights be exercised?';

  @override
  String get privacyRightsText => 'You may exercise your rights of access, rectification, erasure, restriction, objection and not to be subject to automated decisions free of charge, either in writing through a Registry Office addressed to the controller, or online at https://www.jccm.es/tramites/1001969.';

  @override
  String get privacyAepdTitle => 'Can I lodge a complaint with the Spanish Data Protection Agency?';

  @override
  String get privacyAepdTextBeforeLink => 'If you have evidence or indications proving that your right to data protection has been infringed in Espacio Ciudadano or in the Population Register, you may lodge a complaint with the Agencia Española de Protección de Datos (Spanish Data Protection Agency), ';

  @override
  String get privacyAepdLinkLabel => 'Spanish Data Protection Agency (AEPD)';

  @override
  String get privacyAepdTextAfterLink => '. You may also lodge a complaint with the data protection officer, whose contact details are included in this information.';

  @override
  String get privacySecurityTitle => 'What security measures are in place?';

  @override
  String get privacySecurityText => 'The security measures implemented to guarantee the security of personal data correspond to those set out in Annex II (Security measures) of Real Decreto 311/2022, de 3 de mayo (Royal Decree 311/2022, of May 3), which regulates the National Security Framework (Esquema Nacional de Seguridad).';

  @override
  String get privacyProfilingTitle => 'Automated decisions, including profiling';

  @override
  String get privacyProfilingText => 'In the case of recommendations of procedures based on the life events selected by a data subject, profiling does take place.';

  @override
  String get privacyDpoTitle => 'Contact details of the data protection officer';

  @override
  String get privacyDpoIntro => 'For any matter related to data protection, you may contact the data protection officer of the Administration of the Junta de Comunidades de Castilla-La Mancha (Regional Government of Castilla-La Mancha), whose contact details are the following:';

  @override
  String get privacyDpoContactAddressLabel => 'Postal address:\n';

  @override
  String get privacyDpoContactAddressValue => 'Data Protection Officer\nOficina del Dato\nVicepresidencia Primera\nC/ Río Cabriel, 12 – Edificio CIE III\n45071 - Toledo\n\n';

  @override
  String get privacyDpoContactEmailLabel => 'Email address:\n';

  @override
  String get accessibilityStatementHeading => 'Accessibility statement';

  @override
  String get accessibilityIntroCommitment => 'The Junta de Comunidades de Castilla-La Mancha (Regional Government of Castilla-La Mancha) is committed to making its website accessible, in accordance with ';

  @override
  String get accessibilityIntroDecreeLink => 'Royal Decree 1112/2018, of September 7';

  @override
  String get accessibilityIntroDecreeSuffix => ', on the accessibility of public sector websites and applications for mobile devices (hereinafter, Royal Decree 1112/2018, of September 7).\n\n';

  @override
  String get accessibilityDeclarationScope => 'This accessibility statement applies to the website ';

  @override
  String get accessibilityComplianceTitle => 'Compliance status';

  @override
  String get accessibilityComplianceText => 'b) This website is partially compliant with RD 1112/2018, of September 7, due to the lack of conformity of the aspects indicated below.';

  @override
  String get accessibilityNonAccessibleTitle => 'Non-accessible content';

  @override
  String get accessibilityNonAccessibleIntro => 'The content listed below is not accessible for the following reasons:';

  @override
  String get accessibilityNonAccessibleItemNonConformity => 'lack of conformity with RD 1112/2018, of September 7: There could be occasional editing errors on some web pages, both in HTML content and in final documents, published after September 20, 2018.';

  @override
  String get accessibilityNonAccessibleItemBurden => 'disproportionate burden: Not applicable.';

  @override
  String get accessibilityNonAccessibleItemOutOfScope => 'the content does not fall within the scope of the applicable legislation: There could be office files in PDF or other formats published before September 20, 2018 that do not fully meet all accessibility requirements.';

  @override
  String get accessibilityPreparationTitle => 'Preparation of this accessibility statement';

  @override
  String get accessibilityPreparationText => 'This statement was prepared on October 8, 2025.\nThe method used to prepare the statement was a self-assessment carried out by the body itself.';

  @override
  String get accessibilityContactTitle => 'Observations and contact information';

  @override
  String get accessibilityContactIntro => 'You may submit communications on accessibility requirements (Article 10.2.a) of Royal Decree 1112/2018, of September 7) such as, for example:';

  @override
  String get accessibilityContactItemReport => 'reporting any possible non-compliance by this website,';

  @override
  String get accessibilityContactItemDifficulties => 'conveying other difficulties in accessing the content,';

  @override
  String get accessibilityContactItemSuggestions => 'raising any other query or suggestion for improvement regarding the accessibility of the website,';

  @override
  String get accessibilityContactChannelsIntro => 'through the following channels:';

  @override
  String get accessibilityContactFormLink => 'contact form';

  @override
  String get accessibilityOfficesPrefix => 'in person at ';

  @override
  String get accessibilityOfficesLink => 'the 012 and OIRES offices';

  @override
  String get accessibilityOfficesSuffix => ' information and registration offices).';

  @override
  String get accessibilityContactProcessing => 'Communications will be received and handled by the Viceconsejería de Administración Local y Coordinación Administrativa (Vice-Ministry of Local Administration and Administrative Coordination).';

  @override
  String get accessibilityEnforcementTitle => 'Enforcement procedure';

  @override
  String get accessibilityEnforcementText => 'The complaint procedure set out in Article 13 of RD 1112/2018 will enter into force on September 20, 2020.';

  @override
  String get accessibilityOptionalTitle => 'Optional content';

  @override
  String get accessibilityOptionalText => 'In addition to the accessibility aids built into browsers, a series of keyboard shortcuts are provided to make it easier to navigate the portal:\nAn access key or Accesskey allows the user to jump immediately to a specific part of a web page using the keyboard.';

  @override
  String get accessibilityOptionalItemIncreaseText => 'Increase Text Size: CTRL +';

  @override
  String get accessibilityOptionalItemDecreaseText => 'Decrease Text Size: CTRL -';

  @override
  String get legalNoticeHeading => 'Legal notice';

  @override
  String get legalNoticeOfficialDescription => 'Consulta el Aviso Legal completo y actualizado en el portal oficial de Espacio Ciudadano.';

  @override
  String get legalNoticeOfficialAction => 'Abrir Aviso Legal oficial';

  @override
  String get supportErrorSubmitUnauthorized => 'You do not have permission to submit the support form.';

  @override
  String get supportErrorSubmitInvalidData => 'We could not validate the information provided.';

  @override
  String get supportErrorSubmitUnavailable => 'We could not send your request. Please try again later.';

  @override
  String get notificationContactSaveUnauthorizedError => 'You do not have permission to save these contact details.';

  @override
  String get notificationContactSaveInvalidDataError => 'We could not validate the information provided.';

  @override
  String get notificationContactSaveUnavailableError => 'We could not save the contact details. Please try again later.';

  @override
  String get gestionAportacionExpedienteNotFoundError => 'We could not find any case matching those details. Please check they are correct.';

  @override
  String get gestionAportacionExpedienteUnauthorizedError => 'You do not have permission to view this case.';

  @override
  String get gestionAportacionExpedienteUnavailableError => 'We could not locate the case. Please try again later.';

  @override
  String get preferencesBiometricEnableFailed => 'Quick access could not be turned on. Identify yourself again with Cl@ve and try again.';

  @override
  String get preferencesBiometricDisabledNotice => 'Quick access is now off. When this session ends you will need to identify yourself again with Cl@ve.';

  @override
  String get sessionExpiredNotice => 'Your session could not be renewed. Identify yourself again with Cl@ve to continue.';

  @override
  String get sessionUnlockBiometricCancel => 'Cancel';

  @override
  String get sessionUnlockBiometricTitle => 'Access your space';

  @override
  String get sessionUnlockBiometricReason => 'Confirm your identity to access your space';

  @override
  String get sessionContinueBiometricTitle => 'Continue in your space';

  @override
  String get sessionContinueBiometricReason => 'Your session needs renewing. Confirm your identity to continue.';

  @override
  String get biometricAccessDialogTitle => 'Would you like to enable quick access with fingerprint or facial recognition?';

  @override
  String get biometricAccessDialogDescription => 'You will be able to access the application more quickly without having to authenticate every time. To protect your data, we will ask you to authenticate again periodically.';

  @override
  String get biometricAccessDialogCancel => 'Complete later';

  @override
  String get biometricAccessDialogConfirm => 'Enable';

  @override
  String get appUpdateRequiredTitle => 'Update required';

  @override
  String appUpdateRequiredBody(String version) {
    return 'To keep using the app you need to install version $version. Earlier versions are no longer supported.';
  }

  @override
  String get appUpdateRecommendedTitle => 'A new version is available';

  @override
  String appUpdateRecommendedBody(String version) {
    return 'Version $version includes improvements and fixes. You can update now or later.';
  }

  @override
  String get appUpdateAction => 'Update';

  @override
  String get appUpdateLater => 'Not now';

  @override
  String get appUpdateStoreUnavailable => 'The app store could not be opened. Please try again later.';

  @override
  String get appUpdateA11yDialog => 'App update notice';
}
