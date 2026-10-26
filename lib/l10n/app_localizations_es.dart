// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Espacio Ciudadano CLM';

  @override
  String get landingTitle => 'Espacio Ciudadano';

  @override
  String get landingTagline => 'Accede y consulta de forma digital los trámites y servicios disponibles para la ciudadanía de Castilla-La Mancha.';

  @override
  String get landingTaglinePrefix => 'Accede y consulta de forma digital los trámites y servicios disponibles para la ciudadanía de ';

  @override
  String get landingTaglineHighlight => 'Castilla-La Mancha.';

  @override
  String landingAccessStepLabel(int stepNumber) {
    return 'Paso $stepNumber';
  }

  @override
  String get landingCtaButton => 'Acceder a mi Espacio ciudadano';

  @override
  String get landingAboutButton => 'Saber más sobre Espacio ciudadano';

  @override
  String get landingHelpLink => 'Ayuda y contacto';

  @override
  String get landingDemoButton => 'Acceder a demostración';

  @override
  String get demoConfirmTitle => 'Modo demostración';

  @override
  String get demoConfirmBody => 'Verás la aplicación con los datos ficticios de una persona inventada, sin identificarte con Cl@ve. Nada de lo que hagas se envía ni se guarda en ningún servicio real. Para salir, cierra sesión.';

  @override
  String get demoConfirmEnter => 'Entrar en la demostración';

  @override
  String get demoConfirmBack => 'Volver';

  @override
  String get demoConfirmPersistedSessionBody => 'En este dispositivo hay una sesión guardada con acceso rápido. Para entrar en la demostración se cerrará primero: cuando quieras volver a tu espacio tendrás que identificarte de nuevo con Cl@ve.';

  @override
  String get demoConfirmCloseSessionAndEnter => 'Cerrar la sesión guardada y entrar';

  @override
  String get demoConfirmCodeLabel => 'Código de acceso';

  @override
  String get demoConfirmCodeError => 'Código incorrecto. Comprueba el código de acceso a la demostración.';

  @override
  String get demoBannerLabel => 'DEMO';

  @override
  String get demoPersistedSessionNotice => 'Hay una sesión guardada en este dispositivo. Entra con tu acceso rápido y cierra sesión antes de usar la demostración.';

  @override
  String get landingHelpPageTitle => 'Cómo acceder';

  @override
  String get landingHelpTitle => 'Cómo acceder';

  @override
  String get landingHelpBody1 => 'Para acceder a Espacio Ciudadano debes identificarte con Cl@ve, el sistema de acceso a los servicios públicos. Puedes usar Cl@ve Móvil, Cl@ve Permanente, DNI electrónico o un certificado electrónico (personal o de representante).';

  @override
  String get landingHelpAccessButton => 'Acceder a mi Espacio Ciudadano';

  @override
  String get landingHelpExternalLink => 'Enlace externo';

  @override
  String get landingAboutPageTitle => 'Saber más sobre Espacio Ciudadano';

  @override
  String get landingAboutTitle => '¿Qué es el Espacio ciudadano?';

  @override
  String get landingAboutBodyPrefix => 'es el área digital donde aparecerá información relevante con el objetivo de';

  @override
  String get landingAboutBodyBold => 'facilitar y mejorar tu relación con la Administración regional';

  @override
  String get landingAboutBodySuffix => 'en los trámites y procedimientos en los que seas parte o que puedan ser de tu interés.';

  @override
  String get landingAboutBody => 'Espacio ciudadano es un espacio digital donde puedes consultar tus trámites, encontrar otros que pueden interesarte y acceder a información y servicios que facilitan tu relación con la Administración.';

  @override
  String get landingAboutWhatYouFindTitle => '¿Qué puedo consultar?';

  @override
  String get landingAboutWhatYouFindIntro => 'En el Espacio ciudadano encontrarás:';

  @override
  String get landingAboutBullet1 => 'Tu información personal.';

  @override
  String get landingAboutBullet2 => 'Tus expedientes y su estado de tramitación.';

  @override
  String get landingAboutBullet3 => 'Tus notificaciones.';

  @override
  String get landingAboutBullet4 => 'Tus carnets digitales.';

  @override
  String get landingAboutBullet5 => 'Tus citas y eventos.';

  @override
  String get landingAboutBullet6 => 'Recomendaciones personalizadas según tus intereses.';

  @override
  String get landingAboutHelpLink => 'Mostrar información de Ayuda y contacto';

  @override
  String get landingAboutAccessButton => 'Acceder a mi Espacio ciudadano';

  @override
  String get landingAboutExternalLink => 'Enlace externo';

  @override
  String get landingWhatYouFindTitle => 'Qué encontrarás';

  @override
  String get landingHowToAccessTitle => 'Cómo acceder';

  @override
  String get landingFooterHelp => 'Ayuda';

  @override
  String get landingFooterAccessibility => 'Accesibilidad';

  @override
  String get landingFooterLegal => 'Aviso legal';

  @override
  String get landingFooterPrivacy => 'Protección de datos';

  @override
  String get loginPageTitle => 'Accediendo con Cl@ve';

  @override
  String get loginPageLoading => 'Iniciando autenticación...';

  @override
  String get loginPageLoadingDescription => 'Estamos validando tu identidad y preparando tus datos. Puede tardar unos segundos.';

  @override
  String get loginTimeoutError => 'El acceso está tardando demasiado. Inténtalo de nuevo.';

  @override
  String get loginPageError => 'Error al iniciar sesión';

  @override
  String get logoutConfirm => '¿Cerrar sesión?';

  @override
  String get sessionExpired => 'Tu sesión ha caducado';

  @override
  String get consentPageTitle => 'Condiciones de uso';

  @override
  String get consentPageSubtitle => 'Protección de datos personales';

  @override
  String get consentPageBody =>
      'De conformidad con lo dispuesto en el Reglamento (UE) 2016/679 del Parlamento Europeo y del Consejo (RGPD) y la Ley Orgánica 3/2018 de Protección de Datos Personales y garantía de los derechos digitales (LOPDGDD), la Junta de Comunidades de Castilla-La Mancha le informa de que los datos personales recabados a través de esta aplicación serán tratados bajo la responsabilidad de la Junta de Comunidades de Castilla-La Mancha, con el fin de prestarle los servicios de administración electrónica incluidos en el Espacio Ciudadano.\n\nDe acuerdo con la Ley 3/2017 de la Junta de Comunidades de Castilla-La Mancha, tiene usted derecho a acceder, rectificar y suprimir sus datos, así como a ejercer los demás derechos reconocidos en la normativa aplicable, mediante escrito dirigido a la Secretaría General de la Junta de Comunidades de Castilla-La Mancha.\n\nPara continuar utilizando la aplicación debe aceptar las presentes condiciones de uso y protección de datos. Si no acepta, se cerrará su sesión y deberá identificarse de nuevo.';

  @override
  String get consentPagePrivacyLink => 'Ver política de privacidad completa';

  @override
  String get consentAcceptButton => 'Continuar';

  @override
  String get consentRejectButton => 'Salir';

  @override
  String get consentPageSemantics => 'Pantalla de aceptación de condiciones de uso';

  @override
  String get consentStep1FullTitle => 'Condiciones de uso y autorizaciones';

  @override
  String get consentFinalAcceptButton => 'Continuar';

  @override
  String get consentSaveError => 'No se ha podido guardar el consentimiento. Por favor, inténtalo de nuevo.';

  @override
  String get consentClausesUnavailableError => 'No se han podido cargar las autorizaciones. Comprueba tu conexión e inténtalo de nuevo.';

  @override
  String get consentClausesLoadError => 'No se han podido cargar las autorizaciones.';

  @override
  String get consentScrollHint => 'Desliza hasta el final para continuar';

  @override
  String get consentLegalInfoSnackBar => 'Lee la información sobre el tratamiento y protección de datos antes de continuar';

  @override
  String get consentInfoButtonSemantics => 'Ver información legal completa';

  @override
  String get consentCloseButtonSemantics => 'Cerrar y rechazar condiciones';

  @override
  String get loadingStateDefault => 'Cargando…';

  @override
  String get emptyStateDefault => 'No hay elementos';

  @override
  String get errorStateDefault => 'Se ha producido un error';

  @override
  String get errorStateRetry => 'Reintentar';

  @override
  String get blockedStateDefault => 'Acceso no disponible';

  @override
  String get documentOpen => 'Abrir documento';

  @override
  String get documentDownload => 'Descargar documento';

  @override
  String get documentShare => 'Compartir documento';

  @override
  String get loadMoreItems => 'Cargar más elementos';

  @override
  String get pullToRefresh => 'Desliza para actualizar';

  @override
  String userGreeting(String name) {
    return 'Hola, $name';
  }

  @override
  String get userMenuProfile => 'Mi perfil';

  @override
  String get userMenuNotifications => 'Notificaciones';

  @override
  String get userMenuSettings => 'Configuración';

  @override
  String get userMenuLogout => 'Cerrar sesión';

  @override
  String get maintenanceTitle => 'Servicio en mantenimiento';

  @override
  String get maintenanceSubtitle => 'El servicio no está disponible temporalmente.';

  @override
  String get maintenanceRetry => 'Reintentar';

  @override
  String get homeGreetingFallback => 'Bienvenido al Espacio Ciudadano';

  @override
  String homeCitizenId(String id) {
    return 'Identificador: $id';
  }

  @override
  String get homeBlockEducationTitle => 'Educación';

  @override
  String get homeBlockEmploymentTitle => 'Empleo';

  @override
  String get homeBlockSocialWelfareTitle => 'Bienestar Social';

  @override
  String get homeBlockStateAffairsTitle => 'Estado y otros';

  @override
  String get homeBlockAgendaTitle => 'Agenda';

  @override
  String get homeBlockUpcomingEventsTitle => 'Próximos eventos';

  @override
  String get homeBlockCaseworkTitle => 'Mis expedientes';

  @override
  String get homeBlockNotificationsTitle => 'Mis notificaciones';

  @override
  String get homeBlockDigitalCardsTitle => 'Mis carnets digitales';

  @override
  String get homeBlockRecommendationsTitle => 'Recomendaciones';

  @override
  String get homeBlockEmpty => 'Sin novedades';

  @override
  String get homeBlockError => 'No se ha podido cargar este bloque';

  @override
  String homeBlockCount(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString elementos',
      one: '1 elemento',
      zero: 'Sin elementos',
    );
    return '$_temp0';
  }

  @override
  String homeBlockLastUpdated(String time) {
    return 'Actualizado a las $time';
  }

  @override
  String get homeBlockLastUpdatedUnknown => 'Sin datos de actualización';

  @override
  String get externalLinkA11yHint => 'Abre en navegador externo';

  @override
  String get externalLinkVisibleNotice => 'Enlace externo · Se abrirá fuera de la aplicación';

  @override
  String get externalLinkOpenFailed => 'No se pudo abrir el enlace. Inténtalo de nuevo más tarde.';

  @override
  String get externalNavigationDialogTitle => 'Vas a salir de la aplicación';

  @override
  String get drawerElectronicOfficeDialogTitle => 'Te vamos a redirigir a la Sede Electrónica';

  @override
  String get externalNavigationDialogBody => 'El contenido se abrirá en una ventana de tu navegador';

  @override
  String get externalNavigationDialogCancel => 'Volver';

  @override
  String get externalNavigationDialogContinue => 'Continuar';

  @override
  String get externalLinkEducamosClmLabel => 'Educamos CLM';

  @override
  String get externalLinkEducacionClmLabel => 'Educación Castilla-La Mancha';

  @override
  String get externalLinkEmpleoClmLabel => 'Empleo CLM';

  @override
  String get externalLinkEmpleoPublicoClmLabel => 'Empleo público CLM';

  @override
  String get externalLinkSedeDgtLabel => 'Sede Electrónica DGT';

  @override
  String get externalLinkCarpetaCiudadanaAgeLabel => 'Carpeta Ciudadana AGE';

  @override
  String get externalLinkHistoriaSocialUnicaLabel => 'Historia social única';

  @override
  String get externalLinkBienestarSocialClmLabel => 'Bienestar Social CLM';

  @override
  String get externalLinkInfanciaFamiliasLabel => 'Infancia y familias';

  @override
  String get externalLinkAepdLabel => 'Agencia Española de Protección de Datos';

  @override
  String get helpPageTitle => 'Centro de ayuda';

  @override
  String get helpSearchHint => 'Buscar en preguntas frecuentes';

  @override
  String get helpFaqSectionTitle => 'Preguntas frecuentes';

  @override
  String get helpGuidesSectionTitle => 'Guías';

  @override
  String get helpContactSectionTitle => 'Contacto';

  @override
  String get helpEmptySearchMessage => 'Sin resultados';

  @override
  String get helpEmptySearchSubtitle => 'Prueba con otros términos.';

  @override
  String get helpCategoryAccess => 'Acceso y autenticación';

  @override
  String get helpCategoryPrivacy => 'Privacidad y datos';

  @override
  String get helpCategoryServices => 'Servicios y funcionalidades';

  @override
  String get helpFaqLoginClaveQ => '¿Cómo accedo con Cl@ve?';

  @override
  String get helpFaqLoginClaveA => 'Pulsa \"Acceder con Cl@ve\" en la pantalla de inicio. Se abrirá el sistema oficial de identificación. Tras la autenticación volverás a la aplicación.';

  @override
  String get helpFaqLoginProblemsQ => 'No puedo iniciar sesión, ¿qué hago?';

  @override
  String get helpFaqLoginProblemsA => 'Verifica tu conexión y que tu certificado o credencial Cl@ve siga vigente. Si el problema persiste, contacta con el 012.';

  @override
  String get helpFaqDataProtectionQ => '¿Qué se hace con mis datos personales?';

  @override
  String get helpFaqDataProtectionA => 'Tus datos se tratan conforme al RGPD y la LOPDGDD. Consulta la política de privacidad para conocer las finalidades, plazos y derechos.';

  @override
  String get helpFaqNotificationsQ => '¿Cómo recibo notificaciones?';

  @override
  String get helpFaqNotificationsA => 'Activa los avisos en tu perfil y permite las notificaciones del sistema. Recibirás aviso cuando haya novedades en tus expedientes.';

  @override
  String get helpFaqDocumentsQ => '¿Puedo descargar documentos oficiales?';

  @override
  String get helpFaqDocumentsA => 'Sí. Desde el detalle de cada expediente puedes descargar o compartir los documentos disponibles.';

  @override
  String get helpFaqOfflineQ => '¿La aplicación funciona sin conexión?';

  @override
  String get helpFaqOfflineA => 'Algunas funciones (consulta de tarjetas y contenidos legales) se mantienen sin conexión. Las que requieren datos actualizados necesitan conectividad.';

  @override
  String get helpGuideFirstStepsTitle => 'Primeros pasos';

  @override
  String get helpGuideFirstStepsBody => 'Aprende a navegar entre Inicio, Expedientes, Notificaciones y Tarjetas. Personaliza tu perfil para una experiencia adaptada.';

  @override
  String get helpGuideCarpetaAgeTitle => 'Carpeta Ciudadana del Estado';

  @override
  String get helpGuideCarpetaAgeBody => 'Si tu trámite depende de la Administración General del Estado, accede directamente a la Carpeta Ciudadana AGE.';

  @override
  String get helpContact012PhoneLabel => 'Atención telefónica 012';

  @override
  String get helpContactEmailSupportLabel => 'Correo de soporte';

  @override
  String get helpContactOfficesUrlLabel => 'Oficinas de información y registro';

  @override
  String get legalTermsTitle => 'Condiciones de uso';

  @override
  String get legalPrivacyTitle => 'Protección de datos';

  @override
  String get legalAccessibilityTitle => 'Accesibilidad';

  @override
  String get legalNoticeTitle => 'Aviso Legal';

  @override
  String get legalNotFoundTitle => 'Documento no encontrado';

  @override
  String get legalNotFoundMessage => 'No se ha podido cargar el documento solicitado.';

  @override
  String get sitemapPageTitle => 'Mapa del sitio';

  @override
  String get sitemapGroupAuthenticated => 'Mi espacio';

  @override
  String get sitemapGroupThematic => 'Áreas temáticas';

  @override
  String get sitemapGroupHelpLegal => 'Ayuda y legales';

  @override
  String get sitemapGroupExternal => 'Recursos externos';

  @override
  String get sitemapHome => 'Inicio';

  @override
  String get sitemapAgenda => 'Agenda';

  @override
  String get sitemapCasework => 'Expedientes';

  @override
  String get sitemapNotifications => 'Notificaciones';

  @override
  String get sitemapCards => 'Tarjetas';

  @override
  String get sitemapRecommendations => 'Recomendaciones';

  @override
  String get sitemapSupport => 'Soporte';

  @override
  String get sitemapProfile => 'Perfil';

  @override
  String get sitemapEducation => 'Educación';

  @override
  String get sitemapEmployment => 'Empleo';

  @override
  String get sitemapSocialWelfare => 'Bienestar Social';

  @override
  String get sitemapStateAffairs => 'Estado y otros';

  @override
  String get sitemapHelp => 'Centro de ayuda';

  @override
  String get footerHelp => 'Ayuda';

  @override
  String get footerSitemap => 'Mapa del sitio';

  @override
  String get footerTerms => 'Condiciones';

  @override
  String get footerPrivacy => 'Privacidad';

  @override
  String get footerAccessibility => 'Accesibilidad';

  @override
  String get footerLegalNotice => 'Aviso legal';

  @override
  String get agendaRefreshFailedMessage => 'No hemos podido actualizar tu agenda con los sistemas de origen. Se muestran los últimos datos disponibles.';

  @override
  String get agendaPageTitle => 'Agenda';

  @override
  String get agendaPendingAppointmentsTitle => 'Citas pendientes';

  @override
  String get agendaFilterAll => 'Todos';

  @override
  String get agendaFilterNext7Days => 'Próximos 7 días';

  @override
  String get agendaFilterNext30Days => 'Próximos 30 días';

  @override
  String get agendaFilterNext365Days => 'Próximos 365 días';

  @override
  String get agendaFilterPast => 'Pasados';

  @override
  String get agendaViewList => 'Lista';

  @override
  String get agendaViewCalendar => 'Calendario';

  @override
  String get agendaEmpty => 'No hay eventos para el periodo seleccionado.';

  @override
  String get agendaError => 'No hemos podido cargar tu agenda.';

  @override
  String get agendaHealthAppointmentsUnavailable => 'No hemos podido cargar tus citas sanitarias.';

  @override
  String get agendaHealthCipMissing => 'En el servicio del SESCAM no existe ningún CIP vinculado a su identidad. Puede que no podamos mostrar esta información ahora. Inténtelo de nuevo más tarde.';

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
    return 'Última actualización: $timestamp';
  }

  @override
  String get agendaCategorySalud => 'Salud';

  @override
  String get agendaCategoryAdministrativo => 'Administrativo';

  @override
  String get agendaCategoryEducacion => 'Educación';

  @override
  String get agendaCategoryOtros => 'Otros';

  @override
  String get agendaPreviousMonth => 'Mes anterior';

  @override
  String get agendaNextMonth => 'Mes siguiente';

  @override
  String get agendaClearDay => 'Quitar filtro de día';

  @override
  String get agendaDetailBack => 'Volver';

  @override
  String get agendaDetailNotFound => 'El evento solicitado ya no está disponible.';

  @override
  String get agendaDetailLocation => 'Ubicación';

  @override
  String get agendaDetailWhen => 'Fecha';

  @override
  String get agendaDetailCentro => 'Centro';

  @override
  String get agendaDetailProfesional => 'Profesional';

  @override
  String get agendaDetailTipo => 'Tipo';

  @override
  String get agendaDetailDescription => 'Descripción';

  @override
  String get agendaDetailJustificante => 'Ver justificante de asistencia';

  @override
  String get agendaJustificanteUnavailable => 'El justificante se podrá abrir cuando se habilite el enlace externo.';

  @override
  String get agendaTileExpand => 'Ver más detalles';

  @override
  String get agendaTileCollapse => 'Ocultar detalles';

  @override
  String get agendaTileOpenDetail => 'Abrir detalle completo';

  @override
  String get agendaParseErrorTitle => 'No hemos podido leer tu agenda';

  @override
  String get agendaParseErrorDetail => 'Hubo un problema al interpretar la respuesta del servicio. Vuelve a intentarlo en unos minutos.';

  @override
  String get agendaParseErrorRetry => 'Intentar de nuevo';

  @override
  String get agendaPartialBanner => 'Algunos eventos no se han podido cargar. Mostramos los disponibles.';

  @override
  String get stateAffairsTitle => 'Estado y otros temas de interés';

  @override
  String get stateAffairsHeaderDescription => 'Información procedente de registros estatales (INE/Padrón, Catastro, DGT). Los datos pueden no estar actualizados en tiempo real.';

  @override
  String get stateAffairsResidenceTitle => 'Domicilio';

  @override
  String get stateAffairsResidenceSource => 'Fuente: INE / Padrón municipal';

  @override
  String get stateAffairsResidenceMunicipio => 'Municipio';

  @override
  String get stateAffairsResidenceProvincia => 'Provincia';

  @override
  String get stateAffairsResidenceComunidad => 'Comunidad autónoma';

  @override
  String get stateAffairsResidenceDireccion => 'Dirección';

  @override
  String get stateAffairsResidenceCp => 'Código postal';

  @override
  String stateAffairsResidenceLastUpdated(String timestamp) {
    return 'Actualizado: $timestamp';
  }

  @override
  String get stateAffairsPropertiesTitle => 'Bienes inmuebles';

  @override
  String get stateAffairsPropertiesSource => 'Fuente: Catastro';

  @override
  String get stateAffairsPropertiesEmpty => 'No constan bienes inmuebles a tu nombre.';

  @override
  String get stateAffairsPropertiesError => 'No hemos podido cargar los datos de Catastro.';

  @override
  String stateAffairsPropertiesTitularidad(String value) {
    return 'Titularidad: $value';
  }

  @override
  String stateAffairsPropertiesSurface(String m2) {
    return 'Superficie: $m2 m²';
  }

  @override
  String stateAffairsPropertiesReference(String value) {
    return 'Referencia catastral: $value';
  }

  @override
  String get stateAffairsVehiclesTitle => 'Vehículos';

  @override
  String get stateAffairsVehiclesSource => 'Fuente: DGT';

  @override
  String get stateAffairsVehiclesEmpty => 'No constan vehículos a tu nombre.';

  @override
  String get stateAffairsVehiclesError => 'No hemos podido cargar los datos de la DGT.';

  @override
  String stateAffairsVehiclesPlate(String value) {
    return 'Matrícula: $value';
  }

  @override
  String stateAffairsVehiclesFuel(String value) {
    return 'Combustible: $value';
  }

  @override
  String get stateAffairsDataDisclaimer => 'Los datos proceden de la DGT, INE y Catastro y pueden no estar actualizados en tiempo real.';

  @override
  String get domainExternalLinksTitle => 'Enlaces externos';

  @override
  String get domainGenericLoadError => 'No hemos podido cargar la información solicitada.';

  @override
  String get domainComingSoonBadge => 'Próximamente';

  @override
  String get educationTitle => 'Educación';

  @override
  String get educationHeaderDescription => 'Consulta tus títulos académicos y accede a los servicios oficiales de educación de Castilla-La Mancha.';

  @override
  String get educationUniversityTitlesTitle => 'Títulos universitarios';

  @override
  String get educationUniversityTitlesEmpty => 'No constan títulos universitarios a tu nombre.';

  @override
  String get educationUniversityTitlesError => 'No hemos podido cargar tus títulos universitarios.';

  @override
  String get educationUniversityTitlesInfoTitle => 'Saber más sobre Mis datos de títulos universitarios';

  @override
  String get educationUniversityTitlesInfoBody => 'Consulta la información de tus títulos universitarios inscritos en el Registro Nacional de Titulados Universitarios Oficiales del Ministerio de Ciencia, Innovación y Universidades.\n\nSi obtuviste tu título antes de 1996, es posible que tus datos no estén disponibles automáticamente.';

  @override
  String get educationUniversityTitlesInfoFooter => 'Si alguno de tus datos es incorrecto o no está actualizado, contacta con el Ministerio de Ciencia, Innovación y Universidades.';

  @override
  String get educationUniversityTitlesInfoContactButton => 'Contacto';

  @override
  String get educationNonUniversityTitlesInfoTitle => 'Saber más sobre Mis datos de títulos no universitarios';

  @override
  String get educationNonUniversityTitlesInfoBody => 'Consulta la información de tus títulos no universitarios inscritos en el Registro Nacional de Titulados no Universitarios Oficiales del Ministerio de Educación, Formación profesional y Deportes.';

  @override
  String get educationNonUniversityTitlesInfoFooter => 'Si alguno de tus datos no es correcto o no está actualizado, contacta con el Ministerio de Educación, Formación Profesional y Deportes.';

  @override
  String get educationTitlesInfoMoreInformation => 'Consultar más información';

  @override
  String get educationNonUniversityTitlesTitle => 'Títulos no universitarios';

  @override
  String get educationNonUniversityTitlesEmpty => 'No constan títulos no universitarios a tu nombre.';

  @override
  String get educationNonUniversityTitlesError => 'No hemos podido cargar tus títulos no universitarios.';

  @override
  String educationTitleYear(String year) {
    return 'Año: $year';
  }

  @override
  String get educationScholarshipTitle => 'Condición de becado';

  @override
  String get educationScholarshipDescription => 'Esta información estará disponible próximamente. Necesita un servicio adicional que aún no está integrado.';

  @override
  String get educationScholarshipTooltip => 'Capacidad pendiente de un endpoint específico de becas. Pendiente de validación de contrato (TASK-27).';

  @override
  String get employmentTitle => 'Empleo';

  @override
  String get employmentHeaderDescription => 'Consulta tu situación como demandante de empleo y accede a los portales oficiales de Empleo CLM.';

  @override
  String get employmentSeekerTitle => 'Estado de demandante de empleo';

  @override
  String get employmentSeekerSource => 'Fuente: SEPE';

  @override
  String get employmentSeekerEmpty => 'No constan datos de demanda de empleo a tu nombre.';

  @override
  String get employmentSeekerError => 'No hemos podido cargar tu estado de demandante de empleo.';

  @override
  String get employmentSeekerEstadoLabel => 'Estado actual';

  @override
  String get employmentSeekerInscripcionLabel => 'Fecha de inscripción';

  @override
  String get employmentSeekerContinuidadLabel => 'Fecha de continuidad';

  @override
  String get employmentSeekerEstadoInscrito => 'Inscrito';

  @override
  String get employmentSeekerEstadoNoInscrito => 'No inscrito';

  @override
  String get employmentSeekerEstadoBajaTemporal => 'Baja temporal';

  @override
  String get employmentOffersTitle => 'Inscripciones en ofertas';

  @override
  String get employmentOffersDescription => 'La consulta y gestión de tus inscripciones en ofertas se realiza directamente en el portal de Empleo CLM.';

  @override
  String get socialWelfareTitle => 'Bienestar Social';

  @override
  String get socialWelfareHeaderDescription => 'Consulta tu título de familia numerosa y accede a los servicios de bienestar social de Castilla-La Mancha.';

  @override
  String get socialWelfareScreenTitle => 'Bienestar social';

  @override
  String get socialWelfareDataTab => 'Mis datos de Bienestar';

  @override
  String get socialWelfareServicesTab => 'Información y servicios';

  @override
  String get socialWelfareInterestLinksTitle => 'Enlaces de interés';

  @override
  String get socialWelfareSuggestedProceduresTitle => 'Trámites que te pueden interesar';

  @override
  String get socialWelfareDisabilityRecognitionProcedure => 'Reconocimiento del grado de discapacidad';

  @override
  String get socialWelfareEarlyCareProcedure => 'Acceso al servicio de atención temprana';

  @override
  String get socialWelfareTemporaryResidentialStayProcedure => 'Plaza para el servicio de estancias temporales en centros residenciales para personas mayores';

  @override
  String get socialWelfareInfoSheetTitle => 'Saber más sobre Mis datos de Bienestar social';

  @override
  String get socialWelfareInfoSheetDescription => 'Consulta la información de tus expedientes de Bienestar Social y accede a los servicios disponibles en la Junta de Comunidades de Castilla-La Mancha.';

  @override
  String get myDataJccmAuthorizationRequiredMessage => 'Autoriza el uso de tus datos desde tus preferencias para consultar la información que la Administración tiene sobre ti.';

  @override
  String get authorizationCheckFailedMessage => 'No hemos podido comprobar tus autorizaciones. Inténtalo de nuevo.';

  @override
  String get myDataJccmAuthorizationRequiredCta => 'Ir a Condiciones de uso y autorizaciones';

  @override
  String get myDataAgeAuthorizationRequiredMessage => 'Autoriza el uso de tus datos desde tus preferencias para consultar la información que la Administración tiene sobre ti.';

  @override
  String get socialWelfareFamilyTitle => 'Familia numerosa';

  @override
  String get socialWelfareFamilyNavDescription => 'Título y personas beneficiarias';

  @override
  String get socialWelfareDisabilityTitle => 'Discapacidad';

  @override
  String get socialWelfareDisabilityNavDescription => 'Certificado de discapacidad';

  @override
  String get socialWelfareDisabilityInfoSheetTitle => 'Saber más sobre Mi título de discapacidad';

  @override
  String get socialWelfareDisabilityInfoSheetDescription => 'Consulta los datos de tu título de discapacidad.';

  @override
  String get socialWelfareDisabilityTitleSection => 'Mi título de discapacidad';

  @override
  String get socialWelfareDisabilityEffectiveDateLabel => 'Fecha de efectos';

  @override
  String get socialWelfareDisabilityPermanentValidityLabel => 'Validez definitiva';

  @override
  String get socialWelfareDisabilityFileNumberLabel => 'Número de expediente';

  @override
  String get socialWelfareDisabilityBirthDateLabel => 'Fecha de nacimiento';

  @override
  String get socialWelfareDisabilityMobilityLabel => 'Procede movilidad';

  @override
  String get socialWelfareDisabilityThirdPersonLabel => 'Reconocido concurso de tercera persona';

  @override
  String get socialWelfareDisabilityRoyalDecreeLabel => 'Real decreto en base a la que se concede el grado';

  @override
  String get socialWelfareFamilySource => 'Fuente: Junta de Comunidades de Castilla-La Mancha';

  @override
  String get socialWelfareFamilyEmpty => 'No consta título de familia numerosa a tu nombre.';

  @override
  String get socialWelfareFamilyError => 'No hemos podido cargar tu título de familia numerosa.';

  @override
  String get socialWelfareFamilyNumberLabel => 'Número de título';

  @override
  String get socialWelfareFamilyCategoriaLabel => 'Categoría';

  @override
  String get socialWelfareFamilyCaducidadLabel => 'Fecha de caducidad';

  @override
  String get socialWelfareFamilyCategoriaGeneral => 'General';

  @override
  String get socialWelfareFamilyCategoriaEspecial => 'Especial';

  @override
  String get socialWelfareFamilyBeneficiariosTitle => 'Beneficiarios';

  @override
  String get socialWelfareFamilyRelacionTitular => 'Titular';

  @override
  String get socialWelfareFamilyRelacionConyuge => 'Cónyuge';

  @override
  String get socialWelfareFamilyRelacionHijo => 'Hijo/a';

  @override
  String socialWelfareFamilyBeneficiarioLine(String relacion, String fecha) {
    return '$relacion — nacido el $fecha';
  }

  @override
  String get socialWelfareTermalismoTitle => 'Termalismo / Balnearios';

  @override
  String get socialWelfareTermalismoNavTitle => 'Termalismo';

  @override
  String get socialWelfareTermalismoNavDescription => 'Balneario adjudicado';

  @override
  String get socialWelfareTermalismoInfoSheetTitle => 'Saber más sobre Termalismo';

  @override
  String get socialWelfareTermalismoInfoSheetDescription => 'Consulta los datos del último balneario que te han adjudicado de forma definitiva en el Programa Termalismo de Castilla-La Mancha.';

  @override
  String get socialWelfareTermalismoAwardTitle => 'Último balneario adjudicado';

  @override
  String get socialWelfareTermalismoSpaNameLabel => 'Nombre del balneario';

  @override
  String get socialWelfareTermalismoStartDateLabel => 'Fecha desde';

  @override
  String get socialWelfareTermalismoEndDateLabel => 'Fecha hasta';

  @override
  String get socialWelfareTermalismoUnavailableMessage => 'No hemos encontrado información de termalismo asociada a tus datos. Vuelve a intentarlo más tarde.';

  @override
  String get socialWelfareTermalismoErrorMessage => 'No se ha podido cargar tu información de termalismo.';

  @override
  String get socialWelfareTermalismoDescription => 'El programa de termalismo y balnearios de Castilla-La Mancha se gestiona a través del portal oficial de Bienestar Social.';

  @override
  String get socialWelfareParkingTitle => 'Tarjeta de estacionamiento';

  @override
  String get socialWelfareParkingNavTitle => 'Tarjeta de estacionamiento';

  @override
  String get socialWelfareParkingNavDescription => 'Datos de la tarjeta y condiciones de uso';

  @override
  String get socialWelfareParkingInfoSheetTitle => 'Saber más sobre Mi tarjeta de estacionamiento';

  @override
  String get socialWelfareParkingInfoSheetDescription => 'Consulta los datos de tu tarjeta de estacionamiento en vigor para personas con discapacidad y movilidad reducida de Castilla-La Mancha.';

  @override
  String get socialWelfareParkingCardTitle => 'Mi tarjeta de estacionamiento';

  @override
  String get socialWelfareParkingCodeLabel => 'Código de la tarjeta';

  @override
  String get socialWelfareParkingModalityLabel => 'Modalidad';

  @override
  String get socialWelfareParkingValidFromLabel => 'Fecha de vigencia desde';

  @override
  String get socialWelfareParkingValidUntilLabel => 'Fecha de vigencia hasta';

  @override
  String get socialWelfareParkingUnavailableMessage => 'No hemos encontrado información de tarjeta de estacionamiento asociada a tus datos. Vuelve a intentarlo más tarde.';

  @override
  String get socialWelfareParkingErrorMessage => 'No se ha podido cargar tu tarjeta de estacionamiento.';

  @override
  String get socialWelfareParkingDescription => 'La solicitud y gestión de la tarjeta de estacionamiento para personas con discapacidad se realiza en la sede electrónica correspondiente.';

  @override
  String get socialWelfareDependenciaTitle => 'Atención a la dependencia';

  @override
  String get socialWelfareDependenciaNavDescription => 'Situación actual y prestaciones';

  @override
  String get socialWelfareDependenciaInfoSheetTitle => 'Saber más sobre Atención a la dependencia';

  @override
  String get socialWelfareDependenciaInfoSheetDescription => 'Consulta los datos sobre tu situación actual de las prestaciones en ayuda a la dependencia.';

  @override
  String get socialWelfareDependenciaCurrentStatusTitle => 'Mi situación actual';

  @override
  String get socialWelfareDependenciaRequestDateLabel => 'Fecha de solicitud';

  @override
  String get socialWelfareDependenciaResolutionDateLabel => 'Fecha de resolución';

  @override
  String get socialWelfareDependenciaRecognizedDegreeLabel => 'Grado reconocido';

  @override
  String get socialWelfareDependenciaBaremoLabel => 'Baremo';

  @override
  String get socialWelfareDependenciaBenefitsTitle => 'Prestaciones';

  @override
  String get socialWelfareDependenciaBenefitResolutionDateLabel => 'Fecha resolución';

  @override
  String get socialWelfareDependenciaBenefitEffectiveDateLabel => 'Fecha efecto';

  @override
  String get socialWelfareDependenciaBenefitAmountLabel => 'Importe (€)';

  @override
  String get socialWelfareDependenciaUnavailableMessage => 'No hemos encontrado información de atención a la dependencia asociada a tus datos. Vuelve a intentarlo más tarde.';

  @override
  String get socialWelfareDependenciaErrorMessage => 'No se ha podido cargar tu información de atención a la dependencia.';

  @override
  String get socialWelfareDependenciaDescription => 'La información y los trámites de la Ley de Dependencia se gestionan en el portal oficial de Bienestar Social de Castilla-La Mancha.';

  @override
  String get socialWelfareServicesEmpty => 'Información y servicios de Bienestar disponible próximamente.';

  @override
  String get supportFormTitle => 'Soporte técnico';

  @override
  String get supportFormIntro => 'Cuéntanos qué ha pasado. Nuestro equipo te responderá por correo electrónico.';

  @override
  String get supportCtaFromHelp => 'Contactar con soporte';

  @override
  String get supportFieldName => 'Nombre';

  @override
  String get supportFieldEmail => 'Correo electrónico';

  @override
  String get supportFieldEmailConfirm => 'Confirmación del correo electrónico';

  @override
  String get supportFieldSubject => 'Asunto';

  @override
  String get supportFieldDescription => 'Descripción';

  @override
  String get supportAttachmentLabel => 'Adjunto (opcional)';

  @override
  String get supportAttachmentHint => 'Puedes adjuntar un único archivo (capturas, documentos).';

  @override
  String get supportAttachmentPick => 'Seleccionar archivo';

  @override
  String get supportAttachmentChange => 'Cambiar archivo';

  @override
  String get supportAttachmentRemove => 'Quitar adjunto';

  @override
  String get supportConsentLabel => 'Autorizo el tratamiento de mis datos para gestionar mi solicitud.';

  @override
  String get supportCaptchaLabel => 'No soy un robot';

  @override
  String get supportSubmitButton => 'Enviar solicitud';

  @override
  String get supportConfirmationTitle => 'Solicitud enviada';

  @override
  String get supportConfirmationMessage => 'Hemos recibido tu solicitud. Te confirmaremos por correo electrónico.';

  @override
  String get supportConfirmationNewRequest => 'Enviar otra solicitud';

  @override
  String get supportSubmissionError => 'No hemos podido enviar tu solicitud. Inténtalo de nuevo.';

  @override
  String get supportErrorNameRequired => 'Indica tu nombre.';

  @override
  String get supportErrorEmailRequired => 'Indica tu correo electrónico.';

  @override
  String get supportErrorEmailInvalid => 'Introduce un correo electrónico válido.';

  @override
  String get supportErrorEmailConfirmRequired => 'Confirma tu correo electrónico.';

  @override
  String get supportErrorEmailMismatch => 'Los correos no coinciden.';

  @override
  String get supportErrorSubjectRequired => 'Indica un asunto.';

  @override
  String get supportErrorSubjectTooLong => 'El asunto no puede superar los 100 caracteres.';

  @override
  String get supportErrorDescriptionRequired => 'Describe tu solicitud.';

  @override
  String get supportErrorDescriptionTooLong => 'La descripción supera el límite permitido.';

  @override
  String get supportErrorConsentRequired => 'Debes autorizar el tratamiento de tus datos.';

  @override
  String get supportErrorCaptchaRequired => 'Confirma que no eres un robot.';

  @override
  String get cipCardTitle => 'Tarjeta sanitaria (CIP)';

  @override
  String get cipCardCopyTooltip => 'Copiar CIP';

  @override
  String get cipCardCopied => 'CIP copiado al portapapeles';

  @override
  String get cipCardReadOnlySubtitle => 'Sólo lectura — la tarjeta sanitaria no es descargable desde la app.';

  @override
  String get cipCardContractGap => 'Otras capacidades de salud (consultas, recetas) están sujetas a confirmación de contrato.';

  @override
  String get cipCardEmpty => 'Aún no hay tarjeta sanitaria asociada a tu perfil.';

  @override
  String get cipCardError => 'No hemos podido cargar tu tarjeta sanitaria.';

  @override
  String get cipCardParseError => 'No hemos podido leer la respuesta de la tarjeta sanitaria.';

  @override
  String get saludSurfaceTitle => 'Salud';

  @override
  String get saludSurfaceCta => 'Ver agenda';

  @override
  String get homeNoNewsMessage => 'No tienes notificaciones pendientes ni citas próximas.';

  @override
  String get homeUpcomingEventsTitle => 'Próximos eventos';

  @override
  String get homeUpcomingEventsEmpty => 'No tienes eventos próximos.';

  @override
  String get caseworkWorkspaceTitle => 'Mis gestiones';

  @override
  String get caseworkWorkspaceLoadError => 'No hemos podido cargar tus gestiones.';

  @override
  String get caseworkBreadcrumbHome => 'Inicio';

  @override
  String get caseworkTabExpedientes => 'Mis expedientes';

  @override
  String get caseworkTabEntradasRegistro => 'Mis entradas de registro';

  @override
  String get caseworkTabSalidasRegistro => 'Mis salidas de registro';

  @override
  String get caseworkExpedientesEmpty => 'No constan expedientes a tu nombre.';

  @override
  String get caseworkEntradasRegistroEmpty => 'No constan entradas de registro a tu nombre.';

  @override
  String get caseworkSalidasRegistroEmpty => 'No constan salidas de registro a tu nombre.';

  @override
  String get caseworkExpedientesError => 'No hemos podido cargar tus expedientes.';

  @override
  String get caseworkEntradasRegistroError => 'No hemos podido cargar tus entradas de registro.';

  @override
  String get caseworkSalidasRegistroError => 'No hemos podido cargar tus salidas de registro.';

  @override
  String get caseworkStatusEnTramite => 'En trámite';

  @override
  String get caseworkStatusFinalizado => 'Finalizado';

  @override
  String get caseworkStatusPendiente => 'Pendiente';

  @override
  String get caseworkStatusRechazado => 'Rechazado';

  @override
  String caseworkItemDateLabel(String date) {
    return 'Fecha: $date';
  }

  @override
  String get caseworkSearchTitle => 'Buscar expedientes y registros';

  @override
  String get caseworkSearchOpenCta => 'Buscar expedientes y registros';

  @override
  String get caseworkSearchIntro => 'Rellena al menos uno de los campos para localizar tu expediente o registro.';

  @override
  String get caseworkSearchFieldIdentificationLabel => 'NIF / NIE / Pasaporte';

  @override
  String get caseworkSearchFieldIdentificationHelper => 'Ej.: 12345678Z, X1234567A o pasaporte alfanumérico.';

  @override
  String get caseworkSearchFieldExpedienteLabel => 'Número de expediente';

  @override
  String get caseworkSearchFieldExpedienteHelper => 'Ej.: EXP/2025/00123';

  @override
  String get caseworkSearchFieldRegistroLabel => 'Número de registro';

  @override
  String get caseworkSearchFieldRegistroHelper => 'Ej.: REG/E/45612';

  @override
  String get caseworkSearchSubmit => 'Buscar';

  @override
  String get caseworkSearchAnother => 'Buscar otra cosa';

  @override
  String get caseworkSearchAportar => 'Aportar documentación al resultado';

  @override
  String get caseworkSearchAportarPending => 'La aportación documental se habilita en STORY-37 / STORY-38.';

  @override
  String get caseworkSearchErrorAtLeastOne => 'Introduce al menos uno de los tres campos para buscar.';

  @override
  String get caseworkSearchErrorInvalidIdentification => 'Formato no válido. Usa NIF (8 dígitos + letra), NIE (X/Y/Z + 7 dígitos + letra) o pasaporte alfanumérico de 6 a 9 caracteres.';

  @override
  String get caseworkSearchErrorInvalidNumber => 'Formato no válido. Solo letras, números, guiones y barras.';

  @override
  String get caseworkSearchNoResults => 'Sin coincidencias';

  @override
  String get caseworkSearchNoResultsHint => 'Revisa los datos introducidos y vuelve a intentarlo.';

  @override
  String get caseworkSearchError => 'No hemos podido completar la búsqueda. Inténtalo de nuevo.';

  @override
  String caseworkSearchResultsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count resultados',
      one: '1 resultado',
    );
    return '$_temp0';
  }

  @override
  String get caseworkExpedienteDetailTitle => 'Detalle del expediente';

  @override
  String get caseworkExpedienteDetailBack => 'Volver a Mis gestiones';

  @override
  String get caseworkExpedienteDetailLoading => 'Cargando detalle del expediente…';

  @override
  String get caseworkExpedienteDetailErrorTitle => 'No hemos podido cargar el expediente.';

  @override
  String get caseworkExpedienteDetailErrorBody => 'Vuelve a intentarlo en unos minutos.';

  @override
  String get caseworkExpedienteDetailMetadataTitle => 'Información del expediente';

  @override
  String get caseworkExpedienteDetailNumero => 'Número de expediente';

  @override
  String get caseworkExpedienteDetailAsuntoCodigo => 'Código del asunto';

  @override
  String get caseworkExpedienteDetailAsunto => 'Asunto';

  @override
  String get caseworkExpedienteDetailConsejeria => 'Consejería';

  @override
  String get caseworkExpedienteDetailOficina => 'Oficina tramitadora';

  @override
  String get caseworkExpedienteDetailProcedimiento => 'Procedimiento';

  @override
  String get caseworkExpedienteDetailFechaInicio => 'Fecha de inicio';

  @override
  String get caseworkExpedienteDetailFechaActualizacion => 'Última actualización';

  @override
  String get caseworkExpedienteDetailEstadoLabel => 'Estado';

  @override
  String get caseworkExpedienteDetailEstadoAbierto => 'Abierto';

  @override
  String get caseworkExpedienteDetailEstadoCerrado => 'Cerrado';

  @override
  String get caseworkExpedienteDetailEstadoUnknown => 'Estado desconocido';

  @override
  String get caseworkExpedienteDetailFilesTitle => 'Ficheros asociados';

  @override
  String get caseworkExpedienteDetailFilesEmpty => 'No hay ficheros asociados a este expediente.';

  @override
  String get caseworkExpedienteDetailFicheroDownloadTooltip => 'Descargar fichero';

  @override
  String get caseworkExpedienteDetailFicheroDownloadStub => 'La descarga del fichero se habilitará en una próxima versión.';

  @override
  String get caseworkExpedienteDetailOperationsTitle => 'Aportar documentación';

  @override
  String get caseworkExpedienteDetailClosedBanner => 'Expediente cerrado, no se admiten aportaciones.';

  @override
  String get digitalCardsPageTitle => 'Mis carnets digitales';

  @override
  String get digitalCardsTypeFamiliaNumerosa => 'Carnet de familia numerosa';

  @override
  String get digitalCardsTypeJoven => 'Carnet Joven';

  @override
  String get digitalCardsTypeDiscapacidad => 'Carnet de discapacidad';

  @override
  String get digitalCardsIssueDate => 'Fecha de emisión';

  @override
  String get digitalCardsEffectiveDate => 'Fecha de entrada en vigor';

  @override
  String get digitalCardsExpiryDate => 'Fecha de caducidad';

  @override
  String get digitalCardsDefinitive => 'DEFINITIVO';

  @override
  String get digitalCardTitleLabel => 'Título / Carnet';

  @override
  String get digitalCardNumberLabel => 'Número de carnet';

  @override
  String get digitalCardDownload => 'Descargar';

  @override
  String get digitalCardsStatusAvailable => 'Disponible';

  @override
  String get digitalCardsStatusNotValid => 'No vigente';

  @override
  String get digitalCardsStatusNotDownloadable => 'No descargable';

  @override
  String get digitalCardsStatusNotAvailable => 'No disponible';

  @override
  String get digitalCardsMessageNotValid => 'Este carnet no está vigente. No es posible obtener QR, PKPASS ni PDF.';

  @override
  String get digitalCardsMessageNotDownloadable => 'Este carnet no es descargable en este momento.';

  @override
  String get digitalCardsMessageNotAvailable => 'No tienes este carnet disponible.';

  @override
  String get digitalCardsActionQr => 'Ver QR';

  @override
  String get digitalCardsActionPkpass => 'Añadir a Wallet';

  @override
  String get digitalCardsActionPdf => 'Descargar PDF';

  @override
  String get digitalCardsActionComingSoon => 'Disponible próximamente.';

  @override
  String get digitalCardsPartialErrorMessage => 'No hemos podido comprobar todos tus carnets. Se muestran los disponibles.';

  @override
  String get digitalCardsEmptyMessage => 'Aún no tienes carnets digitales asociados.';

  @override
  String get digitalCardsErrorMessage => 'No hemos podido cargar tus carnets digitales.';

  @override
  String get digitalCardsCipMiniTitle => 'Tarjeta sanitaria (CIP)';

  @override
  String get digitalCardsCipMiniReadOnly => 'Sólo lectura';

  @override
  String get digitalCardsCipMiniOpenAction => 'Ver tarjeta sanitaria';

  @override
  String get lifeEventsTitle => 'Mis hechos vitales';

  @override
  String get lifeEventsHeaderDescription => 'Selecciona los hechos vitales que mejor describen tu situación para recibir recomendaciones personalizadas.';

  @override
  String get lifeEventsOnboardingTitle => 'Recomendaciones personalizadas';

  @override
  String get lifeEventsOnboardingDescription => 'Selecciona las situaciones, intereses o necesidades que más se ajustan a ti para recibir recomendaciones personalizadas.';

  @override
  String get lifeEventsCompleteLaterAction => 'Completar más tarde';

  @override
  String get lifeEventsIntroHeading => 'Selecciona las temáticas sobre las que te gustaría recibir información';

  @override
  String get lifeEventsIntroBody => 'Selecciona las temáticas sobre las que te gustaría recibir información en el apartado de recomendaciones';

  @override
  String get lifeEventsSaveAction => 'Guardar';

  @override
  String get lifeEventsAcceptAction => 'Aceptar';

  @override
  String get lifeEventsFillLaterAction => 'Rellenar luego';

  @override
  String get lifeEventsClearAllAction => 'Desmarcar todos';

  @override
  String get lifeEventsResetAction => 'Borrar preferencias';

  @override
  String get lifeEventsResetConfirmTitle => 'Borrar tus preferencias';

  @override
  String get lifeEventsResetConfirmBody => 'Se eliminarán todos los hechos vitales seleccionados. Esta acción no se puede deshacer.';

  @override
  String get lifeEventsResetConfirm => 'Borrar';

  @override
  String get lifeEventsResetCancel => 'Cancelar';

  @override
  String get lifeEventsSavedFeedback => 'Tus preferencias se han guardado correctamente.';

  @override
  String get lifeEventsErrorFeedback => 'No hemos podido guardar tus preferencias. Inténtalo de nuevo.';

  @override
  String get lifeEventsResetSuccessFeedback => 'Tus preferencias se han borrado.';

  @override
  String get lifeEventsResetErrorFeedback => 'No hemos podido borrar tus preferencias. Inténtalo de nuevo.';

  @override
  String get lifeEventsLoadError => 'No hemos podido cargar los hechos vitales.';

  @override
  String get lifeEventsEmpty => 'No hay hechos vitales disponibles en este momento.';

  @override
  String get lifeEventsDiscardConfirmTitle => 'Descartar cambios';

  @override
  String get lifeEventsDiscardConfirmBody => 'Tienes cambios sin guardar. Si sales ahora, perderás las modificaciones realizadas.';

  @override
  String get lifeEventsDiscardStay => 'Seguir editando';

  @override
  String get lifeEventsDiscardAction => 'Descartar';

  @override
  String get lifeEventsCategoryFamilia => 'Familia';

  @override
  String get lifeEventsCategorySalud => 'Salud';

  @override
  String get lifeEventsCategoryEmpleo => 'Empleo';

  @override
  String get lifeEventsCategoryVivienda => 'Vivienda';

  @override
  String get lifeEventsCategoryEducacion => 'Educación';

  @override
  String get dataConsentTitle => 'Mis autorizaciones';

  @override
  String get dataConsentHeaderDescription => 'Gestiona qué datos pueden utilizarse para ofrecerte servicios y recomendaciones personalizadas. Puedes cambiar tu decisión en cualquier momento.';

  @override
  String get dataConsentSaveAction => 'Guardar';

  @override
  String get dataConsentRevokeAction => 'Revocar todas las autorizaciones';

  @override
  String get dataConsentRevokeConfirmTitle => 'Revocar tus autorizaciones';

  @override
  String get dataConsentRevokeConfirmBody => 'Se eliminarán todas tus autorizaciones y dejaremos de personalizar contenidos hasta que vuelvas a aceptarlas.';

  @override
  String get dataConsentRevokeConfirm => 'Revocar';

  @override
  String get dataConsentRevokeCancel => 'Cancelar';

  @override
  String get dataConsentSavedFeedback => 'Tus autorizaciones se han actualizado correctamente.';

  @override
  String get dataConsentErrorFeedback => 'No hemos podido actualizar tus autorizaciones. Inténtalo de nuevo.';

  @override
  String get dataConsentLoadError => 'No hemos podido cargar tus autorizaciones.';

  @override
  String get dataConsentEmpty => 'No hay autorizaciones disponibles en este momento.';

  @override
  String get dataConsentTypeJccmTitle => 'Datos de la Junta de Comunidades de Castilla-La Mancha';

  @override
  String get dataConsentTypeJccmSubtitle => 'Permite que la JCCM utilice tus datos administrativos para ofrecerte trámites y servicios personalizados.';

  @override
  String get dataConsentTypeOtrasAdminTitle => 'Datos de otras administraciones';

  @override
  String get dataConsentTypeOtrasAdminSubtitle => 'Permite consultar datos de otras administraciones públicas para evitar que tengas que aportarlos manualmente.';

  @override
  String get dataConsentTypePerfiladoTitle => 'Perfilado para recomendaciones';

  @override
  String get dataConsentTypePerfiladoSubtitle => 'Permite analizar tu actividad para recomendarte trámites, ayudas y contenidos relevantes.';

  @override
  String get dataConsentPrivacyReferenceTitle => 'Información de protección de datos';

  @override
  String get dataConsentPrivacyReferenceBody => 'Estas autorizaciones se basan en la información de protección de datos aceptada al iniciar sesión.';

  @override
  String get dataConsentPrivacyReferenceCta => 'Ver información de protección de datos';

  @override
  String get dataConsentNavCta => 'Mis autorizaciones';

  @override
  String get caseworkUploadPageTitle => 'Aportar documentación';

  @override
  String get caseworkUploadPickerCta => 'Adjuntar archivos';

  @override
  String get caseworkUploadSelectFilesCta => 'Seleccionar archivos';

  @override
  String get caseworkUploadDropZoneSemantic => 'Zona para arrastrar y soltar archivos. También se pueden seleccionar pulsando.';

  @override
  String caseworkUploadLimitHint(int maxFiles, int maxMb) {
    return 'Máximo $maxFiles archivos. Hasta $maxMb MB cada uno.';
  }

  @override
  String caseworkUploadRemainingHint(int remaining) {
    String _temp0 = intl.Intl.pluralLogic(
      remaining,
      locale: localeName,
      other: 'Puedes adjuntar $remaining archivos más.',
      one: 'Puedes adjuntar 1 archivo más.',
      zero: 'No puedes adjuntar más archivos.',
    );
    return '$_temp0';
  }

  @override
  String get caseworkUploadEmptyList => 'Aún no hay archivos adjuntos.';

  @override
  String get caseworkUploadRemoveFile => 'Quitar archivo';

  @override
  String get caseworkUploadUploadAllCta => 'Subir todos';

  @override
  String get caseworkUploadFinalizeCta => 'Finalizar y solicitar justificante';

  @override
  String get caseworkUploadStatusSelected => 'Seleccionado';

  @override
  String get caseworkUploadStatusValidating => 'Validando';

  @override
  String get caseworkUploadStatusHashed => 'Hash calculado';

  @override
  String get caseworkUploadStatusUploading => 'Subiendo';

  @override
  String get caseworkUploadStatusUploaded => 'Subido';

  @override
  String get caseworkUploadStatusFailed => 'Error';

  @override
  String get fileUploadCancel => 'Cancelar';

  @override
  String get fileUploadCompleted => 'Completado';

  @override
  String get fileUploadDelete => 'Eliminar archivo';

  @override
  String get fileUploadRetry => 'Reintentar';

  @override
  String a11yFileUpload(String fileName, String fileInfo, String status) {
    return 'Archivo: $fileName, $fileInfo. Estado: $status';
  }

  @override
  String get caseworkUploadErrorUnsupportedMime => 'Formato no admitido.';

  @override
  String get caseworkUploadErrorTooLarge => 'El archivo excede el tamaño máximo.';

  @override
  String get caseworkUploadErrorTooManyFiles => 'Has alcanzado el número máximo de archivos.';

  @override
  String get caseworkUploadErrorEmptyFile => 'El archivo está vacío.';

  @override
  String get caseworkUploadErrorHashMismatch => 'La huella del archivo no coincide.';

  @override
  String get caseworkUploadErrorGeneric => 'Se produjo un error con el archivo.';

  @override
  String get caseworkUploadJustificantePending => 'El justificante se generará cuando finalices el envío.';

  @override
  String get caseworkUploadJustificanteUnavailable => 'El justificante todavía no está disponible.';

  @override
  String caseworkUploadJustificanteUnavailableReason(String reason) {
    return 'Motivo: $reason';
  }

  @override
  String get caseworkUploadJustificanteAvailable => 'Tu justificante está listo.';

  @override
  String get caseworkUploadJustificanteDownloadCta => 'Descargar justificante';

  @override
  String get caseworkUploadJustificanteDownloadStub => 'La descarga del justificante se habilitará cuando el backend confirme el formato.';

  @override
  String get caseworkRegistroDetailTitleEntrada => 'Detalle de entrada de registro';

  @override
  String get caseworkRegistroDetailTitleSalida => 'Detalle de salida de registro';

  @override
  String get caseworkRegistroDetailBreadcrumbHome => 'Inicio';

  @override
  String get caseworkRegistroDetailBreadcrumbCasework => 'Mis gestiones';

  @override
  String get caseworkRegistroDetailKindEntrada => 'Entradas de registro';

  @override
  String get caseworkRegistroDetailKindSalida => 'Salidas de registro';

  @override
  String get caseworkRegistroDetailBackToList => 'Volver al listado';

  @override
  String get caseworkRegistroDetailLoadError => 'No hemos podido cargar el detalle del registro.';

  @override
  String get caseworkRegistroDetailFieldNumero => 'Número de registro';

  @override
  String get caseworkRegistroDetailFieldFecha => 'Fecha';

  @override
  String get caseworkRegistroDetailFieldConsejeria => 'Consejería destino';

  @override
  String get caseworkRegistroDetailFieldOficina => 'Oficina de registro';

  @override
  String get caseworkRegistroDetailFieldAsunto => 'Asunto';

  @override
  String get caseworkRegistroDetailFieldObservaciones => 'Observaciones';

  @override
  String get caseworkRegistroDetailFicherosTitle => 'Documentación adjunta';

  @override
  String get caseworkRegistroDetailFicherosEmpty => 'Este registro no incluye ficheros adjuntos.';

  @override
  String get caseworkRegistroDetailReadOnlyBanner => 'Esta pantalla muestra el detalle del registro en modo consulta. No es posible aportar documentación desde aquí.';

  @override
  String get caseworkAportacionOpenCta => 'Aportar documentación';

  @override
  String get caseworkAportacionTitle => 'Aportación de documentos';

  @override
  String get caseworkAportacionBreadcrumb => 'Aportación';

  @override
  String get caseworkAportacionBack => 'Paso anterior';

  @override
  String get caseworkAportacionExit => 'Salir del flujo';

  @override
  String caseworkAportacionStepIndicator(int current, int total) {
    return 'Paso $current de $total';
  }

  @override
  String get caseworkAportacionStepIntro => 'Introducción';

  @override
  String get caseworkAportacionStepIdentificacion => 'Identificación';

  @override
  String get caseworkAportacionStepSearch => 'Búsqueda';

  @override
  String get caseworkAportacionStepDetail => 'Detalle';

  @override
  String get caseworkAportacionStepComplete => 'Confirmación';

  @override
  String get caseworkAportacionIntroHeadline => 'Aporta documentación a un expediente';

  @override
  String get caseworkAportacionIntroBody => 'Este flujo te permite aportar documentación adicional a un expediente abierto en nombre de la persona interesada. Identifícate, localiza el expediente y adjunta los ficheros.';

  @override
  String get caseworkAportacionIntroRestrictionsTitle => 'Antes de continuar';

  @override
  String get caseworkAportacionIntroRestriction1 => 'Solo puedes aportar documentación a expedientes que estén abiertos.';

  @override
  String get caseworkAportacionIntroRestriction2 => 'Necesitas el número de expediente o el número de registro asociado.';

  @override
  String get caseworkAportacionIntroRestriction3 => 'Los ficheros aportados quedan vinculados a la persona interesada que indiques.';

  @override
  String get caseworkAportacionIntroContinueCta => 'Continuar';

  @override
  String get caseworkAportacionIdentificationHeadline => 'Identifica al interesado';

  @override
  String get caseworkAportacionIdentificationBody => 'Indica el tipo y número de documento de la persona titular del expediente.';

  @override
  String get caseworkAportacionIdentificationTypeLabel => 'Tipo de documento';

  @override
  String get caseworkAportacionIdentificationTypeNif => 'NIF';

  @override
  String get caseworkAportacionIdentificationTypeNie => 'NIE';

  @override
  String get caseworkAportacionIdentificationTypePassport => 'Pasaporte';

  @override
  String get caseworkAportacionIdentificationTypeCif => 'CIF';

  @override
  String get caseworkAportacionIdentificationNumberLabel => 'Número de documento';

  @override
  String get caseworkAportacionIdentificationNumberHint => 'Ej. 12345678A';

  @override
  String get caseworkAportacionIdentificationNextCta => 'Siguiente';

  @override
  String get caseworkAportacionSearchHeadline => 'Localiza el expediente';

  @override
  String get caseworkAportacionSearchBody => 'Busca por número de expediente o número de registro asociado.';

  @override
  String get caseworkAportacionSearchTabExpediente => 'Por nº de expediente';

  @override
  String get caseworkAportacionSearchTabRegistro => 'Por nº de registro';

  @override
  String get caseworkAportacionSearchExpedienteLabel => 'Número de expediente';

  @override
  String get caseworkAportacionSearchExpedienteHint => 'Ej. EXP/2025/00123';

  @override
  String get caseworkAportacionSearchRegistroLabel => 'Número de registro';

  @override
  String get caseworkAportacionSearchRegistroHint => 'Ej. REG/E/45612';

  @override
  String get caseworkAportacionSearchSubmitCta => 'Buscar';

  @override
  String get caseworkAportacionFailureInvalidIdentification => 'El número de documento no es válido para el tipo seleccionado.';

  @override
  String get caseworkAportacionFailureNotFound => 'No hemos encontrado ningún expediente con esos datos.';

  @override
  String get caseworkAportacionFailureNetworkError => 'No hemos podido completar la búsqueda. Inténtalo de nuevo más tarde.';

  @override
  String get caseworkAportacionCompleteHeadline => 'Aportación enviada';

  @override
  String caseworkAportacionCompleteBody(String expediente) {
    return 'La documentación se ha aportado correctamente al expediente $expediente. Conserva el justificante por si necesitas consultarlo.';
  }

  @override
  String get caseworkAportacionCompleteHomeCta => 'Volver a Mis gestiones';

  @override
  String get notificationsCenterTitle => 'Mis notificaciones';

  @override
  String get notificationsLoading => 'Cargando notificaciones…';

  @override
  String get notificationsErrorMessage => 'No hemos podido cargar tus notificaciones.';

  @override
  String get notificationsLoadMoreError => 'No hemos podido cargar más notificaciones. Inténtalo de nuevo.';

  @override
  String get notificationsEmptyTitle => 'No hay notificaciones';

  @override
  String get notificationsEmptySubtitle => 'No hemos encontrado notificaciones para los filtros aplicados.';

  @override
  String get notificationsFilterAll => 'Todas';

  @override
  String get notificationsItemHasDocuments => 'Documentos asociados';

  @override
  String notificationsPaginationFooter(int loaded, int total) {
    return 'Mostrando $loaded de $total';
  }

  @override
  String get notificationStatusPendiente => 'Pendiente';

  @override
  String get notificationStatusAceptada => 'Aceptada';

  @override
  String get notificationStatusRechazada => 'Rechazada';

  @override
  String get notificationStatusCaducada => 'Caducada';

  @override
  String get notificationStatusUnknown => 'Sin clasificar';

  @override
  String get notificationDetailTitle => 'Detalle de notificación';

  @override
  String get notificationDetailLoading => 'Cargando notificación…';

  @override
  String get notificationDetailErrorMessage => 'No hemos podido cargar el detalle de la notificación.';

  @override
  String get notificationDetailRetry => 'Reintentar';

  @override
  String notificationDetailHeaderOrganismo(String organismo) {
    return 'Emitida por: $organismo';
  }

  @override
  String notificationDetailHeaderEmittedOn(String date) {
    return 'Fecha de emisión: $date';
  }

  @override
  String notificationDetailHeaderExpediente(String ref) {
    return 'Expediente: $ref';
  }

  @override
  String notificationDetailHeaderProcedimiento(String procedimiento) {
    return 'Procedimiento: $procedimiento';
  }

  @override
  String notificationDetailHeaderDeadline(String date) {
    return 'Plazo límite para decidir: $date';
  }

  @override
  String get notificationDetailDescriptionTitle => 'Descripción';

  @override
  String get notificationDetailAcceptCta => 'Aceptar';

  @override
  String get notificationDetailRejectCta => 'Rechazar';

  @override
  String get notificationDetailRejectDialogTitle => 'Confirmar rechazo';

  @override
  String get notificationDetailRejectDialogBody => 'Si rechazas esta notificación, la administración tendrá constancia formal del rechazo y la notificación se considerará practicada. Esta acción es irreversible.';

  @override
  String get notificationDetailRejectDialogConfirm => 'Rechazar definitivamente';

  @override
  String get notificationDetailRejectDialogCancel => 'Cancelar';

  @override
  String get notificationDetailDecisionAcceptedToast => 'Has aceptado la notificación.';

  @override
  String get notificationDetailDecisionRejectedToast => 'Has rechazado la notificación.';

  @override
  String get notificationDetailConflictToast => 'Esta notificación ya no admite cambios. Hemos actualizado su estado.';

  @override
  String get notificationDetailDecisionInFlight => 'Enviando tu decisión…';

  @override
  String notificationDetailReadOn(String date) {
    return 'Leída el $date';
  }

  @override
  String get notificationDetailDocumentsTitle => 'Documentos asociados';

  @override
  String get notificationDetailDocumentsEmpty => 'No hay documentos asociados a esta notificación.';

  @override
  String get notificationDetailDocumentDownload => 'Descargar documento';

  @override
  String get notificationDetailDocumentUnavailableChip => 'No disponible';

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
  String get notificationDetailDocumentSizeUnknown => 'Tamaño desconocido';

  @override
  String get notificationDetailDocumentDownloadSuccessToast => 'Documento listo';

  @override
  String get notificationDetailDocumentDownloadUnavailableToast => 'Documento no disponible';

  @override
  String get notificationDetailDocumentDownloadErrorToast => 'No se pudo descargar el documento';

  @override
  String get notificationDetailVariantAceptadaBanner => 'Has aceptado esta notificación. Puedes consultar los documentos asociados.';

  @override
  String get notificationDetailVariantRechazadaBanner => 'Has rechazado esta notificación. Conservas el acuse de rechazo.';

  @override
  String get notificationDetailVariantCaducadaBanner => 'El plazo para decidir sobre esta notificación ha caducado.';

  @override
  String get notificationContactPageTitle => 'Datos de contacto';

  @override
  String get notificationContactExplanation => 'Necesitamos un teléfono móvil o un correo electrónico para avisarte de las notificaciones electrónicas que recibas. Solo usaremos estos datos para enviarte avisos relacionados con tus notificaciones.';

  @override
  String get notificationContactPhoneLabel => 'Teléfono móvil';

  @override
  String get notificationContactPhoneHint => '600 123 456';

  @override
  String get notificationContactPhoneHelper => 'Indica un número con prefijo internacional si no es de España.';

  @override
  String get notificationContactEmailLabel => 'Correo electrónico';

  @override
  String get notificationContactEmailHint => 'ejemplo@correo.com';

  @override
  String get notificationContactEmailHelper => 'Usaremos este correo solo para avisos de notificaciones.';

  @override
  String get notificationContactSubmitCta => 'Registrar';

  @override
  String get notificationContactLoading => 'Cargando datos de contacto…';

  @override
  String get notificationContactErrorLoading => 'No hemos podido cargar tus datos de contacto.';

  @override
  String get notificationContactNotRegistered => 'No estás dado de alta en el servicio de notificaciones. Completa tus datos para darte de alta.';

  @override
  String get notificationContactErrorPhoneInvalid => 'Introduce un teléfono móvil válido.';

  @override
  String get notificationContactErrorEmailInvalid => 'Introduce un correo electrónico válido.';

  @override
  String get notificationContactErrorBothEmpty => 'Indica al menos un teléfono móvil o un correo electrónico.';

  @override
  String get notificationContactSuccessMessage => 'Tus datos de contacto se han registrado correctamente.';

  @override
  String get notificationContactGateBannerMessage => 'Configura tus datos de contacto para recibir notificaciones.';

  @override
  String get notificationContactGateBannerCta => 'Configurar ahora';

  @override
  String get walletActionOpen => 'Abrir';

  @override
  String get walletActionShare => 'Compartir';

  @override
  String get walletActionAddToWallet => 'Añadir a Wallet';

  @override
  String get walletPreviewPdfPlaceholder => 'Documento PDF';

  @override
  String get walletPreviewPkpassPlaceholder => 'Pase para Wallet';

  @override
  String get walletPreviewQrUnavailable => 'Vista previa del QR no disponible';

  @override
  String get walletPreviewQrImageSemantic => 'Imagen del código QR';

  @override
  String get walletPreviewQrTextSemantic => 'Contenido del código QR en texto';

  @override
  String get walletErrorInvalidArtifact => 'El archivo recibido no es válido. Inténtalo de nuevo.';

  @override
  String get walletErrorSystem => 'No hemos podido completar la acción. Inténtalo de nuevo.';

  @override
  String get walletErrorNoCapability => 'Esta acción no está disponible en tu dispositivo.';

  @override
  String get walletErrorEmptyPayload => 'El archivo está vacío.';

  @override
  String get walletErrorTooLarge => 'El archivo supera el tamaño permitido.';

  @override
  String get walletErrorUnsupportedSource => 'El formato recibido no es compatible.';

  @override
  String get signatureInboxTitle => 'Firma de documentos';

  @override
  String get signatureTabPending => 'Pendientes';

  @override
  String get signatureTabHistory => 'Histórico';

  @override
  String get signatureLoading => 'Cargando documentos…';

  @override
  String get signatureEmptyPendingTitle => 'No hay documentos pendientes';

  @override
  String get signatureEmptyPendingSubtitle => 'No tienes documentos esperando tu firma.';

  @override
  String get signatureEmptyHistoryTitle => 'Aún no has firmado documentos';

  @override
  String get signatureEmptyHistorySubtitle => 'Cuando firmes un documento aparecerá aquí.';

  @override
  String get signatureErrorMessage => 'No hemos podido cargar tus documentos para firmar.';

  @override
  String get signatureRetry => 'Reintentar';

  @override
  String get signatureSignAction => 'Firmar';

  @override
  String get signatureHandoffPendingToast => 'Te hemos llevado a Afirma. Vuelve aquí cuando termines.';

  @override
  String get signatureHandoffSignedToast => 'Documento firmado';

  @override
  String get signatureHandoffCancelledToast => 'Has cancelado la firma.';

  @override
  String get signatureHandoffErrorToast => 'No hemos podido completar la firma. Inténtalo de nuevo.';

  @override
  String get signatureHandoffLaunchFailedToast => 'No hemos podido abrir Afirma. Inténtalo de nuevo.';

  @override
  String get signatureAfirmaReturnTitle => 'Volviendo de Afirma';

  @override
  String get signatureAfirmaReturnProcessing => 'Procesando firma…';

  @override
  String get signatureCertificateValidTitle => 'Certificado válido';

  @override
  String get signatureCertificateMissingTitle => 'Necesitas instalar tu certificado';

  @override
  String get signatureCertificateExpiredTitle => 'Tu certificado ha caducado';

  @override
  String get signatureCertificateInvalidTitle => 'El certificado no es válido';

  @override
  String get signatureCertificateVecTitle => 'Disponible mediante VEC';

  @override
  String get signatureCertificateUnknownTitle => 'No hemos podido validar tu certificado';

  @override
  String get signatureCertificateRecheck => 'Volver a validar';

  @override
  String get signatureStatusPendiente => 'Pendiente';

  @override
  String get signatureStatusFirmado => 'Firmado';

  @override
  String get signatureStatusExpirado => 'Caducado';

  @override
  String get signatureStatusError => 'Con errores';

  @override
  String get signatureStatusUnknown => 'Sin clasificar';

  @override
  String signatureDocumentSize(String size) {
    return '$size';
  }

  @override
  String signatureCertificateExpiresOn(String date) {
    return 'Caduca el $date';
  }

  @override
  String get notificationDetailPlaceholderTitle => 'Detalle de notificación';

  @override
  String notificationDetailPlaceholderBody(String id) {
    return 'Notificación $id';
  }

  @override
  String get notificationDetailPlaceholderPending => 'Detalle pendiente de habilitar en STORY-44.';

  @override
  String get familiaNumerosaDetailTitle => 'Familia numerosa';

  @override
  String get familiaNumerosaInfoSheetTitle => 'Saber más sobre Familia numerosa';

  @override
  String get familiaNumerosaInfoSheetDescription => 'Consulta los datos de tu título de familia numerosa.';

  @override
  String get familiaNumerosaTitleSection => 'Mi título de familia numerosa';

  @override
  String get familiaNumerosaRegionLabel => 'Comunidad autónoma';

  @override
  String get familiaNumerosaTitleNumberLabel => 'Número de título';

  @override
  String get familiaNumerosaCategoryGeneral => 'General';

  @override
  String get familiaNumerosaCategoryEspecial => 'Especial';

  @override
  String get familiaNumerosaCategoryLabel => 'Categoría';

  @override
  String get familiaNumerosaValidLabel => 'Vigente';

  @override
  String get familiaNumerosaIssueDateLabel => 'Fecha de expedición';

  @override
  String get familiaNumerosaExpiryDateLabel => 'Fecha de caducidad';

  @override
  String get familiaNumerosaChildrenCountLabel => 'Número de hijos/as del título';

  @override
  String get familiaNumerosaBeneficiariesTitle => 'Beneficiarios/as';

  @override
  String familiaNumerosaBeneficiaryTitle(int index) {
    return 'Beneficiario/a $index';
  }

  @override
  String get familiaNumerosaDocumentNumberLabel => 'Número de documento';

  @override
  String get familiaNumerosaBirthDateLabel => 'Fecha de nacimiento';

  @override
  String get familiaNumerosaFullNameLabel => 'Nombre y apellidos';

  @override
  String get familiaNumerosaHolderLabel => 'Titular';

  @override
  String get familiaNumerosaYes => 'Sí';

  @override
  String get familiaNumerosaNo => 'No';

  @override
  String get familiaNumerosaNoDataMessage => 'No hemos encontrado información sobre tu título de familia numerosa.';

  @override
  String get familiaNumerosaNoDataContactHint => 'Si esta información es incorrecta o no está actualizada, contacta con la Consejería de Bienestar Social de Castilla-La Mancha.';

  @override
  String get familiaNumerosaContactListButton => 'Consultar el listado de contactos';

  @override
  String get familiaNumerosaContactHint => 'Si alguno de tus datos no es correcto o no está actualizado, contacta con la Consejería de Bienestar Social de Castilla-La Mancha.';

  @override
  String get familiaNumerosaOfficeContactsButton => 'Contacto';

  @override
  String get familiaNumerosaMoreInformation => 'Consultar más información';

  @override
  String familiaNumerosaCardNumberLabel(String number) {
    return 'Número de carnet: $number';
  }

  @override
  String get familiaNumerosaCategoriaGeneral => 'General';

  @override
  String get familiaNumerosaCategoriaEspecial => 'Especial';

  @override
  String get familiaNumerosaCategoriaUnknown => 'Sin clasificar';

  @override
  String familiaNumerosaExpiresOn(String date) {
    return 'Caduca el $date';
  }

  @override
  String get familiaNumerosaMembersTitle => 'Miembros del carnet';

  @override
  String get familiaNumerosaMemberFallbackName => 'Sin nombre';

  @override
  String get familiaNumerosaParentescoTitular => 'Titular';

  @override
  String get familiaNumerosaParentescoConyuge => 'Cónyuge';

  @override
  String get familiaNumerosaParentescoHijo => 'Hijo';

  @override
  String get familiaNumerosaParentescoHija => 'Hija';

  @override
  String get familiaNumerosaParentescoOtro => 'Otro';

  @override
  String get familiaNumerosaUnavailableTitle => 'Carnet no disponible';

  @override
  String get familiaNumerosaUnavailableMessage => 'Tu carnet de familia numerosa no está vigente o no se ha podido obtener.';

  @override
  String get familiaNumerosaErrorMessage => 'No se ha podido cargar tu carnet de familia numerosa.';

  @override
  String get familiaNumerosaServiceUnavailableMessage => 'El servicio de consulta de tu título de familia numerosa no está disponible. Puedes recargar la información o intentarlo de nuevo más tarde.';

  @override
  String get myDataServiceUnavailableUpdate => 'Actualizar';

  @override
  String get myDataNoDataContact => 'Contacto';

  @override
  String get myDataNoDataOfficeContacts => 'Contacto';

  @override
  String get discapacidadNoDataMessage => 'No hemos encontrado información de discapacidad asociada a tus datos en el servicio de consulta de la JCCM.\n\nSi la situación no es correcta o no está actualizada, contacta con la Consejería de Bienestar Social de Castilla-La Mancha.';

  @override
  String get socialWelfareParkingNoDataMessage => 'No hemos encontrado información de tarjeta de estacionamiento asociada a tus datos en el servicio de consulta de la JCCM.\n\nSi la situación no es correcta o no está actualizada, contacta con la Consejería de Bienestar Social de Castilla-La Mancha.';

  @override
  String get socialWelfareThermalSpaNoDataMessage => 'No hemos encontrado información de termalismo asociada a tus datos en el servicio de consulta de la JCCM.\n\nSi la situación no es correcta o no está actualizada, contacta con la Consejería de Bienestar Social de Castilla-La Mancha.';

  @override
  String get socialWelfareDependencyNoDataMessage => 'No hemos encontrado información de atención a la dependencia asociada a tus datos en el servicio de consulta de la JCCM.\n\nSi la situación no es correcta o no está actualizada, contacta con la Consejería de Bienestar Social de Castilla-La Mancha.';

  @override
  String get educationUniversityTitlesNoDataMessage => 'No hemos encontrado títulos universitarios asociados a tus datos en el servicio de consulta.\n\nSi la situación no es correcta o no está actualizada, contacta con el Ministerio de Ciencia, Innovación y Universidades.';

  @override
  String get educationNonUniversityTitlesNoDataMessage => 'No hemos encontrado títulos no universitarios asociados a tus datos en el servicio de consulta.\n\nSi la situación no es correcta o no está actualizada, contacta con el Ministerio de Educación, Formación Profesional y Deportes.';

  @override
  String get myDataVehiclesNoDataMessage => 'No hemos encontrado vehículos asociados a tus datos en el servicio de consulta de la DGT.\n\nSi la situación no es correcta o no está actualizada, contacta con la Dirección General de Tráfico.';

  @override
  String get myDataHousingAddressNoDataMessage => 'No hemos encontrado información de domicilio asociada a tus datos en el servicio de consulta del padrón.\n\nSi la situación no es correcta o no está actualizada, contacta con tu Ayuntamiento.';

  @override
  String get myDataHousingRealEstateNoDataMessage => 'No hemos encontrado bienes inmuebles asociados a tus datos en el servicio de consulta de Catastro.\n\nSi la situación no es correcta o no está actualizada, contacta con la Dirección General del Catastro.';

  @override
  String get myDataHealthAppointmentsNoDataMessage => 'No hemos encontrado citas de Atención Primaria asociadas a tus datos en el servicio de consulta del SESCAM.\n\nSi la situación no es correcta o no está actualizada, contacta con tu Centro de Salud.';

  @override
  String get myDataHealthHospitalAppointmentsNoDataMessage => 'No hemos encontrado citas hospitalarias asociadas a tus datos en el servicio de consulta del SESCAM.\n\nSi la situación no es correcta o no está actualizada, contacta con tu centro hospitalario.';

  @override
  String get myDataEmploymentDemandNoDataMessage => 'No hemos encontrado información de demanda de empleo asociada a tus datos en el servicio de consulta.\n\nSi la situación no es correcta o no está actualizada, contacta con una oficina de empleo de Castilla-La Mancha.';

  @override
  String get myDataEmploymentOffersNoDataMessage => 'Aún no te has inscrito a ninguna oferta.\n\nSi la información es incorrecta o no está actualizada, revisa tu espacio personal en el Portal de empleo de Castilla-La Mancha.';

  @override
  String get myDataEmploymentOffersAuthorizationRequiredMessage => 'Autoriza el uso de tus datos desde tus preferencias para consultar tus inscripciones en ofertas de empleo.';

  @override
  String get myDataEmploymentDemandAuthorizationRequiredMessage => 'Autoriza el uso de tus datos desde tus preferencias para consultar el estado de tu demanda de empleo.';

  @override
  String get myDataHealthAppointmentsAuthorizationRequiredMessage => 'Autoriza el uso de tus datos desde tus preferencias para consultar tus citas de Atención Primaria.';

  @override
  String get discapacidadServiceUnavailableMessage => 'El servicio de consulta de tu título de discapacidad no está disponible. Puedes recargar la información o intentarlo de nuevo más tarde.';

  @override
  String get socialWelfareParkingServiceUnavailableMessage => 'El servicio de consulta de tu tarjeta de estacionamiento no está disponible. Puedes recargar la información o intentarlo de nuevo más tarde.';

  @override
  String get socialWelfareThermalSpaServiceUnavailableMessage => 'El servicio de consulta de tu información de termalismo no está disponible. Puedes recargar la información o intentarlo de nuevo más tarde.';

  @override
  String get socialWelfareDependencyServiceUnavailableMessage => 'El servicio de consulta de tu información de atención a la dependencia no está disponible. Puedes recargar la información o intentarlo de nuevo más tarde.';

  @override
  String get educationUniversityTitlesServiceUnavailableMessage => 'El servicio de consulta de tus títulos universitarios no está disponible. Puedes recargar la información o intentarlo de nuevo más tarde.';

  @override
  String get educationNonUniversityTitlesServiceUnavailableMessage => 'El servicio de consulta de tus títulos no universitarios no está disponible. Puedes recargar la información o intentarlo de nuevo más tarde.';

  @override
  String get myDataVehiclesServiceUnavailableMessage => 'El servicio de consulta de tus vehículos no está disponible. Puedes recargar la información o intentarlo de nuevo más tarde.';

  @override
  String get myDataHousingAddressServiceUnavailableMessage => 'El servicio de consulta de tus datos de domicilio no está disponible. Puedes recargar la información o intentarlo de nuevo más tarde.';

  @override
  String get myDataHousingRealEstateServiceUnavailableMessage => 'El servicio de consulta de tus bienes inmuebles no está disponible. Puedes recargar la información o intentarlo de nuevo más tarde.';

  @override
  String get myDataHealthAppointmentsServiceUnavailableMessage => 'El servicio de consulta de datos de citas de atención primaria no se encuentra actualmente disponible. Inténtalo de nuevo más tarde.';

  @override
  String get myDataHealthHospitalAppointmentsServiceUnavailableMessage => 'El servicio de consulta de datos de citas de atención hospitalaria no se encuentra actualmente disponible. Inténtalo de nuevo más tarde.';

  @override
  String get familiaNumerosaRetry => 'Reintentar';

  @override
  String get jovenDetailTitle => 'Carnet Joven';

  @override
  String jovenCodigoLabel(String code) {
    return 'Código: $code';
  }

  @override
  String jovenExpiresOn(String date) {
    return 'Vigente hasta el $date';
  }

  @override
  String get jovenSubtitle => 'Acredita tu condición de persona joven y accede a descuentos en cultura, transporte y ocio en Castilla-La Mancha.';

  @override
  String get jovenUnavailableTitle => 'Carnet no disponible';

  @override
  String get jovenUnavailableMessage => 'Tu Carnet Joven no está vigente o no se ha podido obtener.';

  @override
  String get jovenErrorMessage => 'No se ha podido cargar tu Carnet Joven.';

  @override
  String get jovenRetry => 'Reintentar';

  @override
  String get jovenModalDragHandleSemantic => 'Arrastra para ajustar la ficha del Carnet Joven';

  @override
  String get jovenModalCloseAction => 'Cerrar';

  @override
  String get discapacidadDetailTitle => 'Carnet de discapacidad';

  @override
  String get discapacidadGradoLabel => 'Grado de discapacidad';

  @override
  String discapacidadGradoBadge(int grado) {
    return '$grado%';
  }

  @override
  String get discapacidadGradoUnknown => 'Grado no disponible';

  @override
  String discapacidadExpiresOn(String date) {
    return 'Vigente hasta el $date';
  }

  @override
  String get discapacidadValidBadge => 'Vigente';

  @override
  String get discapacidadNotValidTitle => 'Carnet no vigente';

  @override
  String get discapacidadNotValidMessage => 'Tu carnet de discapacidad ya no está vigente. No se puede generar el pase para Wallet.';

  @override
  String get discapacidadUnavailableTitle => 'Sin datos disponibles';

  @override
  String get discapacidadUnavailableMessage => 'No hemos encontrado información de tu carnet de discapacidad. Vuelve a intentarlo más tarde.';

  @override
  String get discapacidadParseErrorMessage => 'No se ha podido interpretar la respuesta del carnet de discapacidad.';

  @override
  String get discapacidadErrorMessage => 'No se ha podido cargar tu carnet de discapacidad.';

  @override
  String get discapacidadRetry => 'Reintentar';

  @override
  String get discapacidadActionPkpass => 'Añadir a Wallet';

  @override
  String get recommendationsTitle => 'Recomendaciones para mí';

  @override
  String get recommendationsTabAll => 'Todo';

  @override
  String get recommendationsTabRecent => 'Últimos días';

  @override
  String get recommendationsTabNew => 'Novedades';

  @override
  String get recommendationsTabImmediate => 'Trámite inmediato';

  @override
  String get recommendationsImmediateBadge => 'Tramitación inmediata';

  @override
  String get recommendationsDeadlinePrefix => 'Plazo:';

  @override
  String get recommendationsResponsibleUnitPrefix => 'Unidad:';

  @override
  String get recommendationsLifeEventPrefix => 'Hecho vital:';

  @override
  String get recommendationsAssociatedLifeEventsLabel => 'Hechos vitales relacionados';

  @override
  String get recommendationsStatusLabel => 'Estado';

  @override
  String get appCardReferenceLabel => 'N.º ref.';

  @override
  String get appCardExpiryLabel => 'Expiración';

  @override
  String get appProgressLabel => 'Progreso';

  @override
  String get appProgressIndeterminateValue => 'En curso';

  @override
  String appProgressPercentage(int percentage) {
    return '$percentage %';
  }

  @override
  String get appAvatarLabel => 'Avatar';

  @override
  String get appAvatarAvailableStatus => 'Disponible';

  @override
  String appPhoneCallLabel(String number, String subtitle) {
    return 'Llamar al $number. $subtitle';
  }

  @override
  String get appPhoneCallHint => 'Inicia una llamada telefónica';

  @override
  String get a11yBack => 'Atrás';

  @override
  String get a11yClose => 'Cerrar';

  @override
  String get a11yHelp => 'Ayuda';

  @override
  String get a11yAppName => 'Espacio Ciudadano';

  @override
  String get a11yCancel => 'Cancelar';

  @override
  String get a11yInformation => 'Información';

  @override
  String get recommendationsLoadMore => 'Ver más';

  @override
  String get recommendationsEmptyUnconfiguredTitle => 'Aún no tienes recomendaciones personalizadas';

  @override
  String get recommendationsEmptyUnconfiguredBody => 'Cuéntanos en qué momento vital estás para sugerirte trámites y servicios relevantes.';

  @override
  String get recommendationsEmptyUnconfiguredPrimaryCta => 'Configurar mis preferencias';

  @override
  String get recommendationsEmptyUnconfiguredSecondaryCta => 'Ver mis hechos vitales';

  @override
  String get recommendationsEmptyUnauthorisedTitle => 'Activa la cláusula de recomendaciones';

  @override
  String get recommendationsEmptyUnauthorisedBody => 'Para mostrarte recomendaciones debes activar la cláusula de recomendaciones en condiciones de uso y autorizaciones.';

  @override
  String get recommendationsEmptyUnauthorisedPrimaryCta => 'Revisar consentimientos';

  @override
  String get recommendationsEmptyConfiguredTitle => 'Todo listo, sin novedades por ahora';

  @override
  String get recommendationsEmptyConfiguredBody => 'Cuando tengamos nuevas recomendaciones para ti las verás aquí. Prueba con otros filtros mientras tanto.';

  @override
  String get recommendationsEmptyConfiguredSecondaryCta => 'Ver todos';

  @override
  String get recommendationsLifeEventsComingSoon => 'Mis hechos vitales estará disponible próximamente';

  @override
  String get recommendationsLoadingError => 'No hemos podido cargar la información de tus recomendaciones. Vuelve a intentarlo más tarde.';

  @override
  String get recommendationsLoadingErrorRetry => 'Actualizar';

  @override
  String get recommendationsDetailUnavailable => 'Detalle disponible próximamente';

  @override
  String get offlineBannerMessage => 'Sin conexión. Mostrando datos guardados.';

  @override
  String get a11yStickybarLabel => 'Acciones principales';

  @override
  String get a11yLandingH1Label => 'Espacio Ciudadano de Castilla-La Mancha';

  @override
  String get a11yCastillaLogoLabel => 'Gobierno de Castilla-La Mancha';

  @override
  String get a11yLoading => 'Cargando';

  @override
  String get a11yContentLoaded => 'Contenido cargado';

  @override
  String a11yFieldError(String field, String error) {
    return 'Error, $field: $error';
  }

  @override
  String a11yExpandTextArea(String field) {
    return 'Ampliar $field';
  }

  @override
  String a11yCollapseTextArea(String field) {
    return 'Contraer $field';
  }

  @override
  String a11ySelectPhoneCountryCode(String countryCode) {
    return 'Seleccionar prefijo telefónico, actual $countryCode';
  }

  @override
  String a11yFilterButtonActiveCount(String label, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count filtros activos',
      one: '1 filtro activo',
    );
    return '$label, $_temp0';
  }

  @override
  String get a11yFilterActions => 'Acciones de filtros';

  @override
  String get listFilterClear => 'Limpiar filtros';

  @override
  String get listFilterApply => 'Aplicar filtros';

  @override
  String get listFilterSelectDateRange => 'Seleccionar rango de fechas';

  @override
  String get listFilterSelectStartDate => 'Selecciona la fecha inicial.';

  @override
  String get listFilterSelectEndDate => 'Selecciona la fecha final.';

  @override
  String get listFilterRangeSelected => 'Rango seleccionado.';

  @override
  String get listFilterRemoveRange => 'Quitar rango';

  @override
  String get listFilterConfirmRange => 'Seleccionar rango';

  @override
  String a11yListFilterDateRange(String label, String startDate, String endDate) {
    return '$label. Desde $startDate hasta $endDate';
  }

  @override
  String a11yErrorState(String message) {
    return 'Error: $message';
  }

  @override
  String a11yEmptyState(String message) {
    return 'Sin contenido: $message';
  }

  @override
  String a11yBlockedState(String message) {
    return 'Acceso no disponible: $message';
  }

  @override
  String a11yAlert(String title, String message) {
    return '$title: $message';
  }

  @override
  String get a11yAlertNeutral => 'Aviso del sistema';

  @override
  String get a11yAlertSuccess => 'Operación correcta';

  @override
  String get a11yAgendaTypeNotification => 'Notificación';

  @override
  String get a11yAgendaTypeHealth => 'Cita sanitaria';

  @override
  String get a11yAgendaTypeCredential => 'Caducidad de acreditación';

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
    return '$label, obligatorio. $hint';
  }

  @override
  String a11yAttachmentSelected(String fileName, String fileInfo) {
    return 'Archivo adjunto: $fileName, $fileInfo';
  }

  @override
  String get a11yBottomSheet => 'Panel inferior';

  @override
  String get a11yBottomSheetClose => 'Cerrar';

  @override
  String get a11yCalendar => 'Calendario';

  @override
  String a11yCalendarMonth(String monthYear) {
    return 'Mes mostrado: $monthYear';
  }

  @override
  String a11ySelectCalendarMonthYear(String monthYear) {
    return 'Seleccionar mes y año, actual $monthYear';
  }

  @override
  String a11yMonthYear(String month, String year) {
    return '$month de $year';
  }

  @override
  String get a11yCalendarHasEvent => 'con evento';

  @override
  String get a11yCalendarOutsideMonth => 'fuera del mes mostrado';

  @override
  String a11yCaptcha(String label, String badge) {
    return '$label, verificación $badge';
  }

  @override
  String get a11yCaptchaVerified => 'Captcha verificado';

  @override
  String get a11yAlertWarning => 'Advertencia';

  @override
  String get a11yAlertError => 'Error';

  @override
  String get preferencesResetError => 'No hemos podido borrar tus preferencias. Inténtalo de nuevo.';

  @override
  String get preferencesLoadError => 'No hemos podido cargar tus preferencias. Vuelve a intentarlo más tarde.';

  @override
  String get preferencesLoadRetry => 'Actualizar';

  @override
  String get drawerPreferences => 'Preferencias';

  @override
  String drawerGreeting(String userName) {
    return 'Hola, $userName';
  }

  @override
  String get drawerLogout => 'Cerrar sesión';

  @override
  String get drawerHelpAndContact => 'Ayuda y contacto';

  @override
  String get drawerCloseMenu => 'Cerrar menú';

  @override
  String get drawerGoToSedeElectronica => 'Ir a Sede Electrónica';

  @override
  String get myDataTitle => 'Mis datos';

  @override
  String get myDataIntro => 'Consulta tu información disponible en la Administración y accede a los servicios relacionados.';

  @override
  String get representativeUnavailableTitle => 'Información no disponible';

  @override
  String get representativeUnavailableMessage => 'Con la identificación que se ha usado para entrar no es posible ver esta información. Si dispones de otra forma de identificarte, puedes probar de nuevo.';

  @override
  String get myDataHealthTitle => 'Salud';

  @override
  String get myDataHealthDescription => 'Datos sanitarios y gestión de citas médicas';

  @override
  String get myDataSocialWelfareTitle => 'Bienestar Social';

  @override
  String get myDataSocialWelfareDescription => 'Familia numerosa, discapacidad, dependencia y otras ayudas';

  @override
  String get myDataEmploymentTitle => 'Empleo';

  @override
  String get myDataEmploymentDescription => 'Demanda de empleo, ofertas e inscripciones';

  @override
  String get myDataEmploymentInfoSheetTitle => 'Saber más sobre Demanda de Empleo';

  @override
  String get myDataEmploymentInfoSheetDescription => 'Consulta tu situación actual como demandante de empleo.';

  @override
  String get myDataEmploymentInfoSheetFooter => 'Si alguno de tus datos es incorrecto o no está actualizado, contacta con Servicio Público de Empleo Estatal (SEPE).';

  @override
  String get myDataEmploymentInfoSheetOfficeContactsButton => 'Consultar más información';

  @override
  String get myDataEmploymentDataTab => 'Mis datos de Empleo';

  @override
  String get myDataEmploymentServicesTab => 'Información y servicios';

  @override
  String get myDataEmploymentDemandTitle => 'Mi demanda de empleo';

  @override
  String get myDataEmploymentDemandUnavailableStatus => 'Inscripción no activa';

  @override
  String get myDataEmploymentRegistrationDateLabel => 'Fecha de inscripción sin interrupciones';

  @override
  String get myDataEmploymentDemandEmpty => 'No constan datos de demanda de empleo.';

  @override
  String get myDataEmploymentDemandError => 'No hemos podido cargar tu demanda de empleo.';

  @override
  String get myDataEmploymentServiceUnavailableTitle => 'Servicio no disponible';

  @override
  String get myDataEmploymentServiceUnavailableMessage => 'El servicio de Demanda de empleo actualmente no está disponible. Puedes recargar la información o intentarlo de nuevo más tarde.';

  @override
  String get myDataEmploymentServiceUnavailableReload => 'Recargar página';

  @override
  String get myDataEmploymentOffersServiceUnavailableMessage => 'No hemos podido cargar tus inscripciones en ofertas de empleo. Vuelve a intentarlo más tarde.';

  @override
  String get myDataEmploymentAuthorizationDialogTitle => 'No has autorizado la consulta de datos en tu perfil';

  @override
  String get myDataEmploymentAuthorizationDialogBody => 'Para visualizar tus inscripciones en ofertas, debes autorizar primero la consulta de los datos en “Condiciones de uso y autorizaciones” en tu perfil.';

  @override
  String get myDataEmploymentAuthorizationDialogAuthorizationsCta => 'Ir a Condiciones de uso y autorizaciones';

  @override
  String get myDataEmploymentAuthorizationDialogBack => 'Volver';

  @override
  String get myDataEmploymentOffersTitle => 'Inscripciones en ofertas';

  @override
  String get myDataEmploymentOffersDescription => 'Historial de las ofertas de empleo solicitadas';

  @override
  String get myDataEmploymentOffersPageTitle => 'Inscripción en ofertas de empleo';

  @override
  String get myDataEmploymentOffersPortalLink => 'Portal de empleabilidad de la Junta de Comunidades de Castilla-La Mancha';

  @override
  String get myDataEmploymentOffersInfoSheetTitle => 'Saber más sobre Inscripción en ofertas de empleo';

  @override
  String get myDataEmploymentOffersInfoSheetFooter => 'Si alguno de tus datos es incorrecto o no está actualizado, revisa tu espacio personal en el Portal de empleo de Castilla-La Mancha.';

  @override
  String get myDataEmploymentOffersInfoSheetDescription => 'Consulta tus últimas inscripciones en ofertas de empleo.';

  @override
  String get myDataEmploymentOffersEmptyMessage => 'Aún no te has inscrito a ninguna oferta. Si consideras que no es correcto o no está actualizado, contacta con el servicio de Lirem ipsum';

  @override
  String get myDataEmploymentOffersLoadError => 'No hemos podido cargar tus inscripciones en ofertas.';

  @override
  String get myDataEmploymentOfferPublicationDateLabel => 'Fecha publicación';

  @override
  String get myDataEmploymentOfferRegistrationDateLabel => 'Fecha inscripción';

  @override
  String get myDataEmploymentOfferSelectionEndDateLabel => 'Fecha de finalización del proceso de selección';

  @override
  String get myDataEmploymentOfferApplicationStatusLabel => 'Estado candidatura';

  @override
  String get myDataEmploymentProceduresTitle => 'Trámites que te pueden interesar';

  @override
  String get myDataEmploymentProcedureProfessionalCertificate => 'Expedición certificado de profesionalidad';

  @override
  String get myDataEmploymentProcedureJobSeekerRegistration => 'Inscripción como demandante de personas trabajadoras en oficinas de empleo y emprendedores';

  @override
  String get myDataEmploymentProcedureVirtualOfficeCredentials => 'Solicitud de credenciales de acceso a la oficina virtual de la consejería de empleo y economía para personas físicas, jurídicas y autónomos.';

  @override
  String get myDataEmploymentInterestLinksTitle => 'Enlaces de interés';

  @override
  String get myDataEmploymentLinkEmploymentClm => 'Empleo CLM';

  @override
  String get myDataEmploymentLinkPublicEmploymentClm => 'Empleo Público CLM';

  @override
  String get myDataEducationTitle => 'Educación';

  @override
  String get myDataEducationDescription => 'Títulos universitarios y no universitarios';

  @override
  String get myDataHousingTitle => 'Vivienda';

  @override
  String get myDataHousingDescription => 'Datos catastrales y titularidad de inmuebles';

  @override
  String get myDataHousingInfoSheetTitle => 'Sobre Mis datos de Vivienda';

  @override
  String get myDataHousingInfoSheetDescription => 'Consulta la información de tus bienes inmuebles, tu vivienda y los datos de tu domicilio actual.';

  @override
  String get myDataHousingDataTab => 'Mis datos de Vivienda';

  @override
  String get myDataHousingServicesTab => 'Información y servicios';

  @override
  String get myDataHousingRealEstateTitle => 'Bienes inmuebles';

  @override
  String get myDataHousingRealEstateDescription => 'Datos catastrales de la propiedad';

  @override
  String get myDataHousingRealEstateInfoSheetTitle => 'Saber más sobre Bienes Inmuebles';

  @override
  String get myDataHousingRealEstateInfoSheetDescription => 'Consulta la información catastral de los inmuebles que tienes registrados a tu nombre en el Catastro.';

  @override
  String get myDataHousingRealEstateInfoSheetFooter => 'Si alguno de tus datos es incorrecto o no está actualizado, contacta con la Sede Electrónica del Catastro.';

  @override
  String get myDataHousingRealEstateFilterAll => 'Todo';

  @override
  String get myDataHousingRealEstateFilterUrban => 'Urbano';

  @override
  String get myDataHousingRealEstateFilterRustic => 'Rústico';

  @override
  String myDataHousingRealEstateReferenceTitle(String value) {
    return 'Referencia catastral $value';
  }

  @override
  String get myDataHousingRealEstateDetailClose => 'Cerrar';

  @override
  String get myDataHousingRealEstateDetailHomeDataTitle => 'Datos de la vivienda';

  @override
  String get myDataHousingRealEstateReferenceLabel => 'Referencia catastral';

  @override
  String get myDataHousingRealEstateAddressLabel => 'Dirección';

  @override
  String get myDataHousingRealEstateUseLabel => 'Uso';

  @override
  String get myDataHousingRealEstateCadastralValueLabel => 'Valor catastral';

  @override
  String get myDataHousingRealEstateLandValueLabel => 'Valor del suelo';

  @override
  String get myDataHousingRealEstateConstructionValueLabel => 'Valor de construcción';

  @override
  String get myDataHousingRealEstateStatusLabel => 'Estado';

  @override
  String get myDataHousingRealEstateShowCartography => 'Mostrar cartografía';

  @override
  String get myDataHousingRealEstateHoldersTitle => 'Titulares';

  @override
  String get myDataHousingRealEstateHoldersEmpty => 'No constan titulares para este bien inmueble.';

  @override
  String get myDataHousingRealEstateDetailEmpty => 'No hemos encontrado el bien inmueble seleccionado.';

  @override
  String get myDataHousingRealEstateEmpty => 'No constan bienes inmuebles a tu nombre.';

  @override
  String get myDataHousingRealEstateFilteredEmpty => 'No hay bienes inmuebles para este filtro.';

  @override
  String get myDataHousingRealEstateError => 'No hemos podido cargar los datos de Catastro.';

  @override
  String get myDataHousingAddressTitle => 'Domicilio en Castilla-La Mancha';

  @override
  String get myDataHousingAddressDescription => 'Datos padronales';

  @override
  String get myDataHousingAddressInfoSheetTitle => 'Saber más sobre Domicilio en Castilla-La Mancha';

  @override
  String get myDataHousingAddressInfoSheetDescription => 'Consulta los datos de tu empadronamiento registrados en el Instituto Nacional de Estadística (INE). Esta información procede de los padrones municipales de Castilla-La Mancha y se actualiza cada mes con los datos que envían los ayuntamientos.\n\nSi has cambiado recientemente tu empadronamiento, es posible que esta información todavía no esté actualizada.';

  @override
  String get myDataHousingAddressInfoSheetFooter => 'Si alguno de tus datos es incorrecto o no está actualizado, contacta con el Ayuntamiento correspondiente.';

  @override
  String get myDataHousingAddressDataTitle => 'Datos del domicilio';

  @override
  String get myDataHousingAddressRegistrationDataTitle => 'Datos relativos a la inscripción';

  @override
  String get myDataHousingAddressLabel => 'Domicilio';

  @override
  String get myDataHousingAddressPostalCodeLabel => 'Código postal';

  @override
  String get myDataHousingAddressMunicipalityLabel => 'Municipio';

  @override
  String get myDataHousingAddressProvinceLabel => 'Provincia';

  @override
  String get myDataHousingAddressCollectiveEntityLabel => 'Entidad colectivo';

  @override
  String get myDataHousingAddressSingleEntityLabel => 'Entidad singular';

  @override
  String get myDataHousingAddressPopulationUnitLabel => 'Núcleo / Diseminado';

  @override
  String get myDataHousingAddressVariationTypeLabel => 'Tipo de variación';

  @override
  String get myDataHousingAddressVariationDateLabel => 'Fecha de variación';

  @override
  String get myDataHousingAddressEmpty => 'No constan datos de domicilio en Castilla-La Mancha.';

  @override
  String get myDataHousingAddressError => 'No hemos podido cargar tus datos de domicilio.';

  @override
  String get myDataHousingLinksTitle => 'Enlaces de interés';

  @override
  String get myDataHousingLinkClmHousing => 'Portal de Vivienda de Castilla-La Mancha';

  @override
  String get myDataHousingLinkCadastre => 'Sede Electrónica del Catastro';

  @override
  String get myDataHousingProceduresTitle => 'Trámites que te pueden interesar';

  @override
  String get myDataHousingProcedureRentalHousingAid => 'Ayudas al alquiler de viviendas';

  @override
  String get myDataHousingProcedureProtectedHousingRegister => 'Inscripción en el Registro de Demandantes de Vivienda';

  @override
  String get myDataHousingProcedureSocialEmergencyAid => 'Ayudas de emergencia social';

  @override
  String get myDataVehiclesTitle => 'Vehículos';

  @override
  String get myDataVehiclesDescription => 'Matriculación y titularidad de vehículos registrados';

  @override
  String get myDataVehiclesInfoSheetTitle => 'Saber más sobre Vehículos';

  @override
  String get myDataVehiclesInfoSheetDescription => 'Consulta la información de los vehículos que tienes registrados a tu nombre en la Dirección General de Tráfico (DGT).';

  @override
  String get myDataVehiclesInfoSheetFooter => 'Si alguno de tus datos es incorrecto o no está actualizado, contacta con la Dirección General de Tráfico (DGT).';

  @override
  String get myDataVehiclesInfoSheetContactButton => 'Consultar más información';

  @override
  String get myDataVehiclesDataTab => 'Mis datos de Vehículos';

  @override
  String get myDataVehiclesServicesTab => 'Información y servicios';

  @override
  String get myDataVehiclesSectionTitle => 'Mis vehículos';

  @override
  String get myDataVehiclesLicensePlateLabel => 'Matrícula del vehículo';

  @override
  String get myDataVehiclesEmpty => 'No constan vehículos registrados a tu nombre.';

  @override
  String get myDataVehiclesError => 'No hemos podido cargar tus vehículos.';

  @override
  String get myDataVehiclesServicesEmpty => 'Información y servicios de Vehículos disponible próximamente.';

  @override
  String get myDataVehiclesLinksTitle => 'Enlaces de interés';

  @override
  String get myDataVehiclesLinkDgt => 'Sede electrónica DGT';

  @override
  String get myDataVehiclesLinkAge => 'Carpeta Ciudadana de la AGE';

  @override
  String get myDataVehiclesProceduresTitle => 'Trámites que te pueden interesar';

  @override
  String get myDataVehiclesProcedureMoves3Vehicle => 'Solicitud de ayuda MOVES III para adquisición de vehículos eléctricos';

  @override
  String get myDataVehiclesProcedureMoves3Infrastructure => 'Solicitud de ayuda MOVES III para implantación de infraestructura de recarga de vehículos eléctricos';

  @override
  String get myDataVehiclesProcedureCap => 'Homologación de cursos de formación de conductores (cap)';

  @override
  String myDataSectionComingSoon(String section) {
    return '$section disponible próximamente';
  }

  @override
  String get myDataHealthInfoMessage => 'Consulta tus datos de salud y las citas disponibles.';

  @override
  String get myDataEducationInfoSheetTitle => 'Sobre Mis datos de Educación';

  @override
  String get myDataEducationInfoSheetDescription => 'Consulta tu información y accede a servicios relacionados de educación en Castilla-La Mancha.';

  @override
  String get myDataEducationDataTab => 'Mis datos de Educación';

  @override
  String get myDataEducationServicesTab => 'Información y servicios';

  @override
  String get myDataEducationUniversityTitles => 'Títulos universitarios';

  @override
  String get myDataEducationNonUniversityTitles => 'Títulos no universitarios';

  @override
  String get myDataEducationTitlesDescription => 'Universidades públicas y privadas';

  @override
  String get myDataEducationNonUniversityTitlesDescription => 'Formación profesional y otras titulaciones';

  @override
  String get myDataEducationServicesEmpty => 'Información y servicios de Educación disponible próximamente.';

  @override
  String get myDataEducationProceduresTitle => 'Trámites que te pueden interesar';

  @override
  String get myDataEducationProcedureEquivalence => 'Solicitud equivalencia de estudios con los títulos oficiales';

  @override
  String get myDataEducationProcedureScholarships => 'Becas y ayudas a alumnos de niveles postobligatorios';

  @override
  String get myDataEducationProcedureSecondaryDegree => 'Pruebas libres para la obtención del título de graduado en educación secundaria obligatoria para > 18 años';

  @override
  String get myDataEducationInterestLinksTitle => 'Enlaces de interés';

  @override
  String get myDataEducationLinkEducationPortal => 'Portal de Educación de Castilla-La Mancha';

  @override
  String get myDataEducationLinkTeachingStaff => 'Personal Docente';

  @override
  String get myDataEducationLinkScholarships => 'Becas y ayudas para estudiantes';

  @override
  String get myDataHealthInfoSheetTitle => 'Sobre Mis datos de Salud';

  @override
  String get myDataHealthInfoSheetDescription => 'Consulta la información de tus citas de Atención Primaria del Servicio de Salud de Castilla-La Mancha (SESCAM).';

  @override
  String get myDataHealthInfoSheetContactHint => 'Si algún dato no es correcto o no está actualizado, contacta con tu Centro de Salud.';

  @override
  String get myDataHealthInfoSheetMoreInformation => 'Consultar más información';

  @override
  String get myDataHealthDataTab => 'Mis datos de Salud';

  @override
  String get myDataHealthServicesTab => 'Información y servicios';

  @override
  String get myDataHealthProceduresTitle => 'Trámites que te pueden interesar';

  @override
  String get myDataHealthProcedureComplaints => 'Reclamaciones y quejas relativas al SESCAM';

  @override
  String get myDataHealthProcedureHealthCard => 'Solicitud de tarjeta para la Atención Sanitaria en el SESCAM';

  @override
  String get myDataHealthProcedureSpecializedCare => 'Libre elección en el ámbito de la Atención Especializada';

  @override
  String get myDataHealthInterestLinksTitle => 'Enlaces de interés';

  @override
  String get myDataHealthLinkSescam => 'Servicio de Salud de Castilla-La Mancha (SESCAM)';

  @override
  String get myDataHealthLinkDigitalHealth => 'Mi Salud Digital';

  @override
  String get myDataHealthLinkClinicalHistory => 'Historia clínica del Sistema Nacional de Salud (HCDSNS)';

  @override
  String get myDataHealthAppointmentsTitle => 'Citas de Atención Primaria';

  @override
  String myDataHealthCipLabel(String cip) {
    return 'Código de Identificación Personal (CIP): $cip';
  }

  @override
  String get myDataHealthAppointmentsEmpty => 'No hay citas para mostrar.';

  @override
  String get myDataHealthAppointmentsError => 'No hemos podido cargar tus citas sanitarias.';

  @override
  String get myDataHealthPendingTab => 'Pendientes';

  @override
  String get myDataHealthPastTab => 'Pasadas';

  @override
  String get myDataHealthScopePrimaryCare => 'Primaria';

  @override
  String get myDataHealthScopeHospital => 'Hospitalaria';

  @override
  String get myDataHealthHospitalAppointmentsTitle => 'Citas de atención hospitalaria';

  @override
  String get myDataHealthPrimaryCareNavTitle => 'Citas de atención primaria';

  @override
  String get myDataHealthHospitalNavTitle => 'Citas de atención hospitalaria';

  @override
  String get myDataHealthHospitalNavVerificationRequired => 'Tus datos hospitalarios están protegidos. Verifica tu identidad para acceder.';

  @override
  String get myDataHealthHospitalLinkTitle => 'Mis citas hospitalarias';

  @override
  String get myDataHealthHospitalLinkDescription => 'Consulta la información sobre tus citas hospitalarias del SESCAM.';

  @override
  String get myDataHealthHospitalContactHint => 'Si alguno de los datos no está actualizado deberás ponerte en contacto con el SESCAM.';

  @override
  String get myDataHealthHospitalPendingTab => 'Citas pendientes';

  @override
  String get myDataHealthHospitalPastTab => 'Citas pasadas';

  @override
  String get myDataHealthHospitalPendingEmpty => 'No tienes citas hospitalarias pendientes.';

  @override
  String get myDataHealthHospitalPastEmpty => 'No tienes citas hospitalarias pasadas.';

  @override
  String get myDataHealthHospitalFieldService => 'Servicio';

  @override
  String get myDataHealthHospitalFieldProvision => 'Prestación';

  @override
  String get myDataHealthHospitalFieldRoom => 'Sala';

  @override
  String get myDataHealthHospitalFieldCenter => 'Centro';

  @override
  String get myDataHealthHospitalFieldAgenda => 'Agenda';

  @override
  String get myDataHealthCipUnavailable => 'CIP no disponible';

  @override
  String get identityVerificationDialogTitle => 'Verificación de identidad';

  @override
  String get identityVerificationDialogBody => 'Esta consulta necesita de un nivel de seguridad mayor y es necesario volver a identificarte.';

  @override
  String get identityVerificationDialogDoNotShowAgain => 'No volver a mostrar';

  @override
  String get identityVerificationDialogBack => 'Volver';

  @override
  String get identityVerificationDialogContinue => 'Acceder a cl@ve';

  @override
  String get identityVerificationCompletedMessage => 'Verificación completada';

  @override
  String get identityVerificationSwitchedMessage => 'Te has identificado con otra persona. Se ha cerrado la sesión anterior.';

  @override
  String get myDataHealthLevelRequiredMessage => 'El nivel de acceso actual es insuficiente para cumplir las políticas de seguridad de la aplicación. Pulse «Continuar» para reiniciar la sesión con el nivel de acceso superior requerido.';

  @override
  String get myDataHealthLevelUnverifiedMessage => 'No ha sido posible comprobar su nivel de acceso, por lo que no se pueden mostrar sus citas hospitalarias. Pulse «Continuar» para reiniciar la sesión.';

  @override
  String get myDataHealthLevelElevateAction => 'Continuar';

  @override
  String get myDataHealthLevelStillInsufficientMessage => 'El método de identificación utilizado no alcanza el nivel de acceso requerido. Pulse «Continuar» e identifíquese con certificado digital o DNI electrónico.';

  @override
  String get myDataHealthLevelElevationFailedMessage => 'No ha sido posible elevar su nivel de acceso. Inténtelo de nuevo.';

  @override
  String get myDataHealthLoadMoreAppointments => 'Cargar más citas';

  @override
  String get myDataHealthYear => '2026';

  @override
  String get myDataHealthDecember => 'diciembre';

  @override
  String get myDataHealthOctober => 'octubre';

  @override
  String get myDataHealthAppointmentDayNumber => '12';

  @override
  String get myDataHealthAppointmentWeekday => 'Jueves';

  @override
  String get myDataHealthAppointmentTime => '17:35h';

  @override
  String get myDataHealthAppointmentType => 'TELÉFONICA';

  @override
  String get myDataHealthAppointmentDescription => 'Cita de Atención Primaria';

  @override
  String get myDataHealthAppointmentModality => 'Teleconsulta a demanda';

  @override
  String get gestionTitle => 'Gestión';

  @override
  String get gestionExpedientesTitle => 'Mis expedientes';

  @override
  String get gestionExpedientesDescription => 'Consulta la información y el estado de los expedientes que has iniciado con la Junta de Comunidades de Castilla-La Mancha (JCCM).';

  @override
  String get gestionRegistrosTitle => 'Mis registros';

  @override
  String get gestionRegistrosDescription => 'Accede a tus entradas y salidas de registro';

  @override
  String get gestionAportacionTitle => 'Aportar documentos a un expediente de terceros';

  @override
  String get gestionAportacionDescription => 'Adjunta documentación a expedientes de otras personas';

  @override
  String get gestionNotificacionesTitle => 'Mis notificaciones';

  @override
  String get gestionNotificacionesDescription => 'Gestiona tus notificaciones electrónicas';

  @override
  String get gestionSectionComingSoon => 'Función disponible próximamente';

  @override
  String get gestionExpedientesPageTitle => 'Mis expedientes';

  @override
  String get gestionExpedientesNumExpedienteLabel => 'Nº EXPEDIENTE';

  @override
  String get gestionExpedientesFechaInicioLabel => 'FECHA DE INICIO';

  @override
  String get gestionExpedientesEstadoLabel => 'ESTADO';

  @override
  String get gestionExpedientesLoadError => 'No hemos podido cargar tus expedientes';

  @override
  String get gestionExpedientesEmpty => 'No tienes expedientes activos';

  @override
  String get gestionExpedientesDetalleTitle => 'Detalle de expediente';

  @override
  String get gestionExpedientesDatosExpedienteTitle => 'Datos del expediente';

  @override
  String get gestionExpedientesEstadoTramitacionTitle => 'Estado de tramitación';

  @override
  String get gestionExpedientesConsejeriaLabel => 'CONSEJERÍA';

  @override
  String get gestionExpedientesOficinaTramitadoraLabel => 'OFICINA TRAMITADORA';

  @override
  String get gestionExpedientesFechaCierreLabel => 'FECHA DE CIERRE';

  @override
  String get gestionExpedientesAportarDocumentacionButton => 'Aportar documentación';

  @override
  String get gestionExpedientesDetalleLoadError => 'No hemos podido cargar el detalle del expediente';

  @override
  String get gestionAportarDocumentacionTitle => 'Aportar documentación';

  @override
  String get gestionAportarDocumentacionHelperText => 'Puedes adjuntar hasta 5 archivos de un máximo de 20 MB cada uno. Se admiten archivos en formato PDF, DOC, DOCX, ZIP, XLS y XLSX.';

  @override
  String get gestionAportarDocumentacionInfoTitle => 'Saber más sobre Aportar documentación';

  @override
  String get gestionAportarDocumentacionInfoBody => 'Los documentos aportados solo estarán disponibles para su consulta por la Administración y no podrán consultarse desde el expediente.';

  @override
  String get gestionAportarDocumentacionCancelarButton => 'Cancelar';

  @override
  String get gestionAportarDocumentacionSeleccionarButton => 'Seleccionar documentos';

  @override
  String get gestionAportarDocumentacionRegistrarButton => 'Enviar documentos aportados';

  @override
  String get gestionAportarDocumentacionMaxFilesError => 'No puedes aportar más de 5 ficheros.';

  @override
  String get gestionAportarDocumentacionMaxSizeError => 'Cada fichero debe pesar como máximo 20MB.';

  @override
  String get gestionAportarDocumentacionInvalidTypeError => 'Formato de fichero no permitido.';

  @override
  String get gestionAportarDocumentacionDuplicateError => 'Ese fichero ya se ha añadido.';

  @override
  String get gestionAportarDocumentacionNoFilesError => 'Selecciona al menos un fichero antes de registrar.';

  @override
  String get gestionAportarDocumentacionRegistroSuccess => 'Documentación registrada correctamente.';

  @override
  String get gestionAportarDocumentacionRegistroError => 'No hemos podido registrar la documentación. Inténtalo de nuevo.';

  @override
  String get gestionAportarDocumentacionUploadIncompleto => 'Falta algún fichero por enviar. Al registrar de nuevo se enviarán todos otra vez.';

  @override
  String get gestionAportarDocumentacionUploadErrorParcial => 'Algunos ficheros no se han podido enviar. Puedes reintentarlo.';

  @override
  String get gestionAportarDocumentacionExitoTitulo => 'Documentos enviados. Descarga el justificante de la aportación.';

  @override
  String get gestionAportarDocumentacionExitoDescripcion => 'Has enviado la documentación correctamente y la aportación ha quedado registrada.\n\nDescarga el justificante ahora para conservar una copia de la aportación. Después, no podrás volver a descargarlo.';

  @override
  String get gestionAportarDocumentacionCerrarSinDescargarButton => 'Cerrar sin descargar';

  @override
  String get gestionAportarDocumentacionDescargarJustificanteButton => 'Descargar justificante';

  @override
  String get gestionAportarDocumentacionJustificanteDescargado => 'Justificante de aportación descargado';

  @override
  String get gestionAportarDocumentacionJustificanteError => 'No se pudo guardar el justificante. Inténtalo de nuevo.';

  @override
  String get gestionAportarDocumentacionFinalizacionError => 'Los documentos se han subido pero no se ha podido finalizar el registro. Puedes reintentarlo.';

  @override
  String get gestionRegistrosPageTitle => 'Mis registros';

  @override
  String get gestionRegistrosEntradasTab => 'Entradas de registro';

  @override
  String get gestionRegistrosEntradasDescription => 'Consulta los registros de comunicaciones que has enviado a la Junta de Comunidades de Castilla-La Mancha (JCCM).';

  @override
  String get gestionRegistrosSalidasTab => 'Salidas de registro';

  @override
  String get gestionRegistrosSalidasDescription => 'Consulta los registros de comunicaciones que has recibido de la Junta de Comunidades de Castilla-La Mancha (JCCM).';

  @override
  String get gestionRegistrosNumRegistroLabel => 'Nº REGISTRO';

  @override
  String get gestionRegistrosFechaLabel => 'FECHA';

  @override
  String get gestionRegistrosCardDateLabel => 'FECHA DE REGISTRO';

  @override
  String get gestionRegistrosConsejeriaOrigenLabel => 'CONSEJERÍA DE ORIGEN';

  @override
  String get gestionRegistrosConsejeriaDestinoLabel => 'CONSEJERÍA DE DESTINO';

  @override
  String get gestionRegistrosDatosRegistroTitle => 'Datos del Registro';

  @override
  String get gestionRegistrosEntradasLoadError => 'No hemos podido cargar tus entradas de registro';

  @override
  String get gestionRegistrosSalidasLoadError => 'No hemos podido cargar tus salidas de registro';

  @override
  String get gestionRegistrosEntradasEmpty => 'No tienes entradas de registro';

  @override
  String get gestionRegistrosSalidasEmpty => 'No tienes salidas de registro';

  @override
  String get gestionRegistrosDetalleEntradaTitle => 'Detalle de entrada de registro';

  @override
  String get gestionRegistrosDetalleSalidaTitle => 'Detalle salida de registro';

  @override
  String get gestionAportacionTipoIdLabel => 'Tipo de identificación y número';

  @override
  String get gestionAportacionTipoIdShortLabel => 'Tipo de identificación';

  @override
  String get gestionAportacionExpedienteIdentifierTypeLabel => 'Tipo de identificación';

  @override
  String get gestionAportacionRegistroOption => 'Número de registro';

  @override
  String get gestionAportacionCodigoOption => 'Número de expediente';

  @override
  String get gestionAportacionTipoIdHint => '000000000A';

  @override
  String get gestionAportacionTipoIdHelper => 'El número de identificación debe ser el que figura en el expediente.';

  @override
  String get gestionAportacionIntroText => 'Para aportar documentos, primero tienes que identificar el expediente al que quieres asociarlos e introducir los siguientes datos:';

  @override
  String get gestionAportacionPersonaLabel => 'DATOS DE LA PERSONA INTERESADA';

  @override
  String get gestionAportacionExpedienteLabel => 'DATOS DEL EXPEDIENTE';

  @override
  String get gestionAportacionExpedienteNote => '*Rellenar solo uno de los dos campos';

  @override
  String get gestionAportacionNumRegistroLabel => 'NÚMERO DE REGISTRO DEL EXPEDIENTE';

  @override
  String get gestionAportacionNumRegistroHint => 'Número de registro';

  @override
  String get gestionAportacionNumRegistroHelper => 'Este número lo encontrarás en el justificante de presentación de la solicitud.';

  @override
  String get gestionAportacionCodIdentificadorLabel => 'CÓDIGO IDENTIFICADOR DEL EXPEDIENTE';

  @override
  String get gestionAportacionCodIdentificadorHint => 'Número de expediente';

  @override
  String get gestionAportacionCodIdentificadorHelper => 'Este número se encuentra en la documentación del expediente';

  @override
  String get gestionAportacionInfoHeading => 'Saber más sobre Aportar documentos a un expediente';

  @override
  String get gestionAportacionInfoBody => 'Puedes aportar documentos a un expediente solo si eres una persona autorizada, y siempre que el procedimiento esté en curso y todavía no se haya dictado la resolución final. Para aportar documentos a uno de tus expedientes accede a Mis expedientes.';

  @override
  String get gestionAportacionInfoBullet1 => 'La persona interesada';

  @override
  String get gestionAportacionInfoBullet2 => 'Su representante legal';

  @override
  String get gestionAportacionInfoBullet3 => 'Una persona autorizada';

  @override
  String get gestionAportacionSeleccionarTipo => 'Seleccionar tipo de documento';

  @override
  String get gestionAportacionDni => 'DNI/NIE';

  @override
  String get gestionAportacionNie => 'NIE';

  @override
  String get gestionAportacionCif => 'CIF';

  @override
  String get gestionAportacionPasaporte => 'Pasaporte';

  @override
  String get gestionAportacionCee => 'CEE';

  @override
  String get gestionAportacionFindButton => 'Buscar Expediente';

  @override
  String get gestionAportacionDocNumberRequiredError => 'Introduce el número de documento de la persona interesada.';

  @override
  String get gestionAportacionOwnExpedienteError => 'Este trámite es solo para aportación de documentos por terceros. Si deseas aportar documentación a tus expedientes, tienes que acceder a Mis expedientes.';

  @override
  String get gestionAportacionCamposExpedienteError => 'Rellena el número de registro o el código identificador del expediente (solo uno de los dos).';

  @override
  String get gestionNotificacionesContextualMessage => 'Indica tus datos de contacto para activar los avisos y recibirlos cuando tengas una nueva notificación.';

  @override
  String get gestionNotificacionesContextualAction => 'Indicar datos y activar avisos';

  @override
  String get gestionNotificacionesAltaTitle => 'Mis notificaciones';

  @override
  String get gestionNotificacionesAltaIntro => 'Registra tus datos de contacto para empezar a recibir notificaciones de la Junta de Comunidades de Castilla-La Mancha.';

  @override
  String get gestionNotificacionesAltaRequiredNote => 'Es obligatorio completar al menos uno de los campos marcados con (*)';

  @override
  String get gestionNotificacionesAltaPhoneLabel => 'Teléfono móvil';

  @override
  String get gestionNotificacionesAltaPhoneHint => 'Ejemplo: 000 000 000';

  @override
  String get gestionNotificacionesAltaPhoneHelper => 'Recibe notificaciones por SMS en tu teléfono móvil.';

  @override
  String get gestionNotificacionesAltaEmailLabel => 'Correo electrónico';

  @override
  String get gestionNotificacionesAltaEmailHint => 'Ejemplo: mperez@correo.es';

  @override
  String get gestionNotificacionesAltaEmailHelper => 'Para recibir las notificaciones en tu correo electrónico';

  @override
  String get gestionNotificacionesAltaSaveButton => 'Activar';

  @override
  String get gestionNotificacionesAltaInfoTitle => 'Saber más sobre los datos de Mis notificaciones';

  @override
  String get gestionNotificacionesAltaInfoBody => 'Esta información de contacto se utilizará únicamente para avisarte de que tienes una nueva notificación electrónica.\n\nPuedes modificar los datos en cualquier momento. Después los cambios se aplicarán a las nuevas notificaciones.';

  @override
  String get gestionNotificacionesAltaErrorAtLeastOne => 'Debes indicar al menos un teléfono móvil o un correo electrónico.';

  @override
  String get gestionNotificacionesAltaErrorPhone => 'Introduce un teléfono móvil válido.';

  @override
  String get gestionNotificacionesAltaErrorEmail => 'Introduce un correo electrónico válido.';

  @override
  String get gestionNotificacionesAltaErrorNoCitizenId => 'No hemos podido identificar al ciudadano.';

  @override
  String get gestionNotificacionesAltaSuccessMessage => 'Datos de contacto guardados';

  @override
  String get gestionNotificacionesPageTitle => 'Mis notificaciones';

  @override
  String get gestionNotificacionesTabTodo => 'Todo';

  @override
  String get gestionNotificacionesTabPendientes => 'Pendientes';

  @override
  String get gestionNotificacionesTabAceptadas => 'Aceptadas';

  @override
  String get gestionNotificacionesTabExpiradas => 'Expiradas';

  @override
  String get gestionNotificacionesProcedimientoLabel => 'Procedimiento';

  @override
  String get gestionNotificacionesFechaCaducidadLabel => 'Fecha expiración';

  @override
  String get gestionNotificacionesTagPendiente => 'Pendiente';

  @override
  String get gestionNotificacionesTagAceptada => 'Aceptada';

  @override
  String get gestionNotificacionesTagRechazada => 'Rechazada';

  @override
  String get gestionNotificacionesTagExpirada => 'Expirada';

  @override
  String get gestionNotificacionesEmpty => 'No tienes notificaciones en este momento';

  @override
  String get gestionNotificacionesLoadError => 'No se han podido cargar las notificaciones';

  @override
  String get consentRevokedSessionClosed => 'Has retirado la autorización para consultar tus datos, así que hemos cerrado la sesión. Vuelve a iniciarla para concederla de nuevo.';

  @override
  String get authorizationRevokedMessage => 'Ya no tienes autorizada esta consulta. Cerramos la sesión para que puedas volver a concederla al entrar.';

  @override
  String get mainTabHome => 'Inicio';

  @override
  String get mainTabGestion => 'Gestión';

  @override
  String get mainTabMyData => 'Mis datos';

  @override
  String get mainTabAgenda => 'Agenda';

  @override
  String get mainTabRecommendations => 'Para mí';

  @override
  String get notFoundPageTitle => 'Página no encontrada';

  @override
  String get notFoundPageMessage => '404 — La ruta solicitada no existe.';

  @override
  String get appNotificationContactFormTitle => 'Datos de contacto para notificaciones electrónicas';

  @override
  String get appNotificationContactFormRequiredNoteSemantic => 'Obligatorio: rellena al menos uno de los medios de contacto';

  @override
  String get appNotificationContactFormRequiredNote => '* Obligatorio rellenar al menos uno de los medios de contacto';

  @override
  String get appNotificationContactFormSaveButton => 'Guarda cambios';

  @override
  String get appPreferenceEditAction => 'Editar';

  @override
  String get appPreferenceStatusDisabled => 'Desactivado';

  @override
  String get appPreferenceStatusPending => 'Pendiente';

  @override
  String get appPreferenceStatusEnabled => 'Activo';

  @override
  String get appPreferenceStatusUnavailable => 'No disponible';

  @override
  String get appPreferenceStatusUnavailableDescription => 'No hemos podido consultar esta información. Inténtalo de nuevo más tarde.';

  @override
  String get appPreferenceStatusActive => 'Activo';

  @override
  String get appNotificationContactCardTitle => 'Datos de contacto para notificaciones';

  @override
  String get appNotificationContactCardEditAction => 'Editar datos';

  @override
  String get appQrCodeLabel => 'Código QR';

  @override
  String get appQrDownloadFormatTitle => '¿Quieres guardar el carnet?';

  @override
  String get appQrDownloadFormatDescription => 'Elige cómo quieres descargarlo:';

  @override
  String get appQrDownloadWalletLabelAndroid => 'Cartera digital';

  @override
  String get appQrDownloadWalletLabelIos => 'Cartera digital';

  @override
  String appQrDownloadFormatLabel(String format) {
    return 'Descargar $format';
  }

  @override
  String appQrDownloadingFormatLabel(String format) {
    return 'Descargando $format';
  }

  @override
  String get appCalendarPreviousYearTooltip => 'Año anterior';

  @override
  String get appCalendarNextYearTooltip => 'Año siguiente';

  @override
  String get appSearchFieldHint => 'Buscar';

  @override
  String commonWeekdayName(String weekday) {
    String _temp0 = intl.Intl.selectLogic(
      weekday,
      {
        'monday': 'Lunes',
        'tuesday': 'Martes',
        'wednesday': 'Miércoles',
        'thursday': 'Jueves',
        'friday': 'Viernes',
        'saturday': 'Sábado',
        'sunday': 'Domingo',
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
        'january': 'enero',
        'february': 'febrero',
        'march': 'marzo',
        'april': 'abril',
        'may': 'mayo',
        'june': 'junio',
        'july': 'julio',
        'august': 'agosto',
        'september': 'septiembre',
        'october': 'octubre',
        'november': 'noviembre',
        'december': 'diciembre',
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
        'january': 'ene',
        'february': 'feb',
        'march': 'mar',
        'april': 'abr',
        'may': 'may',
        'june': 'jun',
        'july': 'jul',
        'august': 'ago',
        'september': 'sep',
        'october': 'oct',
        'november': 'nov',
        'december': 'dic',
        'other': '',
      },
    );
    return '$_temp0';
  }

  @override
  String commonUpdatedAt(Object day, Object month, Object time, Object year) {
    return 'Actualizado el $day $month $year a las ${time}h';
  }

  @override
  String agendaFilterDays(Object days) {
    return '$days días';
  }

  @override
  String get agendaRefreshTooltip => 'Actualizar agenda';

  @override
  String get agendaEmptyAppointments => 'No hay citas para el periodo seleccionado.';

  @override
  String get agendaChannelPhone => 'telefónica';

  @override
  String get agendaChannelInPerson => 'presencial';

  @override
  String get preferencesInfoSheetBody => 'Gestiona tus autorizaciones y avisos.';

  @override
  String get consentAuthorizationsInfoTitle => 'Saber más sobre Condiciones de uso y autorización';

  @override
  String get consentAuthorizationsInfoBody => 'Si no autorizas el uso de tus datos, las Administraciones públicas no podrán mostrarte la información que tienen sobre ti.';

  @override
  String get consentAuthorizationsInfoClose => 'Cerrar';

  @override
  String get preferencesLifeEventsInactiveDescription => 'Acepta el uso de tus datos sobre los hechos vitales en las Condiciones de uso y autorizaciones para poder seleccionarlos y recibir recomendaciones personalizadas.';

  @override
  String get preferencesLifeEventsPendingDescription => 'Selecciona las situaciones, intereses o necesidades que más se ajustan a ti para recibir recomendaciones personalizadas.';

  @override
  String get preferencesLifeEventsActiveDescription => 'Tienes hechos vitales seleccionados para recibir recomendaciones personalizadas.';

  @override
  String get preferencesSelectAction => 'Seleccionar';

  @override
  String get preferencesNotificationContactTitle => 'Datos de contacto para recibir avisos de notificaciones';

  @override
  String get preferencesNotificationContactInactiveDescription => 'Indica un teléfono móvil o un correo electrónico para recibir avisos cuando tengas notificaciones nuevas.';

  @override
  String get preferencesNotificationContactPendingDescription => 'Gestiona el medio de aviso para recibir notificaciones electrónicas.';

  @override
  String get preferencesNotificationContactActiveDescription => 'Tienes configurado al menos un medio de aviso para recibir notificaciones electrónicas.';

  @override
  String get preferencesManageAction => 'Gestionar';

  @override
  String get preferencesAddContactAction => 'Añadir datos';

  @override
  String get preferencesBiometricTitle => 'Acceso biométrico';

  @override
  String get preferencesBiometricInactiveDescription => 'Activa el acceso con huella dactilar o reconocimiento facial para acceder a la aplicación de forma más rápida.';

  @override
  String get preferencesBiometricActiveDescription => 'El acceso biométrico a la aplicación está activado.';

  @override
  String get preferencesBiometricEnableAction => 'Activar';

  @override
  String get preferencesBiometricDisableAction => 'Desactivar';

  @override
  String get preferencesRevokeDialogTitle => 'Vas a borrar tus preferencias';

  @override
  String get preferencesRevokeDialogDescription => 'Al borrar tus preferencias, se eliminarán las autorizaciones que has concedido a la organización para consultar tus datos personales.\n\nSi vuelves a acceder a la aplicación, tendrás que completar de nuevo el proceso de autentificación y aceptar las Condiciones de uso y las autorizaciones.';

  @override
  String get preferencesRevokeDialogConfirm => 'Borrar';

  @override
  String get preferencesMissingUserIdError => 'No se ha encontrado el identificador del usuario.';

  @override
  String get preferencesResetAuthorizationsError => 'No hemos podido borrar tus autorizaciones. Inténtalo de nuevo.';

  @override
  String get preferencesNotificationContactEditTitle => 'Editar datos de contacto';

  @override
  String get gestionNotificacionesAltaErrorNoDni => 'No hemos podido obtener el DNI del ciudadano.';

  @override
  String myDataEducationTitleNumberLabel(Object number) {
    return 'Nº TÍTULO: $number';
  }

  @override
  String get myDataEducationExpeditionDateLabel => 'FECHA EXPEDICIÓN';

  @override
  String get myDataEducationCompletionDateLabel => 'FECHA FINALIZACIÓN';

  @override
  String get myDataEducationProvinceLabel => 'PROVINCIA';

  @override
  String myDataEducationBookLabel(Object value) {
    return 'LIBRO: $value';
  }

  @override
  String myDataEducationOrderLabel(Object value) {
    return 'ORDEN: $value';
  }

  @override
  String myDataEducationFolioLabel(Object value) {
    return 'FOLIO: $value';
  }

  @override
  String myDataHealthActiveFiltersTooltip(Object count) {
    return 'Criterios de búsqueda activos: $count';
  }

  @override
  String get myDataHealthSearchAppointmentsTooltip => 'Buscar citas';

  @override
  String get myDataHealthFilterPrimaryCareTitle => 'Filtrar citas de primaria';

  @override
  String get myDataHealthFilterHospitalTitle => 'Filtrar citas hospitalarias';

  @override
  String get myDataHealthFilterDateLabel => 'Fecha de la cita';

  @override
  String get recommendationsFilterPageTitle => 'Filtrar por hechos vitales';

  @override
  String get recommendationsFilterInfoMessage => 'Selecciona los hechos vitales que quieras usar para filtrar tus recomendaciones.';

  @override
  String get recommendationsFilterIntro => 'Selecciona los hechos vitales que quieras utilizar para filtrar las recomendaciones. Puedes ampliar el listado y añadir nuevos hechos vitales desde tus preferencias.';

  @override
  String get recommendationsFilterByLifeEvents => 'Filtrar por hechos vitales';

  @override
  String get recommendationsPreferencesHint => 'Personaliza tus recomendaciones editando tus hechos vitales en Preferencias siempre que quieras.';

  @override
  String get recommendationsEmptyNoMatches => 'Actualmente no hay recomendaciones para ti. Puedes modificar la selección actual de tus hechos vitales desde las preferencias o esperar a recibir nuevas actualizaciones.';

  @override
  String get recommendationsEditLifeEventsCta => 'Ir a Preferencias';

  @override
  String get recommendationsEmptyFiltered => 'Actualmente no hay recomendaciones para los filtros seleccionados. Puedes modificar la selección de filtros o esperar a recibir nuevas actualizaciones.';

  @override
  String get recommendationsResetFilterCta => 'Reiniciar filtro';

  @override
  String recommendationsDeadlineFrom(Object date) {
    return 'desde $date';
  }

  @override
  String recommendationsDeadlineUntil(Object date) {
    return 'hasta $date';
  }

  @override
  String get digitalCardsAuthorizationCheckErrorMessage => 'No hemos podido comprobar la autorización necesaria para mostrar tus carnets digitales.';

  @override
  String get digitalCardsInfoSheetTitle => 'Saber más sobre Mis carnets digitales';

  @override
  String get digitalCardsInfoSheetBody => 'Consulta y descarga los carnets digitales asociados a tu perfil y utilízalos para realizar tus gestiones en cualquier momento.';

  @override
  String get digitalCardsAuthorizationRequiredMessage => 'Para consultar y descargar tus carnets digitales, debes autorizar el uso de estos datos en «Condiciones de uso y autorizaciones».';

  @override
  String digitalCardsSaveDialogTitle(Object format) {
    return 'Guardar $format';
  }

  @override
  String digitalCardsDownloadSuccess(Object format) {
    return '$format guardado correctamente.';
  }

  @override
  String get digitalCardsPkPassAddedToWallet => 'Carnet descargado y añadido a Wallet.';

  @override
  String digitalCardsDownloadError(Object format) {
    return 'No hemos podido descargar $format.';
  }

  @override
  String get drawerDefaultUserName => 'Ciudadano/a';

  @override
  String get drawerIdentifierFallbackLabel => 'Identificador';

  @override
  String get gestionNotificacionDetalleAcceptedReloadError => 'Has aceptado la notificación, pero no hemos podido cargar el detalle actualizado.';

  @override
  String get gestionNotificacionDetalleConfirmTitle => 'Confirmación de aceptación de notificación';

  @override
  String get gestionNotificacionDetalleConfirmDescription => '¿Estás seguro que quieres aceptar la notificación?';

  @override
  String get gestionNotificacionDetalleConfirmCancel => 'No';

  @override
  String get gestionNotificacionDetalleConfirmAccept => 'Sí, estoy seguro';

  @override
  String get gestionNotificacionDetalleAcceptError => 'No hemos podido aceptar la notificación. Inténtalo de nuevo.';

  @override
  String get gestionNotificacionDetalleDocumentoDescargado => 'Documento descargado.';

  @override
  String get gestionNotificacionDetalleDocumentoDescargaError => 'No hemos podido descargar el documento. Inténtalo de nuevo.';

  @override
  String get gestionNotificacionDetalleDatosExpedienteTitle => 'Datos del expediente';

  @override
  String get gestionNotificacionDetalleOrganismoEmisorLabel => 'Organismo emisor';

  @override
  String get gestionNotificacionDetalleNumExpedienteLabel => 'Nº Expediente';

  @override
  String get gestionNotificacionDetalleEstadoTitle => 'Estado notificación';

  @override
  String get gestionNotificacionDetalleFechaPuestaDisposicionLabel => 'Fecha de puesta a disposición';

  @override
  String get gestionNotificacionesFechaExpiracionLabel => 'Fecha de expiración';

  @override
  String get gestionNotificacionDetalleFechaLecturaLabel => 'Fecha de lectura';

  @override
  String get gestionNotificacionDetalleDocumentosTitle => 'Documentos';

  @override
  String get gestionNotificacionDetalleAcuseRecibo => 'Acuse de recibo.pdf';

  @override
  String get gestionNotificacionDetalleAceptarButton => 'Aceptar notificación';

  @override
  String get gestionNotificacionesBuscarTooltip => 'Buscar notificaciones';

  @override
  String get gestionNotificacionesConfigurarTooltip => 'Configurar notificaciones';

  @override
  String get gestionNotificacionesFiltrarTitle => 'Filtrar notificaciones';

  @override
  String get gestionNotificacionesFiltroDescripcionLabel => 'Descripción de la notificación';

  @override
  String get gestionNotificacionesFiltrosAnterioresTooltip => 'Mostrar filtros anteriores';

  @override
  String get gestionRegistrosBuscarEntradasTooltip => 'Buscar entradas de registro';

  @override
  String get gestionRegistrosBuscarSalidasTooltip => 'Buscar salidas de registro';

  @override
  String get gestionRegistrosFiltrarEntradasTitle => 'Filtrar entradas de registro';

  @override
  String get gestionRegistrosFiltrarSalidasTitle => 'Filtrar salidas de registro';

  @override
  String get gestionRegistrosFiltroDescripcionEntradaLabel => 'Descripción de la entrada';

  @override
  String get gestionRegistrosFiltroDescripcionSalidaLabel => 'Descripción de la salida';

  @override
  String get gestionRegistrosFiltroFechaEntradaLabel => 'Fecha de entrada';

  @override
  String get gestionRegistrosFiltroFechaSalidaLabel => 'Fecha de salida';

  @override
  String gestionExpedientesFiltrosActivosTooltip(Object count) {
    return 'Criterios de búsqueda activos: $count';
  }

  @override
  String get gestionExpedientesBuscarTooltip => 'Buscar expedientes';

  @override
  String get gestionExpedientesFiltrarTitle => 'Filtrar expedientes';

  @override
  String get gestionExpedientesFiltroDescripcionLabel => 'Descripción del expediente';

  @override
  String get gestionExpedientesFiltroFechaCierreLabel => 'Fecha de cierre';

  @override
  String get gestionFiltroNumeroHint => 'Introduce el número';

  @override
  String get gestionFiltroDescripcionHint => 'Introduce palabras de la descripción';

  @override
  String get gestionMasInformacionTooltip => 'Más información';

  @override
  String get gestionAportacionPasaporteHint => 'N.º de pasaporte';

  @override
  String get gestionAportacionCeeHint => 'N.º de CEE';

  @override
  String get homeNewsSectionTitle => 'Mis novedades';

  @override
  String get homeMyDataAccessesTitle => 'Mis datos';

  @override
  String get homeNewsNotificationsTitle => 'Notificaciones';

  @override
  String get homeNewsNotificationsDescription => 'Consulta tus notificaciones pendientes';

  @override
  String get homeNewsNotificationsEmptyDescription => 'No tienes notificaciones pendientes';

  @override
  String get homeNewsAppointmentsTitle => 'Próximas citas';

  @override
  String get homeNewsAppointmentsDescription => 'Consulta tus próximas citas y eventos';

  @override
  String get homeNewsAppointmentsEmptyDescription => 'No tienes próximas citas ni eventos';

  @override
  String homeNewsLabelWithCount(String label, int count) {
    return '$label ($count)';
  }

  @override
  String homeNewsLabelWithMinimumCount(String label, int count) {
    return '$label (+$count)';
  }

  @override
  String get homeRecommendedProceduresTitle => 'Para mí';

  @override
  String get homeGoToRecommendationsButton => 'Mostrar todas mis recomendaciones';

  @override
  String get homeCardsFabLabel => 'Mis carnets';

  @override
  String get homeCardsFabShowAll => 'Mostrar todos';

  @override
  String get homeCardsFabExpandSemantics => 'Mostrar carnés digitales';

  @override
  String get homeCardsFabCollapseSemantics => 'Cerrar accesos a carnés digitales';

  @override
  String get homeCardsFabLoadingMessage => 'Estamos consultando tus carnets digitales.';

  @override
  String get homeCardsFabLoadFailedMessage => 'No hemos podido consultar tus carnets digitales.';

  @override
  String get homeCardsFabEmptyMessage => 'No tienes carnés digitales disponibles.';

  @override
  String homeRecommendationDeadlineFrom(String date) {
    return 'desde $date';
  }

  @override
  String homeRecommendationDeadlineUntil(String date) {
    return 'hasta $date';
  }

  @override
  String get helpContactPageTitle => 'Ayuda y contacto';

  @override
  String get helpContactGuidesTitle => 'Guías de ayuda';

  @override
  String get helpFaqIntro => 'Resuelve las dudas más habituales sobre Espacio ciudadano.';

  @override
  String get faqCategoryAccess => 'Acceso';

  @override
  String get faqCategoryMyData => 'Mis datos';

  @override
  String get faqCategoryManagements => 'Mis gestiones y notificaciones';

  @override
  String get faqCategoryAgenda => 'Agenda';

  @override
  String get faqCategoryPopulation => 'Registro de población';

  @override
  String get helpContactGuidesIntro => 'Consulta las guías disponibles para resolver tus dudas paso a paso.';

  @override
  String get helpContactShowAllGuides => 'Mostrar todas las guías';

  @override
  String get helpContactGoToJccmPortal => 'Ir al portal de Castilla-La Mancha';

  @override
  String get helpContactInfoHeading => 'Información de contacto';

  @override
  String get helpContactPhonesIntro => 'Para consultas generales o información administrativa, puedes contactar con el servicio de Atención a la ciudadanía.';

  @override
  String get helpContactPhonesIntroBold1 => 'consultas generales o información administrativa';

  @override
  String get helpContactPhonesIntroBold2 => 'Atención a la ciudadanía';

  @override
  String get helpContactCallCitizenService => 'Llamar a Atención a la Ciudadanía';

  @override
  String get helpContactExpedienteIntro => 'Para conocer más detalles sobre un expediente, debes contactar con la oficina tramitadora o la consejería responsable que corresponda.';

  @override
  String get helpContactExpedienteIntroBold => 'conocer más detalles sobre un expediente';

  @override
  String get helpContactOfficesListTitle => 'Listado de Oficinas de Información y Registro';

  @override
  String get helpContactSupportIntro => 'Si necesitas asistencia técnica, puedes contactar con el equipo de soporte técnico a través de un formulario.';

  @override
  String get helpContactSupportIntroBold => 'asistencia técnica';

  @override
  String get helpContactSupportFormButton => 'Completar formulario de soporte';

  @override
  String get faqQuestion1 => '¿Qué es Espacio ciudadano y qué puedo consultar?';

  @override
  String get faqAnswer1 => 'Espacio Ciudadano reúne en un único lugar información y servicios de la Junta de Comunidades de Castilla-La Mancha. Podrás consultar tus datos, expedientes, notificaciones, citas y otros servicios disponibles.';

  @override
  String get faqQuestion2 => '¿Qué necesito para acceder a mi Espacio ciudadano?';

  @override
  String get faqAnswer2 => 'Necesitas identificarte con Cl@ve, certificado electrónico o el sistema de acceso habilitado. Puedes usar Cl@ve Móvil, Cl@ve Permanente, DNI electrónico o un certificado electrónico.';

  @override
  String get faqQuestion3 => '¿Qué datos personales se almacenan?';

  @override
  String get faqAnswer3 => 'Se muestran los datos necesarios para prestar los servicios disponibles en la aplicación.';

  @override
  String get faqQuestion4 => '¿Cómo puedo corregir un dato incorrecto?';

  @override
  String get faqAnswer4 => 'Contacta con el órgano responsable del trámite o expediente para solicitar la corrección.';

  @override
  String get faqQuestion5 => '¿Qué expedientes y trámites puedo consultar?';

  @override
  String get faqAnswer5 => 'Puedes consultar los expedientes y trámites disponibles que estén relacionados con tu identidad y con los servicios integrados en Espacio Ciudadano.';

  @override
  String get faqQuestion6 => '¿Qué eventos aparecerán en mi agenda?';

  @override
  String get faqAnswer6 => 'Se muestran citas, avisos y eventos administrativos relacionados con tus servicios.';

  @override
  String get supportFormPageTitle => 'Formulario de soporte';

  @override
  String get supportCancelButton => 'Cancelar';

  @override
  String get supportAcceptButton => 'Aceptar';

  @override
  String get supportRequiredFieldsNote => 'Los campos marcados con un (*) son obligatorios';

  @override
  String get supportFieldFullName => 'Nombre y apellidos';

  @override
  String get supportFieldFullNameHint => 'Ejemplo: María Pérez';

  @override
  String get supportFieldEmailHint => 'Ejemplo: mperez@correo.es';

  @override
  String get supportFieldConfirmEmail => 'Confirma tu correo electrónico';

  @override
  String get supportFieldSubjectHint => 'Escribe el motivo de la consulta';

  @override
  String get supportFieldSubjectHelper => 'Motivo de consulta. Límite de 1000 caracteres';

  @override
  String get supportFieldMessage => 'Mensaje';

  @override
  String get supportFieldMessageHint => 'Describe los detalles de la consulta';

  @override
  String get supportAttachmentSectionLabel => 'ADJUNTAR DOCUMENTOS DE EVIDENCIA';

  @override
  String get supportAttachmentUploadHint => 'Puedes subir un único archivo o imagen de máx. 20MB en GIF, JPEG, JPG, PNG, TXT, PDF, DOC, DOCX para ayudar a identificar el problema.';

  @override
  String get supportAttachmentPickDocuments => 'Seleccionar documentos';

  @override
  String get supportAttachmentChangeDocument => 'Cambiar documento';

  @override
  String get supportConsentDataUseLabel => 'Autorizo el uso y gestión de mis datos';

  @override
  String get supportCaptchaBadge => 'Verificación';

  @override
  String get supportCaptchaPendingSemantics => 'pendiente de verificar, pulsa para verificar';

  @override
  String get supportCaptchaCheckingSemantics => 'verificando';

  @override
  String get supportCaptchaVerifiedSemantics => 'verificado';

  @override
  String get supportPrivacyInfoDescription => 'La información relativa a protección de datos aplicable a este formulario se encuentra publicada en';

  @override
  String get supportErrorSubjectOverLimit => 'El asunto no puede superar los 1000 caracteres.';

  @override
  String get supportErrorAttachmentTooLarge => 'El archivo excede el tamaño máximo permitido.';

  @override
  String get supportErrorAttachmentUnreadable => 'No hemos podido leer el archivo seleccionado.';

  @override
  String get landingContentTagline => 'Tu información pública en un solo lugar';

  @override
  String get landingFeatureNotificationsTitle => 'Notificaciones';

  @override
  String get landingFeatureNotificationsDescription => 'Recibe alertas y avisos de la administración directamente en tu dispositivo.';

  @override
  String get landingFeatureHealthTitle => 'Sanidad';

  @override
  String get landingFeatureHealthDescription => 'Consulta tu historial médico, citas y tarjeta sanitaria.';

  @override
  String get landingFeatureEmploymentTitle => 'Empleo';

  @override
  String get landingFeatureEmploymentDescription => 'Gestiona tu situación laboral y accede a ofertas de empleo público.';

  @override
  String get landingFeatureProceduresTitle => 'Trámites';

  @override
  String get landingFeatureProceduresDescription => 'Realiza gestiones administrativas sin desplazarte.';

  @override
  String get landingFeatureDigitalCardsTitle => 'Carnets Digitales';

  @override
  String get landingFeatureDigitalCardsDescription => 'Accede a tus carnets y documentos oficiales en formato digital.';

  @override
  String get landingFeatureCadastreTitle => 'Catastro';

  @override
  String get landingFeatureCadastreDescription => 'Consulta datos catastrales de tus inmuebles.';

  @override
  String get landingAccessStep1Title => 'Pulsa \"Acceder\"';

  @override
  String get landingAccessStep1Description => 'Toca el botón para iniciar el proceso de autenticación segura.';

  @override
  String get landingAccessStep2Title => 'Autentícate con Cl@ve';

  @override
  String get landingAccessStep2Description => 'Usa Cl@ve PIN o Cl@ve Permanente para identificarte de forma segura.';

  @override
  String get landingAccessStep3Title => 'Accede a toda tu información';

  @override
  String get landingAccessStep3Description => 'Consulta y gestiona tu información pública desde un único lugar.';

  @override
  String get legalSearchTooltip => 'Buscar';

  @override
  String get legalSearchCloseTooltip => 'Cerrar búsqueda';

  @override
  String get privacyResponsibleTitle => '¿Quién es el responsable del tratamiento?';

  @override
  String get privacyDocumentTitle => 'Información de protección de datos sobre el tratamiento de datos personales en Espacio Ciudadano';

  @override
  String get privacyEmailCopied => 'No hay una aplicación de correo disponible. La dirección se ha copiado al portapapeles.';

  @override
  String get privacyResponsibleIntro => '1. La Agencia de Transformación Digital es responsable del tratamiento de datos de los servicios que se prestan directamente desde Espacio Ciudadano y que son los siguientes:';

  @override
  String get privacyResponsibleItemProfile => 'Visualización de las notificaciones y registro';

  @override
  String get privacyResponsibleItemVisualizations => 'Visualización de los datos seleccionados de la Administración regional y de la Administración General del Estado';

  @override
  String get privacyResponsibleItemRecommendations => 'Recomendaciones realizadas en base a los hechos vitales marcados.';

  @override
  String get privacyResponsibleItemDownloads => 'Descargas de los carnés seleccionados';

  @override
  String get privacyResponsibleItemAgenda => 'Visualización de la agenda';

  @override
  String get privacyResponsibleOrgParagraph => 'Una vez se seleccione cada una de las opciones proporcionadas por Espacio Ciudadano, el responsable del tratamiento será cada uno de los órganos y organismos competentes en ese procedimiento u hecho administrativo.';

  @override
  String get privacyResponsibleContactIntro => 'Los datos de contacto de este responsable son los siguientes:';

  @override
  String get privacyResponsibleContactAddressLabel => 'Dirección Postal:\n';

  @override
  String get privacyResponsibleContactAddressValue => 'Dirección Gerencia de la Agencia de Transformación Digital de Castilla-La Mancha\nEdificio CEMAR\nPlaza de Grecia, S/N\n45071 Toledo\n\nDirección de correo electrónico: direcciongerenciaatd@jccm.es';

  @override
  String get privacyPurposeTitle => '¿Cuál es la denominación y finalidad del tratamiento?';

  @override
  String get privacyPopulationControllerText => '2. La Oficina del Dato es responsable del tratamiento de datos del Registro de Población, a cuyos datos se puede acceder en el apartado “Datos de empadronamiento del Registro de Población” en la sección \"Mis datos de contacto\".\n\nLos datos de contacto de este responsable son los siguientes:\n\nDirección Postal:\nOficina del Dato de Castilla-La Mancha\nC/ Cabriel, 12 – Edificio CIE III\n45071-Toledo\n\nDirección de correo electrónico: oficinadeldato@jccm.es';

  @override
  String get privacyPurposeIntro => 'Las finalidades de los tratamientos de datos personales que se realizan directamente en Espacio Ciudadano son:';

  @override
  String get privacyPurposeItemIdentity => 'Gestionar los datos identificativos de la ciudadanía.';

  @override
  String get privacyPurposeItemVisualizations => 'Mostrar los datos seleccionados de la Administración regional y de otros temas de interés.';

  @override
  String get privacyLegalBasisTitle => '¿Cuál es la legitimación de este tratamiento?';

  @override
  String get privacyLegalBasisText =>
      'Las bases jurídicas que hacen lícito el tratamiento de Espacio Ciudadano son las siguientes:\n\n• Para el acceso a servicios como la consulta del estado de tramitación de un expediente, notificaciones, así como el resto de información administrativa en poder de esta Administración, las bases jurídicas son: 6.1.c) Obligación legal y la 6.1.e) Misión en interés público o ejercicio de poderes públicos.\nY su detalle, entre otras normas legales:\nArtículo 53 de la Ley 39/2015, de 1 de octubre, del Procedimiento Administrativo Común de las Administraciones Públicas.\nReal Decreto 203/2021, de 30 de marzo, por el que se aprueba el Reglamento de actuación y funcionamiento del sector público por medios electrónicos.\nLey 4/2025, de 11 de julio, de Simplificación, Agilización y Digitalización Administrativa.\n• En el caso de consulta de su información administrativa en poder de la Administración General del Estado, la base jurídica es el consentimiento que se recoge al marcar la opción seleccionada, que podrá retirar en cualquier momento retirando la autorización inicial en el apartado \"Perfil de usuario\", sin que ello le impida poder seguir disfrutando del resto de servicios.\n• La base jurídica para el tratamiento de las recomendaciones realizadas en base a los hechos vitales marcados es el consentimiento, que podrá retirar en cualquier momento retirando la autorización inicial de los hechos vitales anteriormente marcados en el apartado \"Perfil de usuario\", sin que ello le impida poder seguir disfrutando del resto de servicios.\n• La base jurídica para el tratamiento de los eventos es el consentimiento expreso, que podrá retirar en cualquier momento retirando la autorización inicial en el apartado \"Perfil de usuario\".\n• Asimismo, la base jurídica para la consulta y descarga de los carnets seleccionados es el consentimiento expreso, que podrá retirar en cualquier momento retirando la autorización inicial en el apartado \"Perfil de usuario\".\n\nLas bases jurídicas que hacen lícito el tratamiento del Registro de Población son las siguientes:\n\n• Para el teléfono y el correo electrónico: 6.1.a) Consentimiento del interesado/a que podrá retirar en cualquier momento.\n• Para el resto de los datos: 6.1.e) Misión en interés público o ejercicio de poderes públicos (Ley 10/2002, de Estadística de Castilla-La Mancha).';

  @override
  String get privacyTransfersTitle => '¿Existen cesiones de datos?';

  @override
  String get privacyTransfersText => 'No existen cesiones de datos personales en el tratamiento de Espacio Ciudadano.\n\nEn el caso del tratamiento del Registro de Población se podrán ceder datos a otros órganos de la Administración regional para la comunicación de estos con la ciudadanía, previa valoración de la compatibilidad de la finalidad del tratamiento, en aplicación del artículo 6.4 del Reglamento General de Protección de Datos.';

  @override
  String get privacyRetentionTitle => '¿Durante cuánto tiempo se conservarán los datos?';

  @override
  String get privacyRetentionText => 'El plazo de conservación de los datos será el necesario para cumplir con la finalidad para la que se recabaron y para determinar las posibles responsabilidades que se pudieran derivar de dicha finalidad y del tratamiento de los datos. Será de aplicación lo dispuesto en la normativa de archivos y documentación.';

  @override
  String get privacyRightsTitle => '¿Cómo se pueden ejercer los derechos previstos en la normativa de protección de datos?';

  @override
  String get privacyRightsText => 'Podrá ejercer de forma gratuita sus derechos de acceso, rectificación, supresión, limitación, oposición y a no ser objeto de decisiones automatizadas por los siguientes medios:\n\n• Mediante escrito presentado en las Oficinas de Registro y dirigido al responsable del tratamiento, la Agencia de Transformación Digital o la Oficina del Dato de Castilla-La Mancha\n• A través de la sede electrónica de esta administración, https://www.jccm.es/tramites/1001969.';

  @override
  String get privacyAepdTitle => '¿Puedo reclamar ante la Agencia Española de Protección de Datos?';

  @override
  String get privacyAepdTextBeforeLink => 'Si dispones de pruebas o indicios que acrediten la vulneración de tu derecho a la protección de datos en Espacio Ciudadano, puedes presentar una reclamación ante la ';

  @override
  String get privacyAepdLinkLabel => 'Agencia Española de Protección de Datos (AEPD)';

  @override
  String get privacyAepdTextAfterLink => '.\n\nTambién puedes reclamar ante la Delegada de Protección de Datos de la Administración de la Junta de Comunidades de Castilla-La Mancha (JCCM), cuya información de contacto está indicada más adelante.';

  @override
  String get privacySecurityTitle => '¿Qué medidas de seguridad están implantadas?';

  @override
  String get privacySecurityText => 'Las medidas implantadas para garantizar la seguridad de los datos de carácter personal se corresponden con las previstas en el Anexo II del Real Decreto 311/2022, de 3 de mayo, por el que se regula el Esquema Nacional de Seguridad.';

  @override
  String get privacyProfilingTitle => 'Decisiones automatizadas y elaboración de perfiles';

  @override
  String get privacyProfilingText => 'Las recomendaciones de trámites que se muestran en función de los hechos vitales indicados por la persona interesada implican la elaboración de perfiles.';

  @override
  String get privacyDpoTitle => 'Información de contacto de la Delegada de Protección de Datos';

  @override
  String get privacyDpoIntro => 'Para cualquier cuestión relacionada con la protección de datos puedes dirigirte a la Delegada de Protección de Datos de la Administración de la Junta de Comunidades de Castilla-La Mancha (JCCM).\n\nPuedes contactar mediante:';

  @override
  String get privacyDpoContactAddressLabel => 'Dirección postal\n';

  @override
  String get privacyDpoContactAddressValue => 'Delegada de Protección de Datos\nOficina del Dato\nVicepresidencia Primera\nC/ Río Cabriel, 12, edificio CIE III\n45071 Toledo\n\n';

  @override
  String get privacyDpoContactEmailLabel => 'Correo electrónico\n';

  @override
  String get accessibilityStatementHeading => 'Declaración de accesibilidad';

  @override
  String get accessibilityIntroCommitment => 'La Junta de Comunidades de Castilla-La Mancha se ha comprometido a hacer accesible su sitio web, de conformidad con el ';

  @override
  String get accessibilityIntroDecreeLink => 'Real Decreto 1112/2018, de 7 de septiembre';

  @override
  String get accessibilityIntroDecreeSuffix => ', sobre accesibilidad de los sitios web y aplicaciones para dispositivos móviles del sector público (en adelante, Real Decreto 1112/2018, de 7 de septiembre).\n\n';

  @override
  String get accessibilityDeclarationScope => 'La presente declaración de accesibilidad se aplica al sitio web ';

  @override
  String get accessibilityComplianceTitle => 'Situación de cumplimiento';

  @override
  String get accessibilityComplianceText => 'b) Este sitio web es parcialmente conforme con el RD 1112/2018, de 7 de septiembre, debido a la falta de conformidad de los aspectos que se indican a continuación.';

  @override
  String get accessibilityNonAccessibleTitle => 'Contenido no accesible';

  @override
  String get accessibilityNonAccessibleIntro => 'El contenido que se recoge a continuación no es accesible por los siguientes motivos:';

  @override
  String get accessibilityNonAccessibleItemNonConformity => 'falta de conformidad con el RD 1112/2018, de 7 de septiembre: Podrían existir fallos puntuales de edición en alguna página web, tanto en contenidos HTML como en documentos finales, publicados en fecha posterior al 20 de septiembre de 2018.';

  @override
  String get accessibilityNonAccessibleItemBurden => 'carga desproporcionada: No resulta aplicable.';

  @override
  String get accessibilityNonAccessibleItemOutOfScope => 'el contenido no entra dentro del ámbito de la legislación aplicable: Podrían existir archivos ofimáticos en PDF u otros formatos publicados antes del 20 de septiembre de 2018 que no cumplan en su totalidad todos los requisitos de accesibilidad.';

  @override
  String get accessibilityPreparationTitle => 'Preparación de la presente declaración de accesibilidad';

  @override
  String get accessibilityPreparationText => 'La presente declaración ha sido preparada el 8 de Octubre de 2025.\nEl método empleado para preparar la declaración ha sido una autoevaluación llevada a cabo por el propio organismo.';

  @override
  String get accessibilityContactTitle => 'Observaciones y datos de contacto';

  @override
  String get accessibilityContactIntro => 'Puede realizar comunicaciones sobre requisitos de accesibilidad (artículo 10.2.a) del Real Decreto 1112/2018, de 7 de septiembre como, por ejemplo:';

  @override
  String get accessibilityContactItemReport => 'informar sobre cualquier posible incumplimiento por parte de este sitio web,';

  @override
  String get accessibilityContactItemDifficulties => 'transmitir otras dificultades de acceso al contenido,';

  @override
  String get accessibilityContactItemSuggestions => 'formular cualquier otra consulta o sugerencia de mejora relativa a la accesibilidad del sitio web,';

  @override
  String get accessibilityContactChannelsIntro => 'a través de las siguientes vías:';

  @override
  String get accessibilityContactFormLink => 'formulario de contacto';

  @override
  String get accessibilityOfficesPrefix => 'de manera presencial en ';

  @override
  String get accessibilityOfficesLink => 'las oficinas del 012 y OIRES';

  @override
  String get accessibilityOfficesSuffix => ' oficinas de información y registro).';

  @override
  String get accessibilityContactProcessing => 'Las comunicaciones serán recibidas y tratadas por la Viceconsejería de Administración Local y Coordinación Administrativa.';

  @override
  String get accessibilityEnforcementTitle => 'Procedimiento de aplicación';

  @override
  String get accessibilityEnforcementText => 'El procedimiento de reclamación recogido en el artículo 13 del RD 1112/2018 entrará en vigor el 20 de septiembre de 2020.';

  @override
  String get accessibilityOptionalTitle => 'Contenido opcional';

  @override
  String get accessibilityOptionalText => 'Además de las ayudas de accesibilidad propias de los navegadores se incorporan una serie de atajos de teclado para facilitar la navegación a través del portal:\nUna clave de acceso o Accesskey permite al usuario saltar de inmediato a una parte específica de una página web a través del teclado.';

  @override
  String get accessibilityOptionalItemIncreaseText => 'Aumentar el Tamaño del Texto: CTRL +';

  @override
  String get accessibilityOptionalItemDecreaseText => 'Reducir el Tamaño del Texto: CTRL -';

  @override
  String get legalNoticeHeading => 'Aviso legal';

  @override
  String get legalNoticeOfficialDescription => 'Consulta el Aviso Legal completo y actualizado en el portal oficial de Espacio Ciudadano.';

  @override
  String get legalNoticeOfficialAction => 'Abrir Aviso Legal oficial';

  @override
  String get supportErrorSubmitUnauthorized => 'No tienes permisos para enviar el formulario de soporte.';

  @override
  String get supportErrorSubmitInvalidData => 'No hemos podido validar los datos introducidos.';

  @override
  String get supportErrorSubmitUnavailable => 'No hemos podido enviar tu solicitud. Inténtalo de nuevo más tarde.';

  @override
  String get notificationContactSaveUnauthorizedError => 'No tienes permisos para guardar estos datos de contacto.';

  @override
  String get notificationContactSaveInvalidDataError => 'No hemos podido validar los datos introducidos.';

  @override
  String get notificationContactSaveUnavailableError => 'No hemos podido guardar los datos de contacto. Inténtalo de nuevo más tarde.';

  @override
  String get gestionAportacionExpedienteNotFoundError => 'No hemos encontrado ningún expediente con esos datos. Revisa que sean correctos.';

  @override
  String get gestionAportacionExpedienteUnauthorizedError => 'No tienes permisos para consultar este expediente.';

  @override
  String get gestionAportacionExpedienteUnavailableError => 'No hemos podido localizar el expediente. Inténtalo de nuevo más tarde.';

  @override
  String get preferencesBiometricEnableFailed => 'No se ha podido activar el acceso rápido. Vuelve a identificarte con Cl@ve e inténtalo de nuevo.';

  @override
  String get preferencesBiometricDisabledNotice => 'Se ha desactivado el acceso rápido. Cuando termine esta sesión tendrás que identificarte de nuevo con Cl@ve.';

  @override
  String get sessionExpiredNotice => 'No ha sido posible renovar tu sesión. Vuelve a identificarte con Cl@ve para continuar.';

  @override
  String get sessionUnlockBiometricCancel => 'Cancelar';

  @override
  String get sessionUnlockBiometricTitle => 'Acceso a tu espacio';

  @override
  String get sessionUnlockBiometricReason => 'Confirma tu identidad para acceder a tu espacio';

  @override
  String get sessionContinueBiometricTitle => 'Continuar en tu espacio';

  @override
  String get sessionContinueBiometricReason => 'Tu sesión necesita renovarse. Confirma tu identidad para continuar.';

  @override
  String get biometricAccessDialogTitle => '¿Quieres activar el acceso rápido con huella dactilar o reconocimiento facial?';

  @override
  String get biometricAccessDialogDescription => 'Podrás acceder a la aplicación de forma más rápida sin tener que autentificarte cada vez. Para proteger tus datos te pediremos que vuelvas a autentificarte cada cierto tiempo.';

  @override
  String get biometricAccessDialogCancel => 'Completar más tarde';

  @override
  String get biometricAccessDialogConfirm => 'Activar';

  @override
  String get appUpdateRequiredTitle => 'Actualización necesaria';

  @override
  String appUpdateRequiredBody(String version) {
    return 'Para seguir usando la aplicación necesitas instalar la versión $version. Las versiones anteriores ya no reciben soporte.';
  }

  @override
  String get appUpdateRecommendedTitle => 'Hay una nueva versión disponible';

  @override
  String appUpdateRecommendedBody(String version) {
    return 'La versión $version incluye mejoras y correcciones. Puedes actualizar ahora o hacerlo más tarde.';
  }

  @override
  String get appUpdateAction => 'Actualizar';

  @override
  String get appUpdateLater => 'Ahora no';

  @override
  String get appUpdateStoreUnavailable => 'No se ha podido abrir la tienda de aplicaciones. Inténtalo de nuevo más tarde.';

  @override
  String get appUpdateA11yDialog => 'Aviso de actualización de la aplicación';
}
