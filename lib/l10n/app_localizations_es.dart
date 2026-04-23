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
  String get landingTagline => 'Tu información pública en un solo lugar';

  @override
  String get landingCtaButton => 'Acceder con Cl@ve';

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
  String get loginPageError => 'Error al iniciar sesión';

  @override
  String get loginRetryButton => 'Reintentar';

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
      'De conformidad con lo dispuesto en el Reglamento (UE) 2016/679 del Parlamento Europeo y del Consejo (RGPD) y la Ley Orgánica 3/2018 de Protección de Datos Personales y garantía de los derechos digitales (LOPDGDD), la Junta de Comunidades de Castilla-La Mancha le informa de que los datos personales recabados a través de esta aplicación serán tratados bajo la responsabilidad de la Junta de Comunidades de Castilla-La Mancha, con el fin de prestarle los servicios de administración electrónica incluidos en el Espacio Ciudadano.\n\nDe acuerdo con la Ley 3/2017 de la Junta de Comunidades de Castilla-La Mancha, tiene usted derecho a acceder, rectificar y suprimir sus datos, así como a ejercer los demás derechos reconocidos en la normativa aplicable, mediante escrito dirigido a la Secretaría General de la Junta de Comunidades de Castilla-La Mancha.\n\nPara continuar utilizando la aplicación debe aceptar las presentes condiciones de uso y protección de datos. Si no acepta, la aplicación se cerrará.';

  @override
  String get consentPagePrivacyLink => 'Ver política de privacidad completa';

  @override
  String get consentAcceptButton => 'Aceptar y continuar';

  @override
  String get consentRejectButton => 'Rechazar y salir';

  @override
  String get consentPageSemantics => 'Pantalla de aceptación de condiciones de uso';

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
  String get externalLinkOpenFailed => 'No se pudo abrir el enlace. Inténtalo de nuevo más tarde.';

  @override
  String get externalLinkEducamosClmLabel => 'Educamos CLM';

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
  String get externalLinkInfanciaFamiliasLabel => 'Infancia y familias';

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
  String get legalNoticeTitle => 'Aviso legal';

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
  String get agendaPageTitle => 'Agenda';

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
}
