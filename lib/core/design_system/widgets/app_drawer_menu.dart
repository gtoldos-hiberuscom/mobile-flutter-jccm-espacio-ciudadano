import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_typography.dart';

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

/// Side drawer menu matching Figma node `15:16056` — "Menu/DropMenu".
///
/// Layout (top → bottom, all on primary-base `#002855` background):
/// 1. **Close bar** — secondary-base (`#117d98`) bg with underlined
///    "Cerrar menú" text + close icon.
/// 2. **Primary section** — secondary-base bg: greeting, NIF, nav items,
///    divider (`#156579`), and logout.
/// 3. **Divider** — neutral-400 (`#939090`) separator on primary bg.
/// 4. **Secondary links** — primary bg, arrow_forward icon + white text.
/// 5. **Action button** — white bg, secondary-light-400 border, 4 px radius,
///    black text + open_in_new icon.
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
    this.actionButtonLabel,
    this.onActionButton,
  });

  /// User display name shown in the greeting.
  final String userName;

  /// NIF/NIE displayed below the greeting.
  final String nif;

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
    return Semantics(
      container: true,
      scopesRoute: true,
      namesRoute: true,
      explicitChildNodes: true,
      label: 'Menú de navegación',
      child: Drawer(
        width: MediaQuery.sizeOf(context).width - AppDimensions.space64,
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
                child: Semantics(
                  label: 'Cerrar menu',
                  button: true,
                  child: ExcludeSemantics(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: onClose ?? () => Navigator.of(context).pop(),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            minWidth: AppDimensions.minTouchTarget,
                            minHeight: AppDimensions.space32,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                'Cerrar menu',
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
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.paddingOf(context).bottom,
                ),
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
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: AppDimensions.space16,
                            ),
                            child: Text(
                              'Hola, $userName',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.h2.copyWith(
                                color: AppColors.textWhite,
                              ),
                            ),
                          ),
                          // NIF
                          Padding(
                            padding: const EdgeInsets.only(
                              bottom: AppDimensions.space8,
                            ),
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'NIF/NIE:',
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
                          ),
                          const SizedBox(height: AppDimensions.space16),
                          // Primary nav items
                          for (var index = 0; index < primaryItems.length; index++) ...[
                            if (index > 0) const SizedBox(height: AppDimensions.space8),
                            _DrawerPrimaryTile(item: primaryItems[index]),
                          ],
                          // Divider before logout
                          if (onLogout != null) ...[
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
                                label: 'Cerrar sesión',
                                icon: Icons.logout_rounded,
                                onTap: onLogout,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),

                    // ── Divider (neutral400 on primary bg) ───────────────
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.space16,
                        vertical: AppDimensions.space8,
                      ),
                      child: Container(
                        height: 1,
                        color: AppColors.neutral400,
                      ),
                    ),

                    // ── Secondary links (primary bg) ─────────────────────
                    ...secondaryLinks.map(
                      (final link) => _DrawerSecondaryTile(link: link),
                    ),

                    // ── Action button ────────────────────────────────────
                    if (actionButtonLabel != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDimensions.space24,
                          vertical: AppDimensions.space16,
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          height: 47,
                          child: Material(
                            color: AppColors.neutral000,
                            elevation: AppDimensions.elevationLow,
                            shadowColor: Colors.black.withValues(alpha: 0.12),
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                color: AppColors.secondaryLight400,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(
                                AppDimensions.radiusXs,
                              ),
                            ),
                            child: InkWell(
                              onTap: onActionButton,
                              customBorder: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  AppDimensions.radiusXs,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppDimensions.space16,
                                  vertical: AppDimensions.space4,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        actionButtonLabel!,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: AppTypography.leadingMedium.copyWith(
                                          color: AppColors.textBase,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: AppDimensions.space8),
                                    const Icon(
                                      Icons.open_in_new,
                                      color: AppColors.textBase,
                                      size: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerPrimaryTile extends StatelessWidget {
  const _DrawerPrimaryTile({required this.item});

  final AppDrawerMenuItem item;

  @override
  Widget build(final BuildContext context) {
    return InkWell(
      onTap: item.onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AppDimensions.space4,
        ),
        child: Row(
          children: [
            Icon(
              item.icon,
              color: AppColors.textWhite,
              size: AppDimensions.iconMedium,
            ),
            const SizedBox(width: AppDimensions.space16),
            Expanded(
              child: Text(
                item.label,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.leadingMedium.copyWith(
                  color: AppColors.textWhite,
                ),
              ),
            ),
          ],
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
      child: InkWell(
        onTap: link.onTap,
        child: ExcludeSemantics(
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
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
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
    );
  }
}

/// Shows the [AppDrawerMenu] as a modal from the right edge.
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
  final String? actionButtonLabel,
  final VoidCallback? onActionButton,
}) {
  unawaited(
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Cerrar menú',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (final context, final animation, final secondaryAnimation) {
        return Align(
          alignment: Alignment.centerRight,
          child: AppDrawerMenu(
            userName: userName,
            nif: nif,
            primaryItems: primaryItems,
            secondaryLinks: secondaryLinks,
            onLogout: onLogout,
            onClose: () => Navigator.of(context).pop(),
            actionButtonLabel: actionButtonLabel,
            onActionButton: onActionButton,
          ),
        );
      },
      transitionBuilder: (final context, final animation, final secondaryAnimation, final child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
          child: child,
        );
      },
    ),
  );
}
