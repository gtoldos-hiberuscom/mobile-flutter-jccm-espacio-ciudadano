import 'package:jccm_espacio_ciudadano/features/personalization/1_domain/data_consent_repository.dart';
import 'package:jccm_espacio_ciudadano/features/personalization/3_data/data_consent_repository_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'data_consent_repository_provider.g.dart';

/// DI composition for [DataConsentRepository].
@riverpod
DataConsentRepository dataConsentRepository(final Ref ref) => const DataConsentRepositoryImpl();
