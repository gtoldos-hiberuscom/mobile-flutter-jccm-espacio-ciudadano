import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/features/user_profile/0_entity/user_profile.dart';
import 'package:jccm_espacio_ciudadano/features/user_profile/2_presentation/widgets/user_avatar_widget.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Shows the logged-in user header in the shell top area.
class UserHeaderWidget extends StatelessWidget {
  const UserHeaderWidget({
    required this.profile,
    super.key,
    this.onProfileTap,
  });

  final UserProfile profile;
  final VoidCallback? onProfileTap;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final name = profile.displayName ?? profile.idAgente;

    return Semantics(
      button: onProfileTap != null,
      label: l10n.userGreeting(name),
      child: InkWell(
        onTap: onProfileTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              UserAvatarWidget(initials: profile.initials),
              const SizedBox(width: 8),
              Text(
                l10n.userGreeting(name),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
