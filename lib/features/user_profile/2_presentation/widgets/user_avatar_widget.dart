import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';

/// Circular avatar displaying the user's initial letter.
class UserAvatarWidget extends StatelessWidget {
  const UserAvatarWidget({
    required this.initials,
    super.key,
    this.radius = 20,
  });

  final String initials;
  final double radius;

  @override
  Widget build(final BuildContext context) {
    return Semantics(
      label: initials,
      child: CircleAvatar(
        radius: radius,
        backgroundColor: AppColors.primary,
        child: Text(
          initials,
          style: TextStyle(
            color: AppColors.textOnPrimary,
            fontSize: radius * 0.9,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
