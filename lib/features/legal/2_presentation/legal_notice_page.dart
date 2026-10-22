import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/core/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Legal notice screen from Figma node `41853:13694`.
class LegalNoticePage extends ConsumerStatefulWidget {
  const LegalNoticePage({super.key});

  @override
  ConsumerState<LegalNoticePage> createState() => _LegalNoticePageState();
}

class _LegalNoticePageState extends ConsumerState<LegalNoticePage> {
  late final ScrollController _scrollController;
  final _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _searchController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundBlueLighter,
      appBar: AppNavBar(
        title: _isSearching ? null : l10n.legalNoticeTitle,
        titleWidget: _isSearching ? AppSearchField(controller: _searchController, autofocus: true) : null,
        actions: [
          IconButton(
            icon: AppIcon(_isSearching ? AppIcons.close : AppIcons.search, color: AppColors.textPrimary),
            tooltip: _isSearching ? l10n.legalSearchCloseTooltip : l10n.legalSearchTooltip,
            onPressed: () => setState(() {
              _isSearching = !_isSearching;
              if (!_isSearching) {
                _searchController.clear();
              }
            }),
          ),
        ],
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
      // `SafeArea` inferior y no un padding fijo: el último bloque quedaba
      // debajo del gesto de navegación del dispositivo y el texto parecía
      // cortado. Igual que en Accesibilidad y Protección de datos.
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          controller: _scrollController,
          padding: appPagePadding(context, top: AppDimensions.space32, bottom: AppDimensions.space48),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _LegalNoticeBody(highlightQuery: _searchController.text.trim()),
            ],
          ),
        ),
      ),
    );
  }
}

class _LegalNoticeBody extends StatelessWidget {
  const _LegalNoticeBody({required this.highlightQuery});

  final String highlightQuery;

  @override
  Widget build(final BuildContext context) {
    final bodyStyle = AppTypography.leadingMedium.copyWith(color: AppColors.textPrimary);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final block in _officialNoticeBlocks) ...[
          if (block.isHeading)
            Semantics(
              header: true,
              headingLevel: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: AppDimensions.space8),
                child: Text.rich(
                  TextSpan(
                    children: _legalTextSpans(block.text, highlightQuery),
                    style: AppTypography.h2.copyWith(color: AppColors.textPrimary),
                  ),
                ),
              ),
            )
          else
            Padding(
              padding: EdgeInsets.only(left: block.isBullet ? AppDimensions.space8 : 0),
              child: Text.rich(
                TextSpan(children: _legalTextSpans(block.isBullet ? '• ${block.text}' : block.text, highlightQuery), style: bodyStyle),
              ),
            ),
          const SizedBox(height: AppDimensions.space16),
        ],
      ],
    );
  }
}

class _LegalNoticeBlock {
  const _LegalNoticeBlock.heading(this.text) : isHeading = true, isBullet = false;
  const _LegalNoticeBlock.paragraph(this.text) : isHeading = false, isBullet = false;
  const _LegalNoticeBlock.bullet(this.text) : isHeading = false, isBullet = true;

  final String text;
  final bool isHeading;
  final bool isBullet;
}

final List<_LegalNoticeBlock> _officialNoticeBlocks = _officialNoticeText
    .trim()
    .split('\n')
    .map((final line) => line.trim())
    .where((final line) => line.isNotEmpty)
    .map(
      (final line) => RegExp(r'^\d+\\. ').hasMatch(line)
          ? _LegalNoticeBlock.heading(line)
          : line.startsWith('• ')
          ? _LegalNoticeBlock.bullet(line.substring(2))
          : _LegalNoticeBlock.paragraph(line),
    )
    .toList(growable: false);

