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
