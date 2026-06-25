import 'package:test/test.dart';
import 'package:espacio_ciudadano_api/espacio_ciudadano_api.dart';

/// tests for ActuatorApi
void main() {
  final instance = EspacioCiudadanoApi().getActuatorApi();

  group(ActuatorApi, () {
    // Actuator web endpoint 'health'
    //
    //Future<JsonObject> health() async
    test('test health', () async {
      // TODO
    });

    // Actuator web endpoint 'health-path'
    //
    //Future<JsonObject> healthPath() async
    test('test healthPath', () async {
      // TODO
    });

    // Actuator root web endpoint
    //
    //Future<BuiltMap<String, BuiltMap<String, Link>>> links() async
    test('test links', () async {
      // TODO
    });
  });
}
