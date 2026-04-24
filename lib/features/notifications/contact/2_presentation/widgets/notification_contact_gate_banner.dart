import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/app/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/app/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/features/notifications/contact/0_entity/notification_contact_status.dart';
import 'package:jccm_espacio_ciudadano/features/notifications/contact/1_domain/notification_contact_gate_provider.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Banner prompting the citizen to register notification-contact data
/// when the gate reports a [NotificationContactStatus.missing] state
/// (STORY-42).
///
/// Embedded by the notifications center page at the top of the body.
/// Renders nothing while the gate is loading or once the contact has
/// been registered, keeping the inbox uncluttered.
class NotificationContactGateBanner extends ConsumerWidget {
  const NotificationContactGateBanner({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final asyncStatus = ref.watch(notificationContactGateProvider);
    final status = asyncStatus.value ?? NotificationContactStatus.unknown;
    if (status != NotificationContactStatus.missing) {
      return const SizedBox.shrink();
    }
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      key: const Key('notification_contact_gate_banner'),
      padding: const EdgeInsets.all(AppDimensions.space16),
      child: Material(
        color: scheme.secondaryContainer,
        borderRadius: const BorderRadius.all(
          Radius.circular(AppDimensions.radiusLarge),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.space16),
          child: Row(
            children: <Widget>[
              Icon(Icons.contact_mail_outlined, color: scheme.onSecondaryContainer),
              const SizedBox(width: AppDimensions.space12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      l10n.notificationContactGateBannerMessage,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: scheme.onSecondaryContainer,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.space8),
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: TextButton(
                        key: const Key('notification_contact_gate_banner_cta'),
                        onPressed: () => GoRouter.of(context)
                            .go(Routes.notificationContactRegistration),
                        child: Text(l10n.notificationContactGateBannerCta),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
