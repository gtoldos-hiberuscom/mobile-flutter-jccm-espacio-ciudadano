import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/app/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Global footer widget shown at the bottom of public-facing screens.
///
/// Provides consistent access to legal, help and navigation links.
class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final year = DateTime.now().year;

    final links = <_FooterLink>[
      _FooterLink(label: l10n.footerHelp, route: Routes.help),
      _FooterLink(label: l10n.footerAccessibility, route: Routes.accessibility),
      _FooterLink(label: l10n.footerPrivacy, route: Routes.privacy),
      _FooterLink(label: l10n.footerLegalNotice, route: Routes.legalNotice),
      _FooterLink(label: l10n.footerSitemap, route: Routes.sitemap),
    ];

    return Container(
      color: theme.colorScheme.surfaceContainerHighest,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 4,
            children: [
              for (int i = 0; i < links.length; i++) ...[
                Semantics(
                  button: true,
                  label: links[i].label,
                  child: TextButton(
                    onPressed: () => context.go(links[i].route),
                    style: TextButton.styleFrom(
                      minimumSize: const Size(44, 44),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                    child: Text(
                      links[i].label,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ),
                if (i < links.length - 1)
                  Text(
                    '·',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.outline,
                    ),
                  ),
              ],
            ],
          ),
          const SizedBox(height: 4),
          Text(
            l10n.footerCopyright(year),
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.outline,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _FooterLink {
  const _FooterLink({required this.label, required this.route});
  final String label;
  final String route;
}
