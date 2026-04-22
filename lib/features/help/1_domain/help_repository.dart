/// Abstract contract for the help content data source.
///
/// Domain layer — must not import Flutter, Riverpod, Dio, or any concrete
/// infrastructure concern. All methods return synchronously because the data
/// is bundled with the app binary.
library;

import 'package:jccm_espacio_ciudadano/features/help/0_entity/contact_info.dart';
import 'package:jccm_espacio_ciudadano/features/help/0_entity/faq_item.dart';
import 'package:jccm_espacio_ciudadano/features/help/0_entity/help_guide.dart';

/// Provides read-only access to bundled help content.
abstract class HelpRepository {
  /// Returns all FAQ items sorted by category priority.
  List<FaqItem> getFaqs();

  /// Returns all help guides, optionally with external links.
  List<HelpGuide> getGuides();

  /// Returns the list of contact channels for the Contacto tab.
  List<ContactInfo> getContacts();
}
