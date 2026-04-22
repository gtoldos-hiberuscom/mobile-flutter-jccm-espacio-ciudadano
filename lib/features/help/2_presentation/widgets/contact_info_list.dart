/// Contact information list widget — shows channels the citizen can use to
/// get in touch with the JCCM administration.
library;

import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/app/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/app/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/features/help/0_entity/contact_info.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

/// Renders a scrollable list of [ContactInfo] tiles.
///
/// Each tile carries:
/// - an icon matching the [ContactType],
/// - a label and value text,
/// - a semantics label, and
/// - an [InkWell] that launches the appropriate URI scheme on tap.
class ContactInfoList extends StatelessWidget {
  const ContactInfoList({required this.contacts, super.key});

  /// The list of contact channels to render.
  final List<ContactInfo> contacts;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.space8),
      itemCount: contacts.length,
      separatorBuilder: (_, _) =>
          const Divider(height: 1, color: AppColors.divider),
      itemBuilder: (final context, final index) {
        final contact = contacts[index];
        final icon = _iconFor(contact.type);
        final semanticsLabel = _semanticsLabel(contact.type, l10n);

        return Semantics(
          label: semanticsLabel,
          button: true,
          child: InkWell(
            onTap: () => _launch(contact),
            child: ListTile(
              leading: Icon(icon, color: AppColors.primary),
              title: Text(
                contact.label,
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              subtitle: Text(
                contact.value,
                style: textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              trailing: const Icon(
                Icons.chevron_right,
                color: AppColors.disabled,
              ),
            ),
          ),
        );
      },
    );
  }

  IconData _iconFor(final ContactType type) => switch (type) {
        ContactType.phone => Icons.phone,
        ContactType.email => Icons.email,
        ContactType.url => Icons.link,
      };

  String _semanticsLabel(
    final ContactType type,
    final AppLocalizations l10n,
  ) =>
      switch (type) {
        ContactType.phone => l10n.helpContactCall,
        ContactType.email => l10n.helpContactEmail,
        ContactType.url => l10n.helpContactVisit,
      };

  Future<void> _launch(final ContactInfo contact) async {
    final uriString = switch (contact.type) {
      ContactType.phone => 'tel:${contact.value}',
      ContactType.email => 'mailto:${contact.value}',
      ContactType.url => contact.value,
    };

    final uri = Uri.tryParse(uriString);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
