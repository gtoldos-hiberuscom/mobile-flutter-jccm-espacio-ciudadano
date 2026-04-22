import 'package:jccm_espacio_ciudadano/features/legal/0_entity/legal_document.dart';
import 'package:jccm_espacio_ciudadano/features/legal/1_domain/legal_repository.dart';

/// In-memory implementation of [LegalRepository].
///
/// All content is bundled with the app — no network call is required.
/// Each document is written in Spanish (the primary locale of the app) and
/// contains ~100–200 words of authoritative government text.
final class LegalRepositoryImpl implements LegalRepository {
  const LegalRepositoryImpl();

  @override
  LegalDocument getDocument(final LegalDocumentType type) {
    return switch (type) {
      LegalDocumentType.termsOfUse => _termsOfUse,
      LegalDocumentType.privacyPolicy => _privacyPolicy,
      LegalDocumentType.accessibility => _accessibility,
      LegalDocumentType.legalNotice => _legalNotice,
    };
  }

  // ── Terms of use ──────────────────────────────────────────────────────────

  static const LegalDocument _termsOfUse = LegalDocument(
    type: LegalDocumentType.termsOfUse,
    title: 'Condiciones de uso',
    content: '''
El acceso y uso de la aplicación Espacio Ciudadano CLM implica la aceptación plena y sin reservas de las presentes condiciones de uso. La Junta de Comunidades de Castilla-La Mancha se reserva el derecho a modificar dichas condiciones en cualquier momento, siendo responsabilidad del usuario consultarlas periódicamente.

El usuario se compromete a utilizar la aplicación de conformidad con la legislación vigente, la moral y el orden público, y a no emplearla para fines ilícitos o que puedan causar daños o perjuicios a terceros o a la propia Administración. Queda expresamente prohibida la reproducción, distribución o modificación no autorizada de los contenidos de esta aplicación.

La Junta de Comunidades de Castilla-La Mancha no garantiza la disponibilidad continuada ni la ausencia de errores en el servicio, y se reserva el derecho de interrumpirlo por razones técnicas o de mantenimiento. El acceso a determinados servicios requiere identificación mediante el sistema Cl@ve, gestionado por la Administración General del Estado.
''',
  );

  // ── Privacy policy ────────────────────────────────────────────────────────

  static const LegalDocument _privacyPolicy = LegalDocument(
    type: LegalDocumentType.privacyPolicy,
    title: 'Protección de datos',
    content: '''
De conformidad con lo dispuesto en el Reglamento (UE) 2016/679 del Parlamento Europeo y del Consejo (RGPD) y la Ley Orgánica 3/2018 de Protección de Datos Personales y garantía de los derechos digitales (LOPDGDD), la Junta de Comunidades de Castilla-La Mancha le informa de que los datos personales recabados a través de esta aplicación serán tratados bajo la responsabilidad de la Junta de Comunidades de Castilla-La Mancha, con el fin de prestarle los servicios de administración electrónica incluidos en el Espacio Ciudadano.

La finalidad del tratamiento es la identificación del ciudadano para la prestación de servicios administrativos electrónicos, la gestión de trámites y el envío de notificaciones relacionadas con dichos servicios. La base jurídica del tratamiento es el cumplimiento de una misión de interés público o el ejercicio de poderes públicos conferidos a la Junta de Comunidades de Castilla-La Mancha.

Sus datos no serán cedidos a terceros, salvo en los casos previstos legalmente. De acuerdo con la Ley 3/2017 de la Junta de Comunidades de Castilla-La Mancha, tiene usted derecho a acceder, rectificar y suprimir sus datos (derechos ARCO), así como a ejercer los demás derechos reconocidos en la normativa aplicable, mediante escrito dirigido a la Secretaría General de la Junta de Comunidades de Castilla-La Mancha, Calle Pío XII, 4 — 45071 Toledo.
''',
  );

  // ── Accessibility ─────────────────────────────────────────────────────────

  static const LegalDocument _accessibility = LegalDocument(
    type: LegalDocumentType.accessibility,
    title: 'Accesibilidad',
    content: '''
La Junta de Comunidades de Castilla-La Mancha se compromete a hacer esta aplicación accesible de conformidad con el Real Decreto 1112/2018, de 7 de septiembre, sobre accesibilidad de los sitios web y aplicaciones para dispositivos móviles del sector público, que transpone la Directiva (UE) 2016/2102.

Esta aplicación aspira a cumplir el nivel de conformidad AA de las Pautas de Accesibilidad para el Contenido Web (WCAG) 2.1. Se han adoptado medidas técnicas para garantizar que los usuarios con discapacidad visual, auditiva o motriz puedan acceder a los servicios ofrecidos, incluyendo compatibilidad con los lectores de pantalla más habituales en iOS y Android (VoiceOver y TalkBack).

Si detecta alguna barrera de accesibilidad o tiene dificultades para utilizar cualquier funcionalidad de la aplicación, puede comunicarlo a través del correo electrónico accesibilidad@jccm.es o del formulario de contacto disponible en www.jccm.es. Su organización se compromete a atender las solicitudes en un plazo máximo de 15 días hábiles.
''',
  );

  // ── Legal notice ──────────────────────────────────────────────────────────

  static const LegalDocument _legalNotice = LegalDocument(
    type: LegalDocumentType.legalNotice,
    title: 'Aviso legal',
    content: '''
La Junta de Comunidades de Castilla-La Mancha, con domicilio en Calle Pío XII, 4 — 45071 Toledo, es titular de la aplicación Espacio Ciudadano CLM y del dominio jccm.es. El acceso a esta aplicación y el uso de sus contenidos está sujeto al presente aviso legal, sin perjuicio de las condiciones particulares aplicables a servicios específicos.

Todos los contenidos de esta aplicación — incluyendo textos, imágenes, logotipos y código fuente — son propiedad de la Junta de Comunidades de Castilla-La Mancha o de terceros que han autorizado su uso, y están protegidos por la legislación española e internacional sobre propiedad intelectual e industrial. Queda prohibida su reproducción, distribución, comunicación pública o transformación sin autorización expresa.

La Junta de Comunidades de Castilla-La Mancha no se hace responsable de los daños derivados del uso incorrecto de la aplicación, de fallos técnicos ajenos a su control, ni de la información contenida en sitios web de terceros a los que se pueda acceder mediante enlaces. El uso de la aplicación implica la aceptación del presente aviso legal, que podrá ser modificado sin previo aviso.
''',
  );
}
