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

  /// Texto que muestra la fecha de última actualización del documento legal.
  ///
  /// In es, this message translates to:
  /// **'Última actualización: {date}'**
  String legalPageLastUpdated(String date);

  /// Título de la página de condiciones de uso.
  ///
  /// In es, this message translates to:
  /// **'Condiciones de uso'**
  String get legalTermsTitle;

  /// Título de la página de política de privacidad / protección de datos.
  ///
  /// In es, this message translates to:
  /// **'Protección de datos'**
  String get legalPrivacyTitle;

  /// Título de la página de declaración de accesibilidad.
  ///
  /// In es, this message translates to:
  /// **'Accesibilidad'**
  String get legalAccessibilityTitle;

  /// Título de la página de aviso legal.
  ///
  /// In es, this message translates to:
  /// **'Aviso legal'**
  String get legalNoticeTitle;

  /// Etiqueta de accesibilidad para el área de contenido de las páginas legales.
  ///
  /// In es, this message translates to:
  /// **'Contenido legal'**
  String get legalContentSemantics;
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
