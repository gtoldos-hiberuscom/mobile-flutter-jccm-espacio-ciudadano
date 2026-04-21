import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

/// Localisation configuration for the application.
///
/// Extend with `AppLocalizations` generated delegates once the ARB pipeline
/// is set up (requires `flutter gen-l10n` with `l10n.yaml`).
abstract final class AppLocalization {
  /// Material and Cupertino localisation delegates.
  ///
  /// Add the generated `AppLocalizations.delegate` here after running
  /// `flutter gen-l10n`.
  static const List<LocalizationsDelegate<dynamic>> delegates = [
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  /// Locales supported by the application.
  static const List<Locale> supportedLocales = [
    Locale('es'),
    Locale('en'),
  ];
}
