import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/core/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

class FaqEntry {
  const FaqEntry({required this.id, required this.question, required this.answer});

  final String id;
  final String Function(AppLocalizations l10n) question;
  final String Function(AppLocalizations l10n) answer;
}

/// A group of related FAQ entries shown as an expandable section in Help.
class FaqCategory {
  const FaqCategory({
    required this.title,
    required this.entries,
  });

  final String Function(AppLocalizations l10n) title;
  final List<FaqEntry> entries;
}

String _faqQuestion1(final AppLocalizations l10n) => l10n.faqQuestion1;
String _faqAnswer1(final AppLocalizations l10n) => l10n.faqAnswer1;
String _faqQuestion2(final AppLocalizations l10n) => l10n.faqQuestion2;
String _faqAnswer2(final AppLocalizations l10n) => l10n.faqAnswer2;
String _faqQuestion3(final AppLocalizations l10n) => l10n.faqQuestion3;
String _faqAnswer3(final AppLocalizations l10n) => l10n.faqAnswer3;
String _faqQuestion4(final AppLocalizations l10n) => l10n.faqQuestion4;
String _faqAnswer4(final AppLocalizations l10n) => l10n.faqAnswer4;
String _faqQuestion5(final AppLocalizations l10n) => l10n.faqQuestion5;
String _faqAnswer5(final AppLocalizations l10n) => l10n.faqAnswer5;
String _faqQuestion6(final AppLocalizations l10n) => l10n.faqQuestion6;
String _faqAnswer6(final AppLocalizations l10n) => l10n.faqAnswer6;

const faqEntries = <FaqEntry>[
  FaqEntry(
    id: 'espacio-ciudadano',
    question: _faqQuestion1,
    answer: _faqAnswer1,
  ),
  FaqEntry(
    id: 'acceso',
    question: _faqQuestion2,
    answer: _faqAnswer2,
  ),
  FaqEntry(
    id: 'datos-personales',
    question: _faqQuestion3,
    answer: _faqAnswer3,
  ),
  FaqEntry(
    id: 'corregir-datos',
    question: _faqQuestion4,
    answer: _faqAnswer4,
  ),
  FaqEntry(
    id: 'expedientes-tramites',
    question: _faqQuestion5,
    answer: _faqAnswer5,
  ),
  FaqEntry(
    id: 'agenda',
    question: _faqQuestion6,
    answer: _faqAnswer6,
  ),
];

String _faqAccessCategory(final AppLocalizations l10n) => l10n.faqCategoryAccess;
String _faqMyDataCategory(final AppLocalizations l10n) => l10n.faqCategoryMyData;
String _faqManagementsCategory(final AppLocalizations l10n) => l10n.faqCategoryManagements;
String _faqAgendaCategory(final AppLocalizations l10n) => l10n.faqCategoryAgenda;
String _faqPopulationCategory(final AppLocalizations l10n) => l10n.faqCategoryPopulation;

/// Categories and their questions for the accordion on the Help screen.
final faqCategories = <FaqCategory>[
  FaqCategory(title: _faqAccessCategory, entries: faqEntries.sublist(0, 3)),
  FaqCategory(title: _faqMyDataCategory, entries: faqEntries.sublist(3, 4)),
  FaqCategory(title: _faqManagementsCategory, entries: faqEntries.sublist(4, 5)),
  FaqCategory(title: _faqAgendaCategory, entries: faqEntries.sublist(5, 6)),
  const FaqCategory(title: _faqPopulationCategory, entries: []),
];

FaqEntry? faqEntryById(final String id) {
  for (final entry in faqEntries) {
    if (entry.id == id) {
      return entry;
    }
  }
  return null;
}

class FaqDetailPage extends StatelessWidget {
  const FaqDetailPage({required this.entry, super.key});

  final FaqEntry entry;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColors.backgroundBlueLighter,
      appBar: AppNavBar(
        title: l10n.helpFaqSectionTitle,
        leading: IconButton(
          icon: const AppIcon(
            AppIcons.arrowBack,
            size: AppDimensions.iconLarge,
            color: AppColors.textPrimary,
          ),
          tooltip: MaterialLocalizations.of(context).backButtonTooltip,
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(Routes.helpContact);
            }
          },
        ),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: appPagePadding(context, top: AppDimensions.space24, bottom: AppDimensions.space48),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppSectionHeading(entry.question(l10n)),
              const SizedBox(height: AppDimensions.space24),
              Text(
                entry.answer(l10n),
                style: AppTypography.bodyL.copyWith(color: AppColors.textPrimary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
