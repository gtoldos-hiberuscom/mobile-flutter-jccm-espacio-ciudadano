import 'package:meta/meta.dart';

/// Datos de quien presenta físicamente la documentación cuando actúa como
/// representante de un tercero ("aportación por contraste"). Refleja
/// `datosRepresentante` en `documentacion/registrarfichero`.
@immutable
final class Representante {
  const Representante({
    required this.nombre,
    required this.apellido1,
    required this.apellido2,
    required this.nifcif,
    required this.tipodoc,
  });

  final String nombre;
  final String apellido1;
  final String apellido2;
  final String nifcif;
  final String tipodoc;

  @override
  bool operator ==(final Object other) => identical(this, other) || other is Representante && runtimeType == other.runtimeType && nombre == other.nombre && apellido1 == other.apellido1 && apellido2 == other.apellido2 && nifcif == other.nifcif && tipodoc == other.tipodoc;

  @override
  int get hashCode => Object.hash(nombre, apellido1, apellido2, nifcif, tipodoc);
}
