import 'package:jccm_espacio_ciudadano/core/demo/demo_backend_core.dart';
import 'package:jccm_espacio_ciudadano/core/demo/demo_session.dart';
import 'package:jccm_espacio_ciudadano/core/demo/fixtures/demo_contact_fixtures.dart';

/// Contacto de notificaciones (tercero de Notifica) de la persona ficticia.
///
/// Empieza sin contacto: la demo enseña el alta completa, y es el camino que
/// la pantalla de Preferencias recorre con un ciudadano nuevo.
final class DemoContactState {
  DemoContactState();

  DemoContact? _contact;

  DemoContact? get contact => _contact;

  bool get exists => _contact != null;

  /// Alta: asigna el `idTercero` de la demo.
  void create({required final String dni, final String? email, final int? telefono}) {
    _contact = (idTercero: demoContactIdTercero, dni: dni, email: email, telefono: telefono);
  }

  /// Modificación: sustituye los datos conservando el `idTercero`.
  void replace({required final String dni, final String? email, final int? telefono}) {
    final current = _contact;
    _contact = (idTercero: current?.idTercero ?? demoContactIdTercero, dni: dni, email: email, telefono: telefono);
  }

  void clear() => _contact = null;
}

List<DemoRoute> demoContactRoutes(final DemoContactState state) {
  const path = '/api/v1/ciudadanos/([^/]+)/contacto';
  return <DemoRoute>[
    DemoRoute('GET', path, (final request) {
      final contact = state.contact;
      if (contact == null) {
        // 404 documentado mientras el ciudadano no está en Notifica: el
        // repositorio lo lee como «sin contacto» y la pantalla ofrece el alta.
        return DemoResponse.status(404, message: demoContactNotFoundMessage);
      }
      return DemoResponse.ok(demoContactJson(contact));
    }),
    DemoRoute('POST', path, (final request) {
      final body = _ContactBody.from(request);
      state.create(dni: body.dni, email: body.email, telefono: body.telefono);
      return DemoResponse.ok(demoContactJson(state.contact!));
    }),
    DemoRoute('PUT', path, (final request) {
      if (!state.exists) {
        // Sin alta previa no hay nada que modificar; el repositorio pasa al POST.
        return DemoResponse.status(404, message: demoContactNotFoundMessage);
      }
      final body = _ContactBody.from(request);
      state.replace(dni: body.dni, email: body.email, telefono: body.telefono);
      return DemoResponse.ok(demoContactJson(state.contact!));
    }),
  ];
}

/// `{ dni, email, telefono, idTercero? }` tal y como lo manda la app.
final class _ContactBody {
  const _ContactBody({required this.dni, required this.email, required this.telefono});

  factory _ContactBody.from(final DemoRequest request) {
    final json = request.jsonObject;
    final dni = json['dni']?.toString().trim();
    final email = json['email']?.toString().trim();
    return _ContactBody(
      dni: dni == null || dni.isEmpty ? DemoSession.personIdentifier : dni,
      email: email == null || email.isEmpty ? null : email,
      telefono: _asInt(json['telefono']),
    );
  }

  final String dni;
  final String? email;
  final int? telefono;
}

int? _asInt(final Object? value) => switch (value) {
  final int number => number,
  final num number => number.toInt(),
  _ => int.tryParse(value?.toString().trim() ?? ''),
};
