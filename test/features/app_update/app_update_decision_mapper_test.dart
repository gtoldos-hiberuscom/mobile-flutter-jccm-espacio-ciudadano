import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/0_entity/app_update_decision.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/0_entity/app_version.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/0_entity/update_policy.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/3_data/dto/app_update_decision_dto.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/3_data/mappers/app_update_decision_mapper.dart';

AppUpdateDecision _map(final Object? response) => AppUpdateDecisionMapper.fromDto(AppUpdateDecisionDto.fromResponse(response));

Map<String, Object?> _envelope(final Map<String, Object?> body) => {'body': body, 'codigo-respuesta': '200', 'timestamp': '2026-10-14T09:30:00.000+02:00'};

void main() {
  group('AppUpdateDecisionDto + AppUpdateDecisionMapper', () {
    test('NINGUNA → none, aunque venga versión o mensaje', () {
      expect(_map(_envelope({'accion': 'NINGUNA', 'versionPublicada': null, 'mensaje': null})), const AppUpdateDecision.none());
      expect(_map(_envelope({'accion': 'NINGUNA', 'versionPublicada': '2.0.0', 'mensaje': 'x'})), const AppUpdateDecision.none());
    });

    test('RECOMENDADA con versión', () {
      expect(
        _map(_envelope({'accion': 'RECOMENDADA', 'versionPublicada': '0.2.0', 'mensaje': null})),
        const AppUpdateDecision(policy: UpdatePolicy.recommended, publishedVersion: AppVersion(0, 2, 0)),
      );
    });

    test('FORZADA con mensaje (recortado)', () {
      expect(
        _map(_envelope({'accion': 'FORZADA', 'versionPublicada': '0.2.0', 'mensaje': '  Versión retirada.  '})),
        const AppUpdateDecision(policy: UpdatePolicy.forced, publishedVersion: AppVersion(0, 2, 0), message: 'Versión retirada.'),
      );
    });

    test('un mensaje en blanco se trata como ausente', () {
      expect(_map(_envelope({'accion': 'FORZADA', 'versionPublicada': '0.2.0', 'mensaje': '   '})).message, isNull);
    });

    test('los campos opcionales pueden faltar', () {
      expect(_map(_envelope({'accion': 'NINGUNA'})), const AppUpdateDecision.none());
    });

    group('lanza FormatException', () {
      test('acción desconocida', () {
        expect(() => _map(_envelope({'accion': 'QUIZA', 'versionPublicada': '1.0.0'})), throwsFormatException);
      });

      test('acción con aviso sin versión publicada', () {
        expect(() => _map(_envelope({'accion': 'FORZADA', 'versionPublicada': null})), throwsFormatException);
      });

      test('versión mal formada', () {
        expect(() => _map(_envelope({'accion': 'RECOMENDADA', 'versionPublicada': '1.0'})), throwsFormatException);
      });

      test('acción ausente', () {
        expect(() => _map(_envelope({'versionPublicada': '1.0.0'})), throwsFormatException);
      });

      test('campo con tipo erróneo', () {
        expect(() => _map(_envelope({'accion': 'RECOMENDADA', 'versionPublicada': 2})), throwsFormatException);
      });

      test('sin body o respuesta que no es un objeto', () {
        expect(() => _map({'codigo-respuesta': '200'}), throwsFormatException);
        expect(() => _map('<html>'), throwsFormatException);
        expect(() => _map(null), throwsFormatException);
      });
    });
  });
}
