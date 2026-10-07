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
    // Only the full-page variant carries the page margin; nested inside an
    // already padded page it keeps its own 16 dp inset.
    final horizontal = scrollable ? appPageHorizontalPadding(context) : AppDimensions.space16;
    // The copy for these states deliberately has two paragraphs: the result of
    // the query and, when present, the guidance on where to correct it. Keep
    // that guidance outside the alert so every "Mis datos" empty state uses
    // the same visual hierarchy as the large-family title screen.
    final paragraphs = message.split('\n\n');
    final noDataMessage = paragraphs.first;
    final contactMessage = paragraphs.skip(1).join('\n\n');

    final content = Padding(
      padding: EdgeInsets.fromLTRB(
        horizontal,
        AppDimensions.space24,
        horizontal,
        AppDimensions.space64,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppAlertContextual(message: noDataMessage),
          if (contactMessage.isNotEmpty) ...[
            const SizedBox(height: AppDimensions.space16),
            Padding(
              // Align with the alert text, after its icon and gap.
              padding: const EdgeInsets.only(left: AppDimensions.space32 + AppDimensions.space4),
              child: Text(
                contactMessage,
                style: AppTypography.bodyRegular.copyWith(color: AppColors.primaryDark),
              ),
            ),
          ],
          const SizedBox(height: AppDimensions.space16),
          Align(
            child: AppButton(
              label: actionLabel,
              hierarchy: AppButtonHierarchy.ghost,
              trailingIcon: AppIcons.openInNew,
              isExternalLink: true,
              onPressed: onAction ?? () => _openContact(context),
            ),
          ),
        ],
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
