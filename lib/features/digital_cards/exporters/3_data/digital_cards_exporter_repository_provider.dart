/// Digital cards exporters (EPIC-7 / STORY-52) — data.
library;

import 'package:jccm_espacio_ciudadano/features/digital_cards/exporters/1_domain/digital_cards_exporter_repository.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/exporters/3_data/digital_cards_exporter_repository_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'digital_cards_exporter_repository_provider.g.dart';

/// DI composition for [DigitalCardsExporterRepository] (canon §16).
///
/// Kept alive for the lifetime of the app so the temp-file cache can be
/// reused across navigations.
@Riverpod(keepAlive: true)
DigitalCardsExporterRepository digitalCardsExporterRepository(
  final Ref ref,
) => DigitalCardsExporterRepositoryMockImpl();
