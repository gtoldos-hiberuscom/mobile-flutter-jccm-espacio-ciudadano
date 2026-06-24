import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';

class MyDataEmploymentDemandSkeletonCard extends StatelessWidget {
  const MyDataEmploymentDemandSkeletonCard({super.key});

  @override
  Widget build(final BuildContext context) {
    return const AppInfoCard(
      leadingBorderWidth: AppDimensions.space4,
      child: Opacity(
        opacity: 0.8,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppDimensions.space16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: AppDimensions.space4),
                child: _SkeletonBlock(width: 51, height: 16, color: AppColors.borderBlueMutedLight),
              ),
              _SkeletonBlock(width: double.infinity, height: 28, color: Color(0xFF58626C)),
              SizedBox(height: AppDimensions.space4),
              _SkeletonBlock(width: 124, height: 24, color: Color(0xFF58626C)),
            ],
          ),
        ),
      ),
    );
  }
}

class _SkeletonBlock extends StatelessWidget {
  const _SkeletonBlock({
    required this.width,
    required this.height,
    required this.color,
  });

  final double width;
  final double height;
  final Color color;

  @override
  Widget build(final BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ColoredBox(color: color),
    );
  }
}
