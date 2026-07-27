import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/core/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/features/external_links/1_domain/external_link_launcher.dart';
import 'package:jccm_espacio_ciudadano/features/external_links/2_presentation/external_navigation_confirmation.dart';
import 'package:jccm_espacio_ciudadano/features/external_links/2_presentation/providers/external_links_provider.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Accessibility statement screen from Figma node `41853:13694`.
class AccessibilityPage extends ConsumerStatefulWidget {
  const AccessibilityPage({super.key});

  @override
  ConsumerState<AccessibilityPage> createState() => _AccessibilityPageState();
}

class _AccessibilityPageState extends ConsumerState<AccessibilityPage> {
  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundBlueLighter,
      appBar: AppNavBar(
        title: l10n.legalAccessibilityTitle,
        leading: IconButton(
          icon: const AppIcon(
            AppIcons.arrowBack,
            size: AppDimensions.iconLarge,
            color: AppColors.textPrimary,
          ),
          tooltip: MaterialLocalizations.of(context).backButtonTooltip,
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(Routes.homeFromDrawer);
            }
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.space16,
          vertical: AppDimensions.space24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _A11yHeading1('Declaración de accesibilidad'),
            const SizedBox(height: AppDimensions.space24),
            _AccessibilityBody(
              onRoyalDecreeTap: () => _openExternalLink('boe_rd_1112_2018'),
              onSiteTap: () => _openExternalLink('espacio_ciudadano'),
              onContactFormTap: () => _openExternalLink('accessibility_contact_form'),
              onOfficesTap: () => _openExternalLink('jccm_offices_oir'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openExternalLink(final String id) async {
    final link = ref.read(externalLinkCatalogProvider).findById(id);
    if (link == null) {
      return;
    }

    if (!await confirmExternalNavigation(context) || !mounted) {
      return;
    }
    final result = await ref.read(externalLinkLauncherProvider).launch(link);
    if (!mounted || result is! ExternalLinkLaunchFailure) {
      return;
    }

    AppAlertSnackbar.show(
      context,
      message: AppLocalizations.of(context).externalLinkOpenFailed,
      severity: AppAlertSeverity.error,
    );
  }
}

class _AccessibilityBody extends StatelessWidget {
  const _AccessibilityBody({
    required this.onRoyalDecreeTap,
    required this.onSiteTap,
    required this.onContactFormTap,
    required this.onOfficesTap,
  });

  final VoidCallback onRoyalDecreeTap;
  final VoidCallback onSiteTap;
  final VoidCallback onContactFormTap;
  final VoidCallback onOfficesTap;

  @override
  Widget build(final BuildContext context) {
    final style = AppTypography.leadingMedium.copyWith(color: AppColors.primary);
    final linkStyle = style.copyWith(
      color: AppColors.secondary,
      decoration: TextDecoration.underline,
      decorationColor: AppColors.secondary,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text.rich(
          TextSpan(
            style: style,
            children: [
              const TextSpan(
                text: 'La Junta de Comunidades de Castilla-La Mancha se ha comprometido a hacer accesible su sitio web, de conformidad con el ',
              ),
              _linkSpan(
                text: 'Real Decreto 1112/2018, de 7 de septiembre⇲',
                style: linkStyle,
                onTap: onRoyalDecreeTap,
              ),
              const TextSpan(
                text: ', sobre accesibilidad de los sitios web y aplicaciones para dispositivos móviles del sector público (en adelante, Real Decreto 1112/2018, de 7 de septiembre).\n\n',
              ),
              const TextSpan(
                text: 'La presente declaración de accesibilidad se aplica al sitio web ',
              ),
              _linkSpan(
                text: 'https://espaciociudadano.jccm.es/⇲',
                style: linkStyle,
                onTap: onSiteTap,
              ),
              const TextSpan(text: '.'),
            ],
          ),
        ),
        const _A11yHeading2('Situación de cumplimiento'),
        _richParagraph(
          style: style,
          spans: const [
            TextSpan(text: 'b) Este sitio web es '),
            TextSpan(
              text: 'parcialmente conforme ',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            TextSpan(text: 'con el RD 1112/2018, de 7 de septiembre, debido a la falta de conformidad de los aspectos que se indican a continuación.'),
          ],
        ),
        const _A11yHeading2('Contenido no accesible'),
        Text(
          'El contenido que se recoge a continuación no es accesible por los siguientes motivos:',
          style: style,
        ),
        const _A11yBulletList(
          items: [
            _A11yBullet(
              text: 'Podrían existir fallos puntuales de edición en alguna página web, tanto en contenidos HMTL como en documentos finales, publicados en fecha posterior al 20 de septiembre de 2018.',
              boldPrefix: 'falta de conformidad con el RD 1112/2018, de 7 de septiembre: ',
            ),
            _A11yBullet(
              text: ' No resulta aplicable.',
              boldPrefix: 'carga desproporcionada:',
            ),
            _A11yBullet(
              text: ' Podrían existir archivos ofimáticos en PDF u otros formatos publicados antes del 20 de septiembre de 2018 que no cumplan en su totalidad todos los requisitos de accesibilidad.',
              boldPrefix: 'el contenido no entra dentro del ámbito de la legislación aplicable:',
            ),
          ],
        ),
        const _A11yHeading2('Preparación de la presente declaración de accesibilidad'),
        Text(
          'La presente declaración ha sido preparada el 8 de Octubre de 2025.\n'
          'El método empleado para preparar la declaración ha sido una autoevaluación llevada a cabo por el propio organismo.',
          style: style,
        ),
        const _A11yHeading2('Observaciones y datos de contacto'),
        Text(
          'Puede realizar comunicaciones sobre requisitos de accesibilidad (artículo 10.2.a) del Real Decreto 1112/2018, de 7 de septiembre como, por ejemplo:',
          style: style,
        ),
        const _A11yBulletList(
          items: [
            _A11yBullet(text: 'informar sobre cualquier posible incumplimiento por parte de este sitio web,'),
            _A11yBullet(text: 'transmitir otras dificultades de acceso al contenido,'),
            _A11yBullet(text: 'formular cualquier otra consulta o sugerencia de mejora relativa a la accesibilidad del sitio web,'),
          ],
        ),
        Text('a través de las siguientes vías:', style: style),
        _A11yLinkedBulletList(
          style: style,
          linkStyle: linkStyle,
          contactFormTap: onContactFormTap,
          officesTap: onOfficesTap,
        ),
        Text(
          'Las comunicaciones serán recibidas y tratadas por la Viceconsejería de Administración Local y Coordinación Administrativa.',
          style: style,
        ),
        const _A11yHeading2('Procedimiento de aplicación'),
        Text(
          'El procedimiento de reclamación recogido en el artículo 13 del RD 1112/2018 entrará en vigor el 20 de septiembre de 2020.',
          style: style,
        ),
        const _A11yHeading2('Contenido opcional'),
        Text(
          'Además de las ayudas de accesibilidad propias de los navegadores se incorporan una serie de atajos de teclado para facilitar la navegación a través del portal:\n'
          'Una clave de acceso o Accesskey permite al usuario saltar de inmediato a una parte específica de una página web a través del teclado.',
          style: style,
        ),
        const _A11yBulletList(
          items: [
            _A11yBullet(text: 'Aumentar el Tamaño del Texto: CTRL +'),
            _A11yBullet(text: 'Reducir el Tamaño del Texto: CTRL -'),
          ],
        ),
      ],
    );
  }

  WidgetSpan _linkSpan({
    required final String text,
    required final TextStyle style,
    required final VoidCallback onTap,
  }) => WidgetSpan(
    alignment: PlaceholderAlignment.baseline,
    baseline: TextBaseline.alphabetic,
    child: InkWell(
      onTap: onTap,
      child: Text(text, style: style),
    ),
  );

  Widget _richParagraph({
    required final TextStyle style,
    required final List<InlineSpan> spans,
  }) => Text.rich(TextSpan(style: style, children: spans));
}

class _A11yHeading1 extends StatelessWidget {
  const _A11yHeading1(this.text);

  final String text;

  @override
  Widget build(final BuildContext context) => Semantics(
    header: true,
    headingLevel: 1,
    child: Text(
      text,
      style: AppTypography.h1.copyWith(color: AppColors.primary),
    ),
  );
}

class _A11yHeading2 extends StatelessWidget {
  const _A11yHeading2(this.text);

  final String text;

  @override
  Widget build(final BuildContext context) => Padding(
    padding: const EdgeInsets.only(
      top: AppDimensions.space32,
      bottom: AppDimensions.space16,
    ),
    child: Semantics(
      header: true,
      headingLevel: 2,
      child: Text(
        text,
        style: AppTypography.h2.copyWith(color: AppColors.primary),
      ),
    ),
  );
}

class _A11yBullet {
  const _A11yBullet({
    required this.text,
    this.boldPrefix,
  });

  final String? boldPrefix;
  final String text;
}

class _A11yBulletList extends StatelessWidget {
  const _A11yBulletList({required this.items});

  final List<_A11yBullet> items;

  @override
  Widget build(final BuildContext context) {
    final style = AppTypography.leadingMedium.copyWith(color: AppColors.primary);

    return Padding(
      padding: const EdgeInsets.only(top: AppDimensions.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final item in items)
            Padding(
              padding: const EdgeInsets.only(left: AppDimensions.space8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('• ', style: style),
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        style: style,
                        children: [
                          if (item.boldPrefix != null)
                            TextSpan(
                              text: item.boldPrefix,
                              style: const TextStyle(fontWeight: FontWeight.w700),
                            ),
                          TextSpan(text: item.text),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _A11yLinkedBulletList extends StatelessWidget {
  const _A11yLinkedBulletList({
    required this.style,
    required this.linkStyle,
    required this.contactFormTap,
    required this.officesTap,
  });

  final TextStyle style;
  final TextStyle linkStyle;
  final VoidCallback contactFormTap;
  final VoidCallback officesTap;

  @override
  Widget build(final BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: AppDimensions.space4),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _linkedBullet(
          children: [
            WidgetSpan(
              alignment: PlaceholderAlignment.baseline,
              baseline: TextBaseline.alphabetic,
              child: InkWell(
                onTap: contactFormTap,
                child: Text('formulario de contacto⇲', style: linkStyle),
              ),
            ),
            TextSpan(text: ',', style: style),
          ],
        ),
        _linkedBullet(
          children: [
            TextSpan(text: 'de manera presencial en ', style: style),
            WidgetSpan(
              alignment: PlaceholderAlignment.baseline,
              baseline: TextBaseline.alphabetic,
              child: InkWell(
                onTap: officesTap,
                child: Text('las oficinas del 012 y OIRES⇲', style: linkStyle),
              ),
            ),
            TextSpan(text: ' oficinas de información y registro).', style: style),
          ],
        ),
      ],
    ),
  );

  Widget _linkedBullet({required final List<InlineSpan> children}) => Padding(
    padding: const EdgeInsets.only(left: AppDimensions.space8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('• ', style: style),
        Expanded(
          child: Text.rich(
            TextSpan(
              style: style,
              children: children,
            ),
          ),
        ),
      ],
    ),
  );
}
