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
  String get externalLinkBienestarSocialClmLabel => 'Bienestar Social CLM';

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
  String get socialWelfareFamilyTitle => 'Familia numerosa';

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
  String get socialWelfareTermalismoDescription => 'El programa de termalismo y balnearios de Castilla-La Mancha se gestiona a través del portal oficial de Bienestar Social.';

  @override
  String get socialWelfareParkingTitle => 'Tarjeta de estacionamiento';

  @override
  String get socialWelfareParkingDescription => 'La solicitud y gestión de la tarjeta de estacionamiento para personas con discapacidad se realiza en la sede electrónica correspondiente.';

  @override
  String get socialWelfareDependenciaTitle => 'Atención a la dependencia';

  @override
  String get socialWelfareDependenciaDescription => 'La información y los trámites de la Ley de Dependencia se gestionan en el portal oficial de Bienestar Social de Castilla-La Mancha.';

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
  String get supportCaptchaMockBadge => 'MOCK';

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
  String get caseworkItemDetailPlaceholderTitle => 'Detalle del expediente';

  @override
  String caseworkItemDetailPlaceholderBody(String id) {
    return 'Detalle del elemento $id';
  }

  @override
  String get caseworkItemDetailPlaceholderPending => 'El detalle real se habilita en STORY-35 / STORY-36.';

  @override
  String get digitalCardsPageTitle => 'Mis carnets digitales';

  @override
  String get digitalCardsTypeFamiliaNumerosa => 'Carnet de familia numerosa';

  @override
  String get digitalCardsTypeJoven => 'Carnet joven';

  @override
  String get digitalCardsTypeDiscapacidad => 'Carnet de discapacidad';

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
  String get lifeEventsSaveAction => 'Guardar';

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
  String get lifeEventsLoadError => 'No hemos podido cargar los hechos vitales.';

  @override
  String get lifeEventsEmpty => 'No hay hechos vitales disponibles en este momento.';

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
  String get notificationDetailPlaceholderTitle => 'Detalle de notificación';

  @override
  String notificationDetailPlaceholderBody(String id) {
    return 'Notificación $id';
  }

  @override
  String get notificationDetailPlaceholderPending => 'Detalle pendiente de habilitar en STORY-44.';

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
  String get signatureExternalLaunchPlaceholder => 'El salto a Afirma se habilitará en STORY-46.';

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
}
