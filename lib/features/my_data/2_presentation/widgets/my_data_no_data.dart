import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/features/external_links/2_presentation/external_navigation_confirmation.dart';

/// Shared empty state for successful "Mis datos" queries with no records.
///
/// [message] has two paragraphs separated by a blank line: the result of the
/// query and, when present, the guidance on where to correct it. When
/// [contactLinkText] is set, the guidance ends with that inline link (to
/// [contactUrl], or [onContact] when the destination is not a plain URL)
/// followed by a full stop.
class MyDataNoData extends StatelessWidget {
  const MyDataNoData({
    required this.message,
    this.contactLinkText,
    this.contactUrl,
    this.onContact,
    this.scrollable = true,
    super.key,
  }) : assert(contactLinkText == null || contactUrl != null || onContact != null, 'a contact link needs a destination');

  final String message;
  final String? contactLinkText;
  final String? contactUrl;
  final VoidCallback? onContact;
  final bool scrollable;

  @override
  Widget build(final BuildContext context) {
    // Only the full-page variant carries the page margin; nested inside an
    // already padded page it keeps its own 16 dp inset.
    final horizontal = scrollable ? appPageHorizontalPadding(context) : AppDimensions.space16;
    // Keep the guidance outside the alert so every "Mis datos" empty state
    // uses the same visual hierarchy as the large-family title screen.
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
              child: MyDataContactParagraph(
                message: contactMessage,
                linkText: contactLinkText,
                onLinkTap: onContact ?? () => _openContact(context),
              ),
            ),
          ],
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

/// Párrafo de «Si crees que la información es incorrecta…» de los estados sin
/// datos, con el organismo de contacto como enlace externo en línea.
class MyDataContactParagraph extends StatelessWidget {
  const MyDataContactParagraph({
    required this.message,
    required this.onLinkTap,
    this.linkText,
    super.key,
  });

  final String message;
  final String? linkText;
  final VoidCallback onLinkTap;

  @override
  Widget build(final BuildContext context) {
    final style = AppTypography.bodyRegular.copyWith(color: AppColors.primaryDark);
    final link = linkText;
    if (link == null) {
      return Text(message, style: style);
    }
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: '$message '),
          AppInlineLink.span(
            text: link,
            style: style.copyWith(decoration: TextDecoration.underline, decorationColor: AppColors.primaryDark),
            onTap: onLinkTap,
          ),
          const TextSpan(text: '.'),
        ],
      ),
      style: style,
    );
  }
}
