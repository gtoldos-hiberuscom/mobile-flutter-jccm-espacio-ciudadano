/// Help center page — FAQ accordion, guides list, and contact information.
///
/// Rendered at [Routes.help] (`/help`).
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/app/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/features/help/2_presentation/widgets/contact_info_list.dart';
import 'package:jccm_espacio_ciudadano/features/help/2_presentation/widgets/faq_list.dart';
import 'package:jccm_espacio_ciudadano/features/help/2_presentation/widgets/help_guides_list.dart';
import 'package:jccm_espacio_ciudadano/features/help/3_data/help_repository_provider.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Full-screen help center page with three tabs: FAQ, Guías, Contacto.
///
/// ## Architecture notes
/// - Uses [ConsumerStatefulWidget] + [SingleTickerProviderStateMixin] for the
///   [TabController].
/// - Data is read synchronously from [helpRepositoryProvider]; no loading or
///   error state is needed because content is entirely bundled.
/// - All user-visible strings are localised.
/// - All interactive items carry semantics labels for accessibility.
class HelpPage extends ConsumerStatefulWidget {
  const HelpPage({super.key});

  @override
  ConsumerState<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends ConsumerState<HelpPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final repository = ref.watch(helpRepositoryProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(l10n.helpPageTitle),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.textOnPrimary,
          unselectedLabelColor: AppColors.primaryLight,
          indicatorColor: AppColors.textOnPrimary,
          tabs: [
            Tab(text: l10n.helpTabFaq),
            Tab(text: l10n.helpTabGuides),
            Tab(text: l10n.helpTabContact),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // ── FAQ tab ──────────────────────────────────────────────────────
          FaqList(faqs: repository.getFaqs()),
          // ── Guides tab ───────────────────────────────────────────────────
          HelpGuidesList(guides: repository.getGuides()),
          // ── Contact tab ──────────────────────────────────────────────────
          ContactInfoList(contacts: repository.getContacts()),
        ],
      ),
    );
  }
}