const _officialNoticeText = '''
1. Objeto y ámbito de aplicación.
De acuerdo con la Ley 4/2025, de 11 de julio, de Simplificación, Agilización y Digitalización Administrativa, el Espacio Ciudadano se configura como un área de servicios digitales destinada a facilitar la relación de las personas físicas o jurídicas, empresas y demás entidades usuarias con la Administración de la Junta de Comunidades de Castilla-La Mancha, permitiendo el acceso a información, expedientes, trámites y comunicaciones relacionados con aquellos procedimientos en los que ostenten la condición de parte interesada.
El acceso a los contenidos y servicios personalizados del Espacio Ciudadano tiene carácter restringido y únicamente podrá realizarse previa acreditación de la identidad mediante sistemas de identificación electrónica habilitados.
La utilización del Espacio Ciudadano supone la aceptación de las condiciones contenidas en este Aviso Legal.
2. Titularidad del servicio.
El Espacio Ciudadano es un servicio digital titularidad de la Junta de Comunidades de Castilla-La Mancha, con CIF S1911001D y domicilio institucional en Plaza del Conde, n.º 5, 45071 Toledo.
La gestión tecnológica del Espacio Ciudadano corresponderá a la Dirección General de Digitalización e Inteligencia Artificial.
Serán responsables de la gestión, contenidos y servicios puestos a disposición de la ciudadanía en el Espacio Ciudadano los órganos y entidades titulares de la información, procedimientos y servicios incorporados al mismo. La responsabilidad se ejercerá de acuerdo con las competencias que tengan atribuidas por la normativa vigente.
La gestión de los contenidos expuestos en el servicio de Espacio Ciudadano corresponderá a la Agencia de Transformación Digital de Castilla-La Mancha, sin perjuicio de las competencias específicas atribuidas a los distintos órganos gestores responsables de la gestión de cada procedimiento, servicio o información asociada al mismo a través de la plataforma.
La Junta de Comunidades de Castilla-La Mancha podrá modificar, actualizar, ampliar o suprimir contenidos, funcionalidades y servicios del Espacio Ciudadano cuando resulte necesario por razones técnicas, organizativas, jurídicas o de mejora del servicio.
3. Acceso al Espacio Ciudadano.
El acceso al Espacio Ciudadano no requiere ningún registro específico previo distinto de la identificación electrónica de la persona usuaria.
El acceso podrá realizarse exclusivamente mediante alguno de los siguientes sistemas de identificación electrónica admitidos por la Junta de Comunidades de Castilla-La Mancha:
• Documento Nacional de Identidad electrónico (DNIe).
• Certificado electrónico cualificado de firma electrónica expedido por un prestador incluido en la Lista de Prestadores de Servicios Electrónicos de Confianza.
• Cl@ve móvil.
• Cl@ve permanente.
La persona usuaria será responsable de la adecuada custodia y utilización de sus medios de identificación electrónica empleados para acceder al Espacio Ciudadano, debiendo mantener la confidencialidad de las claves, certificados o credenciales asociadas y utilizar el Espacio Ciudadano de forma diligente y conforme a la legislación vigente, absteniéndose de realizar actuaciones que puedan comprometer la seguridad, disponibilidad o correcto funcionamiento del servicio.
Asimismo, deberá evitar accesos no autorizados a su información y velar por que el acceso se realice exclusivamente por ella misma o por una persona debidamente autorizada.
El uso de este sitio web implica la aceptación expresa e íntegra de las condiciones generales vigentes en el momento de acceder a él, sin perjuicio de las condiciones particulares que puedan aplicarse a contenidos o servicios del sitio web responsabilidad de otros.
La Junta de Comunidades de Castilla-La Mancha no responderá de los perjuicios que pudieran derivarse de la pérdida, sustracción, cesión o utilización indebida de los medios de identificación electrónica por parte de terceros.
4. Información y servicios disponibles en el Espacio Ciudadano.
A través del Espacio Ciudadano podrá ponerse a disposición de las personas usuarias la información prevista en la normativa reguladora del servicio y, en particular:
• Datos personales y de contacto aportados por la persona interesada.
• Datos obtenidos de otras Administraciones Públicas cuando ello resulte necesario para la prestación de servicios públicos y exista consentimiento.
• Relación de procedimientos y expedientes administrativos en los que se tenga la condición de persona interesada.
• Datos, informes y documentos que hayan sido elaborados por la Administración regional durante la tramitación de cualquier expediente administrativo, siempre que haya mediado autorización de la persona interesada.
• Comunicaciones, avisos y notificaciones asociadas a la actividad administrativa.
• Aquella otra información que pueda añadirse de acuerdo con el estado de la tecnología.
La información mostrada en el Espacio Ciudadano procede de los sistemas de información de la Junta de Comunidades de Castilla-La Mancha y, en su caso, de otras administraciones u organismos públicos integrados o interoperables.
La responsabilidad sobre la exactitud, integridad, actualización y contenido de cada dato corresponderá al órgano o entidad responsable de su generación o custodia.
La información accesible a través del Espacio Ciudadano podrá no comprender la totalidad de los datos, documentos, procedimientos o servicios relacionados con la persona interesada, en función del grado de integración y disponibilidad de los distintos sistemas de información.
Salvo disposición expresa en contrario, la información mostrada tendrá carácter informativo y no sustituirá a los documentos administrativos auténticos ni a los actos administrativos dictados por los órganos competentes.
El Espacio Ciudadano podrá incluir funcionalidades de aviso y seguimiento de la actividad administrativa de la persona interesada. Dichos avisos tendrán carácter meramente informativo y complementario y, en ningún caso, sustituirán a las comunicaciones o notificaciones administrativas practicadas conforme a la normativa aplicable.
5. Obligaciones de las personas usuarias.
La persona usuaria del Espacio Ciudadano, es la única responsable del uso que decida realizar de sus servicios.
El titular no será responsable en ningún caso del uso indebido del Espacio Ciudadano y de la información ofrecida a través de él, siendo la persona usuaria la única responsable por los daños y perjuicios que pudieran derivarse de un mal uso o de la infracción de lo dispuesto en las presentes condiciones en que pueda incurrir.
Así mismo, el titular podrá modificar las presentes condiciones en función de los cambios normativos y evolución tecnológica, modificaciones que serán informadas a las personas usuarias, que dichos cambios no afecten a los principios y derechos regulados en la normativa aplicable a las administraciones públicas y de protección de datos. También corresponde al titular la interpretación de las presentes condiciones, en cuantas cuestiones pudiera plantear su aplicación.
La persona usuaria del Espacio Ciudadano tiene las siguientes obligaciones:
• Custodiar sus credenciales con diligencia, impidiendo el acceso de terceras personas no autorizadas a estas y por tanto asegurando su confidencialidad.
• Notificar al titular, con carácter inmediato, cualquier indicio de la existencia de una violación en la seguridad del Espacio Ciudadano, de usos inapropiados o prohibidos de los servicios prestados desde el mismo, o de fallos de seguridad de cualquier índole.
• Hacer buen uso de los contenidos, información y servicios prestados desde o a través de la Carpeta Ciudadana, conforme a la ley, la buena fe y a las buenas costumbres generalmente aceptadas, comprometiéndose expresamente a:
• Abstenerse de realizar prácticas o usos de los servicios con fines ilícitos, fraudulentos, lesivos de derechos o intereses del titular o de terceros, infractores de las normas contenidas en el presente documento.
• Abstenerse de realizar cualquier tipo de acción que pudiera inutilizar, sobrecargar o dañar sistemas, equipos o servicios del Espacio Ciudadano o accesibles directa o indirectamente a través de éste.
• Respetar los derechos de propiedad intelectual e industrial del titular y de terceros sobre los contenidos, información y servicios prestados desde o a través del Espacio Ciudadano, absteniéndose con carácter general de copiar, distribuir, reproducir o comunicar en forma alguna los mismos a terceros, de no mediar autorización expresa y por escrito del titular o de los titulares de dichos derechos.
• No proporcionar información personal falsa en el Espacio Ciudadano, siendo el único responsable de la comunicación real y veraz de sus datos personales.
• No suplantar la personalidad de un tercero sin su autorización.
• Aceptar que el servicio pueda verse interrumpido cuando sea necesario por labores de mantenimiento. La duración de los tiempos de interrupción será la estrictamente imprescindible.
• La persona usuaria se compromete a mantener indemne al titular frente a las reclamaciones o sanciones que pudiera recibir de terceros, ya sean particulares o entidades públicas o privadas, por razón de dichas infracciones, así como frente a los daños y perjuicios de todo tipo que pueda sufrir como consecuencia de estas.
La enumeración anterior tiene mero carácter enunciativo y no es, en ningún caso, exclusivo ni excluyente en ninguno de sus puntos.
6. Servicios proactivos y personalizados.
De conformidad con la normativa reguladora del Espacio Ciudadano, la Junta de Comunidades de Castilla-La Mancha podrá ofrecer servicios de carácter proactivo y personalizado a través del Espacio Ciudadano con la finalidad de facilitar a las personas interesadas su relación con la Administración regional.
Los servicios proactivos podrán consistir en la puesta a disposición de información relativa a servicios o prestaciones que, atendiendo a la información disponible, pudieran resultar de interés para la persona interesada.
Los servicios personalizados podrán adaptar la información mostrada en el Espacio Ciudadano y las comunicaciones efectuadas a las circunstancias, preferencias o necesidades de la persona interesada, con el fin de facilitar el ejercicio de sus derechos y el cumplimiento de sus obligaciones en sus relaciones con la Administración regional.
Estos servicios se prestarán sobre la base de la información que obre en poder de la Administración regional y únicamente cuando se haya prestado el consentimiento de la persona interesada en los supuestos en que éste resulte exigible.
7. Sistemas automatizados e Inteligencia Artificial.
El Espacio Ciudadano podrá incorporar herramientas tecnológicas basadas en sistemas automatizados, analítica de datos, inteligencia artificial u otras tecnologías equivalentes destinadas a mejorar la prestación de los servicios públicos digitales y facilitar el acceso a la información y a los servicios disponibles.
La utilización de sistemas automatizados o de inteligencia artificial se realizará de conformidad con la normativa europea, estatal y autonómica que resulte de aplicación en cada momento, garantizando los principios de legalidad, transparencia, supervisión humana, seguridad, protección de datos personales, accesibilidad, igualdad y no discriminación.
Estas herramientas tendrán carácter auxiliar y de apoyo a la actividad administrativa.
Las respuestas, contenidos o recomendaciones generadas mediante dichas herramientas tendrán carácter informativo y no sustituirán a los actos administrativos, resoluciones o comunicaciones emitidos por los órganos competentes ni producirán efectos jurídicos por sí mismos.
8. Transparencia sobre la información y los servicios.
La Junta de Comunidades de Castilla-La Mancha procurará que la información disponible en el Espacio Ciudadano sea accesible, comprensible, actualizada y adecuada para facilitar las relaciones de las personas interesadas con la Administración regional.
La prestación de los servicios se realizará de acuerdo con los principios de transparencia, calidad de la información, accesibilidad, servicio efectivo a la ciudadanía y buena administración.
La existencia o ausencia de determinada información en el Espacio Ciudadano no alterará las competencias de los órganos responsables de los procedimientos administrativos ni modificará el régimen jurídico aplicable a los mismos.
9. Propiedad intelectual e industrial.
Todos los elementos, contenidos, diseños, aplicaciones, logotipos, distintivos, textos, imágenes y demás elementos que integran el Espacio Ciudadano son titularidad de la Junta de Comunidades de Castilla-La Mancha y se encuentran protegidos por la normativa vigente en materia de propiedad intelectual e industrial.
Cualquier quebranto de los derechos de propiedad intelectual e industrial dará lugar al ejercicio de las acciones legales pertinentes y, en su caso, a la responsabilidad que pudiera derivarse.
Los escudos, logotipos, marcas y símbolos distintivos (“elementos de identidad corporativa”) son propiedad exclusiva de la Junta. En ningún caso se autoriza la utilización de elementos de identidad corporativa de la Junta de Comunidades de Castilla-La Mancha en publicaciones y/o portales de Internet que no estén participados y/o sean titularidad de la Junta.
También queda prohibida la utilización por parte de terceros de cualquier mecanismo que altere el diseño, la configuración original o los contenidos del Espacio Ciudadano.
10. Responsabilidad.
La Junta de Comunidades de Castilla-La Mancha adoptará las medidas razonables para garantizar la disponibilidad, seguridad y correcto funcionamiento del Espacio Ciudadano, sin perjuicio de las interrupciones temporales que resulten necesarias por motivos técnicos, de mantenimiento o de mejora del servicio.
La Junta de Comunidades de Castilla-La Mancha no será responsable de los daños o perjuicios derivados de un uso indebido del Espacio Ciudadano y de la información ofrecida a través de dicho espacio, siendo el usuario el único responsable por los daños y perjuicios que pudieran derivarse de un mal uso de estos o de la infracción de lo dispuesto en las presentes condiciones en que pueda incurrir.
Tampoco responderá de las decisiones adoptadas por las personas usuarias sobre la base de la información meramente informativa u orientativa facilitada a través del Espacio Ciudadano o de sus herramientas de asistencia digital.
11. Enlaces a otros sitios web.
El Espacio Ciudadano podrá incluir enlaces a páginas web o servicios de otras administraciones públicas u organismos colaboradores, con el objeto de ofrecer al usuario información personalizada en su relación con las administraciones públicas.
12. Normativa aplicable.
El Espacio Ciudadano se regirá por la normativa vigente y, en particular, por:
• Ley 39/2015, de 1 de octubre, del Procedimiento Administrativo Común de las Administraciones Públicas.
• Ley 40/2015, de 1 de octubre, de Régimen Jurídico del Sector Público.
• El Reglamento (UE) 2016/679 del Parlamento Europeo y del Consejo de 27 de abril de 2016 relativo a la protección de las personas físicas en lo que respecta al tratamiento de datos personales y a la libre circulación de estos datos y por el que se deroga la Directiva 95/46/CE (Reglamento general de protección de datos).
• La Ley Orgánica 3/2018, de 5 de diciembre, de Protección de Datos Personales y garantía de los derechos digitales.
• El Real Decreto 203/2021, de 30 de marzo, por el que se aprueba el Reglamento de actuación y funcionamiento del sector público por medios electrónicos.
• La Ley 4/2025, de 11 de julio, de Simplificación, Agilización y Digitalización Administrativa de Castilla-La Mancha, y en particular las disposiciones reguladoras del Espacio Ciudadano y del Canal Empresa.
Asimismo, resultará de aplicación la restante normativa estatal y autonómica aplicable en materia de administración digital, interoperabilidad, transparencia, accesibilidad y seguridad de la información.
''';

/// Fragmentos de texto con las coincidencias de la búsqueda resaltadas.
List<TextSpan> _legalTextSpans(
  final String text,
  final String query,
) {
  if (query.isEmpty) {
    return [TextSpan(text: text)];
  }
  final matches = RegExp(RegExp.escape(query), caseSensitive: false).allMatches(text);
  final spans = <TextSpan>[];
  var start = 0;
  for (final match in matches) {
    if (match.start > start) {
      spans.add(TextSpan(text: text.substring(start, match.start)));
    }
    spans.add(
      TextSpan(
        text: text.substring(match.start, match.end),
        style: TextStyle(backgroundColor: AppColors.secondary.withValues(alpha: 0.3)),
      ),
    );
    start = match.end;
  }
  if (start < text.length) {
    spans.add(TextSpan(text: text.substring(start)));
  }
  return spans;
}
