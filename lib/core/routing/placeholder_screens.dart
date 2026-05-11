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

// ── SSO / deep-link placeholder screens ───────────────────────────────────────

/// Placeholder registered for the Cl@ve SSO callback deep-link.
///
/// The route `/auth/clave/callback` must be declared in GoRouter so that the
/// OS intent-filter (Android) / URL-scheme (iOS) can hand the redirect back
/// to the app. `FlutterAppAuth` handles the actual token exchange internally;
/// this screen is shown only during the brief transition while the framework
/// completes the flow.
///
// TODO(JCCMEC-10): replace with the real login callback handler.
class ClaveCallbackScreen extends StatelessWidget {
  const ClaveCallbackScreen({super.key});

  @override
  Widget build(final BuildContext context) => const Scaffold(
    body: Center(child: CircularProgressIndicator()),
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
