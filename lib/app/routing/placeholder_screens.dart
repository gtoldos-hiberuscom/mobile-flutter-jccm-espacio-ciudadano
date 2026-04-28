import 'package:flutter/material.dart';

// ──────────────────────────────────────────────────────────────────────────────
// Routing placeholder screens
//
// These are MINIMAL scaffolds used only to make routing compile while feature
// screens are built in their respective feature stories. They live in app/
// namespace because they belong to no single feature domain.
//
// DO NOT add business logic here. Replace each entry point with the real
// feature screen once it is implemented.
// ──────────────────────────────────────────────────────────────────────────────

/// Maintenance mode screen.
///
/// Displayed instead of any other screen when the backend reports a
/// maintenance window. No navigation chrome is shown.
class MaintenanceScreen extends StatelessWidget {
  const MaintenanceScreen({super.key});

  @override
  Widget build(final BuildContext context) => Scaffold(
    body: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.build_circle_outlined, size: 64),
          const SizedBox(height: 16),
          Text(
            'En mantenimiento',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          const Text('Vuelva a intentarlo más tarde.'),
        ],
      ),
    ),
  );
}

/// Generic 404 / not-found screen.
class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(final BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Página no encontrada')),
    body: const Center(child: Text('404 — La ruta solicitada no existe.')),
  );
}

// ── Authenticated placeholder screens ─────────────────────────────────────────


/// Placeholder for the thematic landing screens (Educación, Empleo,
/// Bienestar Social, Estado/Otros) that are wired from the home dashboard.
///
/// The real pages are implemented in STORY-23/24/25/26. This placeholder
/// simply renders the title so navigation from the home is observable.
// TODO(STORY-23/24/25/26): replace with real thematic landing pages.
class DomainLandingPlaceholder extends StatelessWidget {
  const DomainLandingPlaceholder({required this.title, super.key});

  final String title;

  @override
  Widget build(final BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(title)),
    body: Center(child: Text('$title (placeholder)')),
  );
}

class AgendaPlaceholder extends StatelessWidget {
  const AgendaPlaceholder({super.key});

  @override
  Widget build(final BuildContext context) => const Center(child: Text('Agenda (placeholder)'));
}

class CaseworkPlaceholder extends StatelessWidget {
  const CaseworkPlaceholder({super.key});

  @override
  Widget build(final BuildContext context) => const Center(child: Text('Expedientes (placeholder)'));
}

class NotificationsPlaceholder extends StatelessWidget {
  const NotificationsPlaceholder({super.key});

  @override
  Widget build(final BuildContext context) => const Center(child: Text('Notificaciones (placeholder)'));
}

class CardsPlaceholder extends StatelessWidget {
  const CardsPlaceholder({super.key});

  @override
  Widget build(final BuildContext context) => const Center(child: Text('Tarjetas (placeholder)'));
}

class ProfilePlaceholder extends StatelessWidget {
  const ProfilePlaceholder({super.key});

  @override
  Widget build(final BuildContext context) => const Center(child: Text('Perfil (placeholder)'));
}

class RecommendationsPlaceholder extends StatelessWidget {
  const RecommendationsPlaceholder({super.key});

  @override
  Widget build(final BuildContext context) => const Center(child: Text('Recomendaciones (placeholder)'));
}

class SupportPlaceholder extends StatelessWidget {
  const SupportPlaceholder({super.key});

  @override
  Widget build(final BuildContext context) => const Center(child: Text('Soporte (placeholder)'));
}

// ── Public / legal placeholder screens ────────────────────────────────────────

class LoginPlaceholder extends StatelessWidget {
  const LoginPlaceholder({super.key});

  @override
  Widget build(final BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Acceso')),
    body: const Center(child: Text('Login (placeholder)')),
  );
}

class LegalPlaceholder extends StatelessWidget {
  const LegalPlaceholder({required this.title, super.key});
  final String title;

  @override
  Widget build(final BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(title)),
    body: Center(child: Text('$title (placeholder)')),
  );
}

class HelpPlaceholder extends StatelessWidget {
  const HelpPlaceholder({super.key});

  @override
  Widget build(final BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Ayuda')),
    body: const Center(child: Text('Ayuda (placeholder)')),
  );
}

class SitemapPlaceholder extends StatelessWidget {
  const SitemapPlaceholder({super.key});

  @override
  Widget build(final BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Mapa del sitio')),
    body: const Center(child: Text('Mapa del sitio (placeholder)')),
  );
}

/// Placeholder for the deep-link login callback screen.
class LoginCallbackPlaceholder extends StatelessWidget {
  const LoginCallbackPlaceholder({super.key});

  @override
  Widget build(final BuildContext context) => const Scaffold(
    body: Center(child: CircularProgressIndicator()),
  );
}
