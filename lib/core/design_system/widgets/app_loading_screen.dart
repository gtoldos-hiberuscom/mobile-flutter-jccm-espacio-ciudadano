import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_typography.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_loading_indicator.dart';

/// Pantalla de carga a pantalla completa — Figma node 44641:23786.
///
/// Cubre por completo la pantalla anterior con un velo azul oscuro, de modo que
/// tape transiciones en las que se vería contenido intermedio: el caso que la
/// motiva es el regreso de Cl@ve, donde la home pública queda a la vista
/// mientras el guard de sesión resuelve sus comprobaciones asíncronas.
///
/// Es una superficie bloqueante: no ofrece ninguna acción, así que sólo debe
/// usarse en esperas que terminan solas.
///
/// Aporta su propio [Material] para poder montarse tal cual dentro de un
/// [Stack], sin `Scaffold` encima: sin él los textos se pintarían con el
/// subrayado de depuración al quedar fuera de cualquier superficie Material.
class AppLoadingScreen extends StatelessWidget {
  const AppLoadingScreen({
    required this.title,
    super.key,
    this.description,
  }) : assert(title.length > 0, 'title must not be empty'),
       assert(description == null || description.length > 0, 'description must not be empty');

  /// Qué está ocurriendo. Se pinta como encabezado y lo anuncia el lector de
  /// pantalla al aparecer.
  final String title;

  /// Detalle opcional bajo el título.
  final String? description;

  /// Medidas del diseño: anillo de 126 con trazo de 16.
  static const double _indicatorSize = 126;
  static const double _indicatorStrokeWidth = 16;

  /// El diseño sitúa el anillo a 160 del borde superior.
  static const double _topPadding = 160;

  static const double _titleMaxWidth = 390;
  static const double _descriptionMaxWidth = 307;

  @override
  Widget build(final BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: ColoredBox(
        color: AppColors.blue900.withValues(alpha: 0.8),
        child: SafeArea(
          // Desplazable para que el contenido no se corte al ampliar el texto.
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              AppDimensions.space16,
              _topPadding,
              AppDimensions.space16,
              AppDimensions.space64,
            ),
            child: Semantics(
              container: true,
              liveRegion: true,
              child: Column(
                children: [
                  // Decorativo: lo que se anuncia es el título, no el spinner.
                  const AppLoadingIndicator(
                    color: AppColors.secondaryLight400,
                    strokeWidth: _indicatorStrokeWidth,
                    size: _indicatorSize,
                    decorative: true,
                  ),
                  const SizedBox(height: AppDimensions.space8),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: _titleMaxWidth),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: AppDimensions.space8),
                      child: Text(
                        title,
                        textAlign: TextAlign.center,
                        style: AppTypography.h2.copyWith(color: AppColors.textWhite),
                      ),
                    ),
                  ),
                  if (description case final String description)
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: _descriptionMaxWidth),
                      child: Text(
                        description,
                        textAlign: TextAlign.center,
                        style: AppTypography.captionRegular.copyWith(
                          color: AppColors.textWhite,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0,
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
