/// Carnet Discapacidad (EPIC-7 / STORY-51) — data composition.
///
/// Plain Riverpod provider (no codegen) — symmetric with the
/// `DiscapacidadDetailNotifier` so test overrides do not need to
/// regenerate `*.g.dart` artifacts.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/discapacidad/1_domain/discapacidad_repository.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/discapacidad/3_data/discapacidad_repository_impl.dart';

/// DI composition for [DiscapacidadRepository] (canon §16).
///
/// Defaults to [DiscapacidadMockVariant.vigente]; tests override the
/// provider with another variant to exercise the no-vigente / parse-
/// error branches.
final discapacidadRepositoryProvider = Provider<DiscapacidadRepository>(
  (final ref) => const DiscapacidadRepositoryImpl(),
);
