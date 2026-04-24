import 'package:jccm_espacio_ciudadano/core/network/result.dart';
import 'package:jccm_espacio_ciudadano/features/help/0_entity/support_request.dart';

/// Domain contract for delivering a [SupportRequest] to the operator
/// channel.
///
/// Implementations live in `3_data/`. Returns a [Result] so business
/// errors are surfaced as values, not thrown exceptions (canon §13).
///
// TODO(TASK-63): the current implementation is a mock that always
/// returns success. Real backend wiring is deferred to TASK-63.
abstract interface class SupportRepository {
  Future<Result<void>> submit(final SupportRequest request);
}
