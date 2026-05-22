import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_shadows.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_typography.dart';

/// A modal bottom-sheet following the JCCM design system (Figma node 113:5701).
///
/// Features:
/// - 80 % dark scrim (`#031B35 @ 80%`)
/// - White card with 16 dp radius, 8 dp gap between children
/// - Drag handle pill (80 × 8 dp, grey)
/// - "Salir" close button with underlined text + close icon
/// - Slots: [title], [body], optional [footer]
///
/// Use the static [AppBottomSheet.show] helper to display.
class AppBottomSheet extends StatelessWidget {
  const AppBottomSheet({
    required this.body,
    super.key,
    this.title,
    this.footer,
    this.onClose,
  });

  /// Bold title displayed below the drag handle.
  final String? title;

  /// Main content of the sheet.
  final Widget body;

  /// Optional footer area (e.g. secondary text + action button).
  final Widget? footer;

  /// Called when the close button is tapped. If null, pops the route.
  final VoidCallback? onClose;

  /// Shows the bottom sheet as a modal with the JCCM scrim colour.
  static Future<T?> show<T>({
    required final BuildContext context,
    required final Widget body,
    final String? title,
    final Widget? footer,
    final VoidCallback? onClose,
    final bool isDismissible = true,
    final bool enableDrag = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: const Color(0xCC031B35),
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      isScrollControlled: true,
      builder: (final context) => AppBottomSheet(
        title: title,
        body: body,
        footer: footer,
        onClose: onClose,
      ),
    );
  }

  @override
  Widget build(final BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(
          left: AppDimensions.space4,
          right: AppDimensions.space4,
          bottom: AppDimensions.space40,
          top: AppDimensions.space32,
        ),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.backgroundWhite,
            borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
            border: Border.all(color: const Color.fromRGBO(12, 13, 13, 0.5)),
            boxShadow: AppShadows.overAll,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(context),
              if (title != null)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.space16,
                  ),
                  child: _buildTitle(),
                ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.space16,
                  ),
                  child: body,
                ),
              ),
              if (footer != null)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.space16,
                  ),
                  child: footer,
                ),
              const SizedBox(height: AppDimensions.space32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(final BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: AppDimensions.space4,
        right: AppDimensions.space8,
      ),
      child: Row(
        children: [
          // Drag handle area (centered in remaining space)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.space4,
                vertical: AppDimensions.space8,
              ),
              child: Align(
                alignment: Alignment.centerRight,
                child: Container(
                  width: 80,
                  height: 8,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD9D9D9),
                    borderRadius: BorderRadius.circular(
                      AppDimensions.space64,
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Close button
          GestureDetector(
            onTap: onClose ?? () => Navigator.of(context).pop(),
            child: Container(
              height: AppDimensions.space48,
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.space8,
                vertical: AppDimensions.space4,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Salir',
                    style: AppTypography.leadingMedium.copyWith(
                      color: AppColors.textBase,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  const SizedBox(width: AppDimensions.space8),
                  const Icon(
                    Icons.close,
                    size: 20,
                    color: AppColors.textBase,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(
          top: AppDimensions.space4,
          bottom: AppDimensions.space8,
        ),
        child: Text(
          title ?? '',
          style: AppTypography.leadingBold.copyWith(
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }
}
