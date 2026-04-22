/// In-memory implementation of [HelpRepository].
///
/// All content is bundled with the app binary — no network call is required.
/// Content is written in Spanish (the primary locale of the app).
library;

import 'package:jccm_espacio_ciudadano/features/help/0_entity/contact_info.dart';
import 'package:jccm_espacio_ciudadano/features/help/0_entity/faq_item.dart';
import 'package:jccm_espacio_ciudadano/features/help/0_entity/help_guide.dart';
import 'package:jccm_espacio_ciudadano/features/help/1_domain/help_repository.dart';

/// Concrete [HelpRepository] backed entirely by static, bundled data.
final class HelpRepositoryImpl implements HelpRepository {
  const HelpRepositoryImpl();

  // ── FAQ items ─────────────────────────────────────────────────────────────

  static const List<FaqItem> _faqs = [
    FaqItem(
      id: 'faq-general-1',
      question: '¿Qué es el Espacio Ciudadano CLM?',
      answer:
          'El Espacio Ciudadano CLM es la aplicación móvil oficial de la Junta de '
          'Comunidades de Castilla-La Mancha que te permite acceder a tus trámites, '
          'notificaciones, carnets y servicios de la administración regional desde '
          'tu dispositivo móvil, de forma segura e identificándote con Cl@ve.',
      category: HelpCategory.general,
    ),
    FaqItem(
      id: 'faq-clave-1',
      question: '¿Cómo accedo con Cl@ve?',
      answer:
          'Cl@ve es el sistema de identificación electrónica de la Administración '
          'General del Estado. Para acceder, pulsa "Acceder con Cl@ve" en la '
          'pantalla de inicio, selecciona tu método preferido (Cl@ve PIN o Cl@ve '
          'permanente) y sigue las instrucciones. Si aún no estás registrado, puedes '
          'hacerlo en www.clave.gob.es.',
      category: HelpCategory.clave,
    ),
    FaqItem(
      id: 'faq-tramites-1',
      question: '¿Qué trámites puedo gestionar?',
      answer:
          'Puedes consultar el estado de tus expedientes administrativos en curso, '
          'recibir y firmar notificaciones electrónicas, acceder a tu historial de '
          'trámites y gestionar solicitudes relacionadas con los servicios de la '
          'Junta de Comunidades de Castilla-La Mancha.',
      category: HelpCategory.tramites,
    ),
    FaqItem(
      id: 'faq-carnets-1',
      question: '¿Puedo ver mi carnet joven digital?',
      answer:
          'Sí. Si dispones del Carnet Joven CLM, puedes visualizar la versión '
          'digital directamente desde la sección "Carnets" de la aplicación. '
          'Para activarlo, accede con Cl@ve y comprueba que tu carnet aparece '
          'en la pestaña correspondiente.',
      category: HelpCategory.carnets,
    ),
    FaqItem(
      id: 'faq-notificaciones-1',
      question: '¿Cómo activo las notificaciones?',
      answer:
          'Las notificaciones push se solicitan automáticamente la primera vez '
          'que inicias sesión. Si las rechazaste o quieres revisarlas, ve a los '
          'ajustes de tu dispositivo → Aplicaciones → Espacio Ciudadano CLM → '
          'Notificaciones y actívalas manualmente.',
      category: HelpCategory.notificaciones,
    ),
    FaqItem(
      id: 'faq-general-2',
      question: '¿Mis datos están seguros?',
      answer:
          'Sí. La aplicación cumple con el Reglamento General de Protección de '
          'Datos (RGPD) y la LOPDGDD. La autenticación se realiza a través de '
          'Cl@ve, el sistema oficial del Estado. Los datos se transmiten siempre '
          'cifrados mediante HTTPS y nunca se almacenan credenciales en el '
          'dispositivo.',
      category: HelpCategory.general,
    ),
  ];

  // ── Help guides ───────────────────────────────────────────────────────────

  static const List<HelpGuide> _guides = [
    HelpGuide(
      id: 'guide-clave-register',
      title: 'Cómo registrarse en Cl@ve',
      summary:
          'Guía paso a paso para crear tu cuenta Cl@ve y poder identificarte '
          'en los servicios de la Administración.',
      category: HelpCategory.clave,
      externalUrl: 'https://www.jccm.es',
    ),
    HelpGuide(
      id: 'guide-tramites-online',
      title: 'Trámites online de la JCCM',
      summary:
          'Catálogo de trámites disponibles en la sede electrónica de la Junta '
          'de Comunidades de Castilla-La Mancha.',
      category: HelpCategory.tramites,
      externalUrl: 'https://www.jccm.es/sede',
    ),
    HelpGuide(
      id: 'guide-carnet-joven',
      title: 'Carnet Joven CLM',
      summary:
          'Información sobre el Carnet Joven CLM: cómo solicitarlo, ventajas '
          'y cómo visualizarlo en formato digital desde la aplicación.',
      category: HelpCategory.carnets,
    ),
  ];

  // ── Contact information ───────────────────────────────────────────────────

  static const List<ContactInfo> _contacts = [
    ContactInfo(
      label: 'Atención ciudadana',
      value: '012',
      type: ContactType.phone,
    ),
    ContactInfo(
      label: 'Correo electrónico',
      value: 'administracion@jccm.es',
      type: ContactType.email,
    ),
    ContactInfo(
      label: 'Portal web JCCM',
      value: 'https://www.jccm.es',
      type: ContactType.url,
    ),
  ];

  // ── HelpRepository interface ──────────────────────────────────────────────

  @override
  List<FaqItem> getFaqs() => _faqs;

  @override
  List<HelpGuide> getGuides() => _guides;

  @override
  List<ContactInfo> getContacts() => _contacts;
}
