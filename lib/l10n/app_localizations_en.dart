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
  String get digitalCardsTypeFamiliaNumerosa => 'Large-family card';

  @override
  String get digitalCardsTypeJoven => 'Youth card';

  @override
  String get digitalCardsTypeDiscapacidad => 'Disability card';

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
  String get lifeEventsSaveAction => 'Save';

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
  String get lifeEventsLoadError => 'We couldn\'t load the life events.';

  @override
  String get lifeEventsEmpty => 'There are no life events available at the moment.';

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
  String get familiaNumerosaDetailTitle => 'Large family card';

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
  String get recommendationsLoadingError => 'We couldn\'t load the recommendations.';

  @override
  String get recommendationsLoadingErrorRetry => 'Retry';

  @override
  String get recommendationsDetailUnavailable => 'Details coming soon';

  @override
  String get offlineBannerMessage => 'Offline. Showing cached data.';
}
