import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/0_entity/agenda_event.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/0_entity/agenda_snapshot.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/3_data/sescam/sescam_payload_parser.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/3_data/sescam/sescam_to_agenda_mapper.dart';

void main() {
  const mapper = SescamToAgendaMapper();
  final now = DateTime(2026, 5, 4);

  group('SescamToAgendaMapper.mapKind', () {
    test('empty payload is treated as a loaded empty agenda', () {
      expect(SescamToAgendaMapper.mapKind(SescamParseErrorKind.empty),
          AgendaLoadState.loaded);
    });

    test('unknown shape becomes parseError', () {
      expect(SescamToAgendaMapper.mapKind(SescamParseErrorKind.unknownShape),
          AgendaLoadState.parseError);
    });

    test('partial becomes partial', () {
      expect(SescamToAgendaMapper.mapKind(SescamParseErrorKind.partial),
          AgendaLoadState.partial);
    });

    test('serverEnvelopeKo becomes recoverable error', () {
      expect(
        SescamToAgendaMapper.mapKind(SescamParseErrorKind.serverEnvelopeKo),
        AgendaLoadState.error,
      );
    });
  });

  group('SescamToAgendaMapper.toSnapshot', () {
    test('ok result with no partialReason → loaded snapshot', () {
      final snapshot = mapper.toSnapshot(
        SescamParseResult.ok(const SescamCitasPayload(citas: <SescamCita>[])),
        const <AgendaEvent>[],
        now,
      );
      expect(snapshot.loadState, AgendaLoadState.loaded);
      expect(snapshot.parseErrorReason, isNull);
    });

    test('ok result with partialReason → partial snapshot', () {
      final snapshot = mapper.toSnapshot(
        SescamParseResult.ok(const SescamCitasPayload(citas: <SescamCita>[])),
        const <AgendaEvent>[],
        now,
        partialReason: 'one_item_dropped',
      );
      expect(snapshot.loadState, AgendaLoadState.partial);
      expect(snapshot.parseErrorReason, 'one_item_dropped');
    });

    test('err unknownShape → parseError snapshot, no raw preview leaks', () {
      final snapshot = mapper.toSnapshot(
        SescamParseResult<SescamCitasPayload>.err(
          SescamParseError.unknownShape('garbage payload'),
        ),
        const <AgendaEvent>[],
        now,
      );
      expect(snapshot.loadState, AgendaLoadState.parseError);
      expect(snapshot.parseErrorReason, 'unknown_shape');
    });
  });
}
