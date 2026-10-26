import 'package:jccm_espacio_ciudadano/core/demo/demo_backend_core.dart';
import 'package:jccm_espacio_ciudadano/core/demo/fixtures/demo_consent_fixtures.dart';
import 'package:jccm_espacio_ciudadano/features/consent/0_entity/clause.dart';

/// Cláusulas de consentimiento de la persona ficticia.
///
/// Un ciudadano nuevo **no recibe un 404**: el gateway devuelve el catálogo
/// completo con `clausulaPendiente: true` y cada cláusula `pendiente: true`
/// sin seleccionar. Es lo que hace falta para que el gate legal funcione —
/// `ConsentRepositoryImpl.fetchClauses` lanza `StateError` ante un 404 y la
/// pantalla legal se quedaría en «no se pudo cargar el catálogo» sin forma de
/// aceptar— y a la vez `hasAcceptedConsent` sale `false` porque la cláusula 0
/// no está seleccionada. Tras el POST/PATCH de la aceptación, el GET devuelve
/// lo registrado y la sesión queda consentida.
final class DemoConsentState {
  /// Con [seededAccepted] el estado nace ya consentido (cláusula 0 más las
  /// opcionales de [seededAcceptedClauseIds]); el resto quedan contestadas en
  /// negativo, no pendientes. Se usa al reanudar la sesión demo tras un
  /// reinicio: si el backend volviera a nacer sin consentimiento, el
  /// `SessionGuard` cerraría la sesión guardada.
  DemoConsentState({required this.now, final bool seededAccepted = false, final Set<int> seededAcceptedClauseIds = const <int>{}}) {
    if (seededAccepted) {
      _registered = true;
      for (final clause in demoClausesCatalogue) {
        _answers[clause.id] = clause.id == requiredConsentClauseId || seededAcceptedClauseIds.contains(clause.id);
      }
    }
  }

  final DateTime Function() now;

  /// Respuesta registrada por cláusula; `null` es «sin contestar».
  final Map<int, bool?> _answers = <int, bool?>{for (final clause in demoClausesCatalogue) clause.id: null};

  bool _registered = false;

  /// `true` desde el primer POST/PATCH (o si se sembró aceptado).
  bool get isRegistered => _registered;

  /// `true` mientras alguna cláusula siga sin contestar.
  bool get hasPending => _answers.values.any((final answer) => answer == null);

  bool isAccepted(final int clauseId) => _answers[clauseId] ?? false;

  Set<int> get acceptedClauseIds => <int>{
    for (final entry in _answers.entries)
      if (entry.value ?? false) entry.key,
  };

  /// Registra las respuestas recibidas (`idClausula` → `seleccionado`). Las
  /// cláusulas que no vengan conservan su estado; un id desconocido se ignora.
  void record(final Map<int, bool> answers) {
    _registered = true;
    for (final entry in answers.entries) {
      if (_answers.containsKey(entry.key)) {
        _answers[entry.key] = entry.value;
      }
    }
  }

  /// Vuelve al estado de un ciudadano nuevo: nada registrado, todo pendiente.
  void reset() {
    _registered = false;
    _answers.updateAll((final _, final _) => null);
  }

  Map<String, Object?> toBodyJson() => demoClausesBody(_answers);
}

List<DemoRoute> demoConsentRoutes(final DemoConsentState state) {
  const path = '/api/v1/ciudadanos/([^/]+)/clausulas';
  return <DemoRoute>[
    DemoRoute('GET', path, (final request) => DemoResponse.ok(state.toBodyJson(), now: state.now())),
    DemoRoute('POST', path, (final request) {
      if (state.isRegistered) {
        // Como el gateway: el alta sobre un registro existente se rechaza y el
        // repositorio reintenta con PATCH.
        return DemoResponse.status(409, message: 'El agente ya tiene cláusulas registradas', now: state.now());
      }
      state.record(_answersFromBody(request));
      return DemoResponse.ok(true, now: state.now());
    }),
    DemoRoute('PATCH', path, (final request) {
      state.record(_answersFromBody(request));
      return DemoResponse.ok(true, now: state.now());
    }),
  ];
}

/// `{ idAgente, clausulas: [{ idClausula, seleccionado, version }] }` →
/// `idClausula` → `seleccionado`.
Map<int, bool> _answersFromBody(final DemoRequest request) {
  final clauses = request.jsonObject['clausulas'];
  if (clauses is! List<Object?>) {
    return const <int, bool>{};
  }
  final answers = <int, bool>{};
  for (final clause in clauses) {
    if (clause is! Map<Object?, Object?>) {
      continue;
    }
    final id = _asInt(clause['idClausula']);
    final selected = _asBool(clause['seleccionado']);
    if (id != null && selected != null) {
      answers[id] = selected;
    }
  }
  return answers;
}

int? _asInt(final Object? value) => switch (value) {
  final int number => number,
  final num number => number.toInt(),
  _ => int.tryParse(value?.toString().trim() ?? ''),
};

bool? _asBool(final Object? value) => switch (value) {
  final bool flag => flag,
  _ => switch (value?.toString().trim().toLowerCase()) {
    'true' || '1' || 's' || 'si' || 'sí' => true,
    'false' || '0' || 'n' || 'no' => false,
    _ => null,
  },
};
