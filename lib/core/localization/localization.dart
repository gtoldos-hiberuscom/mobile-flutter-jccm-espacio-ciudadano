import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Localisation configuration for the application.
///
/// Includes the generated [AppLocalizations.delegate] alongside the standard
/// Material and Cupertino delegates.
abstract final class AppLocalization {
  /// Full list of localisation delegates for [MaterialApp].
  ///
  /// Pass this to `MaterialApp.localizationsDelegates`.
  static const List<LocalizationsDelegate<dynamic>> delegates = [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  /// Locales supported by the application.
  ///
  /// Pass this to `MaterialApp.supportedLocales`.
  static const List<Locale> supportedLocales = [
    Locale('es'),
    Locale('en'),
  ];
}
