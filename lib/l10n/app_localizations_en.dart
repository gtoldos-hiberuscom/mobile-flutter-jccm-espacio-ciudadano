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

  @override
  String get externalLinkA11yHint => 'Opens in external browser';

  @override
  String get externalLinkOpenFailed => 'The link could not be opened. Please try again later.';

  @override
  String get externalLinkEducamosClmLabel => 'Educamos CLM';

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
  String get agendaPageTitle => 'Agenda';

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
  String get socialWelfareFamilyTitle => 'Large family';

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
  String get socialWelfareTermalismoDescription => 'The Castilla-La Mancha thermal-spa program is managed through the official Social Welfare portal.';

  @override
  String get socialWelfareParkingTitle => 'Parking card';

  @override
  String get socialWelfareParkingDescription => 'Requesting and managing the disability parking card is handled in the corresponding e-office.';

  @override
  String get socialWelfareDependenciaTitle => 'Dependency support';

  @override
  String get socialWelfareDependenciaDescription => 'Information and procedures for the Dependency Act are managed on the official Castilla-La Mancha Social Welfare portal.';

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
  String get supportCaptchaMockBadge => 'MOCK';

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
  String get homeUpcomingEventsTitle => 'Upcoming events';

  @override
  String get homeUpcomingEventsEmpty => 'You have no upcoming events.';
}
