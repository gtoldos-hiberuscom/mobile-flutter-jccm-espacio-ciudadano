import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/core/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/widgets/my_data_employment_data_tab.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/widgets/my_data_employment_services_tab.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

/// Employment detail page — Figma nodes 43973:1993 and 43973:2077.
class MyDataEmploymentPage extends StatefulWidget {
  const MyDataEmploymentPage({
    super.key,
    this.backRoute = Routes.myData,
  });

  final String backRoute;

  @override
  State<MyDataEmploymentPage> createState() => _MyDataEmploymentPageState();
}

class _MyDataEmploymentPageState extends State<MyDataEmploymentPage> {
  _EmploymentTab _selectedTab = _EmploymentTab.data;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AppTabbedDetailScaffold(
      title: l10n.myDataEmploymentTitle,
      onBack: () => context.go(widget.backRoute),
      onInfo: () => _showEmploymentInfoSheet(context),
      tabs: [l10n.myDataEmploymentDataTab, l10n.myDataEmploymentServicesTab],
      selectedIndex: _selectedTab.index,
      onTabSelected: (final index) => setState(() => _selectedTab = _EmploymentTab.values[index]),
      tabViews: const [
        MyDataEmploymentDataTab(),
        MyDataEmploymentServicesTab(),
      ],
    );
  }

  Future<void> _showEmploymentInfoSheet(final BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    await AppInfoSheet.show(
      context: context,
      title: l10n.myDataEmploymentInfoSheetTitle,
      bodyText: l10n.myDataEmploymentInfoSheetDescription,
      footerText: l10n.myDataEmploymentInfoSheetFooter,
      actionLabel: l10n.myDataEmploymentInfoSheetOfficeContactsButton,
      onActionPressed: () => _launchExternalUrl(context, 'https://www.jccm.es/oficinas-oir'),
      actionIcon: AppIcons.openInNew,
    );
  }
}

enum _EmploymentTab { data, services }

Future<void> _launchExternalUrl(final BuildContext context, final String urlString) async {
  final uri = Uri.parse(urlString);
  final accepted = await launchUrl(
    uri,
    mode: LaunchMode.externalApplication,
  );

  if (!accepted && context.mounted) {
    AppAlertSnackbar.show(
      context,
      message: AppLocalizations.of(context).externalLinkOpenFailed,
    );
  }
}
