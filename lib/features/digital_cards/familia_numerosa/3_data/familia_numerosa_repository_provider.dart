/// Familia numerosa carnet (EPIC-7 / STORY-49) — data composition.
///
/// Plain Riverpod provider (no codegen) — keeps the wiring symmetric
/// with the `FamiliaNumerosaDetailNotifier` above so test overrides do
/// not need to regenerate `*.g.dart` artifacts.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/familia_numerosa/1_domain/familia_numerosa_repository.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/familia_numerosa/3_data/familia_numerosa_repository_impl.dart';

/// DI composition for [FamiliaNumerosaRepository] (canon §16).
///
/// Not kept alive on purpose: navigation back into the detail screen
/// should re-fetch the carnet metadata.
final familiaNumerosaRepositoryProvider = Provider<FamiliaNumerosaRepository>(
  (final ref) => const FamiliaNumerosaRepositoryImpl(),
);
