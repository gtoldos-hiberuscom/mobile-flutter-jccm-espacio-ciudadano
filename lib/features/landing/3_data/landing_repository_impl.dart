import 'package:jccm_espacio_ciudadano/features/landing/1_domain/landing_repository.dart';

/// Concrete implementation of [LandingRepository].
///
/// Currently a no-op stub: all landing content is resolved from localised
/// strings in the presentation layer and requires no remote data source.
/// This class satisfies the mandatory `3_data/` layer and acts as the
/// extension point when a backend CMS is introduced.
final class LandingRepositoryImpl implements LandingRepository {}
