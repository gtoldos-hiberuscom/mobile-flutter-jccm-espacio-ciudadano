import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_typography.dart';

class AppFormHeader extends StatelessWidget {
  const AppFormHeader({
    required this.title,
    required this.description,
    super.key,
    this.headingLevel = 2,
    this.titleSemanticsLabel,
  }) : assert(title != '', 'title must not be empty'),
       assert(description != '', 'description must not be empty'),
       assert(
         headingLevel >= 1 && headingLevel <= 6,
         'headingLevel must be between 1 and 6',
       ),
       assert(
         titleSemanticsLabel == null || titleSemanticsLabel != '',
         'titleSemanticsLabel must not be empty',
       );

  final String title;
  final String description;

  /// Semantic heading level, independent from the visual H2 style.
  final int headingLevel;

  /// Optional pronunciation-friendly name for the title.
  final String? titleSemanticsLabel;

  @override
  Widget build(final BuildContext context) {
    final titleText = Text(
      title,
      style: AppTypography.h2.copyWith(color: AppColors.primary),
    );

    return Semantics(
      container: true,
      explicitChildNodes: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(
            header: true,
            headingLevel: headingLevel,
            label: titleSemanticsLabel,
            child: titleSemanticsLabel == null ? titleText : ExcludeSemantics(child: titleText),
          ),
          const SizedBox(height: AppDimensions.space8),
          Text(
            description,
            style: AppTypography.bodyRegular.copyWith(color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }
}
