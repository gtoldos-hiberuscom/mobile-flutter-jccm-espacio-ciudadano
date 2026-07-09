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
  /// **'Gestión ágil y online de trámites para la ciudadanía de Castilla-La Mancha'**
  String get landingTagline;

  /// Primera parte del eslogan (peso regular) que precede al nombre de la región.
  ///
  /// In es, this message translates to:
  /// **'Gestión ágil y online de trámites para la ciudadanía de '**
  String get landingTaglinePrefix;

  /// Nombre de la región resaltado con tipografía H2 en el eslogan.
  ///
  /// In es, this message translates to:
  /// **'Castilla-La Mancha'**
  String get landingTaglineHighlight;

  /// Texto del botón principal de acción que inicia el flujo de autenticación con Cl@ve.
  ///
  /// In es, this message translates to:
  /// **'Acceder a mi Espacio ciudadano'**
  String get landingCtaButton;

  /// Botón secundario que navega a la pantalla de información sobre el Espacio Ciudadano.
  ///
  /// In es, this message translates to:
  /// **'Información y ayuda sobre el espacio'**
  String get landingAboutButton;

  /// Enlace de texto que navega a la pantalla de ayuda con el acceso.
  ///
  /// In es, this message translates to:
  /// **'Ayuda y contacto'**
  String get landingHelpLink;

  /// Título del AppBar de la pantalla de ayuda con el acceso.
  ///
  /// In es, this message translates to:
  /// **'Cómo acceder'**
  String get landingHelpPageTitle;

  /// Título principal de la pantalla de ayuda con el acceso.
  ///
  /// In es, this message translates to:
  /// **'Cómo acceder'**
  String get landingHelpTitle;

  /// Primer párrafo explicativo de la pantalla de ayuda con el acceso.
  ///
  /// In es, this message translates to:
  /// **'Para acceder a Espacio Ciudadano debes identificarte con Cl@ve, el sistema de acceso a los servicios públicos. Puedes usar Cl@ve Móvil, Cl@ve Permanente, DNI electrónico o un certificado electrónico (personal o de representante).'**
  String get landingHelpBody1;

  /// Botón de acción principal de la pantalla de ayuda que inicia el flujo de autenticación.
  ///
  /// In es, this message translates to:
  /// **'Acceder a mi Espacio Ciudadano'**
  String get landingHelpAccessButton;

  /// Enlace de texto externo en la pantalla de ayuda.
  ///
  /// In es, this message translates to:
  /// **'Enlace externo'**
  String get landingHelpExternalLink;

  /// Título del AppBar de la pantalla de información sobre el Espacio Ciudadano.
  ///
  /// In es, this message translates to:
  /// **'Saber más sobre el Espacio Ciudadano'**
  String get landingAboutPageTitle;

  /// Título principal de la pantalla de información sobre el Espacio Ciudadano.
  ///
  /// In es, this message translates to:
  /// **'Espacio ciudadano'**
  String get landingAboutTitle;

  /// Texto inicial del párrafo descriptivo (precede al texto en negrita).
  ///
  /// In es, this message translates to:
  /// **'es el área digital donde aparecerá información relevante con el objetivo de'**
  String get landingAboutBodyPrefix;

  /// Fragmento en negrita del párrafo descriptivo.
  ///
  /// In es, this message translates to:
  /// **'facilitar y mejorar tu relación con la Administración regional'**
  String get landingAboutBodyBold;

  /// Texto final del párrafo descriptivo (tras el fragmento en negrita).
  ///
  /// In es, this message translates to:
  /// **'en los trámites y procedimientos en los que seas parte o que puedan ser de tu interés.'**
  String get landingAboutBodySuffix;

  /// Encabezado de la sección de contenidos de la pantalla about.
  ///
  /// In es, this message translates to:
  /// **'¿Qué encontrarás?'**
  String get landingAboutWhatYouFindTitle;

  /// Introducción a la lista de contenidos disponibles.
  ///
  /// In es, this message translates to:
  /// **'Tus datos en relación con la Junta de Comunidades de Castilla-La Mancha:'**
  String get landingAboutWhatYouFindIntro;

  /// Primer elemento de la lista de contenidos.
  ///
  /// In es, this message translates to:
  /// **'Tu información personal.'**
  String get landingAboutBullet1;

  /// Segundo elemento de la lista de contenidos.
  ///
  /// In es, this message translates to:
  /// **'Tus expedientes y su estado de tramitación.'**
  String get landingAboutBullet2;

  /// Tercer elemento de la lista de contenidos.
  ///
  /// In es, this message translates to:
  /// **'Tus notificaciones.'**
  String get landingAboutBullet3;

  /// Cuarto elemento de la lista de contenidos.
  ///
  /// In es, this message translates to:
  /// **'Tus carnets digitales.'**
  String get landingAboutBullet4;

  /// Quinto elemento de la lista de contenidos.
  ///
  /// In es, this message translates to:
  /// **'Tus citas o eventos.'**
  String get landingAboutBullet5;

  /// Sexto elemento de la lista de contenidos.
  ///
  /// In es, this message translates to:
  /// **'Recomendaciones personalizadas basadas en tus intereses.'**
  String get landingAboutBullet6;

  /// Botón de acción principal de la pantalla about que inicia el flujo de autenticación.
  ///
  /// In es, this message translates to:
  /// **'Acceder a mi Espacio Ciudadano'**
  String get landingAboutAccessButton;

  /// Enlace de texto externo en la pantalla about.
  ///
  /// In es, this message translates to:
  /// **'Enlace externo'**
  String get landingAboutExternalLink;

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

  /// Texto mostrado por el sistema al solicitar autenticación biométrica para reanudar una sesión guardada.
  ///
  /// In es, this message translates to:
  /// **'Confirma tu identidad para acceder a tu espacio'**
  String get sessionUnlockBiometricReason;

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
  /// **'De conformidad con lo dispuesto en el Reglamento (UE) 2016/679 del Parlamento Europeo y del Consejo (RGPD) y la Ley Orgánica 3/2018 de Protección de Datos Personales y garantía de los derechos digitales (LOPDGDD), la Junta de Comunidades de Castilla-La Mancha le informa de que los datos personales recabados a través de esta aplicación serán tratados bajo la responsabilidad de la Junta de Comunidades de Castilla-La Mancha, con el fin de prestarle los servicios de administración electrónica incluidos en el Espacio Ciudadano.\n\nDe acuerdo con la Ley 3/2017 de la Junta de Comunidades de Castilla-La Mancha, tiene usted derecho a acceder, rectificar y suprimir sus datos, así como a ejercer los demás derechos reconocidos en la normativa aplicable, mediante escrito dirigido a la Secretaría General de la Junta de Comunidades de Castilla-La Mancha.\n\nPara continuar utilizando la aplicación debe aceptar las presentes condiciones de uso y protección de datos. Si no acepta, se cerrará su sesión y deberá identificarse de nuevo.'**
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

  /// Título completo del paso 1 del flujo de consentimiento legal (JCCMEC-11).
  ///
  /// In es, this message translates to:
  /// **'Condiciones de uso y autorizaciones'**
  String get consentStep1FullTitle;

  /// Botón de confirmación final del consentimiento en el paso 2.
  ///
  /// In es, this message translates to:
  /// **'Aceptar'**
  String get consentFinalAcceptButton;

  /// Mensaje de error cuando el guardado del consentimiento falla.
  ///
  /// In es, this message translates to:
  /// **'No se ha podido guardar el consentimiento. Por favor, inténtalo de nuevo.'**
  String get consentSaveError;

  /// Indicación para el usuario de que debe desplazarse hasta el final del contenido.
  ///
  /// In es, this message translates to:
  /// **'Desliza hasta el final para continuar'**
  String get consentScrollHint;

  /// SnackBar mostrado al pulsar el botón de información en la pantalla de protección de datos del onboarding.
  ///
  /// In es, this message translates to:
  /// **'Lee la información sobre el tratamiento y protección de datos antes de continuar'**
  String get consentLegalInfoSnackBar;

  /// Etiqueta de accesibilidad del botón de información legal en el paso 2.
  ///
  /// In es, this message translates to:
  /// **'Ver información legal completa'**
  String get consentInfoButtonSemantics;

  /// Etiqueta de accesibilidad del botón de cierre del paso 2 (equivalente a rechazar).
  ///
  /// In es, this message translates to:
  /// **'Cerrar y rechazar condiciones'**
  String get consentCloseButtonSemantics;

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

  /// Etiqueta del enlace externo a la Agencia Española de Protección de Datos.
  ///
  /// In es, this message translates to:
  /// **'Agencia Española de Protección de Datos'**
  String get externalLinkAepdLabel;

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

  /// Educación — título del modal de ayuda de títulos universitarios.
  ///
  /// In es, this message translates to:
  /// **'Sobre tus títulos universitarios'**
  String get educationUniversityTitlesInfoTitle;

  /// Educación — cuerpo principal del modal de ayuda de títulos universitarios.
  ///
  /// In es, this message translates to:
  /// **'Consulta los datos de los títulos que figuren en el registro Nacional de Titulados universitarios oficiales del Ministerio de Ciencia, Innovación y Universidades.\nSi tu título es anterior a 1996 es posible que tus datos no puedan visualizarse automáticamente.'**
  String get educationUniversityTitlesInfoBody;

  /// Educación — texto de pie del modal de ayuda de títulos universitarios.
  ///
  /// In es, this message translates to:
  /// **'Si alguno de tus datos no es correcto o no está actualizado, contacta con la Ministerio de Ciencia, Innovación y Universidades.'**
  String get educationUniversityTitlesInfoFooter;

  /// Educación — botón de contacto en el modal de ayuda de títulos universitarios.
  ///
  /// In es, this message translates to:
  /// **'Contactar'**
  String get educationUniversityTitlesInfoContactButton;

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

  /// Mis datos de Bienestar — título de la pantalla.
  ///
  /// In es, this message translates to:
  /// **'Bienestar social'**
  String get socialWelfareScreenTitle;

  /// Mis datos de Bienestar — pestaña de datos personales.
  ///
  /// In es, this message translates to:
  /// **'Mis datos de Bienestar'**
  String get socialWelfareDataTab;

  /// Mis datos de Bienestar — pestaña de información y servicios.
  ///
  /// In es, this message translates to:
  /// **'Información y servicios'**
  String get socialWelfareServicesTab;

  /// Mis datos de Bienestar — título de la sección de enlaces de interés.
  ///
  /// In es, this message translates to:
  /// **'Enlaces de interés'**
  String get socialWelfareInterestLinksTitle;

  /// Mis datos de Bienestar — título de la sección de trámites sugeridos.
  ///
  /// In es, this message translates to:
  /// **'Trámites que te pueden interesar'**
  String get socialWelfareSuggestedProceduresTitle;

  /// Mis datos de Bienestar — enlace al trámite de reconocimiento de discapacidad.
  ///
  /// In es, this message translates to:
  /// **'Reconocimiento del grado de discapacidad'**
  String get socialWelfareDisabilityRecognitionProcedure;

  /// Mis datos de Bienestar — enlace al trámite de atención temprana.
  ///
  /// In es, this message translates to:
  /// **'Acceso al servicio de atención temprana'**
  String get socialWelfareEarlyCareProcedure;

  /// Mis datos de Bienestar — enlace al trámite de estancias temporales en centros residenciales.
  ///
  /// In es, this message translates to:
  /// **'Plaza para el servicio de estancias temporales en centros residenciales para personas mayores'**
  String get socialWelfareTemporaryResidentialStayProcedure;

  /// Mis datos de Bienestar — título del modal informativo.
  ///
  /// In es, this message translates to:
  /// **'Sobre Mis datos de Bienestar social'**
  String get socialWelfareInfoSheetTitle;

  /// Mis datos de Bienestar — descripción del modal informativo.
  ///
  /// In es, this message translates to:
  /// **'Consulta la información de tus expedientes en el ámbito de Bienestar Social y accede a los servicios disponibles en la Junta de Comunidades de Castilla-La Mancha.'**
  String get socialWelfareInfoSheetDescription;

  /// Mensaje mostrado cuando la consulta de datos JCCM no está autorizada.
  ///
  /// In es, this message translates to:
  /// **'Debes autorizar la consulta de los hechos administrativos que obren en poder de la JCCM desde tus preferencias.'**
  String get myDataJccmAuthorizationRequiredMessage;

  /// Texto accesible del botón para abrir condiciones de uso y autorizaciones.
  ///
  /// In es, this message translates to:
  /// **'Ir a Condiciones de uso y autorizaciones'**
  String get myDataJccmAuthorizationRequiredCta;

  /// Mensaje mostrado cuando la consulta de datos AGE no está autorizada.
  ///
  /// In es, this message translates to:
  /// **'Debes autorizar la consulta de los datos que la Administración General del Estado tiene sobre ti desde tus preferencias.'**
  String get myDataAgeAuthorizationRequiredMessage;

  /// Bienestar — sección familia numerosa.
  ///
  /// In es, this message translates to:
  /// **'Familia numerosa'**
  String get socialWelfareFamilyTitle;

  /// Mis datos de Bienestar — descripción de la tarjeta de familia numerosa.
  ///
  /// In es, this message translates to:
  /// **'Detalles del título y personas beneficiarias'**
  String get socialWelfareFamilyNavDescription;

  /// Mis datos de Bienestar — título de la tarjeta de discapacidad.
  ///
  /// In es, this message translates to:
  /// **'Discapacidad'**
  String get socialWelfareDisabilityTitle;

  /// Mis datos de Bienestar — descripción de la tarjeta de discapacidad.
  ///
  /// In es, this message translates to:
  /// **'Detalles del título de discapacidad'**
  String get socialWelfareDisabilityNavDescription;

  /// Mis datos de Bienestar — título del panel informativo de discapacidad.
  ///
  /// In es, this message translates to:
  /// **'Sobre Mi título de discapacidad'**
  String get socialWelfareDisabilityInfoSheetTitle;

  /// Mis datos de Bienestar — descripción del panel informativo de discapacidad.
  ///
  /// In es, this message translates to:
  /// **'Consulta los datos de tu título de discapacidad.'**
  String get socialWelfareDisabilityInfoSheetDescription;

  /// Mis datos de Bienestar — sección del título de discapacidad.
  ///
  /// In es, this message translates to:
  /// **'Mi título de discapacidad'**
  String get socialWelfareDisabilityTitleSection;

  /// Mis datos de Bienestar — etiqueta de fecha de efectos.
  ///
  /// In es, this message translates to:
  /// **'Fecha de efectos'**
  String get socialWelfareDisabilityEffectiveDateLabel;

  /// Mis datos de Bienestar — etiqueta de validez definitiva.
  ///
  /// In es, this message translates to:
  /// **'Validez definitiva'**
  String get socialWelfareDisabilityPermanentValidityLabel;

  /// Mis datos de Bienestar — etiqueta de número de expediente.
  ///
  /// In es, this message translates to:
  /// **'Número de expediente'**
  String get socialWelfareDisabilityFileNumberLabel;

  /// Mis datos de Bienestar — etiqueta de fecha de nacimiento.
  ///
  /// In es, this message translates to:
  /// **'Fecha de nacimiento'**
  String get socialWelfareDisabilityBirthDateLabel;

  /// Mis datos de Bienestar — etiqueta de movilidad.
  ///
  /// In es, this message translates to:
  /// **'Procede movilidad'**
  String get socialWelfareDisabilityMobilityLabel;

  /// Mis datos de Bienestar — etiqueta de tercera persona.
  ///
  /// In es, this message translates to:
  /// **'Reconocido concurso de tercera persona'**
  String get socialWelfareDisabilityThirdPersonLabel;

  /// Mis datos de Bienestar — etiqueta del real decreto.
  ///
  /// In es, this message translates to:
  /// **'Real decreto en base a la que se concede el grado'**
  String get socialWelfareDisabilityRoyalDecreeLabel;

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

  /// Mis datos de Bienestar — título de la tarjeta de termalismo.
  ///
  /// In es, this message translates to:
  /// **'Termalismo'**
  String get socialWelfareTermalismoNavTitle;

  /// Mis datos de Bienestar — descripción de la tarjeta de termalismo.
  ///
  /// In es, this message translates to:
  /// **'Balneario adjudicado'**
  String get socialWelfareTermalismoNavDescription;

  /// Mis datos de Bienestar — título del panel informativo de termalismo.
  ///
  /// In es, this message translates to:
  /// **'Sobre Termalismo'**
  String get socialWelfareTermalismoInfoSheetTitle;

  /// Mis datos de Bienestar — descripción del panel informativo de termalismo.
  ///
  /// In es, this message translates to:
  /// **'Consulta los datos del último balneario que te han adjudicado de forma definitiva en el Programa Termalismo de Castilla-La Mancha.'**
  String get socialWelfareTermalismoInfoSheetDescription;

  /// Mis datos de Bienestar — sección del último balneario adjudicado.
  ///
  /// In es, this message translates to:
  /// **'Último balneario adjudicado'**
  String get socialWelfareTermalismoAwardTitle;

  /// Mis datos de Bienestar — etiqueta del nombre del balneario.
  ///
  /// In es, this message translates to:
  /// **'Nombre del balneario'**
  String get socialWelfareTermalismoSpaNameLabel;

  /// Mis datos de Bienestar — etiqueta de fecha desde.
  ///
  /// In es, this message translates to:
  /// **'Fecha desde'**
  String get socialWelfareTermalismoStartDateLabel;

  /// Mis datos de Bienestar — etiqueta de fecha hasta.
  ///
  /// In es, this message translates to:
  /// **'Fecha hasta'**
  String get socialWelfareTermalismoEndDateLabel;

  /// Mis datos de Bienestar — estado vacío de termalismo.
  ///
  /// In es, this message translates to:
  /// **'No hemos encontrado información de termalismo asociada a tus datos. Vuelve a intentarlo más tarde.'**
  String get socialWelfareTermalismoUnavailableMessage;

  /// Mis datos de Bienestar — error de carga de termalismo.
  ///
  /// In es, this message translates to:
  /// **'No se ha podido cargar tu información de termalismo.'**
  String get socialWelfareTermalismoErrorMessage;

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

  /// Mis datos de Bienestar — título de la tarjeta de estacionamiento.
  ///
  /// In es, this message translates to:
  /// **'Tarjeta estacionamiento'**
  String get socialWelfareParkingNavTitle;

  /// Mis datos de Bienestar — descripción de la tarjeta de estacionamiento.
  ///
  /// In es, this message translates to:
  /// **'Detalles de tu tarjeta de estacionamiento'**
  String get socialWelfareParkingNavDescription;

  /// Mis datos de Bienestar — título del panel informativo de tarjeta de estacionamiento.
  ///
  /// In es, this message translates to:
  /// **'Sobre Mi tarjeta de estacionamiento'**
  String get socialWelfareParkingInfoSheetTitle;

  /// Mis datos de Bienestar — descripción del panel informativo de tarjeta de estacionamiento.
  ///
  /// In es, this message translates to:
  /// **'Consulta los datos de tu tarjeta de estacionamiento en vigor para personas con discapacidad y movilidad reducida de Castilla-La Mancha.'**
  String get socialWelfareParkingInfoSheetDescription;

  /// Mis datos de Bienestar — título de detalle de tarjeta de estacionamiento.
  ///
  /// In es, this message translates to:
  /// **'Mi tarjeta de estacionamiento'**
  String get socialWelfareParkingCardTitle;

  /// Mis datos de Bienestar — etiqueta del código de tarjeta.
  ///
  /// In es, this message translates to:
  /// **'Código de la tarjeta'**
  String get socialWelfareParkingCodeLabel;

  /// Mis datos de Bienestar — etiqueta de modalidad.
  ///
  /// In es, this message translates to:
  /// **'Modalidad'**
  String get socialWelfareParkingModalityLabel;

  /// Mis datos de Bienestar — etiqueta de fecha de vigencia desde.
  ///
  /// In es, this message translates to:
  /// **'Fecha de vigencia desde'**
  String get socialWelfareParkingValidFromLabel;

  /// Mis datos de Bienestar — etiqueta de fecha de vigencia hasta.
  ///
  /// In es, this message translates to:
  /// **'Fecha de vigencia hasta'**
  String get socialWelfareParkingValidUntilLabel;

  /// Mis datos de Bienestar — estado vacío de tarjeta de estacionamiento.
  ///
  /// In es, this message translates to:
  /// **'No hemos encontrado información de tarjeta de estacionamiento asociada a tus datos. Vuelve a intentarlo más tarde.'**
  String get socialWelfareParkingUnavailableMessage;

  /// Mis datos de Bienestar — error de carga de tarjeta de estacionamiento.
  ///
  /// In es, this message translates to:
  /// **'No se ha podido cargar tu tarjeta de estacionamiento.'**
  String get socialWelfareParkingErrorMessage;

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

  /// Mis datos de Bienestar — descripción de la tarjeta de dependencia.
  ///
  /// In es, this message translates to:
  /// **'Situación actual y prestaciones'**
  String get socialWelfareDependenciaNavDescription;

  /// Mis datos de Bienestar — título del panel informativo de dependencia.
  ///
  /// In es, this message translates to:
  /// **'Sobre Atención a la dependencia'**
  String get socialWelfareDependenciaInfoSheetTitle;

  /// Mis datos de Bienestar — descripción del panel informativo de dependencia.
  ///
  /// In es, this message translates to:
  /// **'Consulta los datos sobre tu situación actual de las prestaciones en ayuda a la dependencia.'**
  String get socialWelfareDependenciaInfoSheetDescription;

  /// Mis datos de Bienestar — título de situación actual.
  ///
  /// In es, this message translates to:
  /// **'Mi situación actual'**
  String get socialWelfareDependenciaCurrentStatusTitle;

  /// Mis datos de Bienestar — etiqueta de fecha de solicitud.
  ///
  /// In es, this message translates to:
  /// **'Fecha de solicitud'**
  String get socialWelfareDependenciaRequestDateLabel;

  /// Mis datos de Bienestar — etiqueta de fecha de resolución.
  ///
  /// In es, this message translates to:
  /// **'Fecha de resolución'**
  String get socialWelfareDependenciaResolutionDateLabel;

  /// Mis datos de Bienestar — etiqueta de grado reconocido.
  ///
  /// In es, this message translates to:
  /// **'Grado reconocido'**
  String get socialWelfareDependenciaRecognizedDegreeLabel;

  /// Mis datos de Bienestar — etiqueta de baremo.
  ///
  /// In es, this message translates to:
  /// **'Baremo'**
  String get socialWelfareDependenciaBaremoLabel;

  /// Mis datos de Bienestar — título de prestaciones.
  ///
  /// In es, this message translates to:
  /// **'Prestaciones'**
  String get socialWelfareDependenciaBenefitsTitle;

  /// Mis datos de Bienestar — etiqueta de fecha resolución de prestación.
  ///
  /// In es, this message translates to:
  /// **'Fecha resolución'**
  String get socialWelfareDependenciaBenefitResolutionDateLabel;

  /// Mis datos de Bienestar — etiqueta de fecha efecto de prestación.
  ///
  /// In es, this message translates to:
  /// **'Fecha efecto'**
  String get socialWelfareDependenciaBenefitEffectiveDateLabel;

  /// Mis datos de Bienestar — etiqueta de importe de prestación.
  ///
  /// In es, this message translates to:
  /// **'Importe (€)'**
  String get socialWelfareDependenciaBenefitAmountLabel;

  /// Mis datos de Bienestar — estado vacío de dependencia.
  ///
  /// In es, this message translates to:
  /// **'No hemos encontrado información de atención a la dependencia asociada a tus datos. Vuelve a intentarlo más tarde.'**
  String get socialWelfareDependenciaUnavailableMessage;

  /// Mis datos de Bienestar — error de carga de dependencia.
  ///
  /// In es, this message translates to:
  /// **'No se ha podido cargar tu información de atención a la dependencia.'**
  String get socialWelfareDependenciaErrorMessage;

  /// Bienestar — copy dependencia.
  ///
  /// In es, this message translates to:
  /// **'La información y los trámites de la Ley de Dependencia se gestionan en el portal oficial de Bienestar Social de Castilla-La Mancha.'**
  String get socialWelfareDependenciaDescription;

  /// Mis datos de Bienestar — estado vacío temporal de la pestaña Información y servicios.
  ///
  /// In es, this message translates to:
  /// **'Información y servicios de Bienestar disponible próximamente.'**
  String get socialWelfareServicesEmpty;

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

  /// Casework — título de la pantalla de detalle (STORY-35).
  ///
  /// In es, this message translates to:
  /// **'Detalle del expediente'**
  String get caseworkExpedienteDetailTitle;

  /// Casework — tooltip botón volver detalle.
  ///
  /// In es, this message translates to:
  /// **'Volver a Mis gestiones'**
  String get caseworkExpedienteDetailBack;

  /// Casework — mensaje de carga detalle.
  ///
  /// In es, this message translates to:
  /// **'Cargando detalle del expediente…'**
  String get caseworkExpedienteDetailLoading;

  /// Casework — título de error en detalle.
  ///
  /// In es, this message translates to:
  /// **'No hemos podido cargar el expediente.'**
  String get caseworkExpedienteDetailErrorTitle;

  /// Casework — cuerpo de error en detalle.
  ///
  /// In es, this message translates to:
  /// **'Vuelve a intentarlo en unos minutos.'**
  String get caseworkExpedienteDetailErrorBody;

  /// Casework — título del bloque de metadata.
  ///
  /// In es, this message translates to:
  /// **'Información del expediente'**
  String get caseworkExpedienteDetailMetadataTitle;

  /// Casework — etiqueta número de expediente.
  ///
  /// In es, this message translates to:
  /// **'Número de expediente'**
  String get caseworkExpedienteDetailNumero;

  /// Casework — etiqueta código del asunto.
  ///
  /// In es, this message translates to:
  /// **'Código del asunto'**
  String get caseworkExpedienteDetailAsuntoCodigo;

  /// Casework — etiqueta asunto.
  ///
  /// In es, this message translates to:
  /// **'Asunto'**
  String get caseworkExpedienteDetailAsunto;

  /// Casework — etiqueta consejería.
  ///
  /// In es, this message translates to:
  /// **'Consejería'**
  String get caseworkExpedienteDetailConsejeria;

  /// Casework — etiqueta oficina tramitadora.
  ///
  /// In es, this message translates to:
  /// **'Oficina tramitadora'**
  String get caseworkExpedienteDetailOficina;

  /// Casework — etiqueta procedimiento.
  ///
  /// In es, this message translates to:
  /// **'Procedimiento'**
  String get caseworkExpedienteDetailProcedimiento;

  /// Casework — etiqueta fecha de inicio.
  ///
  /// In es, this message translates to:
  /// **'Fecha de inicio'**
  String get caseworkExpedienteDetailFechaInicio;

  /// Casework — etiqueta última actualización.
  ///
  /// In es, this message translates to:
  /// **'Última actualización'**
  String get caseworkExpedienteDetailFechaActualizacion;

  /// Casework — etiqueta accesible del estado.
  ///
  /// In es, this message translates to:
  /// **'Estado'**
  String get caseworkExpedienteDetailEstadoLabel;

  /// Casework — estado abierto.
  ///
  /// In es, this message translates to:
  /// **'Abierto'**
  String get caseworkExpedienteDetailEstadoAbierto;

  /// Casework — estado cerrado.
  ///
  /// In es, this message translates to:
  /// **'Cerrado'**
  String get caseworkExpedienteDetailEstadoCerrado;

  /// Casework — fallback de estado desconocido (TASK-40 Q1).
  ///
  /// In es, this message translates to:
  /// **'Estado desconocido'**
  String get caseworkExpedienteDetailEstadoUnknown;

  /// Casework — título sección de ficheros.
  ///
  /// In es, this message translates to:
  /// **'Ficheros asociados'**
  String get caseworkExpedienteDetailFilesTitle;

  /// Casework — vacío sección de ficheros.
  ///
  /// In es, this message translates to:
  /// **'No hay ficheros asociados a este expediente.'**
  String get caseworkExpedienteDetailFilesEmpty;

  /// Casework — tooltip descarga fichero.
  ///
  /// In es, this message translates to:
  /// **'Descargar fichero'**
  String get caseworkExpedienteDetailFicheroDownloadTooltip;

  /// Casework — mensaje placeholder descarga fichero.
  ///
  /// In es, this message translates to:
  /// **'La descarga del fichero se habilitará en una próxima versión.'**
  String get caseworkExpedienteDetailFicheroDownloadStub;

  /// Casework — título zona operativa de aportación.
  ///
  /// In es, this message translates to:
  /// **'Aportar documentación'**
  String get caseworkExpedienteDetailOperationsTitle;

  /// Casework — banner expediente cerrado.
  ///
  /// In es, this message translates to:
  /// **'Expediente cerrado, no se admiten aportaciones.'**
  String get caseworkExpedienteDetailClosedBanner;

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

  /// Personalization — large intro heading on the hechos vitales screen.
  ///
  /// In es, this message translates to:
  /// **'Selecciona las temáticas sobre las que te gustaría recibir información'**
  String get lifeEventsIntroHeading;

  /// Personalization — smaller intro body text on the hechos vitales screen.
  ///
  /// In es, this message translates to:
  /// **'Selecciona las temáticas sobre las que te gustaría recibir información en el apartado de recomendaciones'**
  String get lifeEventsIntroBody;

  /// Personalization — explicit save button label.
  ///
  /// In es, this message translates to:
  /// **'Guardar'**
  String get lifeEventsSaveAction;

  /// Personalization — accept button label for first-login onboarding.
  ///
  /// In es, this message translates to:
  /// **'Aceptar'**
  String get lifeEventsAcceptAction;

  /// Personalization — skip action label for first-login onboarding.
  ///
  /// In es, this message translates to:
  /// **'Rellenar luego'**
  String get lifeEventsFillLaterAction;

  /// Personalization — clear all selected life events action label.
  ///
  /// In es, this message translates to:
  /// **'Desmarcar todo'**
  String get lifeEventsClearAllAction;

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

  /// Casework upload — page title.
  ///
  /// In es, this message translates to:
  /// **'Aportar documentación'**
  String get caseworkUploadPageTitle;

  /// Casework upload — picker panel headline.
  ///
  /// In es, this message translates to:
  /// **'Adjuntar archivos'**
  String get caseworkUploadPickerCta;

  /// Casework upload — picker button label.
  ///
  /// In es, this message translates to:
  /// **'Seleccionar archivos'**
  String get caseworkUploadSelectFilesCta;

  /// Casework upload — semantic label for the drop / picker area.
  ///
  /// In es, this message translates to:
  /// **'Zona para arrastrar y soltar archivos. También se pueden seleccionar pulsando.'**
  String get caseworkUploadDropZoneSemantic;

  /// Casework upload — files and size limit hint.
  ///
  /// In es, this message translates to:
  /// **'Máximo {maxFiles} archivos. Hasta {maxMb} MB cada uno.'**
  String caseworkUploadLimitHint(int maxFiles, int maxMb);

  /// Casework upload — remaining slots.
  ///
  /// In es, this message translates to:
  /// **'{remaining, plural, =0{No puedes adjuntar más archivos.} =1{Puedes adjuntar 1 archivo más.} other{Puedes adjuntar {remaining} archivos más.}}'**
  String caseworkUploadRemainingHint(int remaining);

  /// Casework upload — empty list state.
  ///
  /// In es, this message translates to:
  /// **'Aún no hay archivos adjuntos.'**
  String get caseworkUploadEmptyList;

  /// Casework upload — remove file tooltip.
  ///
  /// In es, this message translates to:
  /// **'Quitar archivo'**
  String get caseworkUploadRemoveFile;

  /// Casework upload — upload all CTA.
  ///
  /// In es, this message translates to:
  /// **'Subir todos'**
  String get caseworkUploadUploadAllCta;

  /// Casework upload — finalize CTA.
  ///
  /// In es, this message translates to:
  /// **'Finalizar y solicitar justificante'**
  String get caseworkUploadFinalizeCta;

  /// Casework upload — status: selected.
  ///
  /// In es, this message translates to:
  /// **'Seleccionado'**
  String get caseworkUploadStatusSelected;

  /// Casework upload — status: validating.
  ///
  /// In es, this message translates to:
  /// **'Validando'**
  String get caseworkUploadStatusValidating;

  /// Casework upload — status: hashed.
  ///
  /// In es, this message translates to:
  /// **'Hash calculado'**
  String get caseworkUploadStatusHashed;

  /// Casework upload — status: uploading.
  ///
  /// In es, this message translates to:
  /// **'Subiendo'**
  String get caseworkUploadStatusUploading;

  /// Casework upload — status: uploaded.
  ///
  /// In es, this message translates to:
  /// **'Subido'**
  String get caseworkUploadStatusUploaded;

  /// Casework upload — status: failed.
  ///
  /// In es, this message translates to:
  /// **'Error'**
  String get caseworkUploadStatusFailed;

  /// Casework upload — error: unsupported mime.
  ///
  /// In es, this message translates to:
  /// **'Formato no admitido.'**
  String get caseworkUploadErrorUnsupportedMime;

  /// Casework upload — error: too large.
  ///
  /// In es, this message translates to:
  /// **'El archivo excede el tamaño máximo.'**
  String get caseworkUploadErrorTooLarge;

  /// Casework upload — error: too many files.
  ///
  /// In es, this message translates to:
  /// **'Has alcanzado el número máximo de archivos.'**
  String get caseworkUploadErrorTooManyFiles;

  /// Casework upload — error: empty file.
  ///
  /// In es, this message translates to:
  /// **'El archivo está vacío.'**
  String get caseworkUploadErrorEmptyFile;

  /// Casework upload — error: hash mismatch.
  ///
  /// In es, this message translates to:
  /// **'La huella del archivo no coincide.'**
  String get caseworkUploadErrorHashMismatch;

  /// Casework upload — error: generic.
  ///
  /// In es, this message translates to:
  /// **'Se produjo un error con el archivo.'**
  String get caseworkUploadErrorGeneric;

  /// Casework upload — justificante pending.
  ///
  /// In es, this message translates to:
  /// **'El justificante se generará cuando finalices el envío.'**
  String get caseworkUploadJustificantePending;

  /// Casework upload — justificante unavailable headline.
  ///
  /// In es, this message translates to:
  /// **'El justificante todavía no está disponible.'**
  String get caseworkUploadJustificanteUnavailable;

  /// Casework upload — justificante unavailable reason.
  ///
  /// In es, this message translates to:
  /// **'Motivo: {reason}'**
  String caseworkUploadJustificanteUnavailableReason(String reason);

  /// Casework upload — justificante available.
  ///
  /// In es, this message translates to:
  /// **'Tu justificante está listo.'**
  String get caseworkUploadJustificanteAvailable;

  /// Casework upload — justificante download CTA.
  ///
  /// In es, this message translates to:
  /// **'Descargar justificante'**
  String get caseworkUploadJustificanteDownloadCta;

  /// Casework upload — stub message when download is triggered.
  ///
  /// In es, this message translates to:
  /// **'La descarga del justificante se habilitará cuando el backend confirme el formato.'**
  String get caseworkUploadJustificanteDownloadStub;

  /// Casework registro detail — page title for entradas.
  ///
  /// In es, this message translates to:
  /// **'Detalle de entrada de registro'**
  String get caseworkRegistroDetailTitleEntrada;

  /// Casework registro detail — page title for salidas.
  ///
  /// In es, this message translates to:
  /// **'Detalle de salida de registro'**
  String get caseworkRegistroDetailTitleSalida;

  /// Casework registro detail — breadcrumb root.
  ///
  /// In es, this message translates to:
  /// **'Inicio'**
  String get caseworkRegistroDetailBreadcrumbHome;

  /// Casework registro detail — breadcrumb workspace segment.
  ///
  /// In es, this message translates to:
  /// **'Mis gestiones'**
  String get caseworkRegistroDetailBreadcrumbCasework;

  /// Casework registro detail — breadcrumb segment for entradas.
  ///
  /// In es, this message translates to:
  /// **'Entradas de registro'**
  String get caseworkRegistroDetailKindEntrada;

  /// Casework registro detail — breadcrumb segment for salidas.
  ///
  /// In es, this message translates to:
  /// **'Salidas de registro'**
  String get caseworkRegistroDetailKindSalida;

  /// Casework registro detail — back-to-list tooltip on the AppBar.
  ///
  /// In es, this message translates to:
  /// **'Volver al listado'**
  String get caseworkRegistroDetailBackToList;

  /// Casework registro detail — error loading detail.
  ///
  /// In es, this message translates to:
  /// **'No hemos podido cargar el detalle del registro.'**
  String get caseworkRegistroDetailLoadError;

  /// Casework registro detail — número field label.
  ///
  /// In es, this message translates to:
  /// **'Número de registro'**
  String get caseworkRegistroDetailFieldNumero;

  /// Casework registro detail — fecha field label.
  ///
  /// In es, this message translates to:
  /// **'Fecha'**
  String get caseworkRegistroDetailFieldFecha;

  /// Casework registro detail — consejería destino field label.
  ///
  /// In es, this message translates to:
  /// **'Consejería destino'**
  String get caseworkRegistroDetailFieldConsejeria;

  /// Casework registro detail — oficina field label.
  ///
  /// In es, this message translates to:
  /// **'Oficina de registro'**
  String get caseworkRegistroDetailFieldOficina;

  /// Casework registro detail — asunto field label.
  ///
  /// In es, this message translates to:
  /// **'Asunto'**
  String get caseworkRegistroDetailFieldAsunto;

  /// Casework registro detail — observaciones field label.
  ///
  /// In es, this message translates to:
  /// **'Observaciones'**
  String get caseworkRegistroDetailFieldObservaciones;

  /// Casework registro detail — ficheros section title.
  ///
  /// In es, this message translates to:
  /// **'Documentación adjunta'**
  String get caseworkRegistroDetailFicherosTitle;

  /// Casework registro detail — ficheros empty state.
  ///
  /// In es, this message translates to:
  /// **'Este registro no incluye ficheros adjuntos.'**
  String get caseworkRegistroDetailFicherosEmpty;

  /// Casework registro detail — informational banner reminding the user the screen is read-only.
  ///
  /// In es, this message translates to:
  /// **'Esta pantalla muestra el detalle del registro en modo consulta. No es posible aportar documentación desde aquí.'**
  String get caseworkRegistroDetailReadOnlyBanner;

  /// Casework workspace — entrypoint button that opens the third-party aportación wizard (STORY-37).
  ///
  /// In es, this message translates to:
  /// **'Aportar documentación'**
  String get caseworkAportacionOpenCta;

  /// Casework aportación wizard — page title.
  ///
  /// In es, this message translates to:
  /// **'Aportación de documentos'**
  String get caseworkAportacionTitle;

  /// Casework aportación wizard — breadcrumb segment.
  ///
  /// In es, this message translates to:
  /// **'Aportación'**
  String get caseworkAportacionBreadcrumb;

  /// Casework aportación wizard — AppBar back tooltip.
  ///
  /// In es, this message translates to:
  /// **'Paso anterior'**
  String get caseworkAportacionBack;

  /// Casework aportación wizard — AppBar exit tooltip on the intro step.
  ///
  /// In es, this message translates to:
  /// **'Salir del flujo'**
  String get caseworkAportacionExit;

  /// Casework aportación wizard — step indicator.
  ///
  /// In es, this message translates to:
  /// **'Paso {current} de {total}'**
  String caseworkAportacionStepIndicator(int current, int total);

  /// Casework aportación wizard — step label for intro.
  ///
  /// In es, this message translates to:
  /// **'Introducción'**
  String get caseworkAportacionStepIntro;

  /// Casework aportación wizard — step label for identification.
  ///
  /// In es, this message translates to:
  /// **'Identificación'**
  String get caseworkAportacionStepIdentificacion;

  /// Casework aportación wizard — step label for search.
  ///
  /// In es, this message translates to:
  /// **'Búsqueda'**
  String get caseworkAportacionStepSearch;

  /// Casework aportación wizard — step label for detail.
  ///
  /// In es, this message translates to:
  /// **'Detalle'**
  String get caseworkAportacionStepDetail;

  /// Casework aportación wizard — step label for completion.
  ///
  /// In es, this message translates to:
  /// **'Confirmación'**
  String get caseworkAportacionStepComplete;

  /// Casework aportación wizard — intro headline.
  ///
  /// In es, this message translates to:
  /// **'Aporta documentación a un expediente'**
  String get caseworkAportacionIntroHeadline;

  /// Casework aportación wizard — intro body.
  ///
  /// In es, this message translates to:
  /// **'Este flujo te permite aportar documentación adicional a un expediente abierto en nombre de la persona interesada. Identifícate, localiza el expediente y adjunta los ficheros.'**
  String get caseworkAportacionIntroBody;

  /// Casework aportación wizard — restrictions section title.
  ///
  /// In es, this message translates to:
  /// **'Antes de continuar'**
  String get caseworkAportacionIntroRestrictionsTitle;

  /// Casework aportación wizard — restriction bullet 1.
  ///
  /// In es, this message translates to:
  /// **'Solo puedes aportar documentación a expedientes que estén abiertos.'**
  String get caseworkAportacionIntroRestriction1;

  /// Casework aportación wizard — restriction bullet 2.
  ///
  /// In es, this message translates to:
  /// **'Necesitas el número de expediente o el número de registro asociado.'**
  String get caseworkAportacionIntroRestriction2;

  /// Casework aportación wizard — restriction bullet 3.
  ///
  /// In es, this message translates to:
  /// **'Los ficheros aportados quedan vinculados a la persona interesada que indiques.'**
  String get caseworkAportacionIntroRestriction3;

  /// Casework aportación wizard — intro continue CTA.
  ///
  /// In es, this message translates to:
  /// **'Continuar'**
  String get caseworkAportacionIntroContinueCta;

  /// Casework aportación wizard — identification headline.
  ///
  /// In es, this message translates to:
  /// **'Identifica al interesado'**
  String get caseworkAportacionIdentificationHeadline;

  /// Casework aportación wizard — identification body.
  ///
  /// In es, this message translates to:
  /// **'Indica el tipo y número de documento de la persona titular del expediente.'**
  String get caseworkAportacionIdentificationBody;

  /// Casework aportación wizard — identification type label.
  ///
  /// In es, this message translates to:
  /// **'Tipo de documento'**
  String get caseworkAportacionIdentificationTypeLabel;

  /// Casework aportación wizard — identification type NIF.
  ///
  /// In es, this message translates to:
  /// **'NIF'**
  String get caseworkAportacionIdentificationTypeNif;

  /// Casework aportación wizard — identification type NIE.
  ///
  /// In es, this message translates to:
  /// **'NIE'**
  String get caseworkAportacionIdentificationTypeNie;

  /// Casework aportación wizard — identification type passport.
  ///
  /// In es, this message translates to:
  /// **'Pasaporte'**
  String get caseworkAportacionIdentificationTypePassport;

  /// Casework aportación wizard — identification type CIF.
  ///
  /// In es, this message translates to:
  /// **'CIF'**
  String get caseworkAportacionIdentificationTypeCif;

  /// Casework aportación wizard — identification number label.
  ///
  /// In es, this message translates to:
  /// **'Número de documento'**
  String get caseworkAportacionIdentificationNumberLabel;

  /// Casework aportación wizard — identification number hint.
  ///
  /// In es, this message translates to:
  /// **'Ej. 12345678A'**
  String get caseworkAportacionIdentificationNumberHint;

  /// Casework aportación wizard — identification next CTA.
  ///
  /// In es, this message translates to:
  /// **'Siguiente'**
  String get caseworkAportacionIdentificationNextCta;

  /// Casework aportación wizard — search headline.
  ///
  /// In es, this message translates to:
  /// **'Localiza el expediente'**
  String get caseworkAportacionSearchHeadline;

  /// Casework aportación wizard — search body.
  ///
  /// In es, this message translates to:
  /// **'Busca por número de expediente o número de registro asociado.'**
  String get caseworkAportacionSearchBody;

  /// Casework aportación wizard — search tab expediente.
  ///
  /// In es, this message translates to:
  /// **'Por nº de expediente'**
  String get caseworkAportacionSearchTabExpediente;

  /// Casework aportación wizard — search tab registro.
  ///
  /// In es, this message translates to:
  /// **'Por nº de registro'**
  String get caseworkAportacionSearchTabRegistro;

  /// Casework aportación wizard — search expediente label.
  ///
  /// In es, this message translates to:
  /// **'Número de expediente'**
  String get caseworkAportacionSearchExpedienteLabel;

  /// Casework aportación wizard — search expediente hint.
  ///
  /// In es, this message translates to:
  /// **'Ej. EXP/2025/00123'**
  String get caseworkAportacionSearchExpedienteHint;

  /// Casework aportación wizard — search registro label.
  ///
  /// In es, this message translates to:
  /// **'Número de registro'**
  String get caseworkAportacionSearchRegistroLabel;

  /// Casework aportación wizard — search registro hint.
  ///
  /// In es, this message translates to:
  /// **'Ej. REG/E/45612'**
  String get caseworkAportacionSearchRegistroHint;

  /// Casework aportación wizard — search submit CTA.
  ///
  /// In es, this message translates to:
  /// **'Buscar'**
  String get caseworkAportacionSearchSubmitCta;

  /// Casework aportación wizard — invalid identification failure.
  ///
  /// In es, this message translates to:
  /// **'El número de documento no es válido para el tipo seleccionado.'**
  String get caseworkAportacionFailureInvalidIdentification;

  /// Casework aportación wizard — not found failure.
  ///
  /// In es, this message translates to:
  /// **'No hemos encontrado ningún expediente con esos datos.'**
  String get caseworkAportacionFailureNotFound;

  /// Casework aportación wizard — network failure.
  ///
  /// In es, this message translates to:
  /// **'No hemos podido completar la búsqueda. Inténtalo de nuevo más tarde.'**
  String get caseworkAportacionFailureNetworkError;

  /// Casework aportación wizard — completion headline.
  ///
  /// In es, this message translates to:
  /// **'Aportación enviada'**
  String get caseworkAportacionCompleteHeadline;

  /// Casework aportación wizard — completion body.
  ///
  /// In es, this message translates to:
  /// **'La documentación se ha aportado correctamente al expediente {expediente}. Conserva el justificante por si necesitas consultarlo.'**
  String caseworkAportacionCompleteBody(String expediente);

  /// Casework aportación wizard — back to workspace CTA.
  ///
  /// In es, this message translates to:
  /// **'Volver a Mis gestiones'**
  String get caseworkAportacionCompleteHomeCta;

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

  /// Notifications detail (STORY-43) — título del AppBar de la pantalla de detalle.
  ///
  /// In es, this message translates to:
  /// **'Detalle de notificación'**
  String get notificationDetailTitle;

  /// Notifications detail (STORY-43) — mensaje del estado de carga.
  ///
  /// In es, this message translates to:
  /// **'Cargando notificación…'**
  String get notificationDetailLoading;

  /// Notifications detail (STORY-43) — mensaje del estado de error al cargar el detalle.
  ///
  /// In es, this message translates to:
  /// **'No hemos podido cargar el detalle de la notificación.'**
  String get notificationDetailErrorMessage;

  /// Notifications detail (STORY-43) — etiqueta del botón de reintento del estado de error.
  ///
  /// In es, this message translates to:
  /// **'Reintentar'**
  String get notificationDetailRetry;

  /// Notifications detail (STORY-43) — línea de cabecera con el organismo emisor.
  ///
  /// In es, this message translates to:
  /// **'Emitida por: {organismo}'**
  String notificationDetailHeaderOrganismo(String organismo);

  /// Notifications detail (STORY-43) — línea de cabecera con la fecha de emisión.
  ///
  /// In es, this message translates to:
  /// **'Fecha de emisión: {date}'**
  String notificationDetailHeaderEmittedOn(String date);

  /// Notifications detail (STORY-43) — fila de metadatos con la referencia del expediente.
  ///
  /// In es, this message translates to:
  /// **'Expediente: {ref}'**
  String notificationDetailHeaderExpediente(String ref);

  /// Notifications detail (STORY-43) — fila de metadatos con el procedimiento administrativo.
  ///
  /// In es, this message translates to:
  /// **'Procedimiento: {procedimiento}'**
  String notificationDetailHeaderProcedimiento(String procedimiento);

  /// Notifications detail (STORY-43) — fila de metadatos con la fecha límite para aceptar o rechazar.
  ///
  /// In es, this message translates to:
  /// **'Plazo límite para decidir: {date}'**
  String notificationDetailHeaderDeadline(String date);

  /// Notifications detail (STORY-43) — título de la sección de descripción.
  ///
  /// In es, this message translates to:
  /// **'Descripción'**
  String get notificationDetailDescriptionTitle;

  /// Notifications detail (STORY-43) — CTA principal de la barra de decisión.
  ///
  /// In es, this message translates to:
  /// **'Aceptar'**
  String get notificationDetailAcceptCta;

  /// Notifications detail (STORY-43) — CTA secundaria de la barra de decisión.
  ///
  /// In es, this message translates to:
  /// **'Rechazar'**
  String get notificationDetailRejectCta;

  /// Notifications detail (STORY-43) — título del diálogo de confirmación de rechazo.
  ///
  /// In es, this message translates to:
  /// **'Confirmar rechazo'**
  String get notificationDetailRejectDialogTitle;

  /// Notifications detail (STORY-43) — cuerpo del diálogo de confirmación de rechazo.
  ///
  /// In es, this message translates to:
  /// **'Si rechazas esta notificación, la administración tendrá constancia formal del rechazo y la notificación se considerará practicada. Esta acción es irreversible.'**
  String get notificationDetailRejectDialogBody;

  /// Notifications detail (STORY-43) — CTA destructiva del diálogo de confirmación de rechazo.
  ///
  /// In es, this message translates to:
  /// **'Rechazar definitivamente'**
  String get notificationDetailRejectDialogConfirm;

  /// Notifications detail (STORY-43) — CTA neutra del diálogo de confirmación de rechazo.
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get notificationDetailRejectDialogCancel;

  /// Notifications detail (STORY-43) — snackbar mostrado tras aceptar correctamente la notificación.
  ///
  /// In es, this message translates to:
  /// **'Has aceptado la notificación.'**
  String get notificationDetailDecisionAcceptedToast;

  /// Notifications detail (STORY-43) — snackbar mostrado tras rechazar correctamente la notificación.
  ///
  /// In es, this message translates to:
  /// **'Has rechazado la notificación.'**
  String get notificationDetailDecisionRejectedToast;

  /// Notifications detail (STORY-43) — snackbar mostrado cuando el backend reporta un conflicto (ya decidida o caducada).
  ///
  /// In es, this message translates to:
  /// **'Esta notificación ya no admite cambios. Hemos actualizado su estado.'**
  String get notificationDetailConflictToast;

  /// Notifications detail (STORY-43) — mensaje del overlay de carga mientras se envía la decisión.
  ///
  /// In es, this message translates to:
  /// **'Enviando tu decisión…'**
  String get notificationDetailDecisionInFlight;

  /// Notifications detail (STORY-44) — leyenda mostrada en la cabecera cuando la notificación tiene fecha de lectura.
  ///
  /// In es, this message translates to:
  /// **'Leída el {date}'**
  String notificationDetailReadOn(String date);

  /// Notifications detail (STORY-44) — título de la sección de documentos en variantes no pendientes.
  ///
  /// In es, this message translates to:
  /// **'Documentos asociados'**
  String get notificationDetailDocumentsTitle;

  /// Notifications detail (STORY-44) — empty state cuando la notificación no tiene documentos (por ejemplo, caducada).
  ///
  /// In es, this message translates to:
  /// **'No hay documentos asociados a esta notificación.'**
  String get notificationDetailDocumentsEmpty;

  /// Notifications detail (STORY-44) — tooltip / etiqueta del botón de descarga de un documento.
  ///
  /// In es, this message translates to:
  /// **'Descargar documento'**
  String get notificationDetailDocumentDownload;

  /// Notifications detail (STORY-44) — chip mostrado en documentos reconocidos pero no descargables.
  ///
  /// In es, this message translates to:
  /// **'No disponible'**
  String get notificationDetailDocumentUnavailableChip;

  /// Notifications detail (STORY-44) — etiqueta de tamaño de documento expresado en kilobytes.
  ///
  /// In es, this message translates to:
  /// **'{kb} KB'**
  String notificationDetailDocumentSizeKb(num kb);

  /// Notifications detail (STORY-44) — etiqueta de tamaño de documento expresado en megabytes.
  ///
  /// In es, this message translates to:
  /// **'{mb} MB'**
  String notificationDetailDocumentSizeMb(num mb);

  /// Notifications detail (STORY-44) — etiqueta de tamaño cuando el backend no informa los bytes.
  ///
  /// In es, this message translates to:
  /// **'Tamaño desconocido'**
  String get notificationDetailDocumentSizeUnknown;

  /// Notifications detail (STORY-44) — snackbar tras una descarga correcta.
  ///
  /// In es, this message translates to:
  /// **'Documento listo'**
  String get notificationDetailDocumentDownloadSuccessToast;

  /// Notifications detail (STORY-44) — snackbar cuando el backend reconoce el documento pero no lo entrega.
  ///
  /// In es, this message translates to:
  /// **'Documento no disponible'**
  String get notificationDetailDocumentDownloadUnavailableToast;

  /// Notifications detail (STORY-44) — snackbar de error genérico al fallar la descarga.
  ///
  /// In es, this message translates to:
  /// **'No se pudo descargar el documento'**
  String get notificationDetailDocumentDownloadErrorToast;

  /// Notifications detail (STORY-44) — mensaje de cabecera para la variante aceptada.
  ///
  /// In es, this message translates to:
  /// **'Has aceptado esta notificación. Puedes consultar los documentos asociados.'**
  String get notificationDetailVariantAceptadaBanner;

  /// Notifications detail (STORY-44) — mensaje de cabecera para la variante rechazada.
  ///
  /// In es, this message translates to:
  /// **'Has rechazado esta notificación. Conservas el acuse de rechazo.'**
  String get notificationDetailVariantRechazadaBanner;

  /// Notifications detail (STORY-44) — mensaje de cabecera para la variante caducada.
  ///
  /// In es, this message translates to:
  /// **'El plazo para decidir sobre esta notificación ha caducado.'**
  String get notificationDetailVariantCaducadaBanner;

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

  /// Digital cards exporter — label for the open-with-system-viewer action.
  ///
  /// In es, this message translates to:
  /// **'Abrir'**
  String get walletActionOpen;

  /// Digital cards exporter — label for the share-sheet action.
  ///
  /// In es, this message translates to:
  /// **'Compartir'**
  String get walletActionShare;

  /// Digital cards exporter — label for the Apple/Google Wallet action.
  ///
  /// In es, this message translates to:
  /// **'Añadir a Wallet'**
  String get walletActionAddToWallet;

  /// Digital cards exporter — placeholder caption for a PDF preview tile.
  ///
  /// In es, this message translates to:
  /// **'Documento PDF'**
  String get walletPreviewPdfPlaceholder;

  /// Digital cards exporter — placeholder caption for a PKPass preview tile.
  ///
  /// In es, this message translates to:
  /// **'Pase para Wallet'**
  String get walletPreviewPkpassPlaceholder;

  /// Digital cards exporter — fallback message when the QR image bytes are missing.
  ///
  /// In es, this message translates to:
  /// **'Vista previa del QR no disponible'**
  String get walletPreviewQrUnavailable;

  /// Digital cards exporter — accessibility label for the QR image preview.
  ///
  /// In es, this message translates to:
  /// **'Imagen del código QR'**
  String get walletPreviewQrImageSemantic;

  /// Digital cards exporter — accessibility label for the QR textual preview.
  ///
  /// In es, this message translates to:
  /// **'Contenido del código QR en texto'**
  String get walletPreviewQrTextSemantic;

  /// Digital cards exporter — error shown when the binary fails magic / size validation.
  ///
  /// In es, this message translates to:
  /// **'El archivo recibido no es válido. Inténtalo de nuevo.'**
  String get walletErrorInvalidArtifact;

  /// Digital cards exporter — error shown when an OS-level operation fails.
  ///
  /// In es, this message translates to:
  /// **'No hemos podido completar la acción. Inténtalo de nuevo.'**
  String get walletErrorSystem;

  /// Digital cards exporter — error shown when no platform capability matches the request.
  ///
  /// In es, this message translates to:
  /// **'Esta acción no está disponible en tu dispositivo.'**
  String get walletErrorNoCapability;

  /// Digital cards exporter — error shown when the payload has zero bytes.
  ///
  /// In es, this message translates to:
  /// **'El archivo está vacío.'**
  String get walletErrorEmptyPayload;

  /// Digital cards exporter — error shown when the payload exceeds the safety threshold.
  ///
  /// In es, this message translates to:
  /// **'El archivo supera el tamaño permitido.'**
  String get walletErrorTooLarge;

  /// Digital cards exporter — error shown when the source variant is unsupported / unavailable.
  ///
  /// In es, this message translates to:
  /// **'El formato recibido no es compatible.'**
  String get walletErrorUnsupportedSource;

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

  /// Signature — toast no bloqueante mostrado tras lanzar el handoff externo a Afirma.
  ///
  /// In es, this message translates to:
  /// **'Te hemos llevado a Afirma. Vuelve aquí cuando termines.'**
  String get signatureHandoffPendingToast;

  /// Signature — toast mostrado cuando el deep-link de retorno confirma firma exitosa.
  ///
  /// In es, this message translates to:
  /// **'Documento firmado'**
  String get signatureHandoffSignedToast;

  /// Signature — toast mostrado cuando el deep-link de retorno indica cancelación por el ciudadano.
  ///
  /// In es, this message translates to:
  /// **'Has cancelado la firma.'**
  String get signatureHandoffCancelledToast;

  /// Signature — toast mostrado cuando el deep-link de retorno indica error en Afirma.
  ///
  /// In es, this message translates to:
  /// **'No hemos podido completar la firma. Inténtalo de nuevo.'**
  String get signatureHandoffErrorToast;

  /// Signature — toast mostrado cuando el SO rechaza abrir el navegador / Afirma.
  ///
  /// In es, this message translates to:
  /// **'No hemos podido abrir Afirma. Inténtalo de nuevo.'**
  String get signatureHandoffLaunchFailedToast;

  /// Signature — título de la pantalla intermedia que recibe el deep-link de retorno de Afirma.
  ///
  /// In es, this message translates to:
  /// **'Volviendo de Afirma'**
  String get signatureAfirmaReturnTitle;

  /// Signature — texto de la pantalla intermedia mientras se interpreta el resultado del deep-link.
  ///
  /// In es, this message translates to:
  /// **'Procesando firma…'**
  String get signatureAfirmaReturnProcessing;

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

  /// Familia numerosa detail page — AppBar title.
  ///
  /// In es, this message translates to:
  /// **'Familia numerosa'**
  String get familiaNumerosaDetailTitle;

  /// Familia numerosa detail — título del panel informativo.
  ///
  /// In es, this message translates to:
  /// **'Sobre Familia numerosa'**
  String get familiaNumerosaInfoSheetTitle;

  /// Familia numerosa detail — descripción del panel informativo.
  ///
  /// In es, this message translates to:
  /// **'Consulta los datos de tu título de familia numerosa.'**
  String get familiaNumerosaInfoSheetDescription;

  /// Familia numerosa detail — sección de datos del título.
  ///
  /// In es, this message translates to:
  /// **'Mi título de familia numerosa'**
  String get familiaNumerosaTitleSection;

  /// Familia numerosa detail — etiqueta de comunidad autónoma.
  ///
  /// In es, this message translates to:
  /// **'Comunidad autónoma'**
  String get familiaNumerosaRegionLabel;

  /// Familia numerosa detail — etiqueta de número de título.
  ///
  /// In es, this message translates to:
  /// **'Número de título'**
  String get familiaNumerosaTitleNumberLabel;

  /// Familia numerosa detail — etiqueta de categoría.
  ///
  /// In es, this message translates to:
  /// **'Categoría'**
  String get familiaNumerosaCategoryLabel;

  /// Familia numerosa detail — etiqueta de vigencia.
  ///
  /// In es, this message translates to:
  /// **'Vigente'**
  String get familiaNumerosaValidLabel;

  /// Familia numerosa detail — etiqueta de fecha de expedición.
  ///
  /// In es, this message translates to:
  /// **'Fecha de expedición'**
  String get familiaNumerosaIssueDateLabel;

  /// Familia numerosa detail — etiqueta de fecha de caducidad.
  ///
  /// In es, this message translates to:
  /// **'Fecha de caducidad'**
  String get familiaNumerosaExpiryDateLabel;

  /// Familia numerosa detail — etiqueta de número de hijos/as.
  ///
  /// In es, this message translates to:
  /// **'Número de hijos/as del título'**
  String get familiaNumerosaChildrenCountLabel;

  /// Familia numerosa detail — sección de beneficiarios/as.
  ///
  /// In es, this message translates to:
  /// **'Beneficiarios/as'**
  String get familiaNumerosaBeneficiariesTitle;

  /// Familia numerosa detail — título numerado de beneficiario/a.
  ///
  /// In es, this message translates to:
  /// **'Beneficiario/a {index}'**
  String familiaNumerosaBeneficiaryTitle(int index);

  /// Familia numerosa detail — etiqueta de documento de beneficiario/a.
  ///
  /// In es, this message translates to:
  /// **'Número de documento'**
  String get familiaNumerosaDocumentNumberLabel;

  /// Familia numerosa detail — etiqueta de fecha de nacimiento.
  ///
  /// In es, this message translates to:
  /// **'Fecha de nacimiento'**
  String get familiaNumerosaBirthDateLabel;

  /// Familia numerosa detail — etiqueta de nombre completo.
  ///
  /// In es, this message translates to:
  /// **'Nombre y apellidos'**
  String get familiaNumerosaFullNameLabel;

  /// Familia numerosa detail — etiqueta de titular.
  ///
  /// In es, this message translates to:
  /// **'Titular'**
  String get familiaNumerosaHolderLabel;

  /// Familia numerosa detail — valor afirmativo.
  ///
  /// In es, this message translates to:
  /// **'Sí'**
  String get familiaNumerosaYes;

  /// Familia numerosa detail — valor negativo.
  ///
  /// In es, this message translates to:
  /// **'No'**
  String get familiaNumerosaNo;

  /// Familia numerosa detail — helper mostrado cuando no hay datos.
  ///
  /// In es, this message translates to:
  /// **'No hemos encontrado información de familia numerosa asociado a tus datos en el servicio de consulta de la JCCM.\n\nSi la situación no es correcta o no está actualizada, contacta con la Consejería de Bienestar Social de Castilla-La Mancha.'**
  String get familiaNumerosaNoDataMessage;

  /// Familia numerosa detail — helper bajo los datos.
  ///
  /// In es, this message translates to:
  /// **'Si alguno de tus datos no es correcto o no está actualizado, contacta con la Consejería de Bienestar Social de Castilla-La Mancha.'**
  String get familiaNumerosaContactHint;

  /// Familia numerosa detail — botón externo hacia oficinas y contactos.
  ///
  /// In es, this message translates to:
  /// **'Listado de oficinas y contactos'**
  String get familiaNumerosaOfficeContactsButton;

  /// Familia numerosa detail page — printed carnet number row.
  ///
  /// In es, this message translates to:
  /// **'Número de carnet: {number}'**
  String familiaNumerosaCardNumberLabel(String number);

  /// Familia numerosa categoría — general.
  ///
  /// In es, this message translates to:
  /// **'General'**
  String get familiaNumerosaCategoriaGeneral;

  /// Familia numerosa categoría — especial.
  ///
  /// In es, this message translates to:
  /// **'Especial'**
  String get familiaNumerosaCategoriaEspecial;

  /// Familia numerosa categoría — desconocida / no proyectada por el backend.
  ///
  /// In es, this message translates to:
  /// **'Sin clasificar'**
  String get familiaNumerosaCategoriaUnknown;

  /// Familia numerosa detail — expiry date row.
  ///
  /// In es, this message translates to:
  /// **'Caduca el {date}'**
  String familiaNumerosaExpiresOn(String date);

  /// Familia numerosa detail — members section header.
  ///
  /// In es, this message translates to:
  /// **'Miembros del carnet'**
  String get familiaNumerosaMembersTitle;

  /// Familia numerosa detail — fallback when a member has no name.
  ///
  /// In es, this message translates to:
  /// **'Sin nombre'**
  String get familiaNumerosaMemberFallbackName;

  /// Familia numerosa member parentesco — titular.
  ///
  /// In es, this message translates to:
  /// **'Titular'**
  String get familiaNumerosaParentescoTitular;

  /// Familia numerosa member parentesco — cónyuge.
  ///
  /// In es, this message translates to:
  /// **'Cónyuge'**
  String get familiaNumerosaParentescoConyuge;

  /// Familia numerosa member parentesco — hijo.
  ///
  /// In es, this message translates to:
  /// **'Hijo'**
  String get familiaNumerosaParentescoHijo;

  /// Familia numerosa member parentesco — hija.
  ///
  /// In es, this message translates to:
  /// **'Hija'**
  String get familiaNumerosaParentescoHija;

  /// Familia numerosa member parentesco — otro / sin clasificar.
  ///
  /// In es, this message translates to:
  /// **'Otro'**
  String get familiaNumerosaParentescoOtro;

  /// Familia numerosa detail — title shown when the citizen has no vigente carnet.
  ///
  /// In es, this message translates to:
  /// **'Carnet no disponible'**
  String get familiaNumerosaUnavailableTitle;

  /// Familia numerosa detail — body shown when the citizen has no vigente carnet.
  ///
  /// In es, this message translates to:
  /// **'Tu carnet de familia numerosa no está vigente o no se ha podido obtener.'**
  String get familiaNumerosaUnavailableMessage;

  /// Familia numerosa detail — generic error message.
  ///
  /// In es, this message translates to:
  /// **'No se ha podido cargar tu carnet de familia numerosa.'**
  String get familiaNumerosaErrorMessage;

  /// Familia numerosa detail — retry button label.
  ///
  /// In es, this message translates to:
  /// **'Reintentar'**
  String get familiaNumerosaRetry;

  /// Carnet Joven detail surface — AppBar / modal title.
  ///
  /// In es, this message translates to:
  /// **'Carnet Joven'**
  String get jovenDetailTitle;

  /// Carnet Joven detail — printed carnet code row.
  ///
  /// In es, this message translates to:
  /// **'Código: {code}'**
  String jovenCodigoLabel(String code);

  /// Carnet Joven detail — expiry date badge.
  ///
  /// In es, this message translates to:
  /// **'Vigente hasta el {date}'**
  String jovenExpiresOn(String date);

  /// Carnet Joven detail — descriptive subtitle under the hero card.
  ///
  /// In es, this message translates to:
  /// **'Acredita tu condición de persona joven y accede a descuentos en cultura, transporte y ocio en Castilla-La Mancha.'**
  String get jovenSubtitle;

  /// Carnet Joven detail — title shown when the citizen has no vigente carnet.
  ///
  /// In es, this message translates to:
  /// **'Carnet no disponible'**
  String get jovenUnavailableTitle;

  /// Carnet Joven detail — body shown when the citizen has no vigente carnet.
  ///
  /// In es, this message translates to:
  /// **'Tu Carnet Joven no está vigente o no se ha podido obtener.'**
  String get jovenUnavailableMessage;

  /// Carnet Joven detail — generic error message.
  ///
  /// In es, this message translates to:
  /// **'No se ha podido cargar tu Carnet Joven.'**
  String get jovenErrorMessage;

  /// Carnet Joven detail — retry button label.
  ///
  /// In es, this message translates to:
  /// **'Reintentar'**
  String get jovenRetry;

  /// Carnet Joven modal — accessibility label for the drag handle.
  ///
  /// In es, this message translates to:
  /// **'Arrastra para ajustar la ficha del Carnet Joven'**
  String get jovenModalDragHandleSemantic;

  /// Carnet Joven modal — close action label / tooltip.
  ///
  /// In es, this message translates to:
  /// **'Cerrar'**
  String get jovenModalCloseAction;

  /// Carnet Discapacidad detail — AppBar title.
  ///
  /// In es, this message translates to:
  /// **'Carnet de discapacidad'**
  String get discapacidadDetailTitle;

  /// Carnet Discapacidad detail — semantic / row label for the grado de discapacidad.
  ///
  /// In es, this message translates to:
  /// **'Grado de discapacidad'**
  String get discapacidadGradoLabel;

  /// Carnet Discapacidad detail — grado badge label.
  ///
  /// In es, this message translates to:
  /// **'{grado}%'**
  String discapacidadGradoBadge(int grado);

  /// Carnet Discapacidad detail — fallback shown when the grado is missing.
  ///
  /// In es, this message translates to:
  /// **'Grado no disponible'**
  String get discapacidadGradoUnknown;

  /// Carnet Discapacidad detail — expiry date row.
  ///
  /// In es, this message translates to:
  /// **'Vigente hasta el {date}'**
  String discapacidadExpiresOn(String date);

  /// Carnet Discapacidad detail — short "vigente" badge.
  ///
  /// In es, this message translates to:
  /// **'Vigente'**
  String get discapacidadValidBadge;

  /// Carnet Discapacidad detail — title shown when the carnet is no vigente.
  ///
  /// In es, this message translates to:
  /// **'Carnet no vigente'**
  String get discapacidadNotValidTitle;

  /// Carnet Discapacidad detail — body shown when the carnet is no vigente.
  ///
  /// In es, this message translates to:
  /// **'Tu carnet de discapacidad ya no está vigente. No se puede generar el pase para Wallet.'**
  String get discapacidadNotValidMessage;

  /// Carnet Discapacidad detail — title shown when no carnet data is available.
  ///
  /// In es, this message translates to:
  /// **'Sin datos disponibles'**
  String get discapacidadUnavailableTitle;

  /// Carnet Discapacidad detail — body shown when no carnet data is available.
  ///
  /// In es, this message translates to:
  /// **'No hemos encontrado información de tu carnet de discapacidad. Vuelve a intentarlo más tarde.'**
  String get discapacidadUnavailableMessage;

  /// Carnet Discapacidad detail — message shown on a payload-parse error.
  ///
  /// In es, this message translates to:
  /// **'No se ha podido interpretar la respuesta del carnet de discapacidad.'**
  String get discapacidadParseErrorMessage;

  /// Carnet Discapacidad detail — generic error message.
  ///
  /// In es, this message translates to:
  /// **'No se ha podido cargar tu carnet de discapacidad.'**
  String get discapacidadErrorMessage;

  /// Carnet Discapacidad detail — retry button label.
  ///
  /// In es, this message translates to:
  /// **'Reintentar'**
  String get discapacidadRetry;

  /// Carnet Discapacidad detail — PKPass action section label.
  ///
  /// In es, this message translates to:
  /// **'Añadir a Wallet'**
  String get discapacidadActionPkpass;

  /// Recommendations — app bar title for the citizen recommendations list.
  ///
  /// In es, this message translates to:
  /// **'Mis Recomendaciones'**
  String get recommendationsTitle;

  /// Recommendations — tab label for the unfiltered bucket.
  ///
  /// In es, this message translates to:
  /// **'Todos'**
  String get recommendationsTabAll;

  /// Recommendations — tab label for the recently published bucket.
  ///
  /// In es, this message translates to:
  /// **'Últimos días'**
  String get recommendationsTabRecent;

  /// Recommendations — tab label for the newly assigned bucket.
  ///
  /// In es, this message translates to:
  /// **'Novedades'**
  String get recommendationsTabNew;

  /// Recommendations — tab label for the immediate-processing bucket.
  ///
  /// In es, this message translates to:
  /// **'Trámite inmediato'**
  String get recommendationsTabImmediate;

  /// Recommendations — badge shown on cards flagged as immediate-processing.
  ///
  /// In es, this message translates to:
  /// **'Tramitación inmediata'**
  String get recommendationsImmediateBadge;

  /// Recommendations — prefix shown before the deadline label inside a card chip.
  ///
  /// In es, this message translates to:
  /// **'Plazo:'**
  String get recommendationsDeadlinePrefix;

  /// Recommendations — prefix shown before the responsible unit name inside a card chip.
  ///
  /// In es, this message translates to:
  /// **'Unidad:'**
  String get recommendationsResponsibleUnitPrefix;

  /// Recommendations — prefix shown before the life event label inside a card chip.
  ///
  /// In es, this message translates to:
  /// **'Hecho vital:'**
  String get recommendationsLifeEventPrefix;

  /// Recommendations — label shown above the life events associated with a recommendation card.
  ///
  /// In es, this message translates to:
  /// **'Hechos vitales asociados'**
  String get recommendationsAssociatedLifeEventsLabel;

  /// Recommendations — load-more button label at the bottom of the list.
  ///
  /// In es, this message translates to:
  /// **'Ver más'**
  String get recommendationsLoadMore;

  /// Recommendations — STORY-57 onboarding empty state title shown when the citizen has not selected any life event yet.
  ///
  /// In es, this message translates to:
  /// **'Aún no tienes recomendaciones personalizadas'**
  String get recommendationsEmptyUnconfiguredTitle;

  /// Recommendations — STORY-57 onboarding empty state body explaining the value of selecting life events.
  ///
  /// In es, this message translates to:
  /// **'Cuéntanos en qué momento vital estás para sugerirte trámites y servicios relevantes.'**
  String get recommendationsEmptyUnconfiguredBody;

  /// Recommendations — STORY-57 onboarding empty state primary CTA navigating to the preferences/consent surface.
  ///
  /// In es, this message translates to:
  /// **'Configurar mis preferencias'**
  String get recommendationsEmptyUnconfiguredPrimaryCta;

  /// Recommendations — STORY-57 onboarding empty state secondary CTA. The dedicated 'Mis hechos vitales' route does not exist yet, so the page shows a SnackBar fallback.
  ///
  /// In es, this message translates to:
  /// **'Ver mis hechos vitales'**
  String get recommendationsEmptyUnconfiguredSecondaryCta;

  /// Recommendations — STORY-57 unauthorised empty state title shown when the citizen has preferences but the consent is missing.
  ///
  /// In es, this message translates to:
  /// **'Falta autorizar tus preferencias'**
  String get recommendationsEmptyUnauthorisedTitle;

  /// Recommendations — STORY-57 unauthorised empty state body explaining the missing consent.
  ///
  /// In es, this message translates to:
  /// **'Para mostrarte recomendaciones personalizadas necesitamos tu autorización para tratar tus datos.'**
  String get recommendationsEmptyUnauthorisedBody;

  /// Recommendations — STORY-57 unauthorised empty state primary CTA navigating to the consent surface.
  ///
  /// In es, this message translates to:
  /// **'Revisar consentimientos'**
  String get recommendationsEmptyUnauthorisedPrimaryCta;

  /// Recommendations — STORY-57 configured-but-empty title shown when the citizen is fully configured but the backend has no matches for the selected filter.
  ///
  /// In es, this message translates to:
  /// **'Todo listo, sin novedades por ahora'**
  String get recommendationsEmptyConfiguredTitle;

  /// Recommendations — STORY-57 configured-but-empty body explaining why the list is empty.
  ///
  /// In es, this message translates to:
  /// **'Cuando tengamos nuevas recomendaciones para ti las verás aquí. Prueba con otros filtros mientras tanto.'**
  String get recommendationsEmptyConfiguredBody;

  /// Recommendations — STORY-57 configured-but-empty secondary CTA that switches the active tab back to 'Todos'.
  ///
  /// In es, this message translates to:
  /// **'Ver todos'**
  String get recommendationsEmptyConfiguredSecondaryCta;

  /// Recommendations — STORY-57 SnackBar shown when tapping the 'Ver mis hechos vitales' secondary CTA before that surface ships.
  ///
  /// In es, this message translates to:
  /// **'Mis hechos vitales estará disponible próximamente'**
  String get recommendationsLifeEventsComingSoon;

  /// Recommendations — generic error message when the list cannot be loaded.
  ///
  /// In es, this message translates to:
  /// **'No hemos podido cargar las recomendaciones.'**
  String get recommendationsLoadingError;

  /// Recommendations — retry button label in the error state.
  ///
  /// In es, this message translates to:
  /// **'Reintentar'**
  String get recommendationsLoadingErrorRetry;

  /// Recommendations — SnackBar shown when a card has no detail URI or the URL launcher fails.
  ///
  /// In es, this message translates to:
  /// **'Detalle disponible próximamente'**
  String get recommendationsDetailUnavailable;

  /// STORY-65 — default advisory message displayed by the OfflineBanner when connectivity is reported as offline; adopters keep showing cached data underneath.
  ///
  /// In es, this message translates to:
  /// **'Sin conexión. Mostrando datos guardados.'**
  String get offlineBannerMessage;

  /// Accessibility — semantic label for the sticky bottom action bar.
  ///
  /// In es, this message translates to:
  /// **'Acciones principales'**
  String get a11yStickybarLabel;

  /// Accessibility — semantic H1 label for the landing splash screen.
  ///
  /// In es, this message translates to:
  /// **'Espacio Ciudadano de Castilla-La Mancha'**
  String get a11yLandingH1Label;

  /// Accessibility — semantic label for the institutional Castilla-La Mancha logo.
  ///
  /// In es, this message translates to:
  /// **'Logotipo de la Junta de Comunidades de Castilla-La Mancha'**
  String get a11yCastillaLogoLabel;

  /// Accessibility — announced by screen reader when a loading state starts.
  ///
  /// In es, this message translates to:
  /// **'Cargando'**
  String get a11yLoading;

  /// Accessibility — announced by screen reader when loading finishes.
  ///
  /// In es, this message translates to:
  /// **'Contenido cargado'**
  String get a11yContentLoaded;

  /// Etiqueta del ítem de Preferencias en el menú desplegable del perfil.
  ///
  /// In es, this message translates to:
  /// **'Preferencias'**
  String get drawerPreferences;

  /// Etiqueta del ítem de Ayuda y Contacto en la sección secundaria del menú de perfil.
  ///
  /// In es, this message translates to:
  /// **'Ayuda y Contacto'**
  String get drawerHelpAndContact;

  /// Botón de acción del menú de perfil que enlaza con la Sede Electrónica.
  ///
  /// In es, this message translates to:
  /// **'Ir a Sede Electrónica'**
  String get drawerGoToSedeElectronica;

  /// Título de la sección Mis datos en la barra superior y navegación principal.
  ///
  /// In es, this message translates to:
  /// **'Mis datos'**
  String get myDataTitle;

  /// Texto introductorio de la pantalla Mis datos.
  ///
  /// In es, this message translates to:
  /// **'Consulta tu información disponible en la Administración y accede a servicios y trámites asociados a cada área.'**
  String get myDataIntro;

  /// Título de la tarjeta de Salud en la pantalla Mis datos.
  ///
  /// In es, this message translates to:
  /// **'Salud'**
  String get myDataHealthTitle;

  /// Descripción de la tarjeta de Salud en la pantalla Mis datos.
  ///
  /// In es, this message translates to:
  /// **'SESCAM y servicios de salud'**
  String get myDataHealthDescription;

  /// Título de la tarjeta de Bienestar Social en la pantalla Mis datos.
  ///
  /// In es, this message translates to:
  /// **'Bienestar Social'**
  String get myDataSocialWelfareTitle;

  /// Descripción de la tarjeta de Bienestar Social en la pantalla Mis datos.
  ///
  /// In es, this message translates to:
  /// **'Servicios disponibles'**
  String get myDataSocialWelfareDescription;

  /// Título de la tarjeta de Empleo en la pantalla Mis datos.
  ///
  /// In es, this message translates to:
  /// **'Empleo'**
  String get myDataEmploymentTitle;

  /// Descripción de la tarjeta de Empleo en la pantalla Mis datos.
  ///
  /// In es, this message translates to:
  /// **'Demanda y servicios de empleo'**
  String get myDataEmploymentDescription;

  /// Título del modal informativo de Mis datos de Empleo.
  ///
  /// In es, this message translates to:
  /// **'Sobre Mis datos de Empleo'**
  String get myDataEmploymentInfoSheetTitle;

  /// Descripción principal del modal informativo de Mis datos de Empleo.
  ///
  /// In es, this message translates to:
  /// **'Consulta tu situación actual como demandante de empleo y tus últimas inscripciones en ofertas.'**
  String get myDataEmploymentInfoSheetDescription;

  /// Texto de contacto del modal informativo de Mis datos de Empleo.
  ///
  /// In es, this message translates to:
  /// **'Si tus datos como demandante de empleo no son correctos, contacta con Servicio Público de Empleo Estatal (SEPE).'**
  String get myDataEmploymentInfoSheetFooter;

  /// Botón externo hacia oficinas y contactos en el modal informativo de Mis datos de Empleo.
  ///
  /// In es, this message translates to:
  /// **'Listado de oficinas y contactos'**
  String get myDataEmploymentInfoSheetOfficeContactsButton;

  /// Primera pestaña del detalle de Empleo.
  ///
  /// In es, this message translates to:
  /// **'Mis datos de Empleo'**
  String get myDataEmploymentDataTab;

  /// Segunda pestaña del detalle de Empleo.
  ///
  /// In es, this message translates to:
  /// **'Información y servicios'**
  String get myDataEmploymentServicesTab;

  /// Título de la tarjeta de demanda de empleo.
  ///
  /// In es, this message translates to:
  /// **'Tu demanda de empleo'**
  String get myDataEmploymentDemandTitle;

  /// Etiqueta de la fecha de inscripción sin interrupciones.
  ///
  /// In es, this message translates to:
  /// **'Fecha de inscripción sin interrupciones'**
  String get myDataEmploymentRegistrationDateLabel;

  /// Mensaje mostrado cuando no hay datos de demanda de empleo.
  ///
  /// In es, this message translates to:
  /// **'No constan datos de demanda de empleo.'**
  String get myDataEmploymentDemandEmpty;

  /// Mensaje de error al cargar la demanda de empleo.
  ///
  /// In es, this message translates to:
  /// **'No hemos podido cargar tu demanda de empleo.'**
  String get myDataEmploymentDemandError;

  /// Título del banner mostrado cuando el servicio de demanda de empleo no está disponible.
  ///
  /// In es, this message translates to:
  /// **'Servicio no disponible'**
  String get myDataEmploymentServiceUnavailableTitle;

  /// Mensaje del banner mostrado cuando el servicio de demanda de empleo no está disponible.
  ///
  /// In es, this message translates to:
  /// **'El servicio de Demanda de empleo actualmente no está disponible. Puedes recargar la información o intentarlo de nuevo más tarde.'**
  String get myDataEmploymentServiceUnavailableMessage;

  /// Etiqueta del botón para recargar la demanda de empleo cuando el servicio no está disponible.
  ///
  /// In es, this message translates to:
  /// **'Recargar página'**
  String get myDataEmploymentServiceUnavailableReload;

  /// Mensaje del helper contextual mostrado cuando el servicio de inscripciones en ofertas no está disponible.
  ///
  /// In es, this message translates to:
  /// **'El servicio de inscripciones en ofertas actualmente no está disponible. Puedes recargar la información o intentarlo de nuevo más tarde.'**
  String get myDataEmploymentOffersServiceUnavailableMessage;

  /// Título del diálogo mostrado cuando faltan autorizaciones para ver inscripciones en ofertas.
  ///
  /// In es, this message translates to:
  /// **'No has autorizado la consulta de datos en tu perfil'**
  String get myDataEmploymentAuthorizationDialogTitle;

  /// Cuerpo del diálogo mostrado cuando faltan autorizaciones para ver inscripciones en ofertas.
  ///
  /// In es, this message translates to:
  /// **'Para visualizar tus inscripciones en ofertas, debes autorizar primero la consulta de los datos en “Condiciones de uso y autorizaciones” en tu perfil.'**
  String get myDataEmploymentAuthorizationDialogBody;

  /// CTA del diálogo para ir a la pantalla de condiciones de uso y autorizaciones.
  ///
  /// In es, this message translates to:
  /// **'Ir a Condiciones de uso y autorizaciones'**
  String get myDataEmploymentAuthorizationDialogAuthorizationsCta;

  /// Botón para cerrar el diálogo de autorización de inscripciones en ofertas.
  ///
  /// In es, this message translates to:
  /// **'Volver'**
  String get myDataEmploymentAuthorizationDialogBack;

  /// Título de la tarjeta de inscripciones en ofertas.
  ///
  /// In es, this message translates to:
  /// **'Inscripciones en ofertas'**
  String get myDataEmploymentOffersTitle;

  /// Descripción de la tarjeta de inscripciones en ofertas.
  ///
  /// In es, this message translates to:
  /// **'Ofertas de empleo en las que te has inscrito'**
  String get myDataEmploymentOffersDescription;

  /// Título de la pantalla de inscripciones en ofertas de empleo.
  ///
  /// In es, this message translates to:
  /// **'Inscripción en ofertas de empleo'**
  String get myDataEmploymentOffersPageTitle;

  /// Descripción del modal informativo de la pantalla de inscripciones en ofertas.
  ///
  /// In es, this message translates to:
  /// **'Consulta las ofertas de empleo en las que te has inscrito y el estado de tu candidatura.'**
  String get myDataEmploymentOffersInfoSheetDescription;

  /// Mensaje mostrado cuando no hay inscripciones en ofertas.
  ///
  /// In es, this message translates to:
  /// **'Aún no te has inscrito a ninguna oferta. Si consideras que no es correcto o no está actualizado, contacta con el servicio de Lirem ipsum'**
  String get myDataEmploymentOffersEmptyMessage;

  /// Mensaje de error al cargar inscripciones en ofertas.
  ///
  /// In es, this message translates to:
  /// **'No hemos podido cargar tus inscripciones en ofertas.'**
  String get myDataEmploymentOffersLoadError;

  /// Etiqueta de fecha de publicación de una oferta.
  ///
  /// In es, this message translates to:
  /// **'Fecha publicación'**
  String get myDataEmploymentOfferPublicationDateLabel;

  /// Etiqueta de fecha de inscripción a una oferta.
  ///
  /// In es, this message translates to:
  /// **'Fecha inscripción'**
  String get myDataEmploymentOfferRegistrationDateLabel;

  /// Etiqueta de fecha de finalización del proceso de selección de una oferta.
  ///
  /// In es, this message translates to:
  /// **'Fecha de finalización del proceso de selección'**
  String get myDataEmploymentOfferSelectionEndDateLabel;

  /// Etiqueta del estado de candidatura de una oferta.
  ///
  /// In es, this message translates to:
  /// **'Estado candidatura'**
  String get myDataEmploymentOfferApplicationStatusLabel;

  /// Título de la sección de trámites de empleo.
  ///
  /// In es, this message translates to:
  /// **'Trámites que te pueden interesar'**
  String get myDataEmploymentProceduresTitle;

  /// Trámite de expedición de certificado de profesionalidad.
  ///
  /// In es, this message translates to:
  /// **'Expedición certificado de profesionalidad'**
  String get myDataEmploymentProcedureProfessionalCertificate;

  /// Trámite de inscripción como demandante de empleo.
  ///
  /// In es, this message translates to:
  /// **'Inscripción como demandante de personas trabajadoras en oficinas de empleo y emprendedores'**
  String get myDataEmploymentProcedureJobSeekerRegistration;

  /// Trámite de solicitud de credenciales de la oficina virtual de empleo.
  ///
  /// In es, this message translates to:
  /// **'Solicitud de credenciales de acceso a la oficina virtual de la consejería de empleo y economía para personas físicas, jurídicas y autónomos.'**
  String get myDataEmploymentProcedureVirtualOfficeCredentials;

  /// Título de la sección de enlaces de interés de empleo.
  ///
  /// In es, this message translates to:
  /// **'Enlaces de interés'**
  String get myDataEmploymentInterestLinksTitle;

  /// Enlace al portal Empleo CLM.
  ///
  /// In es, this message translates to:
  /// **'Empleo CLM'**
  String get myDataEmploymentLinkEmploymentClm;

  /// Enlace al portal Empleo Público CLM.
  ///
  /// In es, this message translates to:
  /// **'Empleo Público CLM'**
  String get myDataEmploymentLinkPublicEmploymentClm;

  /// Título de la tarjeta de Educación en la pantalla Mis datos.
  ///
  /// In es, this message translates to:
  /// **'Educación'**
  String get myDataEducationTitle;

  /// Descripción de la tarjeta de Educación en la pantalla Mis datos.
  ///
  /// In es, this message translates to:
  /// **'Titulos formativos'**
  String get myDataEducationDescription;

  /// Título de la tarjeta de Vivienda en la pantalla Mis datos.
  ///
  /// In es, this message translates to:
  /// **'Vivienda'**
  String get myDataHousingTitle;

  /// Descripción de la tarjeta de Vivienda en la pantalla Mis datos.
  ///
  /// In es, this message translates to:
  /// **'Titularidad de bienes inmueble'**
  String get myDataHousingDescription;

  /// Título del modal informativo de Mis datos de Vivienda.
  ///
  /// In es, this message translates to:
  /// **'Sobre Mis datos de Vivienda'**
  String get myDataHousingInfoSheetTitle;

  /// Descripción principal del modal informativo de Mis datos de Vivienda.
  ///
  /// In es, this message translates to:
  /// **'Consulta la información de tus bienes inmuebles, tu vivienda y los datos de tu domicilio actual.'**
  String get myDataHousingInfoSheetDescription;

  /// Primera pestaña del detalle de Vivienda.
  ///
  /// In es, this message translates to:
  /// **'Mis datos de Vivienda'**
  String get myDataHousingDataTab;

  /// Segunda pestaña del detalle de Vivienda.
  ///
  /// In es, this message translates to:
  /// **'Información y servicios'**
  String get myDataHousingServicesTab;

  /// Título de la tarjeta de bienes inmuebles en el detalle de Vivienda.
  ///
  /// In es, this message translates to:
  /// **'Bienes inmuebles'**
  String get myDataHousingRealEstateTitle;

  /// Descripción de la tarjeta de bienes inmuebles en el detalle de Vivienda.
  ///
  /// In es, this message translates to:
  /// **'Datos catastrales de mis inmuebles'**
  String get myDataHousingRealEstateDescription;

  /// Título del modal informativo de bienes inmuebles.
  ///
  /// In es, this message translates to:
  /// **'Sobre Bienes Inmuebles'**
  String get myDataHousingRealEstateInfoSheetTitle;

  /// Descripción principal del modal informativo de bienes inmuebles.
  ///
  /// In es, this message translates to:
  /// **'Consulta los datos catastrales de tus inmuebles registrados en la Dirección General de Catastro.'**
  String get myDataHousingRealEstateInfoSheetDescription;

  /// Pie del modal informativo de bienes inmuebles.
  ///
  /// In es, this message translates to:
  /// **'Si alguno de tus datos no es correcto dirígete o contacta con la Sede Electrónica de Catastro'**
  String get myDataHousingRealEstateInfoSheetFooter;

  /// Etiqueta del filtro de todos los bienes inmuebles.
  ///
  /// In es, this message translates to:
  /// **'Todo'**
  String get myDataHousingRealEstateFilterAll;

  /// Etiqueta del filtro de bienes inmuebles urbanos.
  ///
  /// In es, this message translates to:
  /// **'Urbano'**
  String get myDataHousingRealEstateFilterUrban;

  /// Etiqueta del filtro de bienes inmuebles rústicos.
  ///
  /// In es, this message translates to:
  /// **'Rústico'**
  String get myDataHousingRealEstateFilterRustic;

  /// Título de la tarjeta de bien inmueble con referencia catastral.
  ///
  /// In es, this message translates to:
  /// **'Referencia catastral {value}'**
  String myDataHousingRealEstateReferenceTitle(String value);

  /// Tooltip del botón de cerrar el detalle de bien inmueble.
  ///
  /// In es, this message translates to:
  /// **'Cerrar'**
  String get myDataHousingRealEstateDetailClose;

  /// Título de la sección de datos de la vivienda.
  ///
  /// In es, this message translates to:
  /// **'Datos de la vivienda'**
  String get myDataHousingRealEstateDetailHomeDataTitle;

  /// Etiqueta del campo referencia catastral.
  ///
  /// In es, this message translates to:
  /// **'Referencia catastral'**
  String get myDataHousingRealEstateReferenceLabel;

  /// Etiqueta de dirección del bien inmueble.
  ///
  /// In es, this message translates to:
  /// **'Dirección'**
  String get myDataHousingRealEstateAddressLabel;

  /// Etiqueta de uso del bien inmueble.
  ///
  /// In es, this message translates to:
  /// **'Uso'**
  String get myDataHousingRealEstateUseLabel;

  /// Etiqueta de valor catastral del bien inmueble.
  ///
  /// In es, this message translates to:
  /// **'Valor catastral'**
  String get myDataHousingRealEstateCadastralValueLabel;

  /// Etiqueta de valor del suelo del bien inmueble.
  ///
  /// In es, this message translates to:
  /// **'Valor del suelo'**
  String get myDataHousingRealEstateLandValueLabel;

  /// Etiqueta de valor de construcción del bien inmueble.
  ///
  /// In es, this message translates to:
  /// **'Valor de construcción'**
  String get myDataHousingRealEstateConstructionValueLabel;

  /// Etiqueta de estado del bien inmueble.
  ///
  /// In es, this message translates to:
  /// **'Estado'**
  String get myDataHousingRealEstateStatusLabel;

  /// Texto del botón para abrir la cartografía del bien inmueble.
  ///
  /// In es, this message translates to:
  /// **'Mostrar cartografía'**
  String get myDataHousingRealEstateShowCartography;

  /// Título de la sección de titulares del bien inmueble.
  ///
  /// In es, this message translates to:
  /// **'Titulares'**
  String get myDataHousingRealEstateHoldersTitle;

  /// Mensaje mostrado cuando no hay titulares del bien inmueble.
  ///
  /// In es, this message translates to:
  /// **'No constan titulares para este bien inmueble.'**
  String get myDataHousingRealEstateHoldersEmpty;

  /// Mensaje mostrado cuando no se encuentra el detalle del inmueble seleccionado.
  ///
  /// In es, this message translates to:
  /// **'No hemos encontrado el bien inmueble seleccionado.'**
  String get myDataHousingRealEstateDetailEmpty;

  /// Estado vacío de bienes inmuebles.
  ///
  /// In es, this message translates to:
  /// **'No constan bienes inmuebles a tu nombre.'**
  String get myDataHousingRealEstateEmpty;

  /// Estado vacío de bienes inmuebles filtrados.
  ///
  /// In es, this message translates to:
  /// **'No hay bienes inmuebles para este filtro.'**
  String get myDataHousingRealEstateFilteredEmpty;

  /// Estado de error de bienes inmuebles.
  ///
  /// In es, this message translates to:
  /// **'No hemos podido cargar los datos de Catastro.'**
  String get myDataHousingRealEstateError;

  /// Título de la tarjeta de domicilio en el detalle de Vivienda.
  ///
  /// In es, this message translates to:
  /// **'Domicilio en Castilla-La Mancha'**
  String get myDataHousingAddressTitle;

  /// Descripción de la tarjeta de domicilio en el detalle de Vivienda.
  ///
  /// In es, this message translates to:
  /// **'Datos en la base padronal'**
  String get myDataHousingAddressDescription;

  /// Título del modal informativo del detalle de domicilio.
  ///
  /// In es, this message translates to:
  /// **'Sobre tu domicilio'**
  String get myDataHousingAddressInfoSheetTitle;

  /// Descripción principal del modal informativo del detalle de domicilio.
  ///
  /// In es, this message translates to:
  /// **'Consulta tus datos en la base padronal del Instituto Nacional de Estadística (INE) dentro de Castilla-La Mancha, que recoge información de todos los Padrones municipales de Castilla-La Mancha. Esta información se actualiza cada mes con datos enviados por los ayuntamientos, por lo que podría no coincidir con tu situación actual si modificaste tu empadronamiento recientemente.'**
  String get myDataHousingAddressInfoSheetDescription;

  /// Pie del modal informativo del detalle de domicilio.
  ///
  /// In es, this message translates to:
  /// **'Si alguno de tus datos no es correcto dirígete o contacta con tu Ayuntamiento.'**
  String get myDataHousingAddressInfoSheetFooter;

  /// Título de la sección de datos del domicilio.
  ///
  /// In es, this message translates to:
  /// **'Datos del domicilio'**
  String get myDataHousingAddressDataTitle;

  /// Título de la sección de datos de inscripción padronal.
  ///
  /// In es, this message translates to:
  /// **'Datos relativos a la inscripción'**
  String get myDataHousingAddressRegistrationDataTitle;

  /// Etiqueta del campo domicilio.
  ///
  /// In es, this message translates to:
  /// **'Domicilio'**
  String get myDataHousingAddressLabel;

  /// Etiqueta del campo código postal.
  ///
  /// In es, this message translates to:
  /// **'Código postal'**
  String get myDataHousingAddressPostalCodeLabel;

  /// Etiqueta del campo municipio.
  ///
  /// In es, this message translates to:
  /// **'Municipio'**
  String get myDataHousingAddressMunicipalityLabel;

  /// Etiqueta del campo provincia.
  ///
  /// In es, this message translates to:
  /// **'Provincia'**
  String get myDataHousingAddressProvinceLabel;

  /// Etiqueta del campo entidad colectivo.
  ///
  /// In es, this message translates to:
  /// **'Entidad colectivo'**
  String get myDataHousingAddressCollectiveEntityLabel;

  /// Etiqueta del campo entidad singular.
  ///
  /// In es, this message translates to:
  /// **'Entidad singular'**
  String get myDataHousingAddressSingleEntityLabel;

  /// Etiqueta del campo núcleo o diseminado.
  ///
  /// In es, this message translates to:
  /// **'Núcleo / Diseminado'**
  String get myDataHousingAddressPopulationUnitLabel;

  /// Etiqueta del tipo de variación padronal.
  ///
  /// In es, this message translates to:
  /// **'Tipo de variación'**
  String get myDataHousingAddressVariationTypeLabel;

  /// Etiqueta de la fecha de variación padronal.
  ///
  /// In es, this message translates to:
  /// **'Fecha de variación'**
  String get myDataHousingAddressVariationDateLabel;

  /// Mensaje mostrado cuando no hay domicilio registrado.
  ///
  /// In es, this message translates to:
  /// **'No constan datos de domicilio en Castilla-La Mancha.'**
  String get myDataHousingAddressEmpty;

  /// Mensaje de error al cargar domicilio.
  ///
  /// In es, this message translates to:
  /// **'No hemos podido cargar tus datos de domicilio.'**
  String get myDataHousingAddressError;

  /// Título de la sección de enlaces de interés en la pestaña Información y servicios de Vivienda.
  ///
  /// In es, this message translates to:
  /// **'Enlaces de interés'**
  String get myDataHousingLinksTitle;

  /// Enlace al portal de Vivienda Castilla-La Mancha.
  ///
  /// In es, this message translates to:
  /// **'Vivienda Castilla-La Mancha'**
  String get myDataHousingLinkClmHousing;

  /// Enlace a la Sede del Catastro.
  ///
  /// In es, this message translates to:
  /// **'Sede del catastro'**
  String get myDataHousingLinkCadastre;

  /// Título de la sección de trámites relacionados con vivienda.
  ///
  /// In es, this message translates to:
  /// **'Trámites que te pueden interesar'**
  String get myDataHousingProceduresTitle;

  /// Trámite de ayudas al alquiler de viviendas.
  ///
  /// In es, this message translates to:
  /// **'Ayudas al alquiler de viviendas'**
  String get myDataHousingProcedureRentalHousingAid;

  /// Trámite de inscripción en el registro de demandantes de vivienda con protección pública de CLM.
  ///
  /// In es, this message translates to:
  /// **'Inscripción en el registro de demandantes de vivienda con protección pública de CLM'**
  String get myDataHousingProcedureProtectedHousingRegister;

  /// Trámite de ayudas de emergencia social.
  ///
  /// In es, this message translates to:
  /// **'Ayudas de emergencia social'**
  String get myDataHousingProcedureSocialEmergencyAid;

  /// Título de la tarjeta de Vehículos en la pantalla Mis datos.
  ///
  /// In es, this message translates to:
  /// **'Vehículos'**
  String get myDataVehiclesTitle;

  /// Descripción de la tarjeta de Vehículos en la pantalla Mis datos.
  ///
  /// In es, this message translates to:
  /// **'Tus vehículos registrados'**
  String get myDataVehiclesDescription;

  /// Título del modal informativo de Mis datos de Vehículos.
  ///
  /// In es, this message translates to:
  /// **'Sobre Mis datos de Vehículos'**
  String get myDataVehiclesInfoSheetTitle;

  /// Descripción principal del modal informativo de Mis datos de Vehículos.
  ///
  /// In es, this message translates to:
  /// **'Consulta la matrícula de los vehículos registrados en la Dirección General de Tráfico (DGT) en los que eres titular.'**
  String get myDataVehiclesInfoSheetDescription;

  /// Texto del pie de página del modal informativo de Mis datos de Vehículos.
  ///
  /// In es, this message translates to:
  /// **'Si alguno de tus datos no es correcto o no está actualizado, contacta con la Dirección General de Tráfico (DGT)'**
  String get myDataVehiclesInfoSheetFooter;

  /// Etiqueta del botón de contacto en el modal informativo de Mis datos de Vehículos.
  ///
  /// In es, this message translates to:
  /// **'Contactar'**
  String get myDataVehiclesInfoSheetContactButton;

  /// Primera pestaña del detalle de Vehículos.
  ///
  /// In es, this message translates to:
  /// **'Mis datos de Vehículos'**
  String get myDataVehiclesDataTab;

  /// Segunda pestaña del detalle de Vehículos.
  ///
  /// In es, this message translates to:
  /// **'Información y servicios'**
  String get myDataVehiclesServicesTab;

  /// Título de la sección de listado de vehículos.
  ///
  /// In es, this message translates to:
  /// **'Mis vehículos'**
  String get myDataVehiclesSectionTitle;

  /// Etiqueta descriptiva de la matrícula del vehículo.
  ///
  /// In es, this message translates to:
  /// **'Matrícula del vehículo'**
  String get myDataVehiclesLicensePlateLabel;

  /// Mensaje mostrado cuando no hay vehículos.
  ///
  /// In es, this message translates to:
  /// **'No constan vehículos registrados a tu nombre.'**
  String get myDataVehiclesEmpty;

  /// Mensaje de error al cargar vehículos.
  ///
  /// In es, this message translates to:
  /// **'No hemos podido cargar tus vehículos.'**
  String get myDataVehiclesError;

  /// Estado vacío temporal de la pestaña Información y servicios de Vehículos.
  ///
  /// In es, this message translates to:
  /// **'Información y servicios de Vehículos disponible próximamente.'**
  String get myDataVehiclesServicesEmpty;

  /// Título de la sección de enlaces de interés en la pestaña Información y servicios de Vehículos.
  ///
  /// In es, this message translates to:
  /// **'Enlaces de interés'**
  String get myDataVehiclesLinksTitle;

  /// Enlace a la Sede electrónica de la Dirección General de Tráfico.
  ///
  /// In es, this message translates to:
  /// **'Sede electrónica DGT'**
  String get myDataVehiclesLinkDgt;

  /// Enlace a la Carpeta Ciudadana de la Administración General del Estado.
  ///
  /// In es, this message translates to:
  /// **'Carpeta Ciudadana de la AGE'**
  String get myDataVehiclesLinkAge;

  /// Título de la sección de trámites relacionados con vehículos.
  ///
  /// In es, this message translates to:
  /// **'Trámites que te pueden interesar'**
  String get myDataVehiclesProceduresTitle;

  /// Trámite para solicitar ayuda MOVES III para comprar vehículos eléctricos.
  ///
  /// In es, this message translates to:
  /// **'Solicitud de ayuda MOVES III para adquisición de vehículos eléctricos'**
  String get myDataVehiclesProcedureMoves3Vehicle;

  /// Trámite para solicitar ayuda MOVES III para infraestructura de recarga.
  ///
  /// In es, this message translates to:
  /// **'Solicitud de ayuda MOVES III para implantación de infraestructura de recarga de vehículos eléctricos'**
  String get myDataVehiclesProcedureMoves3Infrastructure;

  /// Trámite para homologar cursos de formación de conductores CAP.
  ///
  /// In es, this message translates to:
  /// **'Homologación de cursos de formación de conductores (cap)'**
  String get myDataVehiclesProcedureCap;

  /// SnackBar mostrado al pulsar una tarjeta de Mis datos cuyo detalle aún no está implementado.
  ///
  /// In es, this message translates to:
  /// **'{section} disponible próximamente'**
  String myDataSectionComingSoon(String section);

  /// SnackBar mostrado al pulsar el botón de información en el detalle de Salud.
  ///
  /// In es, this message translates to:
  /// **'Consulta tus datos de salud y las citas disponibles.'**
  String get myDataHealthInfoMessage;

  /// Título del modal informativo de Mis datos de Educación.
  ///
  /// In es, this message translates to:
  /// **'Sobre Mis datos de Educación'**
  String get myDataEducationInfoSheetTitle;

  /// Descripción principal del modal informativo de Mis datos de Educación.
  ///
  /// In es, this message translates to:
  /// **'Consulta tu información y accede a servicios relacionados de educación en Castilla-La Mancha.'**
  String get myDataEducationInfoSheetDescription;

  /// Primera pestaña del detalle de Educación.
  ///
  /// In es, this message translates to:
  /// **'Mis datos de Educación'**
  String get myDataEducationDataTab;

  /// Segunda pestaña del detalle de Educación.
  ///
  /// In es, this message translates to:
  /// **'Información y servicios'**
  String get myDataEducationServicesTab;

  /// Tarjeta de acceso a títulos universitarios en Mis datos de Educación.
  ///
  /// In es, this message translates to:
  /// **'Títulos universitarios'**
  String get myDataEducationUniversityTitles;

  /// Tarjeta de acceso a títulos no universitarios en Mis datos de Educación.
  ///
  /// In es, this message translates to:
  /// **'Títulos no universitarios'**
  String get myDataEducationNonUniversityTitles;

  /// Descripción de las tarjetas de títulos educativos.
  ///
  /// In es, this message translates to:
  /// **'Universidades públicas y privadas'**
  String get myDataEducationTitlesDescription;

  /// Estado vacío temporal de la pestaña Información y servicios de Educación.
  ///
  /// In es, this message translates to:
  /// **'Información y servicios de Educación disponible próximamente.'**
  String get myDataEducationServicesEmpty;

  /// Título de la sección de trámites sugeridos en la pestaña de información y servicios de Educación.
  ///
  /// In es, this message translates to:
  /// **'Trámites que te pueden interesar'**
  String get myDataEducationProceduresTitle;

  /// Enlace a la solicitud de equivalencia de estudios con títulos oficiales.
  ///
  /// In es, this message translates to:
  /// **'Solicitud equivalencia de estudios con los títulos oficiales'**
  String get myDataEducationProcedureEquivalence;

  /// Enlace a becas y ayudas para alumnos de niveles postobligatorios.
  ///
  /// In es, this message translates to:
  /// **'Becas y ayudas a alumnos de niveles postobligatorios'**
  String get myDataEducationProcedureScholarships;

  /// Enlace a pruebas libres para obtener el título de graduado en ESO para mayores de 18 años.
  ///
  /// In es, this message translates to:
  /// **'Pruebas libres para la obtención del título de graduado en educación secundaria obligatoria para > 18 años'**
  String get myDataEducationProcedureSecondaryDegree;

  /// Título de la sección de enlaces de interés en la pestaña de información y servicios de Educación.
  ///
  /// In es, this message translates to:
  /// **'Enlaces de interés'**
  String get myDataEducationInterestLinksTitle;

  /// Placeholder de enlace de interés de Educación según el diseño de Figma.
  ///
  /// In es, this message translates to:
  /// **'Lorem ipsum dolor sit amet'**
  String get myDataEducationInterestLinkPlaceholder;

  /// Título del modal informativo de Mis datos de Salud.
  ///
  /// In es, this message translates to:
  /// **'Sobre Mis datos de Salud'**
  String get myDataHealthInfoSheetTitle;

  /// Descripción principal del modal informativo de Mis datos de Salud.
  ///
  /// In es, this message translates to:
  /// **'Consulta la información de tus citas de Atención Primaria del Servicio de Salud de Castilla-La Mancha (SESCAM).'**
  String get myDataHealthInfoSheetDescription;

  /// Texto de ayuda previo al CTA de contacto del modal informativo de Salud.
  ///
  /// In es, this message translates to:
  /// **'Si algún dato no es correcto o no está actualizado, contacta con tu Centro de Salud.'**
  String get myDataHealthInfoSheetContactHint;

  /// Primera pestaña del detalle de Salud.
  ///
  /// In es, this message translates to:
  /// **'Mis datos de Salud'**
  String get myDataHealthDataTab;

  /// Segunda pestaña del detalle de Salud.
  ///
  /// In es, this message translates to:
  /// **'Información y servicios'**
  String get myDataHealthServicesTab;

  /// Título de la sección de trámites sugeridos en la pestaña de información y servicios de Salud.
  ///
  /// In es, this message translates to:
  /// **'Trámites que te pueden interesar'**
  String get myDataHealthProceduresTitle;

  /// Enlace a reclamaciones y quejas relativas al SESCAM.
  ///
  /// In es, this message translates to:
  /// **'Reclamaciones y quejas relativas al SESCAM'**
  String get myDataHealthProcedureComplaints;

  /// Enlace a la solicitud de tarjeta para la Atención Sanitaria en el SESCAM.
  ///
  /// In es, this message translates to:
  /// **'Solicitud de tarjeta para la Atención Sanitaria en el SESCAM'**
  String get myDataHealthProcedureHealthCard;

  /// Enlace de libre elección en el ámbito de la Atención Especializada.
  ///
  /// In es, this message translates to:
  /// **'Libre elección en el ámbito de la Atención Especializada'**
  String get myDataHealthProcedureSpecializedCare;

  /// Título de la sección de enlaces de interés en la pestaña de información y servicios de Salud.
  ///
  /// In es, this message translates to:
  /// **'Enlaces de interés'**
  String get myDataHealthInterestLinksTitle;

  /// Enlace al Servicio de Salud de Castilla-La Mancha.
  ///
  /// In es, this message translates to:
  /// **'Servicio de Salud de Castilla-La Mancha (SESCAM)'**
  String get myDataHealthLinkSescam;

  /// Enlace a Mi Salud Digital.
  ///
  /// In es, this message translates to:
  /// **'Mi Salud Digital'**
  String get myDataHealthLinkDigitalHealth;

  /// Enlace a Historia clínica Digital del Sistema Nacional de Salud.
  ///
  /// In es, this message translates to:
  /// **'Historia clínica Digital (Sistema Nacional de Salud)'**
  String get myDataHealthLinkClinicalHistory;

  /// Título principal del bloque de citas sanitarias.
  ///
  /// In es, this message translates to:
  /// **'Citas de Atención Primaria'**
  String get myDataHealthAppointmentsTitle;

  /// Estado vacío del listado de citas sanitarias.
  ///
  /// In es, this message translates to:
  /// **'No hay citas para mostrar.'**
  String get myDataHealthAppointmentsEmpty;

  /// Mensaje de error del listado de citas sanitarias.
  ///
  /// In es, this message translates to:
  /// **'No hemos podido cargar tus citas sanitarias.'**
  String get myDataHealthAppointmentsError;

  /// Código CIP mostrado bajo el título del detalle de Salud.
  ///
  /// In es, this message translates to:
  /// **'CIP: FCCT590551910012'**
  String get myDataHealthCip;

  /// Pestaña de citas pendientes en Salud.
  ///
  /// In es, this message translates to:
  /// **'Pendientes'**
  String get myDataHealthPendingTab;

  /// Pestaña de citas pasadas en Salud.
  ///
  /// In es, this message translates to:
  /// **'Pasadas'**
  String get myDataHealthPastTab;

  /// Año mostrado en la lista de citas de Salud de la maqueta.
  ///
  /// In es, this message translates to:
  /// **'2026'**
  String get myDataHealthYear;

  /// Mes diciembre mostrado en la lista de citas de Salud.
  ///
  /// In es, this message translates to:
  /// **'diciembre'**
  String get myDataHealthDecember;

  /// Mes octubre mostrado en la lista de citas de Salud.
  ///
  /// In es, this message translates to:
  /// **'octubre'**
  String get myDataHealthOctober;

  /// Número de día de la cita sanitaria de ejemplo.
  ///
  /// In es, this message translates to:
  /// **'12'**
  String get myDataHealthAppointmentDayNumber;

  /// Día de la semana de la cita sanitaria de ejemplo.
  ///
  /// In es, this message translates to:
  /// **'Jueves'**
  String get myDataHealthAppointmentWeekday;

  /// Hora de la cita sanitaria de ejemplo.
  ///
  /// In es, this message translates to:
  /// **'17:35h'**
  String get myDataHealthAppointmentTime;

  /// Tipo de cita sanitaria de ejemplo.
  ///
  /// In es, this message translates to:
  /// **'TELÉFONICA'**
  String get myDataHealthAppointmentType;

  /// Profesional sanitario de la cita de ejemplo.
  ///
  /// In es, this message translates to:
  /// **'Dr. José Manuel Fernández García'**
  String get myDataHealthAppointmentProfessional;

  /// Descripción de la cita sanitaria de ejemplo.
  ///
  /// In es, this message translates to:
  /// **'Cita de Atención Primaria'**
  String get myDataHealthAppointmentDescription;

  /// Modalidad de la cita sanitaria de ejemplo.
  ///
  /// In es, this message translates to:
  /// **'Teleconsulta a demanda'**
  String get myDataHealthAppointmentModality;

  /// Título de la pantalla principal de Gestión.
  ///
  /// In es, this message translates to:
  /// **'Gestión'**
  String get gestionTitle;

  /// Título de la tarjeta de navegación a Mis expedientes.
  ///
  /// In es, this message translates to:
  /// **'Mis expedientes'**
  String get gestionExpedientesTitle;

  /// Descripción de la tarjeta de navegación a Mis expedientes.
  ///
  /// In es, this message translates to:
  /// **'Consulta y gestiona tus expedientes administrativos'**
  String get gestionExpedientesDescription;

  /// Título de la tarjeta de navegación a Mis registros.
  ///
  /// In es, this message translates to:
  /// **'Mis registros'**
  String get gestionRegistrosTitle;

  /// Descripción de la tarjeta de navegación a Mis registros.
  ///
  /// In es, this message translates to:
  /// **'Accede a tus entradas y salidas de registro'**
  String get gestionRegistrosDescription;

  /// Título de la tarjeta de navegación para aportar documentos a expedientes de terceros.
  ///
  /// In es, this message translates to:
  /// **'Aportar documentos a un expediente de terceros'**
  String get gestionAportacionTitle;

  /// Descripción de la tarjeta de navegación para aportar documentos a expedientes de terceros.
  ///
  /// In es, this message translates to:
  /// **'Adjunta documentación a expedientes de otras personas'**
  String get gestionAportacionDescription;

  /// Título de la tarjeta de navegación a Mis notificaciones.
  ///
  /// In es, this message translates to:
  /// **'Mis notificaciones'**
  String get gestionNotificacionesTitle;

  /// Descripción de la tarjeta de navegación a Mis notificaciones.
  ///
  /// In es, this message translates to:
  /// **'Gestiona tus notificaciones electrónicas'**
  String get gestionNotificacionesDescription;

  /// Mensaje cuando una sección de Gestión aún no está implementada.
  ///
  /// In es, this message translates to:
  /// **'Función disponible próximamente'**
  String get gestionSectionComingSoon;

  /// Título de la pantalla de listado de expedientes.
  ///
  /// In es, this message translates to:
  /// **'Mis expedientes'**
  String get gestionExpedientesPageTitle;

  /// Etiqueta del número de expediente en la tarjeta.
  ///
  /// In es, this message translates to:
  /// **'Nº EXPEDIENTE.'**
  String get gestionExpedientesNumExpedienteLabel;

  /// Etiqueta de la fecha de inicio en la tarjeta de expediente.
  ///
  /// In es, this message translates to:
  /// **'FECHA DE INICIO'**
  String get gestionExpedientesFechaInicioLabel;

  /// Etiqueta del estado en la tarjeta de expediente.
  ///
  /// In es, this message translates to:
  /// **'ESTADO'**
  String get gestionExpedientesEstadoLabel;

  /// Error al cargar la lista de expedientes.
  ///
  /// In es, this message translates to:
  /// **'No hemos podido cargar tus expedientes'**
  String get gestionExpedientesLoadError;

  /// Mensaje de lista vacía en la pantalla de expedientes.
  ///
  /// In es, this message translates to:
  /// **'No tienes expedientes activos'**
  String get gestionExpedientesEmpty;

  /// Título de la barra de navegación en la pantalla de detalle de expediente.
  ///
  /// In es, this message translates to:
  /// **'Detalle de expediente'**
  String get gestionExpedientesDetalleTitle;

  /// Encabezado de la primera sección en la pantalla de detalle de expediente.
  ///
  /// In es, this message translates to:
  /// **'Datos del Expediente'**
  String get gestionExpedientesDatosExpedienteTitle;

  /// Encabezado de la segunda sección en la pantalla de detalle de expediente.
  ///
  /// In es, this message translates to:
  /// **'Estado de tramitación'**
  String get gestionExpedientesEstadoTramitacionTitle;

  /// Etiqueta de la consejería en la pantalla de detalle de expediente.
  ///
  /// In es, this message translates to:
  /// **'CONSEJERÍA'**
  String get gestionExpedientesConsejeriaLabel;

  /// Etiqueta de la oficina tramitadora en la pantalla de detalle de expediente.
  ///
  /// In es, this message translates to:
  /// **'OFICINA TRAMITADORA'**
  String get gestionExpedientesOficinaTramitadoraLabel;

  /// Etiqueta de la fecha de cierre en la pantalla de detalle de expediente.
  ///
  /// In es, this message translates to:
  /// **'FECHA DE CIERRE'**
  String get gestionExpedientesFechaCierreLabel;

  /// Etiqueta del botón fijo inferior en la pantalla de detalle de expediente.
  ///
  /// In es, this message translates to:
  /// **'Aportar documentación'**
  String get gestionExpedientesAportarDocumentacionButton;

  /// Error al cargar el detalle de un expediente.
  ///
  /// In es, this message translates to:
  /// **'No hemos podido cargar el detalle del expediente'**
  String get gestionExpedientesDetalleLoadError;

  /// Título de la pantalla de aportar documentación.
  ///
  /// In es, this message translates to:
  /// **'Aportar documentación'**
  String get gestionAportarDocumentacionTitle;

  /// Aviso persistente con las condiciones de subida de ficheros.
  ///
  /// In es, this message translates to:
  /// **'Puedes aportar hasta 5 ficheros de 20MB máx. cada uno, en formato PDF, DOC, DOCX, ZIP, XLS o XLSX.'**
  String get gestionAportarDocumentacionHelperText;

  /// Botón para cancelar la aportación de documentación.
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get gestionAportarDocumentacionCancelarButton;

  /// Botón para abrir el selector de ficheros.
  ///
  /// In es, this message translates to:
  /// **'Seleccionar documentos'**
  String get gestionAportarDocumentacionSeleccionarButton;

  /// Botón para registrar los documentos aportados.
  ///
  /// In es, this message translates to:
  /// **'Registrar documentos aportados'**
  String get gestionAportarDocumentacionRegistrarButton;

  /// Error al superar el número máximo de ficheros permitidos.
  ///
  /// In es, this message translates to:
  /// **'No puedes aportar más de 5 ficheros.'**
  String get gestionAportarDocumentacionMaxFilesError;

  /// Error al superar el tamaño máximo permitido por fichero.
  ///
  /// In es, this message translates to:
  /// **'Cada fichero debe pesar como máximo 20MB.'**
  String get gestionAportarDocumentacionMaxSizeError;

  /// Error al seleccionar un fichero con un formato no admitido.
  ///
  /// In es, this message translates to:
  /// **'Formato de fichero no permitido.'**
  String get gestionAportarDocumentacionInvalidTypeError;

  /// Error al seleccionar un fichero ya añadido previamente.
  ///
  /// In es, this message translates to:
  /// **'Ese fichero ya se ha añadido.'**
  String get gestionAportarDocumentacionDuplicateError;

  /// Error al intentar registrar sin haber seleccionado ningún fichero.
  ///
  /// In es, this message translates to:
  /// **'Selecciona al menos un fichero antes de registrar.'**
  String get gestionAportarDocumentacionNoFilesError;

  /// Mensaje de éxito al registrar los documentos aportados.
  ///
  /// In es, this message translates to:
  /// **'Documentación registrada correctamente.'**
  String get gestionAportarDocumentacionRegistroSuccess;

  /// Mensaje de error al fallar el registro de los documentos aportados.
  ///
  /// In es, this message translates to:
  /// **'No hemos podido registrar la documentación. Inténtalo de nuevo.'**
  String get gestionAportarDocumentacionRegistroError;

  /// Mensaje cuando alguno de los ficheros subidos en paralelo falla.
  ///
  /// In es, this message translates to:
  /// **'Algunos ficheros no se han podido enviar. Puedes reintentarlo.'**
  String get gestionAportarDocumentacionUploadErrorParcial;

  /// Título del diálogo de éxito al completar la aportación de documentación.
  ///
  /// In es, this message translates to:
  /// **'Los documentos han sido enviados correctamente'**
  String get gestionAportarDocumentacionExitoTitulo;

  /// Descripción del diálogo de éxito al completar la aportación de documentación.
  ///
  /// In es, this message translates to:
  /// **'La aportación de documentación ha sido registrada aunque los documentos no serán visibles desde el expediente.\n\nRecomendamos descargar el justificante de su aportación antes de continuar: no estará disponible más adelante'**
  String get gestionAportarDocumentacionExitoDescripcion;

  /// Botón secundario del diálogo de éxito de aportación de documentación.
  ///
  /// In es, this message translates to:
  /// **'Cerrar sin descargar'**
  String get gestionAportarDocumentacionCerrarSinDescargarButton;

  /// Botón primario del diálogo de éxito de aportación de documentación.
  ///
  /// In es, this message translates to:
  /// **'Descargar justificante'**
  String get gestionAportarDocumentacionDescargarJustificanteButton;

  /// Toast mostrado tras guardar el justificante con el selector nativo de destino.
  ///
  /// In es, this message translates to:
  /// **'Justificante de aportación descargado'**
  String get gestionAportarDocumentacionJustificanteDescargado;

  /// Mensaje de error cuando registrarFicheros falla tras haber subido todos los ficheros.
  ///
  /// In es, this message translates to:
  /// **'Los documentos se han subido pero no se ha podido finalizar el registro. Puedes reintentarlo.'**
  String get gestionAportarDocumentacionFinalizacionError;

  /// Título de la pantalla de mis registros.
  ///
  /// In es, this message translates to:
  /// **'Mis registros'**
  String get gestionRegistrosPageTitle;

  /// Etiqueta del tab de entradas de registro.
  ///
  /// In es, this message translates to:
  /// **'Entradas de registro'**
  String get gestionRegistrosEntradasTab;

  /// Etiqueta del tab de salidas de registro.
  ///
  /// In es, this message translates to:
  /// **'Salidas de registro'**
  String get gestionRegistrosSalidasTab;

  /// Etiqueta del campo número de registro.
  ///
  /// In es, this message translates to:
  /// **'Nº REGISTRO'**
  String get gestionRegistrosNumRegistroLabel;

  /// Etiqueta del campo fecha de registro.
  ///
  /// In es, this message translates to:
  /// **'FECHA'**
  String get gestionRegistrosFechaLabel;

  /// Etiqueta del campo consejería de origen (salidas).
  ///
  /// In es, this message translates to:
  /// **'CONSERJERÍA DE ORIGEN'**
  String get gestionRegistrosConsejeriaOrigenLabel;

  /// Etiqueta del campo consejería de destino (entradas).
  ///
  /// In es, this message translates to:
  /// **'CONSERJERÍA DE DESTINO'**
  String get gestionRegistrosConsejeriaDestinoLabel;

  /// Título de la sección de datos del registro en el detalle.
  ///
  /// In es, this message translates to:
  /// **'Datos del Registro'**
  String get gestionRegistrosDatosRegistroTitle;

  /// Error al cargar la lista de entradas de registro.
  ///
  /// In es, this message translates to:
  /// **'No hemos podido cargar tus entradas de registro'**
  String get gestionRegistrosEntradasLoadError;

  /// Error al cargar la lista de salidas de registro.
  ///
  /// In es, this message translates to:
  /// **'No hemos podido cargar tus salidas de registro'**
  String get gestionRegistrosSalidasLoadError;

  /// Mensaje de lista vacía para entradas de registro.
  ///
  /// In es, this message translates to:
  /// **'No tienes entradas de registro'**
  String get gestionRegistrosEntradasEmpty;

  /// Mensaje de lista vacía para salidas de registro.
  ///
  /// In es, this message translates to:
  /// **'No tienes salidas de registro'**
  String get gestionRegistrosSalidasEmpty;

  /// Título de la pantalla de detalle de entrada de registro.
  ///
  /// In es, this message translates to:
  /// **'Detalle de entrada de registro'**
  String get gestionRegistrosDetalleEntradaTitle;

  /// Título de la pantalla de detalle de salida de registro.
  ///
  /// In es, this message translates to:
  /// **'Detalle salida de registro'**
  String get gestionRegistrosDetalleSalidaTitle;

  /// Label del campo de tipo de identificación y número en la pantalla de aportación.
  ///
  /// In es, this message translates to:
  /// **'Tipo de identificación y número'**
  String get gestionAportacionTipoIdLabel;

  /// Placeholder del campo de número de identificación en la pantalla de aportación.
  ///
  /// In es, this message translates to:
  /// **'000000000A'**
  String get gestionAportacionTipoIdHint;

  /// Texto de ayuda del campo de tipo de identificación.
  ///
  /// In es, this message translates to:
  /// **'El número debe corresponder a un NIF, CIF, Pasaporte, NIE o CEE válidos'**
  String get gestionAportacionTipoIdHelper;

  /// Texto introductorio de la pantalla de aportación de documentos.
  ///
  /// In es, this message translates to:
  /// **'Consulta el expediente sobre el que quieres aportar documentación'**
  String get gestionAportacionIntroText;

  /// Etiqueta de sección para identificar a la persona interesada.
  ///
  /// In es, this message translates to:
  /// **'IDENTIFICA A LA PERSONA INTERESADA QUE FIGURA EN EL EXPEDIENTE'**
  String get gestionAportacionPersonaLabel;

  /// Etiqueta de sección para indicar el expediente.
  ///
  /// In es, this message translates to:
  /// **'INDICA EL EXPEDIENTE SOBRE EL QUE SE APORTA DOCUMENTACIÓN'**
  String get gestionAportacionExpedienteLabel;

  /// Nota informativa de los campos del expediente.
  ///
  /// In es, this message translates to:
  /// **'*Rellenar solo uno de los dos campos'**
  String get gestionAportacionExpedienteNote;

  /// Label del campo número de registro del expediente.
  ///
  /// In es, this message translates to:
  /// **'NÚMERO DE REGISTRO DEL EXPEDIENTE'**
  String get gestionAportacionNumRegistroLabel;

  /// Placeholder del campo número de registro del expediente.
  ///
  /// In es, this message translates to:
  /// **'000 0 00000 0 00'**
  String get gestionAportacionNumRegistroHint;

  /// Texto de ayuda del campo número de registro.
  ///
  /// In es, this message translates to:
  /// **'Este número se obtiene en el momento de la presentación del expediente'**
  String get gestionAportacionNumRegistroHelper;

  /// Label del campo código identificador del expediente.
  ///
  /// In es, this message translates to:
  /// **'CÓDIGO IDENTIFICADOR DEL EXPEDIENTE'**
  String get gestionAportacionCodIdentificadorLabel;

  /// Placeholder del campo código identificador del expediente.
  ///
  /// In es, this message translates to:
  /// **'Ejemplo: 600 000 000'**
  String get gestionAportacionCodIdentificadorHint;

  /// Texto de ayuda del campo código identificador.
  ///
  /// In es, this message translates to:
  /// **'Este número se encuentra en la documentación del expediente'**
  String get gestionAportacionCodIdentificadorHelper;

  /// Título del bottom sheet informativo de aportación.
  ///
  /// In es, this message translates to:
  /// **'Aportación de documentos de terceros'**
  String get gestionAportacionInfoTitle;

  /// Cuerpo del bottom sheet informativo de aportación.
  ///
  /// In es, this message translates to:
  /// **'A lo largo de la tramitación de un expediente administrativo las personas interesadas, sus representantes legales o aquellas personas autorizadas, pueden aportar los documentos que estimen oportunos, o bien documentos necesarios para cumplir con requisitos legales o administrativos. En general, se puede presentar documentos en cualquier fase de la tramitación del expediente anterior a la resolución final y siempre que el procedimiento esté abierto y la administración no haya emitido una resolución definitiva.'**
  String get gestionAportacionInfoBody;

  /// Título del bottom sheet para seleccionar tipo de documento.
  ///
  /// In es, this message translates to:
  /// **'Seleccionar tipo de documento'**
  String get gestionAportacionSeleccionarTipo;

  /// Opción DNI en el selector de tipo de documento.
  ///
  /// In es, this message translates to:
  /// **'DNI'**
  String get gestionAportacionDni;

  /// Opción NIE en el selector de tipo de documento.
  ///
  /// In es, this message translates to:
  /// **'NIE'**
  String get gestionAportacionNie;

  /// Opción CIF en el selector de tipo de documento.
  ///
  /// In es, this message translates to:
  /// **'CIF'**
  String get gestionAportacionCif;

  /// Opción Pasaporte en el selector de tipo de documento.
  ///
  /// In es, this message translates to:
  /// **'Pasaporte'**
  String get gestionAportacionPasaporte;

  /// Opción CEE en el selector de tipo de documento.
  ///
  /// In es, this message translates to:
  /// **'CEE'**
  String get gestionAportacionCee;

  /// Texto del botón principal del formulario de aportación.
  ///
  /// In es, this message translates to:
  /// **'Encontrar expediente'**
  String get gestionAportacionFindButton;

  /// Texto del helper contextual bajo la card desactivada de notificaciones.
  ///
  /// In es, this message translates to:
  /// **'Registra tus datos de contacto para empezar a recibir notificaciones de la Junta de Comunidades de Castilla-La Mancha.'**
  String get gestionNotificacionesContextualMessage;

  /// Etiqueta del botón ghost del helper contextual de notificaciones.
  ///
  /// In es, this message translates to:
  /// **'Activar'**
  String get gestionNotificacionesContextualAction;

  /// Título del NavBar de la pantalla de activación de notificaciones.
  ///
  /// In es, this message translates to:
  /// **'Activar notificaciones'**
  String get gestionNotificacionesAltaTitle;

  /// Texto introductorio de la pantalla de activación de notificaciones.
  ///
  /// In es, this message translates to:
  /// **'Registra tus datos de contacto para empezar a recibir notificaciones de la Junta de Comunidades de Castilla-La Mancha.'**
  String get gestionNotificacionesAltaIntro;

  /// Nota de campo obligatorio en la pantalla de activación de notificaciones.
  ///
  /// In es, this message translates to:
  /// **'*Obligatorio rellenar al menos uno de los medios de contacto'**
  String get gestionNotificacionesAltaRequiredNote;

  /// Etiqueta del campo de teléfono en la pantalla de activación.
  ///
  /// In es, this message translates to:
  /// **'Teléfono móvil'**
  String get gestionNotificacionesAltaPhoneLabel;

  /// Placeholder del campo de teléfono en la pantalla de activación.
  ///
  /// In es, this message translates to:
  /// **'600 000 000'**
  String get gestionNotificacionesAltaPhoneHint;

  /// Texto de ayuda bajo el campo de teléfono en la pantalla de activación.
  ///
  /// In es, this message translates to:
  /// **'Para recibir las notificaciones en mensaje SMS'**
  String get gestionNotificacionesAltaPhoneHelper;

  /// Etiqueta del campo de email en la pantalla de activación.
  ///
  /// In es, this message translates to:
  /// **'Correo electrónico'**
  String get gestionNotificacionesAltaEmailLabel;

  /// Placeholder del campo de email en la pantalla de activación.
  ///
  /// In es, this message translates to:
  /// **'Ejemplo: mperez@correo.es'**
  String get gestionNotificacionesAltaEmailHint;

  /// Texto de ayuda bajo el campo de email en la pantalla de activación.
  ///
  /// In es, this message translates to:
  /// **'Para recibir las notificaciones en tu correo electrónico'**
  String get gestionNotificacionesAltaEmailHelper;

  /// Etiqueta del botón principal sticky de la pantalla de activación.
  ///
  /// In es, this message translates to:
  /// **'Dar de alta notificaciones'**
  String get gestionNotificacionesAltaSaveButton;

  /// Título del bottom sheet informativo de la pantalla de activación.
  ///
  /// In es, this message translates to:
  /// **'Datos de contacto'**
  String get gestionNotificacionesAltaInfoTitle;

  /// Cuerpo del bottom sheet informativo de la pantalla de activación.
  ///
  /// In es, this message translates to:
  /// **'Indica un teléfono móvil o un correo electrónico para recibir avisos de notificaciones.'**
  String get gestionNotificacionesAltaInfoBody;

  /// Error de validación cuando no se rellena ningún campo de contacto.
  ///
  /// In es, this message translates to:
  /// **'Debes indicar al menos un teléfono móvil o un correo electrónico.'**
  String get gestionNotificacionesAltaErrorAtLeastOne;

  /// Error de validación del teléfono en la pantalla de activación.
  ///
  /// In es, this message translates to:
  /// **'Introduce un teléfono móvil válido.'**
  String get gestionNotificacionesAltaErrorPhone;

  /// Error de validación del email en la pantalla de activación.
  ///
  /// In es, this message translates to:
  /// **'Introduce un correo electrónico válido.'**
  String get gestionNotificacionesAltaErrorEmail;

  /// Error cuando no se puede obtener el ID del ciudadano.
  ///
  /// In es, this message translates to:
  /// **'No hemos podido identificar al ciudadano.'**
  String get gestionNotificacionesAltaErrorNoCitizenId;

  /// Mensaje de éxito tras guardar los datos de contacto.
  ///
  /// In es, this message translates to:
  /// **'Datos de contacto guardados'**
  String get gestionNotificacionesAltaSuccessMessage;

  /// Título de la pantalla de listado de notificaciones.
  ///
  /// In es, this message translates to:
  /// **'Mis notificaciones'**
  String get gestionNotificacionesPageTitle;

  /// Pestaña 'Todo' en el filtro de notificaciones.
  ///
  /// In es, this message translates to:
  /// **'Todo'**
  String get gestionNotificacionesTabTodo;

  /// Pestaña 'Pendientes' en el filtro de notificaciones.
  ///
  /// In es, this message translates to:
  /// **'Pendientes'**
  String get gestionNotificacionesTabPendientes;

  /// Pestaña 'Aceptadas' en el filtro de notificaciones.
  ///
  /// In es, this message translates to:
  /// **'Aceptadas'**
  String get gestionNotificacionesTabAceptadas;

  /// Etiqueta del campo procedimiento en la card de notificación.
  ///
  /// In es, this message translates to:
  /// **'Procedimiento'**
  String get gestionNotificacionesProcedimientoLabel;

  /// Etiqueta del campo fecha de caducidad en la card de notificación.
  ///
  /// In es, this message translates to:
  /// **'Fecha expiración'**
  String get gestionNotificacionesFechaCaducidadLabel;

  /// Etiqueta del tag de estado pendiente en notificaciones.
  ///
  /// In es, this message translates to:
  /// **'Pendiente'**
  String get gestionNotificacionesTagPendiente;

  /// Etiqueta del tag de estado aceptada en notificaciones.
  ///
  /// In es, this message translates to:
  /// **'Aceptada'**
  String get gestionNotificacionesTagAceptada;

  /// Etiqueta del tag de estado rechazada en notificaciones.
  ///
  /// In es, this message translates to:
  /// **'Rechazada'**
  String get gestionNotificacionesTagRechazada;

  /// Etiqueta del tag de estado expirada en notificaciones.
  ///
  /// In es, this message translates to:
  /// **'Expirada'**
  String get gestionNotificacionesTagExpirada;

  /// Mensaje de lista vacía en la pantalla de notificaciones.
  ///
  /// In es, this message translates to:
  /// **'No tienes notificaciones en este momento'**
  String get gestionNotificacionesEmpty;

  /// Mensaje de error al cargar la lista de notificaciones.
  ///
  /// In es, this message translates to:
  /// **'No se han podido cargar las notificaciones'**
  String get gestionNotificacionesLoadError;
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
