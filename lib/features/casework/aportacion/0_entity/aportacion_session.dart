import 'package:jccm_espacio_ciudadano/features/casework/aportacion/0_entity/aportacion_failure.dart';
import 'package:jccm_espacio_ciudadano/features/casework/aportacion/0_entity/aportacion_step.dart';
import 'package:jccm_espacio_ciudadano/features/casework/aportacion/0_entity/interested_party_identification.dart';

/// Immutable session state for the aportación wizard (STORY-37).
///
/// Only the wizard owns this entity — the data layer never sees it.
final class AportacionSession {
  const AportacionSession({
    this.currentStep = AportacionStep.intro,
    this.identificacion,
    this.expedienteRef,
    this.completed = false,
    this.failure,
    this.isResolving = false,
  });

  /// Initial state when the user opens the wizard.
  static const AportacionSession initial = AportacionSession();

  final AportacionStep currentStep;
  final InterestedPartyIdentification? identificacion;

  /// Administrative number of the resolved expediente (e.g.
  /// `EXP/2025/00123`). Set after a successful search.
  final String? expedienteRef;

  /// True after the upload session has been finalized.
  final bool completed;

  /// Last domain failure raised by the wizard, if any. The presentation
  /// layer renders an in-step banner; consumers must call
  /// [AportacionSession.copyWith] with `clearFailure: true` to dismiss it.
  final AportacionFailure? failure;

  /// True while a repository look-up is in flight.
  final bool isResolving;

  AportacionSession copyWith({
    final AportacionStep? currentStep,
    final InterestedPartyIdentification? identificacion,
    final String? expedienteRef,
    final bool? completed,
    final AportacionFailure? failure,
    final bool? isResolving,
    final bool clearFailure = false,
    final bool clearExpedienteRef = false,
    final bool clearIdentificacion = false,
  }) => AportacionSession(
    currentStep: currentStep ?? this.currentStep,
    identificacion:
        clearIdentificacion ? null : identificacion ?? this.identificacion,
    expedienteRef:
        clearExpedienteRef ? null : expedienteRef ?? this.expedienteRef,
    completed: completed ?? this.completed,
    failure: clearFailure ? null : failure ?? this.failure,
    isResolving: isResolving ?? this.isResolving,
  );
}
