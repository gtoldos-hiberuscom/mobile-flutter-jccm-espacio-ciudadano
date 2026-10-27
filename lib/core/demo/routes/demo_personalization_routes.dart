import 'package:jccm_espacio_ciudadano/core/demo/demo_backend_core.dart';
import 'package:jccm_espacio_ciudadano/core/demo/fixtures/demo_personalization_fixtures.dart';
import 'package:jccm_espacio_ciudadano/core/demo/routes/demo_consent_routes.dart';

/// Hechos vitales de la persona ficticia: el catálogo es fijo y lo único que
/// cambia es qué hechos están marcados. Las recomendaciones se derivan de
/// esta selección (ver `demoRecommendationsRoutes`).
final class DemoPersonalizationState {
  DemoPersonalizationState({required this.now});

  final DateTime Function() now;

  final Set<int> _selectedIds = <int>{...demoInitiallySelectedLifeEventIds};

  Set<int> get selectedIds => Set<int>.unmodifiable(_selectedIds);

  /// Aplica la marca de cada hecho recibido. La app manda el catálogo entero
  /// en cada PATCH, pero un hecho que no venga conserva su estado; un id que
  /// no esté en el catálogo se ignora.
  void apply(final Map<int, bool> selection) {
    for (final entry in selection.entries) {
      if (demoLifeEventName(entry.key) == null) {
        continue;
      }
      if (entry.value) {
        _selectedIds.add(entry.key);
      } else {
        _selectedIds.remove(entry.key);
      }
    }
  }

  /// Deja el catálogo sin ningún hecho marcado.
  void reset() => _selectedIds.clear();

  Map<String, Object?> toBodyJson() => demoLifeEventsBody(_selectedIds);
}

List<DemoRoute> demoPersonalizationRoutes(final DemoPersonalizationState state, {required final DemoConsentState consent}) => <DemoRoute>[
  DemoRoute('GET', '/api/v1/ciudadanos/([^/]+)/hechos', (final request) => DemoResponse.ok(state.toBodyJson(), now: state.now())),
  DemoRoute('PATCH', '/api/v1/ciudadanos/([^/]+)/hechos', (final request) {
    state.apply(_selectionFromBody(request));
    return DemoResponse.ok(true, now: state.now());
  }),
  DemoRoute('DELETE', '/api/v1/ciudadanos/([^/]+)/preferencias', (final request) {
    // El DELETE del gateway arrasa el soporte entero del ciudadano, hechos y
    // cláusulas incluidas. Aquí igual, pero sin la parte irrecuperable: tras
    // él GET /clausulas vuelve a servir el catálogo pendiente y el gate legal
    // se puede volver a pasar.
    state.reset();
    consent.reset();
    return DemoResponse.ok(true, now: state.now());
  }),
];

/// `{ idAgente, listaHechos: [{ idHecho, nombreHecho, seleccionado }] }` →
/// `idHecho` → `seleccionado`.
Map<int, bool> _selectionFromBody(final DemoRequest request) {
  final events = request.jsonObject['listaHechos'];
  if (events is! List<Object?>) {
    return const <int, bool>{};
  }
  final selection = <int, bool>{};
  for (final event in events) {
    if (event is! Map<Object?, Object?>) {
      continue;
    }
    final id = _asInt(event['idHecho']);
    final selected = _asBool(event['seleccionado']);
    if (id != null && selected != null) {
      selection[id] = selected;
    }
  }
  return selection;
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
