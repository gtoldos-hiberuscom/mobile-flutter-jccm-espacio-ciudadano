import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/features/landing/0_entity/landing_content.dart';

/// Provides the static [LandingContent] for the public landing screen.
///
/// Content is hardcoded for this sprint — no network call is required.
/// `keepAlive` defaults to `false` so the provider is disposed when no longer
/// watched, which is acceptable for a screen-level provider.
final landingContentProvider = Provider<LandingContent>((final ref) {
  return const LandingContent(
    appTitle: 'Espacio Ciudadano',
    tagline: 'Tu información pública en un solo lugar',
    features: [
      LandingFeatureItem(
        icon: 'notifications',
        title: 'Notificaciones',
        description: 'Recibe alertas y avisos de la administración directamente en tu dispositivo.',
      ),
      LandingFeatureItem(
        icon: 'health',
        title: 'Sanidad',
        description: 'Consulta tu historial médico, citas y tarjeta sanitaria.',
      ),
      LandingFeatureItem(
        icon: 'work',
        title: 'Empleo',
        description: 'Gestiona tu situación laboral y accede a ofertas de empleo público.',
      ),
      LandingFeatureItem(
        icon: 'assignment',
        title: 'Trámites',
        description: 'Realiza gestiones administrativas sin desplazarte.',
      ),
      LandingFeatureItem(
        icon: 'badge',
        title: 'Carnets Digitales',
        description: 'Accede a tus carnets y documentos oficiales en formato digital.',
      ),
      LandingFeatureItem(
        icon: 'map',
        title: 'Catastro',
        description: 'Consulta datos catastrales de tus inmuebles.',
      ),
    ],
    accessSteps: [
      LandingAccessStep(
        stepNumber: 1,
        title: 'Pulsa "Acceder"',
        description: 'Toca el botón para iniciar el proceso de autenticación segura.',
      ),
      LandingAccessStep(
        stepNumber: 2,
        title: 'Autentícate con Cl@ve',
        description: 'Usa Cl@ve PIN o Cl@ve Permanente para identificarte de forma segura.',
      ),
      LandingAccessStep(
        stepNumber: 3,
        title: 'Accede a toda tu información',
        description: 'Consulta y gestiona tu información pública desde un único lugar.',
      ),
    ],
    links: LandingLinks(
      helpUrl: 'https://www.jccm.es/ciudadanos/ayuda',
      accessibilityUrl: 'https://www.jccm.es/accesibilidad',
      legalUrl: 'https://www.jccm.es/aviso-legal',
      privacyUrl: 'https://www.jccm.es/proteccion-datos',
    ),
  );
});
