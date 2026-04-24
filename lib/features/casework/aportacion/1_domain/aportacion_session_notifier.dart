import 'package:jccm_espacio_ciudadano/features/casework/aportacion/0_entity/aportacion_failure.dart';
import 'package:jccm_espacio_ciudadano/features/casework/aportacion/0_entity/aportacion_search_query.dart';
import 'package:jccm_espacio_ciudadano/features/casework/aportacion/0_entity/aportacion_session.dart';
import 'package:jccm_espacio_ciudadano/features/casework/aportacion/0_entity/aportacion_step.dart';
import 'package:jccm_espacio_ciudadano/features/casework/aportacion/0_entity/interested_party_identification.dart';
import 'package:jccm_espacio_ciudadano/features/casework/aportacion/1_domain/aportacion_resolver.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'aportacion_session_notifier.g.dart';

/// Owns the third-party aportación wizard state (STORY-37).
///
/// Each method advances at most one step and is the only mutator of
/// [AportacionSession]. The notifier never touches Flutter, navigation
/// or storage — UI side-effects remain in the presentation layer.
@riverpod
class AportacionSessionNotifier extends _$AportacionSessionNotifier {
  @override
  AportacionSession build() => AportacionSession.initial;

  /// Resets the wizard to the introductory step.
  void start() {
    state = AportacionSession.initial;
  }

  /// `intro` → `identificacion`. No-op outside the intro step.
  void confirmIntro() {
    if (state.currentStep != AportacionStep.intro) {
      return;
    }
    state = state.copyWith(
      currentStep: AportacionStep.identificacion,
      clearFailure: true,
    );
  }

  /// Validates the identification and advances to the search step.
  /// Surfaces [AportacionFailure.invalidIdentification] when the value
  /// does not match the format for [InterestedPartyIdentification.idType].
  void setIdentification(final InterestedPartyIdentification identificacion) {
    if (state.currentStep != AportacionStep.identificacion) {
      return;
    }
    if (!identificacion.isValid()) {
      state = state.copyWith(
        identificacion: identificacion,
        failure: AportacionFailure.invalidIdentification,
      );
      return;
    }
    state = state.copyWith(
      currentStep: AportacionStep.searchExpediente,
      identificacion: identificacion,
      clearFailure: true,
    );
  }

  /// Resolves [query] against the existing casework repository. On the
  /// first match advances to [AportacionStep.detail]; on no match raises
  /// [AportacionFailure.notFound]; on transport errors raises
  /// [AportacionFailure.networkError].
  Future<void> resolveQuery(final AportacionSearchQuery query) async {
    if (state.currentStep != AportacionStep.searchExpediente) {
      return;
    }
    if (!query.isNotBlank) {
      state = state.copyWith(failure: AportacionFailure.notFound);
      return;
    }
    state = state.copyWith(isResolving: true, clearFailure: true);
    final resolver = ref.read(aportacionResolverProvider);
    try {
      final match = await resolver.resolve(query);
      if (match == null) {
        state = state.copyWith(
          isResolving: false,
          failure: AportacionFailure.notFound,
        );
        return;
      }
      state = state.copyWith(
        currentStep: AportacionStep.detail,
        expedienteRef: match.number,
        isResolving: false,
        clearFailure: true,
      );
    } on Object {
      state = state.copyWith(
        isResolving: false,
        failure: AportacionFailure.networkError,
      );
    }
  }

  /// `detail` → `uploadComplete`. Triggered by the wizard page once the
  /// embedded upload session reports `finalized == true`.
  void onUploadFinalized() {
    if (state.currentStep != AportacionStep.detail) {
      return;
    }
    state = state.copyWith(
      currentStep: AportacionStep.uploadComplete,
      completed: true,
      clearFailure: true,
    );
  }

  /// Walks back one step. No-op on [AportacionStep.intro] or after
  /// completion (the success step uses [start] to restart the flow).
  void back() {
    if (state.completed) {
      return;
    }
    switch (state.currentStep) {
      case AportacionStep.intro:
        return;
      case AportacionStep.identificacion:
        state = state.copyWith(
          currentStep: AportacionStep.intro,
          clearFailure: true,
        );
      case AportacionStep.searchExpediente:
        state = state.copyWith(
          currentStep: AportacionStep.identificacion,
          clearFailure: true,
        );
      case AportacionStep.detail:
        state = state.copyWith(
          currentStep: AportacionStep.searchExpediente,
          clearExpedienteRef: true,
          clearFailure: true,
        );
      case AportacionStep.uploadComplete:
        // Defensive — completed branch above already returns.
        return;
    }
  }

  /// Dismisses the current failure banner without changing the step.
  void dismissFailure() {
    if (state.failure == null) {
      return;
    }
    state = state.copyWith(clearFailure: true);
  }
}
