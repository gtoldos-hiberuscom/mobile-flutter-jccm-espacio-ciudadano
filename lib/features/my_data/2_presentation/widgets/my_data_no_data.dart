import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/features/external_links/2_presentation/external_navigation_confirmation.dart';

/// Shared empty state for successful "Mis datos" queries with no records.
class MyDataNoData extends StatelessWidget {
  const MyDataNoData({
    required this.message,
    required this.actionLabel,
    this.contactUrl,
    this.onAction,
    this.scrollable = true,
    super.key,
  });

  final String message;
  final String actionLabel;
  final String? contactUrl;
  final VoidCallback? onAction;
  final bool scrollable;

  @override
  Widget build(final BuildContext context) {
    final content = Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.space16,
        AppDimensions.space24,
        AppDimensions.space16,
        AppDimensions.space64,
      ),
      child: AppAlertContextual(
        message: message,
        action: AppButton(
          label: actionLabel,
          hierarchy: AppButtonHierarchy.secondary,
          trailingIcon: AppIcons.openInNew,
          onPressed: onAction ?? () => _openContact(context),
        ),
      ),
    );
    return scrollable ? SingleChildScrollView(child: content) : content;
  }

  Future<void> _openContact(final BuildContext context) async {
    final url = contactUrl;
    if (url == null) {
      return;
    }
    await launchExternalUrlWithConfirmation(context, Uri.parse(url));
  }
}
