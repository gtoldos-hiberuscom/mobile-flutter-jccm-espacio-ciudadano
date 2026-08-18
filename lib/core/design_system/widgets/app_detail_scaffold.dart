import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_icons.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_header_bar.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Standard detail-page scaffold with the JCCM header bar.
///
/// Use it for non-tabbed detail screens that need the same app-bar/back/info
/// treatment and full-height body background.
class AppDetailScaffold extends StatelessWidget {
  const AppDetailScaffold({
    required this.title,
    required this.onBack,
    required this.body,
    super.key,
    this.onInfo,
    this.backgroundColor = AppColors.backgroundWhite,
    this.appBarBackgroundColor = AppColors.backgroundWhite,
    this.leadingIcon = AppIcons.arrowBack,
    this.leadingTooltip,
    this.semanticLabel,
  }) : assert(title.length > 0, 'title must not be empty'),
       assert(leadingTooltip == null || leadingTooltip.length > 0, 'leadingTooltip must not be empty'),
       assert(semanticLabel == null || semanticLabel.length > 0, 'semanticLabel must not be empty');

  final String title;
  final VoidCallback onBack;
  final VoidCallback? onInfo;
  final Widget body;
  final Color backgroundColor;
  final Color appBarBackgroundColor;
  final IconData leadingIcon;
  final String? leadingTooltip;
  final String? semanticLabel;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Semantics(
      container: true,
      scopesRoute: true,
      namesRoute: true,
      explicitChildNodes: true,
      label: semanticLabel ?? title,
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppHeaderBar(
          title: title,
          onBack: onBack,
          onInfo: onInfo,
          backgroundColor: appBarBackgroundColor,
          leadingIcon: leadingIcon,
          leadingTooltip: leadingTooltip ?? l10n.a11yBack,
        ),
        body: SizedBox.expand(
          child: ColoredBox(
            color: backgroundColor,
            child: SafeArea(
              top: false,
              child: body,
            ),
          ),
        ),
      ),
    );
  }
}
