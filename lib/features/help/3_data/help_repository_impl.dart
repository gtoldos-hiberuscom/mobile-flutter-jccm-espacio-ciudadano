import 'package:jccm_espacio_ciudadano/features/help/0_entity/faq_entry.dart';
import 'package:jccm_espacio_ciudadano/features/help/0_entity/help_contact.dart';
import 'package:jccm_espacio_ciudadano/features/help/0_entity/help_content.dart';
import 'package:jccm_espacio_ciudadano/features/help/0_entity/help_guide.dart';
import 'package:jccm_espacio_ciudadano/features/help/1_domain/help_repository.dart';

/// Hard-coded help center content shipped with the binary.
///
/// Content is intentionally local — the help center is offline-first
/// (canon §22) and avoids any backend dependency for STORY-59.
///
/// To add a new FAQ / guide / contact:
///  1. Append the entry below with a stable id.
///  2. Add the matching ARB keys to `app_es.arb` and `app_en.arb`.
///  3. Update `test/features/help/help_repository_test.dart`.
final class HelpRepositoryImpl implements HelpRepository {
  const HelpRepositoryImpl();

  static const List<FaqEntry> _faqs = <FaqEntry>[
    FaqEntry(
      id: 'faq_login_clave',
      questionKey: 'helpFaqLoginClaveQ',
      answerKey: 'helpFaqLoginClaveA',
      category: 'helpCategoryAccess',
    ),
    FaqEntry(
      id: 'faq_login_problems',
      questionKey: 'helpFaqLoginProblemsQ',
      answerKey: 'helpFaqLoginProblemsA',
      category: 'helpCategoryAccess',
    ),
    FaqEntry(
      id: 'faq_data_protection',
      questionKey: 'helpFaqDataProtectionQ',
      answerKey: 'helpFaqDataProtectionA',
      category: 'helpCategoryPrivacy',
    ),
    FaqEntry(
      id: 'faq_notifications',
      questionKey: 'helpFaqNotificationsQ',
      answerKey: 'helpFaqNotificationsA',
      category: 'helpCategoryServices',
    ),
    FaqEntry(
      id: 'faq_documents',
      questionKey: 'helpFaqDocumentsQ',
      answerKey: 'helpFaqDocumentsA',
      category: 'helpCategoryServices',
    ),
    FaqEntry(
      id: 'faq_offline',
      questionKey: 'helpFaqOfflineQ',
      answerKey: 'helpFaqOfflineA',
      category: 'helpCategoryServices',
    ),
  ];

  static const List<HelpGuide> _guides = <HelpGuide>[
    HelpGuide(
      id: 'guide_first_steps',
      titleKey: 'helpGuideFirstStepsTitle',
      bodyKey: 'helpGuideFirstStepsBody',
    ),
    HelpGuide(
      id: 'guide_carpeta_age',
      titleKey: 'helpGuideCarpetaAgeTitle',
      bodyKey: 'helpGuideCarpetaAgeBody',
      externalLinkId: 'carpeta_ciudadana_age',
    ),
  ];

  static const List<HelpContact> _contacts = <HelpContact>[
    HelpContact(
      id: 'contact_012_phone',
      labelKey: 'helpContact012PhoneLabel',
      value: '012',
      type: HelpContactType.phone,
    ),
    HelpContact(
      id: 'contact_email_support',
      labelKey: 'helpContactEmailSupportLabel',
      value: 'espacio.ciudadano@jccm.es',
      type: HelpContactType.email,
    ),
    HelpContact(
      id: 'contact_offices_url',
      labelKey: 'helpContactOfficesUrlLabel',
      value: 'castillalamancha.es',
      type: HelpContactType.url,
      // No externalLinkId yet — kept as informational display until the
      // catalog ships an entry for the offices portal.
    ),
  ];

  @override
  HelpContent loadContent() => HelpContent(
    faqs: List<FaqEntry>.unmodifiable(_faqs),
    guides: List<HelpGuide>.unmodifiable(_guides),
    contacts: List<HelpContact>.unmodifiable(_contacts),
  );
}
