import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_modal_layout.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_typography.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_focus_ring.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// A single item in the drawer menu (primary section with icon).
class AppDrawerMenuItem {
  const AppDrawerMenuItem({
    required this.label,
    required this.icon,
    this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onTap;
}

/// A secondary link item (dark section below divider).
class AppDrawerLinkItem {
  const AppDrawerLinkItem({
    required this.label,
    this.icon,
    this.onTap,
  });

  final String label;

  /// Optional leading icon. When `null` the tile falls back to [Icons.arrow_forward_rounded].
  final IconData? icon;
  final VoidCallback? onTap;
}

/// Side drawer menu matching Figma node `44641:24181` — "Menu/DropMenu".
///
/// Layout (top → bottom):
/// 1. **Close bar** — secondary-base (`#117d98`) bg with underlined
///    "Cerrar menú" text + close icon.
/// 2. **Primary section** — secondary-base bg: greeting, NIF, nav items,
///    divider (`#156579`), and logout.
/// 3. **Secondary links** — primary-base (`#002855`) bg and white text.
/// 4. **Bottom action** — borderless white text + open-in-new icon.
///
/// Use with [Scaffold.endDrawer] or show via [showAppDrawerMenu].
class AppDrawerMenu extends StatelessWidget {
  const AppDrawerMenu({
    required this.userName,
    required this.nif,
    required this.primaryItems,
    super.key,
    this.secondaryLinks = const [],
    this.onLogout,
    this.onClose,
    this.identifierLabel = 'NIF/NIE',
    this.actionButtonLabel,
    this.onActionButton,
  });

  /// User display name shown in the greeting.
  final String userName;

  /// NIF/NIE displayed below the greeting.
  final String nif;

  /// Label describing the identifier type (e.g. DNI, NIE or NIF).
  final String identifierLabel;

  /// Primary navigation items (e.g. "Mi perfil", "Mis carnets digitales").
  final List<AppDrawerMenuItem> primaryItems;

  /// Secondary links shown below the divider (e.g. "Ayuda y Contacto").
  final List<AppDrawerLinkItem> secondaryLinks;

  /// Called when "Cerrar sesión" is tapped.
  final VoidCallback? onLogout;

  /// Called when the close button (X) is tapped.
  final VoidCallback? onClose;

  /// Label for the bottom action button (e.g. "Ir a Sede Electrónica").
  final String? actionButtonLabel;

  /// Called when the bottom action button is tapped.
  final VoidCallback? onActionButton;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final availableWidth = MediaQuery.sizeOf(context).width;

    return Drawer(
      width: availableWidth > AppDimensions.space64 ? availableWidth - AppDimensions.space64 : null,
      shape: const RoundedRectangleBorder(),
      backgroundColor: AppColors.primary,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: MediaQuery.paddingOf(context).top,
            color: AppColors.secondary,
          ),

          // ── Close bar (secondary bg) ─────────────────────────────────
          Container(
            width: double.infinity,
            color: AppColors.secondary,
            padding: const EdgeInsets.all(AppDimensions.space8),
            child: Align(
              alignment: Alignment.centerRight,
              // El foco inicial va al propio control: un `Focus` envolvente
              // añadía una parada de teclado sin nombre antes de «Cerrar»
              // (WCAG 2.4.3).
              child: Semantics(
                label: l10n.drawerCloseMenu,
                button: true,
                onTap: onClose ?? () => Navigator.of(context).pop(),
                child: ExcludeSemantics(
                  child: Material(
                    color: Colors.transparent,
                    child: _DrawerInkWell(
                      autofocus: true,
                      onTap: onClose ?? () => Navigator.of(context).pop(),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          minWidth: AppDimensions.minTouchTarget,
                          minHeight: AppDimensions.minTouchTarget,
                        ),
                        child: Wrap(
                          alignment: WrapAlignment.end,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(
                              l10n.drawerCloseMenu,
                              style: AppTypography.leadingMedium.copyWith(
                                color: AppColors.neutral000,
                                decoration: TextDecoration.underline,
                                decorationColor: AppColors.neutral000,
                              ),
                            ),
                            const SizedBox(width: AppDimensions.space4),
                            const Icon(
                              Icons.close,
                              color: AppColors.neutral000,
                              size: AppDimensions.iconMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ── Primary section (secondary bg) ───────────────────────────
          Expanded(
            child: LayoutBuilder(
              builder: (final context, final constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: IntrinsicHeight(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header + items block
                          Container(
                            width: double.infinity,
                            color: AppColors.secondary,
                            padding: const EdgeInsets.all(AppDimensions.space16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Greeting
                                Semantics(
                                  header: true,
                                  child: Text(
                                    l10n.drawerGreeting(userName),
                                    style: AppTypography.h2.copyWith(
                                      color: AppColors.textWhite,
                                    ),
                                  ),
                                ),
                                // NIF
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: '$identifierLabel:',
                                        style: AppTypography.smallBold.copyWith(
                                          color: AppColors.textWhite,
                                        ),
                                      ),
                                      TextSpan(
                                        text: ' $nif',
                                        style: AppTypography.smallRegular.copyWith(
                                          color: AppColors.textWhite,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: AppDimensions.space8),
                                // Primary nav items
                                for (var index = 0; index < primaryItems.length; index++) ...[
                                  if (index > 0) const SizedBox(height: AppDimensions.space8),
                                  _DrawerPrimaryTile(item: primaryItems[index]),
                                ],
                                // Divider before logout
                                if (onLogout != null) ...[
                                  const SizedBox(height: AppDimensions.space8),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: AppDimensions.space16,
                                      vertical: AppDimensions.space8,
                                    ),
                                    child: Container(
                                      height: 1,
                                      color: AppColors.secondaryDark,
                                    ),
                                  ),
                                  const SizedBox(height: AppDimensions.space8),
                                  _DrawerPrimaryTile(
                                    item: AppDrawerMenuItem(
                                      label: l10n.drawerLogout,
                                      icon: Icons.logout_rounded,
                                      onTap: onLogout,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),

                          // ── Secondary links (primary bg) ─────────────────────
                          ...secondaryLinks.map(
                            (final link) => _DrawerSecondaryTile(link: link),
                          ),

                          const Spacer(),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // ── Bottom action ────────────────────────────────────
          if (actionButtonLabel != null)
            Padding(
              padding: EdgeInsets.fromLTRB(
                AppDimensions.space24,
                AppDimensions.space16,
                AppDimensions.space24,
                MediaQuery.viewPaddingOf(context).bottom + AppDimensions.space12,
              ),
              child: SizedBox(
                width: double.infinity,
                // Abre la sede en el navegador: se anuncia como enlace
                // externo, igual que el resto de salidas de la app (4.1.2).
                child: Semantics(
                  label: actionButtonLabel,
                  link: true,
                  hint: l10n.externalLinkA11yHint,
                  enabled: onActionButton != null,
                  onTap: onActionButton,
                  child: ExcludeSemantics(
                    child: Material(
                      color: Colors.transparent,
                      child: _DrawerInkWell(
                        onTap: onActionButton,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            minHeight: AppDimensions.minTouchTarget,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppDimensions.space8,
                              vertical: AppDimensions.space8,
                            ),
                            child: Wrap(
                              alignment: WrapAlignment.center,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Text(
                                  actionButtonLabel!,
                                  textAlign: TextAlign.center,
                                  style: AppTypography.bodyRegular.copyWith(
                                    color: AppColors.textWhite,
                                  ),
                                ),
                                const SizedBox(width: AppDimensions.space4),
                                const Icon(
                                  Icons.open_in_new,
                                  color: AppColors.textWhite,
                                  size: AppDimensions.iconMedium,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _DrawerPrimaryTile extends StatelessWidget {
  const _DrawerPrimaryTile({required this.item});

  final AppDrawerMenuItem item;

  @override
  Widget build(final BuildContext context) {
    return Semantics(
      label: item.label,
      button: true,
      enabled: item.onTap != null,
      onTap: item.onTap,
      child: ExcludeSemantics(
        child: _DrawerInkWell(
          onTap: item.onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: AppDimensions.minTouchTarget),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: AppDimensions.space8),
              child: Row(
                children: [
                  Icon(item.icon, color: AppColors.textWhite, size: AppDimensions.iconMedium),
                  const SizedBox(width: AppDimensions.space16),
                  Expanded(
                    child: Text(
                      item.label,
                      style: AppTypography.leadingMedium.copyWith(color: AppColors.textWhite),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DrawerSecondaryTile extends StatelessWidget {
  const _DrawerSecondaryTile({required this.link});

  final AppDrawerLinkItem link;

  @override
  Widget build(final BuildContext context) {
    return Semantics(
      label: link.label,
      button: true,
      enabled: link.onTap != null,
      onTap: link.onTap,
      child: ExcludeSemantics(
        child: _DrawerInkWell(
          onTap: link.onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: AppDimensions.minTouchTarget),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.space16,
                vertical: AppDimensions.space12,
              ),
              child: Row(
                children: [
                  if (link.icon != null) ...[
                    Icon(
                      link.icon,
                      color: AppColors.neutral000,
                      size: AppDimensions.iconMedium,
                    ),
                    const SizedBox(width: AppDimensions.space16),
                  ],
                  Expanded(
                    child: Text(
                      link.label,
                      style: AppTypography.leadingMedium.copyWith(
                        color: AppColors.neutral000,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// `InkWell` del menú con el anillo de foco común (WCAG 1.4.11 / 2.4.7).
///
/// Sin sombreado de foco ni de paso del puntero: el blanco translúcido que
/// pinta Material aclaraba el fondo y dejaba el texto blanco en 3,8:1
/// (WCAG 1.4.3). El anillo ya indica el foco.
class _DrawerInkWell extends StatelessWidget {
  const _DrawerInkWell({
    required this.onTap,
    required this.child,
    this.autofocus = false,
  });

  final VoidCallback? onTap;
  final Widget child;
  final bool autofocus;

  @override
  Widget build(final BuildContext context) => AppFocusRing(
    enabled: onTap != null,
    child: InkWell(
      onTap: onTap,
      autofocus: autofocus,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      child: child,
    ),
  );
}

/// Shows the [AppDrawerMenu] as a modal aligned to the right edge.
///
/// ```dart
/// showAppDrawerMenu(
///   context: context,
///   userName: 'María del Pilar',
///   nif: '00000000Z',
///   primaryItems: [...],
/// );
/// ```
void showAppDrawerMenu({
  required final BuildContext context,
  required final String userName,
  required final String nif,
  required final List<AppDrawerMenuItem> primaryItems,
  final List<AppDrawerLinkItem> secondaryLinks = const [],
  final VoidCallback? onLogout,
  final String identifierLabel = 'NIF/NIE',
  final String? actionButtonLabel,
  final VoidCallback? onActionButton,
}) {
  unawaited(
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black54,
      transitionDuration: Duration.zero,
      pageBuilder: (final context, final animation, final secondaryAnimation) {
        return Align(
          alignment: Alignment.centerRight,
          child: ConstrainedBox(
            constraints: appModalSheetConstraints(context) ?? const BoxConstraints(),
            child: AppDrawerMenu(
              userName: userName,
              nif: nif,
              primaryItems: primaryItems,
              secondaryLinks: secondaryLinks,
              onLogout: onLogout,
              identifierLabel: identifierLabel,
              onClose: () => Navigator.of(context).pop(),
              actionButtonLabel: actionButtonLabel,
              onActionButton: onActionButton,
            ),
          ),
        );
      },
    ),
  );
}
