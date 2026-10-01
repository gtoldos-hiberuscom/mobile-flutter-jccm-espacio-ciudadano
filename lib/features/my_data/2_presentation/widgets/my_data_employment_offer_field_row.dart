import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';

class MyDataEmploymentOfferFieldRow extends StatelessWidget {
  const MyDataEmploymentOfferFieldRow({
    required this.label,
    required this.value,
    super.key,
  });

  final String label;
  final String value;

  @override
  Widget build(final BuildContext context) {
    final labelText = Text(
      label.toUpperCase(),
      style: AppTypography.captionUppercase.copyWith(color: AppColors.primary),
    );
    final valueStyle = AppTypography.bodyRegular.copyWith(color: AppColors.primary);
    // Con el texto ampliado la etiqueta y el valor se apilan: la columna fija
    // del valor partía la fecha en varias líneas (WCAG 1.4.4).
    if (MediaQuery.textScalerOf(context).scale(1) > 1.5) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: AppDimensions.space8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            labelText,
            const SizedBox(height: AppDimensions.space4),
            Text(value, style: valueStyle),
          ],
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.space12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label.toUpperCase(),
              style: AppTypography.captionUppercase.copyWith(color: AppColors.primary),
            ),
          ),
          const SizedBox(width: AppDimensions.space16),
          SizedBox(
            width: 98,
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: AppTypography.bodyRegular.copyWith(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}
