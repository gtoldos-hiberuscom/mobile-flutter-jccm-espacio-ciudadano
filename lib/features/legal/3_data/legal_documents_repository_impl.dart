import 'package:jccm_espacio_ciudadano/features/legal/0_entity/legal_document.dart';
import 'package:jccm_espacio_ciudadano/features/legal/1_domain/legal_documents_repository.dart';

/// Bundled legal/static documents shipped with the binary.
///
/// AC: offline-first because content is bundled.
///
/// The privacy text reuses (and extends) the consent body shown during
/// the post-login onboarding flow so the user sees consistent wording
/// (canon §29 — consistency between onboarding, footer and static pages).
///
/// TODO(l10n): translate body markdown when the legal team approves
///   the canonical English copy. Titles are already routed through ARB.
final class LegalDocumentsRepositoryImpl implements LegalDocumentsRepository {
  const LegalDocumentsRepositoryImpl();

  static const String _placeholderNotice = 'Texto operativo pendiente de validación legal — STORY-61 baseline.';

  // --- Bodies ---------------------------------------------------------------

  static const String _termsBody = '''
Las presentes Condiciones de uso regulan el acceso y la utilización de la aplicación Espacio Ciudadano de la Junta de Comunidades de Castilla-La Mancha por parte de la ciudadanía.

El uso de la aplicación implica la aceptación expresa de estas condiciones, así como del aviso legal y de la política de protección de datos.

La persona usuaria se compromete a hacer un uso lícito de los servicios disponibles, a no realizar accesos no autorizados y a mantener la confidencialidad de sus credenciales de identificación electrónica.

$_placeholderNotice''';

  static const String _privacyBody = '''
De conformidad con lo dispuesto en el Reglamento (UE) 2016/679 del Parlamento Europeo y del Consejo (RGPD) y la Ley Orgánica 3/2018 de Protección de Datos Personales y garantía de los derechos digitales (LOPDGDD), la Junta de Comunidades de Castilla-La Mancha le informa de que los datos personales recabados a través de esta aplicación serán tratados bajo la responsabilidad de la Junta de Comunidades de Castilla-La Mancha, con el fin de prestarle los servicios de administración electrónica incluidos en el Espacio Ciudadano.

De acuerdo con la Ley 3/2017 de la Junta de Comunidades de Castilla-La Mancha, tiene usted derecho a acceder, rectificar y suprimir sus datos, así como a ejercer los demás derechos reconocidos en la normativa aplicable, mediante escrito dirigido a la Secretaría General de la Junta de Comunidades de Castilla-La Mancha.

Para continuar utilizando la aplicación debe aceptar las presentes condiciones de uso y protección de datos.

$_placeholderNotice''';

  static const String _accessibilityBody = '''
La Junta de Comunidades de Castilla-La Mancha trabaja para que esta aplicación sea accesible conforme al Real Decreto 1112/2018 y a las directrices WCAG 2.1 nivel AA.

Características de accesibilidad implementadas:
- Etiquetado semántico de elementos interactivos para lectores de pantalla.
- Contraste de color suficiente y soporte de tipografía escalable.
- Navegación por teclado y áreas táctiles ampliadas.

Si encuentra alguna barrera de accesibilidad, comuníquela a través del canal de contacto del centro de ayuda.

$_placeholderNotice''';

  static const String _legalNoticeBody = '''
Aviso legal de la aplicación Espacio Ciudadano.

Titularidad: Junta de Comunidades de Castilla-La Mancha.

La información contenida en esta aplicación tiene carácter meramente divulgativo y no sustituye en ningún caso a las publicaciones oficiales de los diarios y boletines correspondientes.

La Junta de Comunidades de Castilla-La Mancha no se responsabiliza del uso indebido de los contenidos por parte de terceros ni de las consecuencias que puedan derivarse de su uso.

$_placeholderNotice''';

  static const List<LegalDocument> _documents = <LegalDocument>[
    LegalDocument(
      id: LegalDocumentId.terms,
      titleKey: 'legalTermsTitle',
      bodyMarkdown: _termsBody,
    ),
    LegalDocument(
      id: LegalDocumentId.privacy,
      titleKey: 'legalPrivacyTitle',
      bodyMarkdown: _privacyBody,
    ),
    LegalDocument(
      id: LegalDocumentId.accessibility,
      titleKey: 'legalAccessibilityTitle',
      bodyMarkdown: _accessibilityBody,
    ),
    LegalDocument(
      id: LegalDocumentId.legalNotice,
      titleKey: 'legalNoticeTitle',
      bodyMarkdown: _legalNoticeBody,
    ),
  ];

  @override
  List<LegalDocument> all() => List<LegalDocument>.unmodifiable(_documents);

  @override
  LegalDocument? findById(final LegalDocumentId id) {
    for (final d in _documents) {
      if (d.id == id) {
        return d;
      }
    }
    return null;
  }
}
