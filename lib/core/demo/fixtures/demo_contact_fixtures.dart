/// Contacto de notificaciones (tercero de Notifica) del modo demostración.
typedef DemoContact = ({int idTercero, String dni, String? email, int? telefono});

/// `idTercero` que asigna el alta en demo. Fijo: la app solo lo reenvía en la
/// modificación y así los tests pueden comprobar que se conserva.
const int demoContactIdTercero = 48213;

/// Mensaje del 404 de `GET {id}/contacto` mientras no hay contacto, con el
/// sentido del gateway: el ciudadano no está dado de alta en Notifica.
const String demoContactNotFoundMessage = 'No existe un tercero dado de alta en Notifica para el ciudadano indicado';

/// Un contacto tal y como viaja en el `body` de las tres operaciones.
///
/// `telefono` va como número, igual que el gateway (`TerceroN2Dto.telefono`
/// es `int`); el repositorio lo vuelve a convertir a texto.
Map<String, Object?> demoContactJson(final DemoContact contact) => <String, Object?>{
  'idTercero': contact.idTercero,
  'dni': contact.dni,
  'email': contact.email,
  'telefono': contact.telefono,
};
