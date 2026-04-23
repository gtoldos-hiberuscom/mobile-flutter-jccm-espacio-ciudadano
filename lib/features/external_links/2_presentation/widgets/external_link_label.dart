import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Resolves a catalog `displayKey` to its localized label without
/// forcing every consumer to inline the same `switch` statement.
///
/// Returns the raw key when no mapping is registered, which makes
/// missing translations easy to spot without crashing the UI.
String resolveExternalLinkLabel(
  final AppLocalizations l10n,
  final String displayKey,
) {
  switch (displayKey) {
    case 'externalLinkEducamosClmLabel':
      return l10n.externalLinkEducamosClmLabel;
    case 'externalLinkEmpleoClmLabel':
      return l10n.externalLinkEmpleoClmLabel;
    case 'externalLinkEmpleoPublicoClmLabel':
      return l10n.externalLinkEmpleoPublicoClmLabel;
    case 'externalLinkSedeDgtLabel':
      return l10n.externalLinkSedeDgtLabel;
    case 'externalLinkCarpetaCiudadanaAgeLabel':
      return l10n.externalLinkCarpetaCiudadanaAgeLabel;
    case 'externalLinkHistoriaSocialUnicaLabel':
      return l10n.externalLinkHistoriaSocialUnicaLabel;
    case 'externalLinkBienestarSocialClmLabel':
      return l10n.externalLinkBienestarSocialClmLabel;
    case 'externalLinkInfanciaFamiliasLabel':
      return l10n.externalLinkInfanciaFamiliasLabel;
    default:
      return displayKey;
  }
}
