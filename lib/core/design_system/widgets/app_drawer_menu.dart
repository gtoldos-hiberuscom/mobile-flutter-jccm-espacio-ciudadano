import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_typography.dart';

/// A single item in the drawer menu.
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

/// A secondary link item (bottom section of drawer).
class AppDrawerLinkItem {
  const AppDrawerLinkItem({
    required this.label,
    this.onTap,
  });

  final String label;
  final VoidCallback? onTap;
}

/// Side drawer menu matching Figma node `15:14576`.
///
/// Split into two sections:
/// - **Dark header** (`primaryDark` bg): greeting, NIF, primary nav items,
///   and logout.
/// - **Light footer** (`neutral000` bg): secondary links and an external
///   action button.
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

  /// Secondary links shown in the light bottom section.
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
      label: 'Menú de navegación',
      child: Drawer(
      width: MediaQuery.sizeOf(context).width * 0.82,
      shape: const RoundedRectangleBorder(),
      child: Column(
        children: [
          // ── Dark header section ──────────────────────────────────────────
          Expanded(
            child: ColoredBox(
              color: AppColors.primaryDark,
              child: SafeArea(
                bottom: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Close button
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: AppDimensions.space8,
                          right: AppDimensions.space8,
                        ),
                        child: TextButton.icon(
                          onPressed: onClose ?? () => Navigator.of(context).pop(),
                          icon: const Icon(
                            Icons.close,
                            color: AppColors.textOnPrimary,
                            size: AppDimensions.iconMedium,
                          ),
                          label: Text(
                            'Cerrar menu',
                            style: AppTypography.smallRegular.copyWith(
                              color: AppColors.textOnPrimary,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Greeting
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.space24,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hola, $userName',
                            style: AppTypography.h2.copyWith(
                              color: AppColors.textOnPrimary,
                            ),
                          ),
                          const SizedBox(height: AppDimensions.space4),
                          Text(
                            'NIF/NIE: $nif',
                            style: AppTypography.smallRegular.copyWith(
                              color: AppColors.textOnPrimary.withValues(alpha: 0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppDimensions.space24),
                    // Primary items
                    ...primaryItems.map(
                      (final item) => _DrawerPrimaryTile(item: item),
                    ),
                    const Spacer(),
                    // Logout
                    if (onLogout != null)
                      _DrawerPrimaryTile(
                        item: AppDrawerMenuItem(
                          label: 'Cerrar sesión',
                          icon: Icons.logout_rounded,
                          onTap: onLogout,
                        ),
                      ),
                    const SizedBox(height: AppDimensions.space16),
                  ],
                ),
              ),
            ),
          ),
          // ── Light footer section ─────────────────────────────────────────
          Container(
            color: AppColors.neutral000,
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.space24,
              vertical: AppDimensions.space16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...secondaryLinks.map(
                  (final link) => _DrawerSecondaryTile(link: link),
                ),
                if (actionButtonLabel != null) ...[
                  const SizedBox(height: AppDimensions.space16),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: onActionButton,
                      icon: const Icon(
                        Icons.open_in_new_rounded,
                        size: AppDimensions.iconSmall,
                      ),
                      label: Text(actionButtonLabel!),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(color: AppColors.primary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppDimensions.radiusRound,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: AppDimensions.space12,
                          horizontal: AppDimensions.space24,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
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
    return ListTile(
      leading: Icon(
        item.icon,
        color: AppColors.textOnPrimary,
        size: AppDimensions.iconMedium,
      ),
      title: Text(
        item.label,
        style: AppTypography.bodyRegular.copyWith(
          color: AppColors.textOnPrimary,
        ),
      ),
      onTap: item.onTap,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.space24,
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
            padding: const EdgeInsets.symmetric(vertical: AppDimensions.space12),
            child: Row(
              children: [
                const Icon(
                  Icons.arrow_forward_rounded,
                  color: AppColors.primary,
                  size: AppDimensions.iconSmall,
                ),
                const SizedBox(width: AppDimensions.space12),
                Expanded(
                  child: Text(
                    link.label,
                    style: AppTypography.bodyRegular.copyWith(
                      color: AppColors.textPrimary,
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
      barrierLabel: 'Cerrar menu',
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
