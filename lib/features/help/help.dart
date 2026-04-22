/// Help feature barrel — re-exports all public types from the help feature.
///
/// Import this file from code that needs to reference help-feature types:
/// ```dart
/// import 'package:jccm_espacio_ciudadano/features/help/help.dart';
/// ```
library;

// 0 — entities
export 'package:jccm_espacio_ciudadano/features/help/0_entity/contact_info.dart';
export 'package:jccm_espacio_ciudadano/features/help/0_entity/faq_item.dart';
export 'package:jccm_espacio_ciudadano/features/help/0_entity/help_guide.dart';

// 1 — domain
export 'package:jccm_espacio_ciudadano/features/help/1_domain/help_repository.dart';

// 2 — presentation
export 'package:jccm_espacio_ciudadano/features/help/2_presentation/help_page.dart';

// 3 — data (provider only; implementation is intentionally not re-exported)
export 'package:jccm_espacio_ciudadano/features/help/3_data/help_repository_provider.dart';
