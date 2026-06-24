import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/employment_offer_registration.dart';

final employmentOfferRegistrationsProvider = FutureProvider.autoDispose<List<EmploymentOfferRegistration>>((final ref) async {
  return const <EmploymentOfferRegistration>[];
});
