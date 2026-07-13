import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

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
    final accepted = await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    );
    if (!accepted && context.mounted) {
      AppAlertSnackbar.show(
        context,
        message: AppLocalizations.of(context).externalLinkOpenFailed,
      );
    }
  }
}
