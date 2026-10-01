import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_focus_ring.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Enlace dentro de un párrafo que se puede usar con teclado.
///
/// Un `TextSpan` con `recognizer` sólo responde al dedo: no recibe el foco del
/// teclado ni muestra indicador (WCAG 2.1.1 y 2.4.7). Este enlace va en un
/// [WidgetSpan], es enfocable, se activa con Intro o Espacio, lleva el anillo
/// de foco común y se anuncia como enlace, con la pista de navegador externo
/// cuando sale de la app (4.1.2).
///
/// Úsese con [AppInlineLink.span] dentro de un `Text.rich`:
///
/// ```dart
/// Text.rich(TextSpan(children: [
///   const TextSpan(text: 'Consulta el '),
///   AppInlineLink.span(text: 'Real Decreto 1112/2018', style: linkStyle, onTap: abrir),
///   const TextSpan(text: '.'),
/// ]))
/// ```
class AppInlineLink extends StatelessWidget {
  const AppInlineLink({
    required this.text,
    required this.style,
    required this.onTap,
    super.key,
    this.isExternal = true,
  }) : assert(text != '', 'text must not be empty');

  /// Crea el enlace como fragmento de un párrafo, alineado a su línea base.
  static WidgetSpan span({
    required final String text,
    required final TextStyle style,
    required final VoidCallback onTap,
    final bool isExternal = true,
    final Key? key,
  }) => WidgetSpan(
    alignment: PlaceholderAlignment.baseline,
    baseline: TextBaseline.alphabetic,
    child: AppInlineLink(
      key: key,
      text: text,
      style: style,
      onTap: onTap,
      isExternal: isExternal,
    ),
  );

  /// Símbolo visual de enlace externo; no se lee en voz alta.
  static const String externalMark = '⇲';

  final String text;
  final TextStyle style;
  final VoidCallback onTap;
  final bool isExternal;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    // `container`: nodo propio. Sin él, el enlace se fundía con el texto
    // que lo rodea y toda la frase se anunciaba como enlace.
    return Semantics(
      container: true,
      link: true,
      label: text,
      hint: isExternal ? l10n.externalLinkA11yHint : null,
      onTap: onTap,
      child: ExcludeSemantics(
        child: AppFocusRing(
          child: InkWell(
            onTap: onTap,
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            borderRadius: const BorderRadius.all(Radius.circular(AppDimensions.radiusXs)),
            child: Text(isExternal ? '$text$externalMark' : text, style: style),
          ),
        ),
      ),
    );
  }
}
