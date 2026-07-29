import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_icons.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_shadows.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_typography.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_loading_indicator.dart';

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
              border: Border.all(color: AppColors.neutral300),
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
    return SizedBox(
      height: AppDimensions.space48,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Drag handle — truly centered over the full header width
          Center(
            child: Container(
              width: 80,
              height: 8,
              decoration: BoxDecoration(
                color: AppColors.neutral200,
                borderRadius: BorderRadius.circular(AppDimensions.space64),
              ),
            ),
          ),
          // Close button pinned to the right
          Align(
            alignment: Alignment.centerRight,
            child: Semantics(
              label: 'Cerrar',
              button: true,
              child: GestureDetector(
                onTap: onClose ?? () => Navigator.of(context).pop(),
                child: ExcludeSemantics(
                  child: Padding(
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
                            fontWeight: FontWeight.w400,
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
    this.qrImageBytes,
    this.isQrLoading = false,
    this.downloadingFormat,
    this.onQrPressed,
    this.onPkPassPressed,
    this.onPdfPressed,
  });

  final Uint8List? qrImageBytes;
  final bool isQrLoading;
  final String? downloadingFormat;
  final VoidCallback? onQrPressed;
  final VoidCallback? onPkPassPressed;
  final VoidCallback? onPdfPressed;

  @override
  Widget build(final BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (onQrPressed != null) ...[
            _QrPreview(
              imageBytes: qrImageBytes,
              isLoading: isQrLoading,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppDimensions.space16,
                vertical: AppDimensions.space8,
              ),
              child: Divider(height: 1, color: AppColors.neutral100),
            ),
          ],
          Padding(
            padding: const EdgeInsets.only(
              top: AppDimensions.space4,
              bottom: AppDimensions.space8,
            ),
            child: Text(
              'Formato de descarga',
              style: AppTypography.leadingBold.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.space8),
          if (onQrPressed != null) ...[
            _DownloadFormatButton(
              label: 'QR',
              onPressed: downloadingFormat == null ? onQrPressed : null,
              isLoading: downloadingFormat == 'QR',
            ),
            const SizedBox(height: AppDimensions.space16),
          ],
          if (onPkPassPressed != null) ...[
            _DownloadFormatButton(
              label: 'PKPASS',
              onPressed: downloadingFormat == null ? onPkPassPressed : null,
              isLoading: downloadingFormat == 'PKPASS',
              primary: onPdfPressed == null,
            ),
            if (onPdfPressed != null) const SizedBox(height: AppDimensions.space16),
          ],
          if (onPdfPressed != null)
            _DownloadFormatButton(
              label: 'PDF',
              onPressed: downloadingFormat == null ? onPdfPressed : null,
              isLoading: downloadingFormat == 'PDF',
              primary: true,
            ),
        ],
      ),
    );
  }
}

class _QrPreview extends StatelessWidget {
  const _QrPreview({
    this.imageBytes,
    this.isLoading = false,
  });

  final Uint8List? imageBytes;
  final bool isLoading;

  @override
  Widget build(final BuildContext context) {
    return LayoutBuilder(
      builder: (final context, final constraints) {
        final heightLimit = MediaQuery.sizeOf(context).height * 0.42;
        final availableWidth = constraints.maxWidth < 326 ? constraints.maxWidth : 326.0;
        final desiredHeight = availableWidth * 331 / 326;
        final scale = desiredHeight > heightLimit ? heightLimit / desiredHeight : 1.0;
        final previewWidth = availableWidth * scale;
        final previewHeight = desiredHeight * scale;

        return Center(
          child: Semantics(
            label: 'Código QR',
            image: true,
            child: ExcludeSemantics(
              child: SizedBox(
                width: previewWidth,
                height: previewHeight,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.backgroundWhite,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
                    border: Border.all(color: AppColors.neutral100),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(AppDimensions.space12),
                    child: isLoading
                        ? const AppLoadingIndicator(strokeWidth: 3)
                        : imageBytes == null
                        ? const CustomPaint(painter: _QrPreviewPainter())
                        : Image.memory(
                            imageBytes!,
                            fit: BoxFit.contain,
                            filterQuality: FilterQuality.none,
                          ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _DownloadFormatButton extends StatelessWidget {
  const _DownloadFormatButton({
    required this.label,
    required this.onPressed,
    this.primary = false,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool primary;
  final bool isLoading;

  @override
  Widget build(final BuildContext context) {
    final background = primary ? AppColors.primary : AppColors.backgroundWhite;
    final foreground = primary ? AppColors.textOnPrimary : AppColors.textBlack;
    final border = primary ? AppColors.primary : AppColors.secondaryLight400;

    return Semantics(
      button: true,
      enabled: onPressed != null,
      label: isLoading ? 'Descargando $label' : 'Descargar $label',
      child: ExcludeSemantics(
        child: DecoratedBox(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(AppDimensions.radiusXs),
            ),
            boxShadow: AppShadows.low,
          ),
          child: SizedBox(
            height: AppDimensions.minTouchTarget,
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
              child: isLoading
                  ? SizedBox.square(
                      dimension: AppDimensions.iconSmall,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: foreground,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AppIcon(AppIcons.add, size: 20, color: foreground),
                        const SizedBox(width: AppDimensions.space8),
                        Text(label),
                        const SizedBox(width: AppDimensions.space8),
                        AppIcon(AppIcons.add, size: 20, color: foreground),
                      ],
                    ),
            ),
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
