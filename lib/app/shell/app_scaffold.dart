import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/app/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/app/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Authenticated shell scaffold.
///
/// Wraps all protected screens with a persistent [NavigationBar] that
/// drives the [ShellRoute] child. Navigation items correspond to the five
/// primary sections of the authenticated experience.
///
/// In addition to the primary navigation bar, an authenticated-only
/// global footer (STORY-62) provides quick access to the help center,
/// sitemap and legal pages. The footer is intentionally rendered inside
/// the `ShellRoute` only so unauthenticated public screens (landing,
/// login) remain free of secondary chrome (canon §17 — shell only
/// authenticated).
///
/// The shell intentionally carries no business logic — it only dispatches
/// `context.go()` calls on item tap and derives the active index from the
/// current route location.
class AppScaffold extends StatelessWidget {
  const AppScaffold({required this.child, super.key});

  /// The current page rendered inside the shell by GoRouter.
  final Widget child;

  static const _destinations = <(String path, IconData icon, String label)>[
    (Routes.home, Icons.home_outlined, 'Inicio'),
    (Routes.agenda, Icons.calendar_today_outlined, 'Agenda'),
    (Routes.casework, Icons.folder_outlined, 'Expedientes'),
    (Routes.notifications, Icons.notifications_outlined, 'Notificaciones'),
    (Routes.cards, Icons.credit_card_outlined, 'Tarjetas'),
  ];

  int _selectedIndex(final BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    final idx = _destinations.indexWhere(
      (final d) => location == d.$1 || location.startsWith('${d.$1}/'),
    );
    return idx < 0 ? 0 : idx;
  }

  @override
  Widget build(final BuildContext context) => Scaffold(
        body: Column(
          children: [
            Expanded(child: child),
            const _AuthenticatedFooter(),
          ],
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _selectedIndex(context),
          onDestinationSelected: (final int index) =>
              context.go(_destinations[index].$1),
          destinations: _destinations
              .map(
                (final d) => NavigationDestination(
                  icon: Icon(d.$2),
                  label: d.$3,
                ),
              )
              .toList(growable: false),
        ),
      );
}

/// Persistent secondary footer shown above the primary [NavigationBar]
/// inside the authenticated shell (STORY-62).
///
/// Provides access to help, sitemap and the four legal pages. Each
/// affordance is wrapped in [Semantics(button: true, label: ...)] so
/// assistive technologies announce the role correctly.
class _AuthenticatedFooter extends StatelessWidget {
  const _AuthenticatedFooter();

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    final List<(String route, String label)> items = <(String, String)>[
      (Routes.help, l10n.footerHelp),
      (Routes.sitemap, l10n.footerSitemap),
      (Routes.terms, l10n.footerTerms),
      (Routes.privacy, l10n.footerPrivacy),
      (Routes.accessibility, l10n.footerAccessibility),
      (Routes.legalNotice, l10n.footerLegalNotice),
    ];

    return Material(
      color: theme.colorScheme.surfaceContainerHighest,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.space12,
            vertical: AppDimensions.space8,
          ),
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: AppDimensions.space8,
            runSpacing: AppDimensions.space4,
            children: items
                .map(
                  (final entry) => Semantics(
                    button: true,
                    label: entry.$2,
                    child: TextButton(
                      onPressed: () => context.go(entry.$1),
                      child: Text(entry.$2),
                    ),
                  ),
                )
                .toList(growable: false),
          ),
        ),
      ),
    );
  }
}
