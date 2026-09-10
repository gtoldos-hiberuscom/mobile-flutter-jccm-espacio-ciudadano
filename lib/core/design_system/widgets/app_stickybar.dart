import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart' show AppButton;
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_page_layout.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_button.dart' show AppButton;
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Sticky bottom action bar — mirrors the Figma "Stickybar" component.
///
/// Renders a frosted-glass container anchored to the bottom of the screen with
/// up to 4 action buttons arranged vertically plus an optional text block.
///
/// **Visual specs (Figma):**
/// - Background: `#FFFFFF` 94% opacity
/// - Border: 1px `#0C0D0D` 8% opacity (all sides)
/// - Shadow: offset(0,1) blur 2 spread 0 `#000000` 12%
/// - Backdrop blur: 4
/// - Padding: M (16) top/left/right, 3XL (48) bottom
/// - Gap between children: M (16)
///
/// **Accessibility:**
/// - Wraps content in a [Semantics] container landmark.
/// - Individual button accessibility is delegated to [AppButton].
class AppStickybar extends StatelessWidget {
  const AppStickybar({
    required this.children,
    super.key,
    this.semanticLabel,
  }) : assert(children.length > 0, 'children must not be empty'),
       assert(semanticLabel == null || semanticLabel != '', 'semanticLabel must not be empty');

  /// Ordered list of actions (top to bottom). Typically [AppButton] instances.
  final List<Widget> children;
  final String? semanticLabel;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isLandscape = MediaQuery.orientationOf(context) == Orientation.landscape;
    final usesVerticalLayout = MediaQuery.textScalerOf(context).scale(1) > 1.5;
    return Semantics(
      container: true,
      explicitChildNodes: true,
      label: semanticLabel ?? l10n.a11yStickybarLabel,
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.surface.withValues(alpha: 0.94),
              border: Border.all(
                color: const Color(0xFF0C0D0D).withValues(alpha: 0.08),
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x1F000000), // #000000 12%
                  offset: Offset(0, 1),
                  blurRadius: 2,
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: Padding(
                padding: appPagePadding(
                  context,
                  top: AppDimensions.space16,
                  bottom: isLandscape ? AppDimensions.space16 : AppDimensions.space48,
                ),
                child: isLandscape && children.length > 1 && !usesVerticalLayout
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _buildHorizontalChildren(),
                      )
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: _buildSpacedChildren(),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildSpacedChildren() {
    final spaced = <Widget>[];
    for (int i = 0; i < children.length; i++) {
      spaced.add(
        Semantics(
          sortKey: OrdinalSortKey(i.toDouble()),
          child: children[i],
        ),
      );
      if (i < children.length - 1) {
        spaced.add(const SizedBox(height: AppDimensions.space16));
      }
    }
    return spaced;
  }

  List<Widget> _buildHorizontalChildren() {
    final spaced = <Widget>[];
    for (int i = 0; i < children.length; i++) {
      spaced.add(
        Expanded(
          child: Semantics(
            sortKey: OrdinalSortKey(i.toDouble()),
            child: children[i],
          ),
        ),
      );
      if (i < children.length - 1) {
        spaced.add(const SizedBox(width: AppDimensions.space12));
      }
    }
    return spaced;
  }
}
