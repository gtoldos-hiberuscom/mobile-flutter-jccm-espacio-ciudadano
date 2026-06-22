import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/core/network/api_client_provider.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/jwt_claims.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/jwt_claims_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/dependency_care_status.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/disability_title.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/large_family_title.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/parking_card.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/thermal_spa_award.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/1_domain/repositories/my_data_social_welfare_repository.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/3_data/my_data_social_welfare_repository_impl.dart';

final myDataSocialWelfareRepositoryProvider = Provider<MyDataSocialWelfareRepository>((final ref) {
  return MyDataSocialWelfareRepositoryImpl(dio: ref.watch(dioProvider));
});

final largeFamilyTitleProvider = FutureProvider.autoDispose<LargeFamilyTitle?>((final ref) async {
  final documentNumber = _documentNumber(ref.watch(jwtClaimsProvider));
  if (documentNumber == null) {
    throw StateError('No se ha encontrado el documento de la persona usuaria.');
  }

  return ref
      .watch(myDataSocialWelfareRepositoryProvider)
      .loadLargeFamilyTitle(
        documentNumber: documentNumber,
      );
});

final disabilityTitleProvider = FutureProvider.autoDispose<DisabilityTitle?>((final ref) async {
  final documentNumber = _documentNumber(ref.watch(jwtClaimsProvider));
  if (documentNumber == null) {
    throw StateError('No se ha encontrado el documento de la persona usuaria.');
  }

  return ref
      .watch(myDataSocialWelfareRepositoryProvider)
      .loadDisabilityTitle(
        documentNumber: documentNumber,
      );
});

final thermalSpaAwardProvider = FutureProvider.autoDispose<ThermalSpaAward?>((final ref) async {
  final documentNumber = _documentNumber(ref.watch(jwtClaimsProvider));
  if (documentNumber == null) {
    throw StateError('No se ha encontrado el documento de la persona usuaria.');
  }

  return ref
      .watch(myDataSocialWelfareRepositoryProvider)
      .loadThermalSpaAward(
        documentNumber: documentNumber,
      );
});

final dependencyCareStatusProvider = FutureProvider.autoDispose<DependencyCareStatus?>((final ref) async {
  final documentNumber = _documentNumber(ref.watch(jwtClaimsProvider));
  if (documentNumber == null) {
    throw StateError('No se ha encontrado el documento de la persona usuaria.');
  }

  return ref
      .watch(myDataSocialWelfareRepositoryProvider)
      .loadDependencyCareStatus(
        documentNumber: documentNumber,
      );
});

final parkingCardProvider = FutureProvider.autoDispose<ParkingCard?>((final ref) async {
  final documentNumber = _documentNumber(ref.watch(jwtClaimsProvider));
  if (documentNumber == null) {
    throw StateError('No se ha encontrado el documento de la persona usuaria.');
  }

  return ref
      .watch(myDataSocialWelfareRepositoryProvider)
      .loadParkingCard(
        documentNumber: documentNumber,
      );
});

String? _documentNumber(final JwtClaims? claims) {
  final candidates = [
    claims?.personIdentifier,
    claims?.preferredUsername,
    claims?.sub,
  ];
  for (final candidate in candidates) {
    final normalized = candidate?.trim();
    if (normalized != null && normalized.isNotEmpty) {
      return normalized;
    }
  }
  return null;
}
