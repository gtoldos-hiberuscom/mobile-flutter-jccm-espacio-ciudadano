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
    this.horizontalMargin = AppDimensions.space16,
  });

  /// Bold title displayed below the drag handle.
  final String? title;

  /// Main content of the sheet.
  final Widget body;

  /// Optional footer area (e.g. secondary text + action button).
  final Widget? footer;

  /// Called when the close button is tapped. If null, pops the route.
  final VoidCallback? onClose;

  /// Horizontal spacing between the sheet and the viewport edge.
  final double horizontalMargin;

  /// Shows the bottom sheet as a modal with the JCCM scrim colour.
  static Future<T?> show<T>({
    required final BuildContext context,
    required final Widget body,
    final String? title,
    final Widget? footer,
    final VoidCallback? onClose,
    final bool isDismissible = true,
    final bool enableDrag = true,
    final double horizontalMargin = AppDimensions.space16,
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
        horizontalMargin: horizontalMargin,
      ),
    );
  }

  @override
  Widget build(final BuildContext context) {
    return Semantics(
      container: true,
      scopesRoute: true,
      namesRoute: true,
      explicitChildNodes: true,
      label: title ?? 'Panel inferior',
      child: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.only(
                bottom: AppDimensions.space40,
                top: AppDimensions.space32,
              ).copyWith(
                left: horizontalMargin,
                right: horizontalMargin,
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
          Semantics(
            label: 'Cerrar',
            button: true,
            child: GestureDetector(
              onTap: onClose ?? () => Navigator.of(context).pop(),
              child: ExcludeSemantics(
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

/// Bottom-sheet body for the digital-card QR download options.
///
/// Matches the Figma bottom-sheet variant with a QR preview and download
/// format actions.
class AppQrDownloadBottomSheetBody extends StatelessWidget {
  const AppQrDownloadBottomSheetBody({
    super.key,
    this.onQrPressed,
    this.onPkPassPressed,
    this.onPdfPressed,
  });

  final VoidCallback? onQrPressed;
  final VoidCallback? onPkPassPressed;
  final VoidCallback? onPdfPressed;

  @override
  Widget build(final BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _QrPreview(),
          const SizedBox(height: AppDimensions.space24),
          const Divider(height: 1, color: AppColors.neutral100),
          const SizedBox(height: AppDimensions.space32),
          Text(
            'Formato de descarga',
            style: AppTypography.leadingBold.copyWith(color: AppColors.primary),
          ),
          const SizedBox(height: AppDimensions.space24),
          _DownloadFormatButton(
            label: 'QR',
            onPressed: onQrPressed,
          ),
          const SizedBox(height: AppDimensions.space16),
          _DownloadFormatButton(
            label: 'PASSPK',
            onPressed: onPkPassPressed,
          ),
          const SizedBox(height: AppDimensions.space16),
          _DownloadFormatButton(
            label: 'PDF',
            onPressed: onPdfPressed,
            primary: true,
          ),
        ],
      ),
    );
  }
}

class _QrPreview extends StatelessWidget {
  const _QrPreview();

  @override
  Widget build(final BuildContext context) {
    return Semantics(
      label: 'Código QR',
      image: true,
      child: ExcludeSemantics(
        child: AspectRatio(
          aspectRatio: 1,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.backgroundWhite,
              borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
              border: Border.all(color: AppColors.neutral100),
            ),
            child: const Padding(
              padding: EdgeInsets.all(AppDimensions.space16),
              child: CustomPaint(painter: _QrPreviewPainter()),
            ),
          ),
        ),
      ),
    );
  }
}

class _DownloadFormatButton extends StatelessWidget {
  const _DownloadFormatButton({
    required this.label,
    required this.onPressed,
    this.primary = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool primary;

  @override
  Widget build(final BuildContext context) {
    final background = primary ? AppColors.primary : AppColors.backgroundWhite;
    final foreground = primary ? AppColors.textOnPrimary : AppColors.textBlack;
    final border = primary ? AppColors.primary : AppColors.secondaryLight400;

    return Semantics(
      button: true,
      label: 'Descargar $label',
      child: ExcludeSemantics(
        child: SizedBox(
          height: AppDimensions.space64,
          child: OutlinedButton(
            onPressed: onPressed,
            style: OutlinedButton.styleFrom(
              backgroundColor: background,
              foregroundColor: foreground,
              side: BorderSide(color: border, width: 2),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(AppDimensions.radiusXs),
                ),
              ),
              textStyle: AppTypography.leadingMedium,
            ),
            child: Text('+  $label  +'),
          ),
        ),
      ),
    );
  }
}

class _QrPreviewPainter extends CustomPainter {
  const _QrPreviewPainter();

  static const int _size = 29;
  static const int _finderSize = 7;

  @override
  void paint(final Canvas canvas, final Size size) {
    final side = size.shortestSide;
    final offset = Offset((size.width - side) / 2, (size.height - side) / 2);
    final cell = side / _size;

    final blackPaint = Paint()..color = AppColors.neutral1000;
    final gridPaint = Paint()
      ..color = AppColors.neutral100.withValues(alpha: 0.35)
      ..strokeWidth = 0.5;

    for (var row = 0; row < _size; row++) {
      for (var col = 0; col < _size; col++) {
        if (_isDark(row, col)) {
          canvas.drawRect(
            Rect.fromLTWH(
              offset.dx + col * cell,
              offset.dy + row * cell,
              cell,
              cell,
            ),
            blackPaint,
          );
        }
      }
    }

    for (var i = 1; i < _size; i++) {
      final p = i * cell;
      canvas
        ..drawLine(
          offset + Offset(p, 0),
          offset + Offset(p, side),
          gridPaint,
        )
        ..drawLine(
          offset + Offset(0, p),
          offset + Offset(side, p),
          gridPaint,
        );
    }
  }

  bool _isDark(final int row, final int col) {
    if (_inFinder(row, col, 0, 0) || _inFinder(row, col, 0, _size - _finderSize) || _inFinder(row, col, _size - _finderSize, 0)) {
      return _finderCell(
        row % (_size - _finderSize),
        col % (_size - _finderSize),
      );
    }

    if (_isReservedFinderArea(row, col)) {
      return false;
    }

    final value = row * 17 + col * 31 + row * col * 7 + (row ^ col) * 11;
    return value % 5 == 0 || value % 7 == 0 || value % 13 == 0;
  }

  bool _inFinder(
    final int row,
    final int col,
    final int top,
    final int left,
  ) {
    return row >= top && row < top + _finderSize && col >= left && col < left + _finderSize;
  }

  bool _isReservedFinderArea(final int row, final int col) {
    return row < _finderSize + 1 && col < _finderSize + 1 || row < _finderSize + 1 && col >= _size - _finderSize - 1 || row >= _size - _finderSize - 1 && col < _finderSize + 1;
  }

  bool _finderCell(final int row, final int col) {
    return row == 0 || row == _finderSize - 1 || col == 0 || col == _finderSize - 1 || row >= 2 && row <= 4 && col >= 2 && col <= 4;
  }

  @override
  bool shouldRepaint(final _QrPreviewPainter oldDelegate) => false;
}
