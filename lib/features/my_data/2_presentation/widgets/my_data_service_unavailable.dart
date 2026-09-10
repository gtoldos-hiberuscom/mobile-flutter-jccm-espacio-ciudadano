import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';

/// Shared server-error state for the detail sections in "Mis datos".
///
/// Keep the service-specific wording at the call site so the same visual
/// treatment can be reused by Salud, Vivienda, Educación, etc.
class MyDataServiceUnavailable extends StatelessWidget {
  const MyDataServiceUnavailable({
    required this.message,
    required this.actionLabel,
    required this.onRetry,
    this.scrollable = true,
    super.key,
  });

  final String message;
  final String actionLabel;
  final VoidCallback onRetry;
  final bool scrollable;

  @override
  Widget build(final BuildContext context) {
    // Only the full-page variant carries the page margin; nested inside an
    // already padded page it keeps its own 16 dp inset.
    final horizontal = scrollable ? appPageHorizontalPadding(context) : AppDimensions.space16;
    final alert = Padding(
      padding: EdgeInsets.fromLTRB(
        horizontal,
        AppDimensions.space24,
        horizontal,
        AppDimensions.space64,
      ),
      child: AppAlertContextual(
        message: message,
        action: AppButton(
          label: actionLabel,
          hierarchy: AppButtonHierarchy.tertiary,
          trailingIcon: AppIcons.autorenew,
          onPressed: onRetry,
        ),
      ),
    );
    return scrollable ? SingleChildScrollView(child: alert) : alert;
  }
}
