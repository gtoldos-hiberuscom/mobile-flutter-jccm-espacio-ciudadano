import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en'), Locale('es')];

  /// El título de la aplicación que se muestra en el lanzador.
  ///
  /// In es, this message translates to:
  /// **'Espacio Ciudadano CLM'**
  String get appTitle;

  /// Título principal mostrado en la sección hero de la pantalla de inicio pública.
  ///
  /// In es, this message translates to:
  /// **'Espacio Ciudadano'**
  String get landingTitle;

  /// Subtítulo o eslogan mostrado debajo del título en la pantalla de inicio.
  ///
  /// In es, this message translates to:
  /// **'Tu información pública en un solo lugar'**
  String get landingTagline;

  /// Texto del botón principal de acción que inicia el flujo de autenticación con Cl@ve.
  ///
  /// In es, this message translates to:
  /// **'Acceder con Cl@ve'**
  String get landingCtaButton;

  /// Encabezado de la sección que muestra las categorías de servicios disponibles.
  ///
  /// In es, this message translates to:
  /// **'Qué encontrarás'**
  String get landingWhatYouFindTitle;

  /// Encabezado de la sección de pasos para autenticarse.
  ///
  /// In es, this message translates to:
  /// **'Cómo acceder'**
  String get landingHowToAccessTitle;

  /// Enlace de pie de página a la sección de ayuda.
  ///
  /// In es, this message translates to:
  /// **'Ayuda'**
  String get landingFooterHelp;

  /// Enlace de pie de página a la declaración de accesibilidad.
  ///
  /// In es, this message translates to:
  /// **'Accesibilidad'**
  String get landingFooterAccessibility;

  /// Enlace de pie de página al aviso legal.
  ///
  /// In es, this message translates to:
  /// **'Aviso legal'**
  String get landingFooterLegal;

  /// Enlace de pie de página a la política de protección de datos.
  ///
  /// In es, this message translates to:
  /// **'Protección de datos'**
  String get landingFooterPrivacy;

  /// Título de la pantalla de login que indica que se está accediendo con Cl@ve.
  ///
  /// In es, this message translates to:
  /// **'Accediendo con Cl@ve'**
  String get loginPageTitle;

  /// Mensaje de estado mientras se inicia la autenticación con Cl@ve.
  ///
  /// In es, this message translates to:
  /// **'Iniciando autenticación...'**
  String get loginPageLoading;

  /// Título del mensaje de error mostrado cuando falla la autenticación.
  ///
  /// In es, this message translates to:
  /// **'Error al iniciar sesión'**
  String get loginPageError;

  /// Texto del botón para reintentar el proceso de login.
  ///
  /// In es, this message translates to:
  /// **'Reintentar'**
  String get loginRetryButton;

  /// Texto de confirmación para cerrar la sesión del usuario.
  ///
  /// In es, this message translates to:
  /// **'¿Cerrar sesión?'**
  String get logoutConfirm;

  /// Mensaje mostrado cuando la sesión del usuario ha expirado.
  ///
  /// In es, this message translates to:
  /// **'Tu sesión ha caducado'**
  String get sessionExpired;

  /// Título principal de la pantalla de aceptación de condiciones de uso.
  ///
  /// In es, this message translates to:
  /// **'Condiciones de uso'**
  String get consentPageTitle;

  /// Subtítulo de la pantalla de consentimiento relativo a la protección de datos.
  ///
  /// In es, this message translates to:
  /// **'Protección de datos personales'**
  String get consentPageSubtitle;

  /// Texto del cuerpo de la pantalla de consentimiento.
  ///
  /// In es, this message translates to:
  /// **'De conformidad con lo dispuesto en el Reglamento (UE) 2016/679 del Parlamento Europeo y del Consejo (RGPD) y la Ley Orgánica 3/2018 de Protección de Datos Personales y garantía de los derechos digitales (LOPDGDD), la Junta de Comunidades de Castilla-La Mancha le informa de que los datos personales recabados a través de esta aplicación serán tratados bajo la responsabilidad de la Junta de Comunidades de Castilla-La Mancha, con el fin de prestarle los servicios de administración electrónica incluidos en el Espacio Ciudadano.\n\nDe acuerdo con la Ley 3/2017 de la Junta de Comunidades de Castilla-La Mancha, tiene usted derecho a acceder, rectificar y suprimir sus datos, así como a ejercer los demás derechos reconocidos en la normativa aplicable, mediante escrito dirigido a la Secretaría General de la Junta de Comunidades de Castilla-La Mancha.\n\nPara continuar utilizando la aplicación debe aceptar las presentes condiciones de uso y protección de datos. Si no acepta, la aplicación se cerrará.'**
  String get consentPageBody;

  /// Enlace para ver la política de privacidad completa en el navegador.
  ///
  /// In es, this message translates to:
  /// **'Ver política de privacidad completa'**
  String get consentPagePrivacyLink;

  /// Botón para aceptar las condiciones de uso y continuar a la pantalla principal.
  ///
  /// In es, this message translates to:
  /// **'Aceptar y continuar'**
  String get consentAcceptButton;

  /// Botón para rechazar las condiciones de uso y cerrar la aplicación.
  ///
  /// In es, this message translates to:
  /// **'Rechazar y salir'**
  String get consentRejectButton;

  /// Etiqueta de accesibilidad para la pantalla de consentimiento.
  ///
  /// In es, this message translates to:
  /// **'Pantalla de aceptación de condiciones de uso'**
  String get consentPageSemantics;

  /// Texto de accesibilidad predeterminado para los indicadores de carga.
  ///
  /// In es, this message translates to:
  /// **'Cargando…'**
  String get loadingStateDefault;

  /// Mensaje predeterminado para las pantallas de estado vacío.
  ///
  /// In es, this message translates to:
  /// **'No hay elementos'**
  String get emptyStateDefault;

  /// Mensaje predeterminado para las pantallas de estado de error.
  ///
  /// In es, this message translates to:
  /// **'Se ha producido un error'**
  String get errorStateDefault;

  /// Etiqueta del botón de reintento en el widget de estado de error.
  ///
  /// In es, this message translates to:
  /// **'Reintentar'**
  String get errorStateRetry;

  /// Mensaje predeterminado para las pantallas de acceso bloqueado o mantenimiento.
  ///
  /// In es, this message translates to:
  /// **'Acceso no disponible'**
  String get blockedStateDefault;

  /// Etiqueta de accesibilidad y tooltip para el botón de abrir documento.
  ///
  /// In es, this message translates to:
  /// **'Abrir documento'**
  String get documentOpen;

  /// Etiqueta de accesibilidad y tooltip para el botón de descarga de documento.
  ///
  /// In es, this message translates to:
  /// **'Descargar documento'**
  String get documentDownload;

  /// Etiqueta de accesibilidad y tooltip para el botón de compartir documento.
  ///
  /// In es, this message translates to:
  /// **'Compartir documento'**
  String get documentShare;

  /// Etiqueta de accesibilidad para el pie de página de carga adicional en listas paginadas.
  ///
  /// In es, this message translates to:
  /// **'Cargar más elementos'**
  String get loadMoreItems;

  /// Etiqueta de accesibilidad para el RefreshIndicator en listas paginadas.
  ///
  /// In es, this message translates to:
  /// **'Desliza para actualizar'**
  String get pullToRefresh;

  /// Saludo personalizado en la cabecera del usuario autenticado.
  ///
  /// In es, this message translates to:
  /// **'Hola, {name}'**
  String userGreeting(String name);

  /// Ítem de menú de navegación al perfil del usuario.
  ///
  /// In es, this message translates to:
  /// **'Mi perfil'**
  String get userMenuProfile;

  /// Ítem de menú de navegación a notificaciones.
  ///
  /// In es, this message translates to:
  /// **'Notificaciones'**
  String get userMenuNotifications;

  /// Ítem de menú de navegación a la configuración.
  ///
  /// In es, this message translates to:
  /// **'Configuración'**
  String get userMenuSettings;

  /// Ítem de menú para cerrar la sesión del usuario.
  ///
  /// In es, this message translates to:
  /// **'Cerrar sesión'**
  String get userMenuLogout;

  /// Título de la página de mantenimiento.
  ///
  /// In es, this message translates to:
  /// **'Servicio en mantenimiento'**
  String get maintenanceTitle;

  /// Subtítulo de la página de mantenimiento.
  ///
  /// In es, this message translates to:
  /// **'El servicio no está disponible temporalmente.'**
  String get maintenanceSubtitle;

  /// Botón para reintentar la carga después del mantenimiento.
  ///
  /// In es, this message translates to:
  /// **'Reintentar'**
  String get maintenanceRetry;

  /// Saludo mostrado en la home cuando todavía no se conoce el perfil del usuario.
  ///
  /// In es, this message translates to:
  /// **'Bienvenido al Espacio Ciudadano'**
  String get homeGreetingFallback;

  /// Etiqueta del identificador del ciudadano (idAgente) mostrada en la home autenticada.
  ///
  /// In es, this message translates to:
  /// **'Identificador: {id}'**
  String homeCitizenId(String id);

  /// Título del bloque temático de Educación en la home.
  ///
  /// In es, this message translates to:
  /// **'Educación'**
  String get homeBlockEducationTitle;

  /// Título del bloque temático de Empleo en la home.
  ///
  /// In es, this message translates to:
  /// **'Empleo'**
  String get homeBlockEmploymentTitle;

  /// Título del bloque temático de Bienestar Social en la home.
  ///
  /// In es, this message translates to:
  /// **'Bienestar Social'**
  String get homeBlockSocialWelfareTitle;

  /// Título del bloque temático de Estado y otros temas en la home.
  ///
  /// In es, this message translates to:
  /// **'Estado y otros'**
  String get homeBlockStateAffairsTitle;

  /// Título del bloque temático de Agenda en la home.
  ///
  /// In es, this message translates to:
  /// **'Agenda'**
  String get homeBlockAgendaTitle;

  /// Título del widget de próximos eventos en la home.
  ///
  /// In es, this message translates to:
  /// **'Próximos eventos'**
  String get homeBlockUpcomingEventsTitle;

  /// Título del widget de expedientes en la home.
  ///
  /// In es, this message translates to:
  /// **'Mis expedientes'**
  String get homeBlockCaseworkTitle;

  /// Título del widget de notificaciones en la home.
  ///
  /// In es, this message translates to:
  /// **'Mis notificaciones'**
  String get homeBlockNotificationsTitle;

  /// Título del widget de carnets digitales en la home.
  ///
  /// In es, this message translates to:
  /// **'Mis carnets digitales'**
  String get homeBlockDigitalCardsTitle;

  /// Título del widget de recomendaciones en la home.
  ///
  /// In es, this message translates to:
  /// **'Recomendaciones'**
  String get homeBlockRecommendationsTitle;

  /// Mensaje de estado vacío para una tarjeta de la home.
  ///
  /// In es, this message translates to:
  /// **'Sin novedades'**
  String get homeBlockEmpty;

  /// Mensaje de error parcial mostrado en una tarjeta de la home cuando su carga falla.
  ///
  /// In es, this message translates to:
  /// **'No se ha podido cargar este bloque'**
  String get homeBlockError;

  /// Resumen del número de elementos disponibles en una tarjeta de la home.
  ///
  /// In es, this message translates to:
  /// **'{count, plural, =0{Sin elementos} =1{1 elemento} other{{count} elementos}}'**
  String homeBlockCount(int count);

  /// Etiqueta del timestamp de última actualización de una tarjeta de la home.
  ///
  /// In es, this message translates to:
  /// **'Actualizado a las {time}'**
  String homeBlockLastUpdated(String time);

  /// Texto mostrado cuando no se conoce el timestamp de actualización de una tarjeta.
  ///
  /// In es, this message translates to:
  /// **'Sin datos de actualización'**
  String get homeBlockLastUpdatedUnknown;

  /// Pista de accesibilidad anunciada por lectores de pantalla en cualquier botón que abre un enlace externo.
  ///
  /// In es, this message translates to:
  /// **'Abre en navegador externo'**
  String get externalLinkA11yHint;

  /// Mensaje de SnackBar mostrado cuando un enlace externo no se puede abrir (validación o rechazo del sistema).
  ///
  /// In es, this message translates to:
  /// **'No se pudo abrir el enlace. Inténtalo de nuevo más tarde.'**
  String get externalLinkOpenFailed;

  /// Etiqueta del enlace externo al portal Educamos CLM.
  ///
  /// In es, this message translates to:
  /// **'Educamos CLM'**
  String get externalLinkEducamosClmLabel;

  /// Etiqueta del enlace externo al portal de Empleo de Castilla-La Mancha.
  ///
  /// In es, this message translates to:
  /// **'Empleo CLM'**
  String get externalLinkEmpleoClmLabel;

  /// Etiqueta del enlace externo al portal de Empleo Público de Castilla-La Mancha.
  ///
  /// In es, this message translates to:
  /// **'Empleo público CLM'**
  String get externalLinkEmpleoPublicoClmLabel;

  /// Etiqueta del enlace externo a la Sede Electrónica de la DGT.
  ///
  /// In es, this message translates to:
  /// **'Sede Electrónica DGT'**
  String get externalLinkSedeDgtLabel;

  /// Etiqueta del enlace externo a la Carpeta Ciudadana de la Administración General del Estado.
  ///
  /// In es, this message translates to:
  /// **'Carpeta Ciudadana AGE'**
  String get externalLinkCarpetaCiudadanaAgeLabel;

  /// Etiqueta del enlace externo al portal de Historia Social Única.
  ///
  /// In es, this message translates to:
  /// **'Historia social única'**
  String get externalLinkHistoriaSocialUnicaLabel;

  /// Etiqueta del enlace externo al portal de Bienestar Social de Castilla-La Mancha.
  ///
  /// In es, this message translates to:
  /// **'Bienestar Social CLM'**
  String get externalLinkBienestarSocialClmLabel;

  /// Etiqueta del enlace externo al portal de Infancia y Familias.
  ///
  /// In es, this message translates to:
  /// **'Infancia y familias'**
  String get externalLinkInfanciaFamiliasLabel;

  /// Título de la pantalla de ayuda.
  ///
  /// In es, this message translates to:
  /// **'Centro de ayuda'**
  String get helpPageTitle;

  /// Texto de ayuda del buscador local del centro de ayuda.
  ///
  /// In es, this message translates to:
  /// **'Buscar en preguntas frecuentes'**
  String get helpSearchHint;

  /// Encabezado de la sección FAQ.
  ///
  /// In es, this message translates to:
  /// **'Preguntas frecuentes'**
  String get helpFaqSectionTitle;

  /// Encabezado de la sección de guías.
  ///
  /// In es, this message translates to:
  /// **'Guías'**
  String get helpGuidesSectionTitle;

  /// Encabezado de la sección de contacto.
  ///
  /// In es, this message translates to:
  /// **'Contacto'**
  String get helpContactSectionTitle;

  /// Mensaje principal cuando la búsqueda local no encuentra resultados.
  ///
  /// In es, this message translates to:
  /// **'Sin resultados'**
  String get helpEmptySearchMessage;

  /// Subtítulo del estado vacío de búsqueda.
  ///
  /// In es, this message translates to:
  /// **'Prueba con otros términos.'**
  String get helpEmptySearchSubtitle;

  /// Categoría FAQ: acceso y autenticación.
  ///
  /// In es, this message translates to:
  /// **'Acceso y autenticación'**
  String get helpCategoryAccess;

  /// Categoría FAQ: privacidad y protección de datos.
  ///
  /// In es, this message translates to:
  /// **'Privacidad y datos'**
  String get helpCategoryPrivacy;

  /// Categoría FAQ: uso de los servicios.
  ///
  /// In es, this message translates to:
  /// **'Servicios y funcionalidades'**
  String get helpCategoryServices;

  /// FAQ — pregunta sobre acceso con Cl@ve.
  ///
  /// In es, this message translates to:
  /// **'¿Cómo accedo con Cl@ve?'**
  String get helpFaqLoginClaveQ;

  /// FAQ — respuesta sobre acceso con Cl@ve.
  ///
  /// In es, this message translates to:
  /// **'Pulsa \"Acceder con Cl@ve\" en la pantalla de inicio. Se abrirá el sistema oficial de identificación. Tras la autenticación volverás a la aplicación.'**
  String get helpFaqLoginClaveA;

  /// FAQ — pregunta sobre problemas de acceso.
  ///
  /// In es, this message translates to:
  /// **'No puedo iniciar sesión, ¿qué hago?'**
  String get helpFaqLoginProblemsQ;

  /// FAQ — respuesta sobre problemas de acceso.
  ///
  /// In es, this message translates to:
  /// **'Verifica tu conexión y que tu certificado o credencial Cl@ve siga vigente. Si el problema persiste, contacta con el 012.'**
  String get helpFaqLoginProblemsA;

  /// FAQ — pregunta sobre protección de datos.
  ///
  /// In es, this message translates to:
  /// **'¿Qué se hace con mis datos personales?'**
  String get helpFaqDataProtectionQ;

  /// FAQ — respuesta sobre protección de datos.
  ///
  /// In es, this message translates to:
  /// **'Tus datos se tratan conforme al RGPD y la LOPDGDD. Consulta la política de privacidad para conocer las finalidades, plazos y derechos.'**
  String get helpFaqDataProtectionA;

  /// FAQ — pregunta sobre notificaciones.
  ///
  /// In es, this message translates to:
  /// **'¿Cómo recibo notificaciones?'**
  String get helpFaqNotificationsQ;

  /// FAQ — respuesta sobre notificaciones.
  ///
  /// In es, this message translates to:
  /// **'Activa los avisos en tu perfil y permite las notificaciones del sistema. Recibirás aviso cuando haya novedades en tus expedientes.'**
  String get helpFaqNotificationsA;

  /// FAQ — pregunta sobre descarga de documentos.
  ///
  /// In es, this message translates to:
  /// **'¿Puedo descargar documentos oficiales?'**
  String get helpFaqDocumentsQ;

  /// FAQ — respuesta sobre descarga de documentos.
  ///
  /// In es, this message translates to:
  /// **'Sí. Desde el detalle de cada expediente puedes descargar o compartir los documentos disponibles.'**
  String get helpFaqDocumentsA;

  /// FAQ — pregunta sobre uso sin conexión.
  ///
  /// In es, this message translates to:
  /// **'¿La aplicación funciona sin conexión?'**
  String get helpFaqOfflineQ;

  /// FAQ — respuesta sobre uso sin conexión.
  ///
  /// In es, this message translates to:
  /// **'Algunas funciones (consulta de tarjetas y contenidos legales) se mantienen sin conexión. Las que requieren datos actualizados necesitan conectividad.'**
  String get helpFaqOfflineA;

  /// Guía — primeros pasos: título.
  ///
  /// In es, this message translates to:
  /// **'Primeros pasos'**
  String get helpGuideFirstStepsTitle;

  /// Guía — primeros pasos: cuerpo.
  ///
  /// In es, this message translates to:
  /// **'Aprende a navegar entre Inicio, Expedientes, Notificaciones y Tarjetas. Personaliza tu perfil para una experiencia adaptada.'**
  String get helpGuideFirstStepsBody;

  /// Guía sobre la Carpeta Ciudadana AGE.
  ///
  /// In es, this message translates to:
  /// **'Carpeta Ciudadana del Estado'**
  String get helpGuideCarpetaAgeTitle;

  /// Guía AGE — cuerpo.
  ///
  /// In es, this message translates to:
  /// **'Si tu trámite depende de la Administración General del Estado, accede directamente a la Carpeta Ciudadana AGE.'**
  String get helpGuideCarpetaAgeBody;

  /// Contacto — etiqueta para el teléfono 012.
  ///
  /// In es, this message translates to:
  /// **'Atención telefónica 012'**
  String get helpContact012PhoneLabel;

  /// Contacto — etiqueta para el correo de soporte.
  ///
  /// In es, this message translates to:
  /// **'Correo de soporte'**
  String get helpContactEmailSupportLabel;

  /// Contacto — etiqueta del recurso web de oficinas de información.
  ///
  /// In es, this message translates to:
  /// **'Oficinas de información y registro'**
  String get helpContactOfficesUrlLabel;

  /// Título de la pantalla de condiciones de uso.
  ///
  /// In es, this message translates to:
  /// **'Condiciones de uso'**
  String get legalTermsTitle;

  /// Título de la pantalla de protección de datos.
  ///
  /// In es, this message translates to:
  /// **'Protección de datos'**
  String get legalPrivacyTitle;

  /// Título de la pantalla de accesibilidad.
  ///
  /// In es, this message translates to:
  /// **'Accesibilidad'**
  String get legalAccessibilityTitle;

  /// Título de la pantalla de aviso legal.
  ///
  /// In es, this message translates to:
  /// **'Aviso legal'**
  String get legalNoticeTitle;

  /// Título cuando el documento legal solicitado no existe.
  ///
  /// In es, this message translates to:
  /// **'Documento no encontrado'**
  String get legalNotFoundTitle;

  /// Mensaje cuando un documento legal no existe.
  ///
  /// In es, this message translates to:
  /// **'No se ha podido cargar el documento solicitado.'**
  String get legalNotFoundMessage;

  /// Título de la pantalla de mapa del sitio.
  ///
  /// In es, this message translates to:
  /// **'Mapa del sitio'**
  String get sitemapPageTitle;

  /// Sitemap — agrupación de áreas autenticadas.
  ///
  /// In es, this message translates to:
  /// **'Mi espacio'**
  String get sitemapGroupAuthenticated;

  /// Sitemap — agrupación de landings temáticas.
  ///
  /// In es, this message translates to:
  /// **'Áreas temáticas'**
  String get sitemapGroupThematic;

  /// Sitemap — agrupación de ayuda y páginas legales.
  ///
  /// In es, this message translates to:
  /// **'Ayuda y legales'**
  String get sitemapGroupHelpLegal;

  /// Sitemap — agrupación de enlaces externos.
  ///
  /// In es, this message translates to:
  /// **'Recursos externos'**
  String get sitemapGroupExternal;

  /// Sitemap — Inicio.
  ///
  /// In es, this message translates to:
  /// **'Inicio'**
  String get sitemapHome;

  /// Sitemap — Agenda.
  ///
  /// In es, this message translates to:
  /// **'Agenda'**
  String get sitemapAgenda;

  /// Sitemap — Expedientes.
  ///
  /// In es, this message translates to:
  /// **'Expedientes'**
  String get sitemapCasework;

  /// Sitemap — Notificaciones.
  ///
  /// In es, this message translates to:
  /// **'Notificaciones'**
  String get sitemapNotifications;

  /// Sitemap — Tarjetas.
  ///
  /// In es, this message translates to:
  /// **'Tarjetas'**
  String get sitemapCards;

  /// Sitemap — Recomendaciones.
  ///
  /// In es, this message translates to:
  /// **'Recomendaciones'**
  String get sitemapRecommendations;

  /// Sitemap — Soporte.
  ///
  /// In es, this message translates to:
  /// **'Soporte'**
  String get sitemapSupport;

  /// Sitemap — Perfil.
  ///
  /// In es, this message translates to:
  /// **'Perfil'**
  String get sitemapProfile;

  /// Sitemap — Educación.
  ///
  /// In es, this message translates to:
  /// **'Educación'**
  String get sitemapEducation;

  /// Sitemap — Empleo.
  ///
  /// In es, this message translates to:
  /// **'Empleo'**
  String get sitemapEmployment;

  /// Sitemap — Bienestar Social.
  ///
  /// In es, this message translates to:
  /// **'Bienestar Social'**
  String get sitemapSocialWelfare;

  /// Sitemap — Estado y otros.
  ///
  /// In es, this message translates to:
  /// **'Estado y otros'**
  String get sitemapStateAffairs;

  /// Sitemap — Centro de ayuda.
  ///
  /// In es, this message translates to:
  /// **'Centro de ayuda'**
  String get sitemapHelp;

  /// Footer — Ayuda.
  ///
  /// In es, this message translates to:
  /// **'Ayuda'**
  String get footerHelp;

  /// Footer — Mapa del sitio.
  ///
  /// In es, this message translates to:
  /// **'Mapa del sitio'**
  String get footerSitemap;

  /// Footer — Condiciones.
  ///
  /// In es, this message translates to:
  /// **'Condiciones'**
  String get footerTerms;

  /// Footer — Privacidad.
  ///
  /// In es, this message translates to:
  /// **'Privacidad'**
  String get footerPrivacy;

  /// Footer — Accesibilidad.
  ///
  /// In es, this message translates to:
  /// **'Accesibilidad'**
  String get footerAccessibility;

  /// Footer — Aviso legal.
  ///
  /// In es, this message translates to:
  /// **'Aviso legal'**
  String get footerLegalNotice;

  /// Agenda — título de la pantalla.
  ///
  /// In es, this message translates to:
  /// **'Agenda'**
  String get agendaPageTitle;

  /// Agenda — filtro temporal: todos los eventos.
  ///
  /// In es, this message translates to:
  /// **'Todos'**
  String get agendaFilterAll;

  /// Agenda — filtro temporal: próximos 7 días.
  ///
  /// In es, this message translates to:
  /// **'Próximos 7 días'**
  String get agendaFilterNext7Days;

  /// Agenda — filtro temporal: próximos 30 días.
  ///
  /// In es, this message translates to:
  /// **'Próximos 30 días'**
  String get agendaFilterNext30Days;

  /// Agenda — filtro temporal: próximos 365 días.
  ///
  /// In es, this message translates to:
  /// **'Próximos 365 días'**
  String get agendaFilterNext365Days;

  /// Agenda — filtro temporal: eventos pasados.
  ///
  /// In es, this message translates to:
  /// **'Pasados'**
  String get agendaFilterPast;

  /// Agenda — pestaña de vista lista.
  ///
  /// In es, this message translates to:
  /// **'Lista'**
  String get agendaViewList;

  /// Agenda — pestaña de vista calendario.
  ///
  /// In es, this message translates to:
  /// **'Calendario'**
  String get agendaViewCalendar;

  /// Agenda — mensaje cuando no hay eventos visibles.
  ///
  /// In es, this message translates to:
  /// **'No hay eventos para el periodo seleccionado.'**
  String get agendaEmpty;

  /// Agenda — mensaje de error al cargar.
  ///
  /// In es, this message translates to:
  /// **'No hemos podido cargar tu agenda.'**
  String get agendaError;

  /// Agenda — etiqueta del timestamp de última actualización.
  ///
  /// In es, this message translates to:
  /// **'Última actualización: {timestamp}'**
  String agendaLastUpdated(String timestamp);

  /// Agenda — etiqueta de la categoría salud.
  ///
  /// In es, this message translates to:
  /// **'Salud'**
  String get agendaCategorySalud;

  /// Agenda — etiqueta de la categoría administrativo.
  ///
  /// In es, this message translates to:
  /// **'Administrativo'**
  String get agendaCategoryAdministrativo;

  /// Agenda — etiqueta de la categoría educación.
  ///
  /// In es, this message translates to:
  /// **'Educación'**
  String get agendaCategoryEducacion;

  /// Agenda — etiqueta de la categoría otros.
  ///
  /// In es, this message translates to:
  /// **'Otros'**
  String get agendaCategoryOtros;

  /// Agenda — botón para ir al mes anterior en el calendario.
  ///
  /// In es, this message translates to:
  /// **'Mes anterior'**
  String get agendaPreviousMonth;

  /// Agenda — botón para ir al mes siguiente en el calendario.
  ///
  /// In es, this message translates to:
  /// **'Mes siguiente'**
  String get agendaNextMonth;

  /// Agenda — botón para limpiar la selección de día del calendario.
  ///
  /// In es, this message translates to:
  /// **'Quitar filtro de día'**
  String get agendaClearDay;

  /// Agenda — botón para volver desde el detalle del evento.
  ///
  /// In es, this message translates to:
  /// **'Volver'**
  String get agendaDetailBack;

  /// Agenda — mensaje cuando el evento del detalle no existe.
  ///
  /// In es, this message translates to:
  /// **'El evento solicitado ya no está disponible.'**
  String get agendaDetailNotFound;

  /// Agenda — etiqueta del campo ubicación en el detalle.
  ///
  /// In es, this message translates to:
  /// **'Ubicación'**
  String get agendaDetailLocation;

  /// Agenda — etiqueta del campo fecha en el detalle.
  ///
  /// In es, this message translates to:
  /// **'Fecha'**
  String get agendaDetailWhen;

  /// Agenda — etiqueta del campo centro en el detalle.
  ///
  /// In es, this message translates to:
  /// **'Centro'**
  String get agendaDetailCentro;

  /// Agenda — etiqueta del campo profesional en el detalle.
  ///
  /// In es, this message translates to:
  /// **'Profesional'**
  String get agendaDetailProfesional;

  /// Agenda — etiqueta del campo tipo en el detalle.
  ///
  /// In es, this message translates to:
  /// **'Tipo'**
  String get agendaDetailTipo;

  /// Agenda — etiqueta de la descripción larga en el detalle.
  ///
  /// In es, this message translates to:
  /// **'Descripción'**
  String get agendaDetailDescription;

  /// Agenda — CTA para abrir el justificante de asistencia.
  ///
  /// In es, this message translates to:
  /// **'Ver justificante de asistencia'**
  String get agendaDetailJustificante;

  /// Agenda — aviso al pulsar el justificante mientras el enlace externo no está habilitado.
  ///
  /// In es, this message translates to:
  /// **'El justificante se podrá abrir cuando se habilite el enlace externo.'**
  String get agendaJustificanteUnavailable;

  /// Agenda — affordance para expandir el detalle inline en la lista.
  ///
  /// In es, this message translates to:
  /// **'Ver más detalles'**
  String get agendaTileExpand;

  /// Agenda — affordance para colapsar el detalle inline en la lista.
  ///
  /// In es, this message translates to:
  /// **'Ocultar detalles'**
  String get agendaTileCollapse;

  /// Agenda — CTA para navegar al detalle completo del evento.
  ///
  /// In es, this message translates to:
  /// **'Abrir detalle completo'**
  String get agendaTileOpenDetail;

  /// Agenda — título del estado de error de parseo.
  ///
  /// In es, this message translates to:
  /// **'No hemos podido leer tu agenda'**
  String get agendaParseErrorTitle;

  /// Agenda — detalle del estado de error de parseo.
  ///
  /// In es, this message translates to:
  /// **'Hubo un problema al interpretar la respuesta del servicio. Vuelve a intentarlo en unos minutos.'**
  String get agendaParseErrorDetail;

  /// Agenda — CTA de reintento del estado de error de parseo.
  ///
  /// In es, this message translates to:
  /// **'Intentar de nuevo'**
  String get agendaParseErrorRetry;

  /// Agenda — aviso de datos parciales sobre la lista.
  ///
  /// In es, this message translates to:
  /// **'Algunos eventos no se han podido cargar. Mostramos los disponibles.'**
  String get agendaPartialBanner;

  /// Estado — título de la landing.
  ///
  /// In es, this message translates to:
  /// **'Estado y otros temas de interés'**
  String get stateAffairsTitle;

  /// Estado — descripción de cabecera.
  ///
  /// In es, this message translates to:
  /// **'Información procedente de registros estatales (INE/Padrón, Catastro, DGT). Los datos pueden no estar actualizados en tiempo real.'**
  String get stateAffairsHeaderDescription;

  /// Estado — título sección domicilio (INE).
  ///
  /// In es, this message translates to:
  /// **'Domicilio'**
  String get stateAffairsResidenceTitle;

  /// Estado — atribución de fuente para domicilio.
  ///
  /// In es, this message translates to:
  /// **'Fuente: INE / Padrón municipal'**
  String get stateAffairsResidenceSource;

  /// Estado — etiqueta municipio.
  ///
  /// In es, this message translates to:
  /// **'Municipio'**
  String get stateAffairsResidenceMunicipio;

  /// Estado — etiqueta provincia.
  ///
  /// In es, this message translates to:
  /// **'Provincia'**
  String get stateAffairsResidenceProvincia;

  /// Estado — etiqueta comunidad autónoma.
  ///
  /// In es, this message translates to:
  /// **'Comunidad autónoma'**
  String get stateAffairsResidenceComunidad;

  /// Estado — etiqueta dirección.
  ///
  /// In es, this message translates to:
  /// **'Dirección'**
  String get stateAffairsResidenceDireccion;

  /// Estado — etiqueta código postal.
  ///
  /// In es, this message translates to:
  /// **'Código postal'**
  String get stateAffairsResidenceCp;

  /// Estado — texto de última actualización del padrón.
  ///
  /// In es, this message translates to:
  /// **'Actualizado: {timestamp}'**
  String stateAffairsResidenceLastUpdated(String timestamp);

  /// Estado — título sección Catastro.
  ///
  /// In es, this message translates to:
  /// **'Bienes inmuebles'**
  String get stateAffairsPropertiesTitle;

  /// Estado — atribución de fuente para Catastro.
  ///
  /// In es, this message translates to:
  /// **'Fuente: Catastro'**
  String get stateAffairsPropertiesSource;

  /// Estado — vacío Catastro.
  ///
  /// In es, this message translates to:
  /// **'No constan bienes inmuebles a tu nombre.'**
  String get stateAffairsPropertiesEmpty;

  /// Estado — error Catastro.
  ///
  /// In es, this message translates to:
  /// **'No hemos podido cargar los datos de Catastro.'**
  String get stateAffairsPropertiesError;

  /// Estado — etiqueta titularidad de un inmueble.
  ///
  /// In es, this message translates to:
  /// **'Titularidad: {value}'**
  String stateAffairsPropertiesTitularidad(String value);

  /// Estado — etiqueta superficie en m².
  ///
  /// In es, this message translates to:
  /// **'Superficie: {m2} m²'**
  String stateAffairsPropertiesSurface(String m2);

  /// Estado — etiqueta referencia catastral.
  ///
  /// In es, this message translates to:
  /// **'Referencia catastral: {value}'**
  String stateAffairsPropertiesReference(String value);

  /// Estado — título sección DGT.
  ///
  /// In es, this message translates to:
  /// **'Vehículos'**
  String get stateAffairsVehiclesTitle;

  /// Estado — atribución de fuente para DGT.
  ///
  /// In es, this message translates to:
  /// **'Fuente: DGT'**
  String get stateAffairsVehiclesSource;

  /// Estado — vacío DGT.
  ///
  /// In es, this message translates to:
  /// **'No constan vehículos a tu nombre.'**
  String get stateAffairsVehiclesEmpty;

  /// Estado — error DGT.
  ///
  /// In es, this message translates to:
  /// **'No hemos podido cargar los datos de la DGT.'**
  String get stateAffairsVehiclesError;

  /// Estado — etiqueta matrícula vehículo.
  ///
  /// In es, this message translates to:
  /// **'Matrícula: {value}'**
  String stateAffairsVehiclesPlate(String value);

  /// Estado — etiqueta combustible vehículo.
  ///
  /// In es, this message translates to:
  /// **'Combustible: {value}'**
  String stateAffairsVehiclesFuel(String value);

  /// Estado — aclaración de procedencia de los datos.
  ///
  /// In es, this message translates to:
  /// **'Los datos proceden de la DGT, INE y Catastro y pueden no estar actualizados en tiempo real.'**
  String get stateAffairsDataDisclaimer;

  /// Domains — título de la sección de enlaces externos.
  ///
  /// In es, this message translates to:
  /// **'Enlaces externos'**
  String get domainExternalLinksTitle;

  /// Domains — error genérico de carga.
  ///
  /// In es, this message translates to:
  /// **'No hemos podido cargar la información solicitada.'**
  String get domainGenericLoadError;

  /// Domains — etiqueta para placeholder controlado.
  ///
  /// In es, this message translates to:
  /// **'Próximamente'**
  String get domainComingSoonBadge;

  /// Educación — título de la landing.
  ///
  /// In es, this message translates to:
  /// **'Educación'**
  String get educationTitle;

  /// Educación — descripción de cabecera.
  ///
  /// In es, this message translates to:
  /// **'Consulta tus títulos académicos y accede a los servicios oficiales de educación de Castilla-La Mancha.'**
  String get educationHeaderDescription;

  /// Educación — sección títulos universitarios.
  ///
  /// In es, this message translates to:
  /// **'Títulos universitarios'**
  String get educationUniversityTitlesTitle;

  /// Educación — vacío títulos universitarios.
  ///
  /// In es, this message translates to:
  /// **'No constan títulos universitarios a tu nombre.'**
  String get educationUniversityTitlesEmpty;

  /// Educación — error títulos universitarios.
  ///
  /// In es, this message translates to:
  /// **'No hemos podido cargar tus títulos universitarios.'**
  String get educationUniversityTitlesError;

  /// Educación — sección títulos no universitarios.
  ///
  /// In es, this message translates to:
  /// **'Títulos no universitarios'**
  String get educationNonUniversityTitlesTitle;

  /// Educación — vacío títulos no universitarios.
  ///
  /// In es, this message translates to:
  /// **'No constan títulos no universitarios a tu nombre.'**
  String get educationNonUniversityTitlesEmpty;

  /// Educación — error títulos no universitarios.
  ///
  /// In es, this message translates to:
  /// **'No hemos podido cargar tus títulos no universitarios.'**
  String get educationNonUniversityTitlesError;

  /// Educación — etiqueta año del título.
  ///
  /// In es, this message translates to:
  /// **'Año: {year}'**
  String educationTitleYear(String year);

  /// Educación — sección condición de becado (placeholder).
  ///
  /// In es, this message translates to:
  /// **'Condición de becado'**
  String get educationScholarshipTitle;

  /// Educación — descripción placeholder condición de becado.
  ///
  /// In es, this message translates to:
  /// **'Esta información estará disponible próximamente. Necesita un servicio adicional que aún no está integrado.'**
  String get educationScholarshipDescription;

  /// Educación — tooltip explicativo placeholder condición de becado.
  ///
  /// In es, this message translates to:
  /// **'Capacidad pendiente de un endpoint específico de becas. Pendiente de validación de contrato (TASK-27).'**
  String get educationScholarshipTooltip;

  /// Empleo — título de la landing.
  ///
  /// In es, this message translates to:
  /// **'Empleo'**
  String get employmentTitle;

  /// Empleo — descripción de cabecera.
  ///
  /// In es, this message translates to:
  /// **'Consulta tu situación como demandante de empleo y accede a los portales oficiales de Empleo CLM.'**
  String get employmentHeaderDescription;

  /// Empleo — sección demandante (SEPE).
  ///
  /// In es, this message translates to:
  /// **'Estado de demandante de empleo'**
  String get employmentSeekerTitle;

  /// Empleo — atribución de fuente SEPE.
  ///
  /// In es, this message translates to:
  /// **'Fuente: SEPE'**
  String get employmentSeekerSource;

  /// Empleo — vacío demandante.
  ///
  /// In es, this message translates to:
  /// **'No constan datos de demanda de empleo a tu nombre.'**
  String get employmentSeekerEmpty;

  /// Empleo — error demandante.
  ///
  /// In es, this message translates to:
  /// **'No hemos podido cargar tu estado de demandante de empleo.'**
  String get employmentSeekerError;

  /// Empleo — etiqueta estado actual.
  ///
  /// In es, this message translates to:
  /// **'Estado actual'**
  String get employmentSeekerEstadoLabel;

  /// Empleo — etiqueta fecha inscripción.
  ///
  /// In es, this message translates to:
  /// **'Fecha de inscripción'**
  String get employmentSeekerInscripcionLabel;

  /// Empleo — etiqueta fecha continuidad.
  ///
  /// In es, this message translates to:
  /// **'Fecha de continuidad'**
  String get employmentSeekerContinuidadLabel;

  /// Empleo — estado inscrito.
  ///
  /// In es, this message translates to:
  /// **'Inscrito'**
  String get employmentSeekerEstadoInscrito;

  /// Empleo — estado no inscrito.
  ///
  /// In es, this message translates to:
  /// **'No inscrito'**
  String get employmentSeekerEstadoNoInscrito;

  /// Empleo — estado baja temporal.
  ///
  /// In es, this message translates to:
  /// **'Baja temporal'**
  String get employmentSeekerEstadoBajaTemporal;

  /// Empleo — sección inscripciones en ofertas (external link).
  ///
  /// In es, this message translates to:
  /// **'Inscripciones en ofertas'**
  String get employmentOffersTitle;

  /// Empleo — copy explicativo inscripciones en ofertas.
  ///
  /// In es, this message translates to:
  /// **'La consulta y gestión de tus inscripciones en ofertas se realiza directamente en el portal de Empleo CLM.'**
  String get employmentOffersDescription;

  /// Bienestar — título de la landing.
  ///
  /// In es, this message translates to:
  /// **'Bienestar Social'**
  String get socialWelfareTitle;

  /// Bienestar — descripción de cabecera.
  ///
  /// In es, this message translates to:
  /// **'Consulta tu título de familia numerosa y accede a los servicios de bienestar social de Castilla-La Mancha.'**
  String get socialWelfareHeaderDescription;

  /// Bienestar — sección familia numerosa.
  ///
  /// In es, this message translates to:
  /// **'Familia numerosa'**
  String get socialWelfareFamilyTitle;

  /// Bienestar — atribución CCAA.
  ///
  /// In es, this message translates to:
  /// **'Fuente: Junta de Comunidades de Castilla-La Mancha'**
  String get socialWelfareFamilySource;

  /// Bienestar — vacío familia numerosa.
  ///
  /// In es, this message translates to:
  /// **'No consta título de familia numerosa a tu nombre.'**
  String get socialWelfareFamilyEmpty;

  /// Bienestar — error familia numerosa.
  ///
  /// In es, this message translates to:
  /// **'No hemos podido cargar tu título de familia numerosa.'**
  String get socialWelfareFamilyError;

  /// Bienestar — etiqueta número de título.
  ///
  /// In es, this message translates to:
  /// **'Número de título'**
  String get socialWelfareFamilyNumberLabel;

  /// Bienestar — etiqueta categoría.
  ///
  /// In es, this message translates to:
  /// **'Categoría'**
  String get socialWelfareFamilyCategoriaLabel;

  /// Bienestar — etiqueta caducidad.
  ///
  /// In es, this message translates to:
  /// **'Fecha de caducidad'**
  String get socialWelfareFamilyCaducidadLabel;

  /// Bienestar — categoría general.
  ///
  /// In es, this message translates to:
  /// **'General'**
  String get socialWelfareFamilyCategoriaGeneral;

  /// Bienestar — categoría especial.
  ///
  /// In es, this message translates to:
  /// **'Especial'**
  String get socialWelfareFamilyCategoriaEspecial;

  /// Bienestar — sub-título beneficiarios.
  ///
  /// In es, this message translates to:
  /// **'Beneficiarios'**
  String get socialWelfareFamilyBeneficiariosTitle;

  /// Bienestar — relación titular.
  ///
  /// In es, this message translates to:
  /// **'Titular'**
  String get socialWelfareFamilyRelacionTitular;

  /// Bienestar — relación cónyuge.
  ///
  /// In es, this message translates to:
  /// **'Cónyuge'**
  String get socialWelfareFamilyRelacionConyuge;

  /// Bienestar — relación hijo/a.
  ///
  /// In es, this message translates to:
  /// **'Hijo/a'**
  String get socialWelfareFamilyRelacionHijo;

  /// Bienestar — línea descriptiva de un beneficiario.
  ///
  /// In es, this message translates to:
  /// **'{relacion} — nacido el {fecha}'**
  String socialWelfareFamilyBeneficiarioLine(String relacion, String fecha);

  /// Bienestar — sección termalismo (external link).
  ///
  /// In es, this message translates to:
  /// **'Termalismo / Balnearios'**
  String get socialWelfareTermalismoTitle;

  /// Bienestar — copy termalismo.
  ///
  /// In es, this message translates to:
  /// **'El programa de termalismo y balnearios de Castilla-La Mancha se gestiona a través del portal oficial de Bienestar Social.'**
  String get socialWelfareTermalismoDescription;

  /// Bienestar — sección tarjeta de estacionamiento (external link).
  ///
  /// In es, this message translates to:
  /// **'Tarjeta de estacionamiento'**
  String get socialWelfareParkingTitle;

  /// Bienestar — copy tarjeta estacionamiento.
  ///
  /// In es, this message translates to:
  /// **'La solicitud y gestión de la tarjeta de estacionamiento para personas con discapacidad se realiza en la sede electrónica correspondiente.'**
  String get socialWelfareParkingDescription;

  /// Bienestar — sección atención a la dependencia (external link).
  ///
  /// In es, this message translates to:
  /// **'Atención a la dependencia'**
  String get socialWelfareDependenciaTitle;

  /// Bienestar — copy dependencia.
  ///
  /// In es, this message translates to:
  /// **'La información y los trámites de la Ley de Dependencia se gestionan en el portal oficial de Bienestar Social de Castilla-La Mancha.'**
  String get socialWelfareDependenciaDescription;

  /// Título de la pantalla de formulario de soporte.
  ///
  /// In es, this message translates to:
  /// **'Soporte técnico'**
  String get supportFormTitle;

  /// Texto introductorio del formulario de soporte.
  ///
  /// In es, this message translates to:
  /// **'Cuéntanos qué ha pasado. Nuestro equipo te responderá por correo electrónico.'**
  String get supportFormIntro;

  /// CTA en el centro de ayuda para abrir el formulario de soporte.
  ///
  /// In es, this message translates to:
  /// **'Contactar con soporte'**
  String get supportCtaFromHelp;

  /// Etiqueta del campo Nombre.
  ///
  /// In es, this message translates to:
  /// **'Nombre'**
  String get supportFieldName;

  /// Etiqueta del campo Email.
  ///
  /// In es, this message translates to:
  /// **'Correo electrónico'**
  String get supportFieldEmail;

  /// Etiqueta del campo Confirmar email.
  ///
  /// In es, this message translates to:
  /// **'Confirmación del correo electrónico'**
  String get supportFieldEmailConfirm;

  /// Etiqueta del campo Asunto.
  ///
  /// In es, this message translates to:
  /// **'Asunto'**
  String get supportFieldSubject;

  /// Etiqueta del campo Descripción.
  ///
  /// In es, this message translates to:
  /// **'Descripción'**
  String get supportFieldDescription;

  /// Etiqueta de la sección de adjuntos.
  ///
  /// In es, this message translates to:
  /// **'Adjunto (opcional)'**
  String get supportAttachmentLabel;

  /// Texto de ayuda del adjunto.
  ///
  /// In es, this message translates to:
  /// **'Puedes adjuntar un único archivo (capturas, documentos).'**
  String get supportAttachmentHint;

  /// Botón para seleccionar adjunto.
  ///
  /// In es, this message translates to:
  /// **'Seleccionar archivo'**
  String get supportAttachmentPick;

  /// Botón para cambiar el adjunto seleccionado.
  ///
  /// In es, this message translates to:
  /// **'Cambiar archivo'**
  String get supportAttachmentChange;

  /// Acción para quitar el adjunto.
  ///
  /// In es, this message translates to:
  /// **'Quitar adjunto'**
  String get supportAttachmentRemove;

  /// Texto del checkbox de consentimiento.
  ///
  /// In es, this message translates to:
  /// **'Autorizo el tratamiento de mis datos para gestionar mi solicitud.'**
  String get supportConsentLabel;

  /// Etiqueta del checkbox antibot.
  ///
  /// In es, this message translates to:
  /// **'No soy un robot'**
  String get supportCaptchaLabel;

  /// Insignia que indica que el captcha es un mock.
  ///
  /// In es, this message translates to:
  /// **'MOCK'**
  String get supportCaptchaMockBadge;

  /// Botón de envío del formulario.
  ///
  /// In es, this message translates to:
  /// **'Enviar solicitud'**
  String get supportSubmitButton;

  /// Título de la pantalla de confirmación.
  ///
  /// In es, this message translates to:
  /// **'Solicitud enviada'**
  String get supportConfirmationTitle;

  /// Mensaje de confirmación tras el envío.
  ///
  /// In es, this message translates to:
  /// **'Hemos recibido tu solicitud. Te confirmaremos por correo electrónico.'**
  String get supportConfirmationMessage;

  /// Botón para enviar otra solicitud.
  ///
  /// In es, this message translates to:
  /// **'Enviar otra solicitud'**
  String get supportConfirmationNewRequest;

  /// Mensaje genérico de error de envío.
  ///
  /// In es, this message translates to:
  /// **'No hemos podido enviar tu solicitud. Inténtalo de nuevo.'**
  String get supportSubmissionError;

  /// Error: nombre requerido.
  ///
  /// In es, this message translates to:
  /// **'Indica tu nombre.'**
  String get supportErrorNameRequired;

  /// Error: email requerido.
  ///
  /// In es, this message translates to:
  /// **'Indica tu correo electrónico.'**
  String get supportErrorEmailRequired;

  /// Error: email no válido.
  ///
  /// In es, this message translates to:
  /// **'Introduce un correo electrónico válido.'**
  String get supportErrorEmailInvalid;

  /// Error: confirmación de email requerida.
  ///
  /// In es, this message translates to:
  /// **'Confirma tu correo electrónico.'**
  String get supportErrorEmailConfirmRequired;

  /// Error: emails no coinciden.
  ///
  /// In es, this message translates to:
  /// **'Los correos no coinciden.'**
  String get supportErrorEmailMismatch;

  /// Error: asunto requerido.
  ///
  /// In es, this message translates to:
  /// **'Indica un asunto.'**
  String get supportErrorSubjectRequired;

  /// Error: asunto demasiado largo.
  ///
  /// In es, this message translates to:
  /// **'El asunto no puede superar los 100 caracteres.'**
  String get supportErrorSubjectTooLong;

  /// Error: descripción requerida.
  ///
  /// In es, this message translates to:
  /// **'Describe tu solicitud.'**
  String get supportErrorDescriptionRequired;

  /// Error: descripción demasiado larga.
  ///
  /// In es, this message translates to:
  /// **'La descripción supera el límite permitido.'**
  String get supportErrorDescriptionTooLong;

  /// Error: consentimiento requerido.
  ///
  /// In es, this message translates to:
  /// **'Debes autorizar el tratamiento de tus datos.'**
  String get supportErrorConsentRequired;

  /// Error: captcha requerido.
  ///
  /// In es, this message translates to:
  /// **'Confirma que no eres un robot.'**
  String get supportErrorCaptchaRequired;

  /// CIP — título del bloque destacado de salud.
  ///
  /// In es, this message translates to:
  /// **'Tarjeta sanitaria (CIP)'**
  String get cipCardTitle;

  /// CIP — tooltip del botón copiar al portapapeles.
  ///
  /// In es, this message translates to:
  /// **'Copiar CIP'**
  String get cipCardCopyTooltip;

  /// CIP — confirmación tras copiar el código.
  ///
  /// In es, this message translates to:
  /// **'CIP copiado al portapapeles'**
  String get cipCardCopied;

  /// CIP — leyenda obligatoria de sólo lectura (TASK-71).
  ///
  /// In es, this message translates to:
  /// **'Sólo lectura — la tarjeta sanitaria no es descargable desde la app.'**
  String get cipCardReadOnlySubtitle;

  /// CIP — gap de contrato visible en diseño (TASK-27 / TASK-32).
  ///
  /// In es, this message translates to:
  /// **'Otras capacidades de salud (consultas, recetas) están sujetas a confirmación de contrato.'**
  String get cipCardContractGap;

  /// CIP — mensaje cuando no hay CIP disponible.
  ///
  /// In es, this message translates to:
  /// **'Aún no hay tarjeta sanitaria asociada a tu perfil.'**
  String get cipCardEmpty;

  /// CIP — mensaje de error genérico.
  ///
  /// In es, this message translates to:
  /// **'No hemos podido cargar tu tarjeta sanitaria.'**
  String get cipCardError;

  /// CIP — mensaje de error de parseo (TASK-32).
  ///
  /// In es, this message translates to:
  /// **'No hemos podido leer la respuesta de la tarjeta sanitaria.'**
  String get cipCardParseError;

  /// Home — título de la superficie destacada de salud.
  ///
  /// In es, this message translates to:
  /// **'Salud'**
  String get saludSurfaceTitle;

  /// Home — CTA de la superficie de salud que lleva a la agenda.
  ///
  /// In es, this message translates to:
  /// **'Ver agenda'**
  String get saludSurfaceCta;

  /// Resumen de próximos eventos — título compartido entre home y agenda.
  ///
  /// In es, this message translates to:
  /// **'Próximos eventos'**
  String get homeUpcomingEventsTitle;

  /// Resumen de próximos eventos — mensaje cuando no hay eventos.
  ///
  /// In es, this message translates to:
  /// **'No tienes eventos próximos.'**
  String get homeUpcomingEventsEmpty;

  /// Casework — título del workspace.
  ///
  /// In es, this message translates to:
  /// **'Mis gestiones'**
  String get caseworkWorkspaceTitle;

  /// Casework — error global de carga.
  ///
  /// In es, this message translates to:
  /// **'No hemos podido cargar tus gestiones.'**
  String get caseworkWorkspaceLoadError;

  /// Casework — breadcrumb raíz.
  ///
  /// In es, this message translates to:
  /// **'Inicio'**
  String get caseworkBreadcrumbHome;

  /// Casework — etiqueta tab expedientes.
  ///
  /// In es, this message translates to:
  /// **'Mis expedientes'**
  String get caseworkTabExpedientes;

  /// Casework — etiqueta tab entradas.
  ///
  /// In es, this message translates to:
  /// **'Mis entradas de registro'**
  String get caseworkTabEntradasRegistro;

  /// Casework — etiqueta tab salidas.
  ///
  /// In es, this message translates to:
  /// **'Mis salidas de registro'**
  String get caseworkTabSalidasRegistro;

  /// Casework — vacío expedientes.
  ///
  /// In es, this message translates to:
  /// **'No constan expedientes a tu nombre.'**
  String get caseworkExpedientesEmpty;

  /// Casework — vacío entradas.
  ///
  /// In es, this message translates to:
  /// **'No constan entradas de registro a tu nombre.'**
  String get caseworkEntradasRegistroEmpty;

  /// Casework — vacío salidas.
  ///
  /// In es, this message translates to:
  /// **'No constan salidas de registro a tu nombre.'**
  String get caseworkSalidasRegistroEmpty;

  /// Casework — error expedientes.
  ///
  /// In es, this message translates to:
  /// **'No hemos podido cargar tus expedientes.'**
  String get caseworkExpedientesError;

  /// Casework — error entradas.
  ///
  /// In es, this message translates to:
  /// **'No hemos podido cargar tus entradas de registro.'**
  String get caseworkEntradasRegistroError;

  /// Casework — error salidas.
  ///
  /// In es, this message translates to:
  /// **'No hemos podido cargar tus salidas de registro.'**
  String get caseworkSalidasRegistroError;

  /// Casework — estado en trámite.
  ///
  /// In es, this message translates to:
  /// **'En trámite'**
  String get caseworkStatusEnTramite;

  /// Casework — estado finalizado.
  ///
  /// In es, this message translates to:
  /// **'Finalizado'**
  String get caseworkStatusFinalizado;

  /// Casework — estado pendiente.
  ///
  /// In es, this message translates to:
  /// **'Pendiente'**
  String get caseworkStatusPendiente;

  /// Casework — estado rechazado.
  ///
  /// In es, this message translates to:
  /// **'Rechazado'**
  String get caseworkStatusRechazado;

  /// Casework — etiqueta de fecha del item.
  ///
  /// In es, this message translates to:
  /// **'Fecha: {date}'**
  String caseworkItemDateLabel(String date);

  /// Casework search — título de la pantalla.
  ///
  /// In es, this message translates to:
  /// **'Buscar expedientes y registros'**
  String get caseworkSearchTitle;

  /// Casework search — CTA en el workspace para abrir la búsqueda.
  ///
  /// In es, this message translates to:
  /// **'Buscar expedientes y registros'**
  String get caseworkSearchOpenCta;

  /// Casework search — texto introductorio del formulario.
  ///
  /// In es, this message translates to:
  /// **'Rellena al menos uno de los campos para localizar tu expediente o registro.'**
  String get caseworkSearchIntro;

  /// Casework search — etiqueta del campo identificación.
  ///
  /// In es, this message translates to:
  /// **'NIF / NIE / Pasaporte'**
  String get caseworkSearchFieldIdentificationLabel;

  /// Casework search — helper del campo identificación.
  ///
  /// In es, this message translates to:
  /// **'Ej.: 12345678Z, X1234567A o pasaporte alfanumérico.'**
  String get caseworkSearchFieldIdentificationHelper;

  /// Casework search — etiqueta del campo expediente.
  ///
  /// In es, this message translates to:
  /// **'Número de expediente'**
  String get caseworkSearchFieldExpedienteLabel;

  /// Casework search — helper del campo expediente.
  ///
  /// In es, this message translates to:
  /// **'Ej.: EXP/2025/00123'**
  String get caseworkSearchFieldExpedienteHelper;

  /// Casework search — etiqueta del campo registro.
  ///
  /// In es, this message translates to:
  /// **'Número de registro'**
  String get caseworkSearchFieldRegistroLabel;

  /// Casework search — helper del campo registro.
  ///
  /// In es, this message translates to:
  /// **'Ej.: REG/E/45612'**
  String get caseworkSearchFieldRegistroHelper;

  /// Casework search — etiqueta del botón de búsqueda.
  ///
  /// In es, this message translates to:
  /// **'Buscar'**
  String get caseworkSearchSubmit;

  /// Casework search — CTA para reiniciar la búsqueda.
  ///
  /// In es, this message translates to:
  /// **'Buscar otra cosa'**
  String get caseworkSearchAnother;

  /// Casework search — CTA placeholder para aportación documental.
  ///
  /// In es, this message translates to:
  /// **'Aportar documentación al resultado'**
  String get caseworkSearchAportar;

  /// Casework search — mensaje provisional de aportación pendiente.
  ///
  /// In es, this message translates to:
  /// **'La aportación documental se habilita en STORY-37 / STORY-38.'**
  String get caseworkSearchAportarPending;

  /// Casework search — error: ningún campo informado.
  ///
  /// In es, this message translates to:
  /// **'Introduce al menos uno de los tres campos para buscar.'**
  String get caseworkSearchErrorAtLeastOne;

  /// Casework search — error de identificación inválida.
  ///
  /// In es, this message translates to:
  /// **'Formato no válido. Usa NIF (8 dígitos + letra), NIE (X/Y/Z + 7 dígitos + letra) o pasaporte alfanumérico de 6 a 9 caracteres.'**
  String get caseworkSearchErrorInvalidIdentification;

  /// Casework search — error de número inválido.
  ///
  /// In es, this message translates to:
  /// **'Formato no válido. Solo letras, números, guiones y barras.'**
  String get caseworkSearchErrorInvalidNumber;

  /// Casework search — estado sin resultados.
  ///
  /// In es, this message translates to:
  /// **'Sin coincidencias'**
  String get caseworkSearchNoResults;

  /// Casework search — pista cuando no hay resultados.
  ///
  /// In es, this message translates to:
  /// **'Revisa los datos introducidos y vuelve a intentarlo.'**
  String get caseworkSearchNoResultsHint;

  /// Casework search — error al ejecutar la búsqueda.
  ///
  /// In es, this message translates to:
  /// **'No hemos podido completar la búsqueda. Inténtalo de nuevo.'**
  String get caseworkSearchError;

  /// Casework search — recuento de resultados.
  ///
  /// In es, this message translates to:
  /// **'{count, plural, one{1 resultado} other{{count} resultados}}'**
  String caseworkSearchResultsCount(int count);

  /// Casework — título del detalle (placeholder).
  ///
  /// In es, this message translates to:
  /// **'Detalle del expediente'**
  String get caseworkItemDetailPlaceholderTitle;

  /// Casework — cuerpo del detalle (placeholder).
  ///
  /// In es, this message translates to:
  /// **'Detalle del elemento {id}'**
  String caseworkItemDetailPlaceholderBody(String id);

  /// Casework — mensaje provisional del detalle.
  ///
  /// In es, this message translates to:
  /// **'El detalle real se habilita en STORY-35 / STORY-36.'**
  String get caseworkItemDetailPlaceholderPending;

  /// Título de la pantalla de catálogo de carnets digitales (STORY-48).
  ///
  /// In es, this message translates to:
  /// **'Mis carnets digitales'**
  String get digitalCardsPageTitle;

  /// Carnets — etiqueta del tipo familia numerosa.
  ///
  /// In es, this message translates to:
  /// **'Carnet de familia numerosa'**
  String get digitalCardsTypeFamiliaNumerosa;

  /// Carnets — etiqueta del tipo carnet joven.
  ///
  /// In es, this message translates to:
  /// **'Carnet joven'**
  String get digitalCardsTypeJoven;

  /// Carnets — etiqueta del tipo discapacidad.
  ///
  /// In es, this message translates to:
  /// **'Carnet de discapacidad'**
  String get digitalCardsTypeDiscapacidad;

  /// Carnets — badge para estado disponible.
  ///
  /// In es, this message translates to:
  /// **'Disponible'**
  String get digitalCardsStatusAvailable;

  /// Carnets — badge para estado no vigente.
  ///
  /// In es, this message translates to:
  /// **'No vigente'**
  String get digitalCardsStatusNotValid;

  /// Carnets — badge para estado no descargable.
  ///
  /// In es, this message translates to:
  /// **'No descargable'**
  String get digitalCardsStatusNotDownloadable;

  /// Carnets — badge para estado no disponible / sin datos.
  ///
  /// In es, this message translates to:
  /// **'No disponible'**
  String get digitalCardsStatusNotAvailable;

  /// Carnets — mensaje explícito para el estado no vigente.
  ///
  /// In es, this message translates to:
  /// **'Este carnet no está vigente. No es posible obtener QR, PKPASS ni PDF.'**
  String get digitalCardsMessageNotValid;

  /// Carnets — mensaje explícito para el estado no descargable.
  ///
  /// In es, this message translates to:
  /// **'Este carnet no es descargable en este momento.'**
  String get digitalCardsMessageNotDownloadable;

  /// Carnets — mensaje explícito para el estado no disponible.
  ///
  /// In es, this message translates to:
  /// **'No tienes este carnet disponible.'**
  String get digitalCardsMessageNotAvailable;

  /// Carnets — acción para mostrar el código QR.
  ///
  /// In es, this message translates to:
  /// **'Ver QR'**
  String get digitalCardsActionQr;

  /// Carnets — acción para añadir el carnet a la cartera (PKPASS).
  ///
  /// In es, this message translates to:
  /// **'Añadir a Wallet'**
  String get digitalCardsActionPkpass;

  /// Carnets — acción para descargar el PDF.
  ///
  /// In es, this message translates to:
  /// **'Descargar PDF'**
  String get digitalCardsActionPdf;

  /// Carnets — mensaje stub mientras TASK-53 cablea las descargas reales.
  ///
  /// In es, this message translates to:
  /// **'Disponible próximamente.'**
  String get digitalCardsActionComingSoon;

  /// Carnets — estado vacío del catálogo.
  ///
  /// In es, this message translates to:
  /// **'Aún no tienes carnets digitales asociados.'**
  String get digitalCardsEmptyMessage;

  /// Carnets — estado de error del catálogo.
  ///
  /// In es, this message translates to:
  /// **'No hemos podido cargar tus carnets digitales.'**
  String get digitalCardsErrorMessage;

  /// Carnets — título del mini-card CIP de sólo lectura (TASK-71).
  ///
  /// In es, this message translates to:
  /// **'Tarjeta sanitaria (CIP)'**
  String get digitalCardsCipMiniTitle;

  /// Carnets — subtítulo que indica que la tarjeta sanitaria es de sólo lectura.
  ///
  /// In es, this message translates to:
  /// **'Sólo lectura'**
  String get digitalCardsCipMiniReadOnly;

  /// Carnets — CTA para abrir la tarjeta sanitaria en la pantalla de salud (STORY-31).
  ///
  /// In es, this message translates to:
  /// **'Ver tarjeta sanitaria'**
  String get digitalCardsCipMiniOpenAction;

  /// Personalization — title of the hechos vitales selection screen.
  ///
  /// In es, this message translates to:
  /// **'Mis hechos vitales'**
  String get lifeEventsTitle;

  /// Personalization — descriptive header on the hechos vitales screen.
  ///
  /// In es, this message translates to:
  /// **'Selecciona los hechos vitales que mejor describen tu situación para recibir recomendaciones personalizadas.'**
  String get lifeEventsHeaderDescription;

  /// Personalization — explicit save button label.
  ///
  /// In es, this message translates to:
  /// **'Guardar'**
  String get lifeEventsSaveAction;

  /// Personalization — reset preferences button label.
  ///
  /// In es, this message translates to:
  /// **'Borrar preferencias'**
  String get lifeEventsResetAction;

  /// Personalization — confirmation dialog title for reset.
  ///
  /// In es, this message translates to:
  /// **'Borrar tus preferencias'**
  String get lifeEventsResetConfirmTitle;

  /// Personalization — confirmation dialog body for reset.
  ///
  /// In es, this message translates to:
  /// **'Se eliminarán todos los hechos vitales seleccionados. Esta acción no se puede deshacer.'**
  String get lifeEventsResetConfirmBody;

  /// Personalization — confirm reset button label.
  ///
  /// In es, this message translates to:
  /// **'Borrar'**
  String get lifeEventsResetConfirm;

  /// Personalization — cancel reset button label.
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get lifeEventsResetCancel;

  /// Personalization — snackbar after a successful save.
  ///
  /// In es, this message translates to:
  /// **'Tus preferencias se han guardado correctamente.'**
  String get lifeEventsSavedFeedback;

  /// Personalization — snackbar after a save / reset failure.
  ///
  /// In es, this message translates to:
  /// **'No hemos podido guardar tus preferencias. Inténtalo de nuevo.'**
  String get lifeEventsErrorFeedback;

  /// Personalization — error state when the catalog fails to load.
  ///
  /// In es, this message translates to:
  /// **'No hemos podido cargar los hechos vitales.'**
  String get lifeEventsLoadError;

  /// Personalization — empty state for the catalog.
  ///
  /// In es, this message translates to:
  /// **'No hay hechos vitales disponibles en este momento.'**
  String get lifeEventsEmpty;

  /// Personalization — familia category header.
  ///
  /// In es, this message translates to:
  /// **'Familia'**
  String get lifeEventsCategoryFamilia;

  /// Personalization — salud category header.
  ///
  /// In es, this message translates to:
  /// **'Salud'**
  String get lifeEventsCategorySalud;

  /// Personalization — empleo category header.
  ///
  /// In es, this message translates to:
  /// **'Empleo'**
  String get lifeEventsCategoryEmpleo;

  /// Personalization — vivienda category header.
  ///
  /// In es, this message translates to:
  /// **'Vivienda'**
  String get lifeEventsCategoryVivienda;

  /// Personalization — educación category header.
  ///
  /// In es, this message translates to:
  /// **'Educación'**
  String get lifeEventsCategoryEducacion;

  /// Data consent — title of the citizen authorizations screen (STORY-55).
  ///
  /// In es, this message translates to:
  /// **'Mis autorizaciones'**
  String get dataConsentTitle;

  /// Data consent — descriptive header on the authorizations screen.
  ///
  /// In es, this message translates to:
  /// **'Gestiona qué datos pueden utilizarse para ofrecerte servicios y recomendaciones personalizadas. Puedes cambiar tu decisión en cualquier momento.'**
  String get dataConsentHeaderDescription;

  /// Data consent — explicit save button label.
  ///
  /// In es, this message translates to:
  /// **'Guardar'**
  String get dataConsentSaveAction;

  /// Data consent — revoke-all button label.
  ///
  /// In es, this message translates to:
  /// **'Revocar todas las autorizaciones'**
  String get dataConsentRevokeAction;

  /// Data consent — confirmation dialog title for revoke-all.
  ///
  /// In es, this message translates to:
  /// **'Revocar tus autorizaciones'**
  String get dataConsentRevokeConfirmTitle;

  /// Data consent — confirmation dialog body for revoke-all.
  ///
  /// In es, this message translates to:
  /// **'Se eliminarán todas tus autorizaciones y dejaremos de personalizar contenidos hasta que vuelvas a aceptarlas.'**
  String get dataConsentRevokeConfirmBody;

  /// Data consent — confirm revoke button label.
  ///
  /// In es, this message translates to:
  /// **'Revocar'**
  String get dataConsentRevokeConfirm;

  /// Data consent — cancel revoke button label.
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get dataConsentRevokeCancel;

  /// Data consent — snackbar after a successful save / revoke.
  ///
  /// In es, this message translates to:
  /// **'Tus autorizaciones se han actualizado correctamente.'**
  String get dataConsentSavedFeedback;

  /// Data consent — snackbar after a save / revoke failure.
  ///
  /// In es, this message translates to:
  /// **'No hemos podido actualizar tus autorizaciones. Inténtalo de nuevo.'**
  String get dataConsentErrorFeedback;

  /// Data consent — error state when the catalog fails to load.
  ///
  /// In es, this message translates to:
  /// **'No hemos podido cargar tus autorizaciones.'**
  String get dataConsentLoadError;

  /// Data consent — empty state for the catalog.
  ///
  /// In es, this message translates to:
  /// **'No hay autorizaciones disponibles en este momento.'**
  String get dataConsentEmpty;

  /// Data consent — JCCM authorization title.
  ///
  /// In es, this message translates to:
  /// **'Datos de la Junta de Comunidades de Castilla-La Mancha'**
  String get dataConsentTypeJccmTitle;

  /// Data consent — JCCM authorization description.
  ///
  /// In es, this message translates to:
  /// **'Permite que la JCCM utilice tus datos administrativos para ofrecerte trámites y servicios personalizados.'**
  String get dataConsentTypeJccmSubtitle;

  /// Data consent — interoperability authorization title.
  ///
  /// In es, this message translates to:
  /// **'Datos de otras administraciones'**
  String get dataConsentTypeOtrasAdminTitle;

  /// Data consent — interoperability authorization description.
  ///
  /// In es, this message translates to:
  /// **'Permite consultar datos de otras administraciones públicas para evitar que tengas que aportarlos manualmente.'**
  String get dataConsentTypeOtrasAdminSubtitle;

  /// Data consent — profiling authorization title.
  ///
  /// In es, this message translates to:
  /// **'Perfilado para recomendaciones'**
  String get dataConsentTypePerfiladoTitle;

  /// Data consent — profiling authorization description.
  ///
  /// In es, this message translates to:
  /// **'Permite analizar tu actividad para recomendarte trámites, ayudas y contenidos relevantes.'**
  String get dataConsentTypePerfiladoSubtitle;

  /// Data consent — privacy reference section title.
  ///
  /// In es, this message translates to:
  /// **'Información de protección de datos'**
  String get dataConsentPrivacyReferenceTitle;

  /// Data consent — privacy reference body.
  ///
  /// In es, this message translates to:
  /// **'Estas autorizaciones se basan en la información de protección de datos aceptada al iniciar sesión.'**
  String get dataConsentPrivacyReferenceBody;

  /// Data consent — link CTA pointing to the onboarding consent screen.
  ///
  /// In es, this message translates to:
  /// **'Ver información de protección de datos'**
  String get dataConsentPrivacyReferenceCta;

  /// Data consent — CTA label that takes the citizen from life-events to the consent screen.
  ///
  /// In es, this message translates to:
  /// **'Mis autorizaciones'**
  String get dataConsentNavCta;

  /// Notifications — título del centro de notificaciones (STORY-41).
  ///
  /// In es, this message translates to:
  /// **'Mis notificaciones'**
  String get notificationsCenterTitle;

  /// Notifications — mensaje del estado de carga del listado.
  ///
  /// In es, this message translates to:
  /// **'Cargando notificaciones…'**
  String get notificationsLoading;

  /// Notifications — mensaje del estado de error global.
  ///
  /// In es, this message translates to:
  /// **'No hemos podido cargar tus notificaciones.'**
  String get notificationsErrorMessage;

  /// Notifications — aviso bajo el listado cuando falla la carga incremental.
  ///
  /// In es, this message translates to:
  /// **'No hemos podido cargar más notificaciones. Inténtalo de nuevo.'**
  String get notificationsLoadMoreError;

  /// Notifications — título del estado vacío del listado.
  ///
  /// In es, this message translates to:
  /// **'No hay notificaciones'**
  String get notificationsEmptyTitle;

  /// Notifications — subtítulo del estado vacío del listado.
  ///
  /// In es, this message translates to:
  /// **'No hemos encontrado notificaciones para los filtros aplicados.'**
  String get notificationsEmptySubtitle;

  /// Notifications — etiqueta del filtro que muestra todos los estados.
  ///
  /// In es, this message translates to:
  /// **'Todas'**
  String get notificationsFilterAll;

  /// Notifications — indicador de que la notificación tiene documentos.
  ///
  /// In es, this message translates to:
  /// **'Documentos asociados'**
  String get notificationsItemHasDocuments;

  /// Notifications — pie del listado con el progreso de la paginación.
  ///
  /// In es, this message translates to:
  /// **'Mostrando {loaded} de {total}'**
  String notificationsPaginationFooter(int loaded, int total);

  /// Notifications — etiqueta del estado pendiente.
  ///
  /// In es, this message translates to:
  /// **'Pendiente'**
  String get notificationStatusPendiente;

  /// Notifications — etiqueta del estado aceptada.
  ///
  /// In es, this message translates to:
  /// **'Aceptada'**
  String get notificationStatusAceptada;

  /// Notifications — etiqueta del estado rechazada.
  ///
  /// In es, this message translates to:
  /// **'Rechazada'**
  String get notificationStatusRechazada;

  /// Notifications — etiqueta del estado caducada.
  ///
  /// In es, this message translates to:
  /// **'Caducada'**
  String get notificationStatusCaducada;

  /// Notifications — etiqueta del estado desconocido (parser tolerante).
  ///
  /// In es, this message translates to:
  /// **'Sin clasificar'**
  String get notificationStatusUnknown;

  /// Notifications — título de la pantalla provisional de detalle.
  ///
  /// In es, this message translates to:
  /// **'Detalle de notificación'**
  String get notificationDetailPlaceholderTitle;

  /// Notifications — cuerpo provisional con el identificador de la notificación.
  ///
  /// In es, this message translates to:
  /// **'Notificación {id}'**
  String notificationDetailPlaceholderBody(String id);

  /// Notifications — mensaje provisional para el detalle real.
  ///
  /// In es, this message translates to:
  /// **'Detalle pendiente de habilitar en STORY-44.'**
  String get notificationDetailPlaceholderPending;

  /// Notifications contact — título de la pantalla de alta de contacto (STORY-42).
  ///
  /// In es, this message translates to:
  /// **'Datos de contacto'**
  String get notificationContactPageTitle;

  /// Notifications contact — copy explicativo sobre el uso futuro del contacto.
  ///
  /// In es, this message translates to:
  /// **'Necesitamos un teléfono móvil o un correo electrónico para avisarte de las notificaciones electrónicas que recibas. Solo usaremos estos datos para enviarte avisos relacionados con tus notificaciones.'**
  String get notificationContactExplanation;

  /// Notifications contact — etiqueta del campo teléfono móvil.
  ///
  /// In es, this message translates to:
  /// **'Teléfono móvil'**
  String get notificationContactPhoneLabel;

  /// Notifications contact — placeholder del campo teléfono móvil.
  ///
  /// In es, this message translates to:
  /// **'600 123 456'**
  String get notificationContactPhoneHint;

  /// Notifications contact — texto auxiliar del campo teléfono móvil.
  ///
  /// In es, this message translates to:
  /// **'Indica un número con prefijo internacional si no es de España.'**
  String get notificationContactPhoneHelper;

  /// Notifications contact — etiqueta del campo correo electrónico.
  ///
  /// In es, this message translates to:
  /// **'Correo electrónico'**
  String get notificationContactEmailLabel;

  /// Notifications contact — placeholder del campo correo electrónico.
  ///
  /// In es, this message translates to:
  /// **'ejemplo@correo.com'**
  String get notificationContactEmailHint;

  /// Notifications contact — texto auxiliar del campo correo electrónico.
  ///
  /// In es, this message translates to:
  /// **'Usaremos este correo solo para avisos de notificaciones.'**
  String get notificationContactEmailHelper;

  /// Notifications contact — botón principal del formulario.
  ///
  /// In es, this message translates to:
  /// **'Registrar'**
  String get notificationContactSubmitCta;

  /// Notifications contact — mensaje del estado de carga.
  ///
  /// In es, this message translates to:
  /// **'Cargando datos de contacto…'**
  String get notificationContactLoading;

  /// Notifications contact — mensaje del estado de error global.
  ///
  /// In es, this message translates to:
  /// **'No hemos podido cargar tus datos de contacto.'**
  String get notificationContactErrorLoading;

  /// Notifications contact — error de validación del teléfono móvil.
  ///
  /// In es, this message translates to:
  /// **'Introduce un teléfono móvil válido.'**
  String get notificationContactErrorPhoneInvalid;

  /// Notifications contact — error de validación del correo electrónico.
  ///
  /// In es, this message translates to:
  /// **'Introduce un correo electrónico válido.'**
  String get notificationContactErrorEmailInvalid;

  /// Notifications contact — error cuando no se proporciona ningún canal.
  ///
  /// In es, this message translates to:
  /// **'Indica al menos un teléfono móvil o un correo electrónico.'**
  String get notificationContactErrorBothEmpty;

  /// Notifications contact — mensaje de éxito tras el alta.
  ///
  /// In es, this message translates to:
  /// **'Tus datos de contacto se han registrado correctamente.'**
  String get notificationContactSuccessMessage;

  /// Notifications contact — mensaje del banner que aparece cuando faltan datos de contacto.
  ///
  /// In es, this message translates to:
  /// **'Configura tus datos de contacto para recibir notificaciones.'**
  String get notificationContactGateBannerMessage;

  /// Notifications contact — CTA del banner que abre el formulario de alta.
  ///
  /// In es, this message translates to:
  /// **'Configurar ahora'**
  String get notificationContactGateBannerCta;

  /// Signature — título de la bandeja de firma del ciudadano (STORY-45).
  ///
  /// In es, this message translates to:
  /// **'Firma de documentos'**
  String get signatureInboxTitle;

  /// Signature — etiqueta de la pestaña de documentos pendientes de firma.
  ///
  /// In es, this message translates to:
  /// **'Pendientes'**
  String get signatureTabPending;

  /// Signature — etiqueta de la pestaña del histórico de documentos firmados.
  ///
  /// In es, this message translates to:
  /// **'Histórico'**
  String get signatureTabHistory;

  /// Signature — mensaje del estado de carga.
  ///
  /// In es, this message translates to:
  /// **'Cargando documentos…'**
  String get signatureLoading;

  /// Signature — título del estado vacío en la pestaña de pendientes.
  ///
  /// In es, this message translates to:
  /// **'No hay documentos pendientes'**
  String get signatureEmptyPendingTitle;

  /// Signature — subtítulo del estado vacío en la pestaña de pendientes.
  ///
  /// In es, this message translates to:
  /// **'No tienes documentos esperando tu firma.'**
  String get signatureEmptyPendingSubtitle;

  /// Signature — título del estado vacío en la pestaña de histórico.
  ///
  /// In es, this message translates to:
  /// **'Aún no has firmado documentos'**
  String get signatureEmptyHistoryTitle;

  /// Signature — subtítulo del estado vacío en la pestaña de histórico.
  ///
  /// In es, this message translates to:
  /// **'Cuando firmes un documento aparecerá aquí.'**
  String get signatureEmptyHistorySubtitle;

  /// Signature — mensaje del estado de error global de la bandeja.
  ///
  /// In es, this message translates to:
  /// **'No hemos podido cargar tus documentos para firmar.'**
  String get signatureErrorMessage;

  /// Signature — etiqueta del botón de reintento del estado de error.
  ///
  /// In es, this message translates to:
  /// **'Reintentar'**
  String get signatureRetry;

  /// Signature — CTA principal en cada documento pendiente.
  ///
  /// In es, this message translates to:
  /// **'Firmar'**
  String get signatureSignAction;

  /// Signature — placeholder mostrado al pulsar Firmar mientras STORY-46 está pendiente.
  ///
  /// In es, this message translates to:
  /// **'El salto a Afirma se habilitará en STORY-46.'**
  String get signatureExternalLaunchPlaceholder;

  /// Signature — título del banner cuando el certificado es válido.
  ///
  /// In es, this message translates to:
  /// **'Certificado válido'**
  String get signatureCertificateValidTitle;

  /// Signature — título del banner cuando no hay certificado disponible.
  ///
  /// In es, this message translates to:
  /// **'Necesitas instalar tu certificado'**
  String get signatureCertificateMissingTitle;

  /// Signature — título del banner cuando el certificado ha caducado.
  ///
  /// In es, this message translates to:
  /// **'Tu certificado ha caducado'**
  String get signatureCertificateExpiredTitle;

  /// Signature — título del banner cuando el certificado no es válido.
  ///
  /// In es, this message translates to:
  /// **'El certificado no es válido'**
  String get signatureCertificateInvalidTitle;

  /// Signature — título del banner cuando solo está disponible la Validación Electrónica Centralizada.
  ///
  /// In es, this message translates to:
  /// **'Disponible mediante VEC'**
  String get signatureCertificateVecTitle;

  /// Signature — título del banner cuando la validación falla o devuelve un estado desconocido.
  ///
  /// In es, this message translates to:
  /// **'No hemos podido validar tu certificado'**
  String get signatureCertificateUnknownTitle;

  /// Signature — CTA del banner para reintentar la validación.
  ///
  /// In es, this message translates to:
  /// **'Volver a validar'**
  String get signatureCertificateRecheck;

  /// Signature — etiqueta del estado pendiente.
  ///
  /// In es, this message translates to:
  /// **'Pendiente'**
  String get signatureStatusPendiente;

  /// Signature — etiqueta del estado firmado.
  ///
  /// In es, this message translates to:
  /// **'Firmado'**
  String get signatureStatusFirmado;

  /// Signature — etiqueta del estado caducado.
  ///
  /// In es, this message translates to:
  /// **'Caducado'**
  String get signatureStatusExpirado;

  /// Signature — etiqueta del estado de error.
  ///
  /// In es, this message translates to:
  /// **'Con errores'**
  String get signatureStatusError;

  /// Signature — etiqueta del estado desconocido (parser tolerante).
  ///
  /// In es, this message translates to:
  /// **'Sin clasificar'**
  String get signatureStatusUnknown;

  /// Signature — etiqueta auxiliar con el tamaño del documento (ya formateado por la presentación).
  ///
  /// In es, this message translates to:
  /// **'{size}'**
  String signatureDocumentSize(String size);

  /// Signature — texto secundario del banner indicando la fecha de caducidad del certificado.
  ///
  /// In es, this message translates to:
  /// **'Caduca el {date}'**
  String signatureCertificateExpiresOn(String date);
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
