/// Carnet Joven (EPIC-7 / STORY-50) — data composition.
///
/// Plain Riverpod provider (no codegen) — keeps the wiring symmetric
/// with the `JovenDetailNotifier` above so test overrides do not need
/// to regenerate `*.g.dart` artifacts.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/joven/1_domain/joven_repository.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/joven/3_data/joven_repository_impl.dart';

/// DI composition for [JovenRepository] (canon §16).
///
/// Not kept alive on purpose: navigation back into the detail surface
/// should re-fetch the carnet metadata.
final jovenRepositoryProvider = Provider<JovenRepository>(
  (final ref) => const JovenRepositoryImpl(),
);
