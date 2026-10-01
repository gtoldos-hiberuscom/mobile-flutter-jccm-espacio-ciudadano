import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/core/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/features/external_links/2_presentation/external_navigation_confirmation.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/widgets/my_data_employment_data_tab.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/widgets/my_data_employment_services_tab.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Employment detail page — Figma nodes 43973:1993 and 43973:2077.
class MyDataEmploymentPage extends ConsumerStatefulWidget {
  const MyDataEmploymentPage({
    super.key,
    this.backRoute = Routes.myData,
  });

  final String backRoute;

  @override
  ConsumerState<MyDataEmploymentPage> createState() => _MyDataEmploymentPageState();
}

class _MyDataEmploymentPageState extends ConsumerState<MyDataEmploymentPage> {
  _EmploymentTab? _selectedTab;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final selectedTab = _selectedTab ?? _EmploymentTab.data;

    return AppTabbedDetailScaffold(
      title: l10n.myDataEmploymentTitle,
      onBack: () => context.go(widget.backRoute),
      onInfo: () => _showEmploymentInfoSheet(context),
      tabs: [l10n.myDataEmploymentDataTab, l10n.myDataEmploymentServicesTab],
      selectedIndex: selectedTab.index,
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
      onActionPressed: () => _launchExternalUrl(context, 'https://www.sepe.es/HomeSepe'),
      actionIcon: AppIcons.openInNew,
    );
  }
}

enum _EmploymentTab { data, services }

Future<void> _launchExternalUrl(final BuildContext context, final String urlString) async {
  await launchExternalUrlWithConfirmation(context, Uri.parse(urlString));
}
