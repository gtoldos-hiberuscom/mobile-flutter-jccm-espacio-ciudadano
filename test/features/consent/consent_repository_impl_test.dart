import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/storage/app_storage.dart';
import 'package:jccm_espacio_ciudadano/core/storage/storage_keys.dart';
import 'package:jccm_espacio_ciudadano/features/consent/0_entity/clause.dart';
import 'package:jccm_espacio_ciudadano/features/consent/1_domain/consent_status_unknown_exception.dart';
import 'package:jccm_espacio_ciudadano/features/consent/3_data/repositories/consent_repository_impl.dart';

void main() {
  group('ConsentRepositoryImpl', () {
    test('uses sub_alt in the gateway path and idAgente in the write body', () async {
      final adapter = _CapturingAdapter();
      final repository = ConsentRepositoryImpl(
        storage: _MemoryAppStorage(),
        dio: _dioWith(adapter),
        agentId: 'PER9998003',
      );

      await repository.markConsentAccepted(
        idAgente: 'f5b3ec2b-8b7a-34fe-89cd-b924c86f91f6',
        clauses: const [
          Clause(id: 1, label: 'A', isSelected: true),
        ],
      );

      expect(adapter.methods, ['GET', 'PATCH']);
      expect(adapter.paths, [
        '/api/v1/ciudadanos/f5b3ec2b-8b7a-34fe-89cd-b924c86f91f6/clausulas',
        '/api/v1/ciudadanos/f5b3ec2b-8b7a-34fe-89cd-b924c86f91f6/clausulas',
      ]);
      expect(adapter.jsonBodies.single['idAgente'], 'PER9998003');
    });

    test('markConsentAccepted creates clauses when agent has no remote preference', () async {
      final adapter = _CapturingAdapter(getStatusCode: 404);
      final repository = ConsentRepositoryImpl(
        storage: _MemoryAppStorage(),
        dio: _dioWith(adapter),
      );

      await repository.markConsentAccepted(
        idAgente: 'PER9998003',
        clauses: const [
          Clause(id: 1, label: 'A', isSelected: true),
          Clause(id: 2, label: 'B', isSelected: false),
        ],
      );

      expect(adapter.methods, ['GET', 'POST']);
      expect(adapter.paths, [
        '/api/v1/ciudadanos/PER9998003/clausulas',
        '/api/v1/ciudadanos/PER9998003/clausulas',
      ]);
      expect(
        adapter.jsonBodies.single,
        <String, dynamic>{
          'idAgente': 'PER9998003',
          'clausulas': [
            {
              'idClausula': 1,
              'seleccionado': true,
              'version': '1.0',
            },
            {
              'idClausula': 2,
              'seleccionado': false,
              'version': '1.0',
            },
          ],
        },
      );
    });

    test('markConsentAccepted updates clauses directly when agent already has remote preference', () async {
      final adapter = _CapturingAdapter();
      final repository = ConsentRepositoryImpl(
        storage: _MemoryAppStorage(),
        dio: _dioWith(adapter),
      );

      await repository.markConsentAccepted(
        idAgente: 'PER9998003',
        clauses: const [
          Clause(id: 0, label: 'A', isSelected: true, version: '1'),
          Clause(id: 1, label: 'B', isSelected: true, version: '1'),
        ],
      );

      expect(adapter.methods, ['GET', 'PATCH']);
      expect(adapter.paths, [
        '/api/v1/ciudadanos/PER9998003/clausulas',
        '/api/v1/ciudadanos/PER9998003/clausulas',
      ]);
      expect(adapter.jsonBodies.single['clausulas'], [
        {
          'idClausula': 0,
          'seleccionado': true,
          'version': '1',
        },
        {
          'idClausula': 1,
          'seleccionado': true,
          'version': '1',
        },
      ]);
    });

    test('markConsentAccepted retries with PATCH when initial POST is recoverable', () async {
      final adapter = _CapturingAdapter(getStatusCode: 404, firstWriteStatusCode: 409);
      final repository = ConsentRepositoryImpl(
        storage: _MemoryAppStorage(),
        dio: _dioWith(adapter),
      );

      await repository.markConsentAccepted(
        idAgente: 'PER9998003',
        clauses: const [
          Clause(id: 1, label: 'A', isSelected: true),
        ],
      );

      expect(adapter.methods, ['GET', 'POST', 'PATCH']);
      expect(adapter.paths, [
        '/api/v1/ciudadanos/PER9998003/clausulas',
        '/api/v1/ciudadanos/PER9998003/clausulas',
        '/api/v1/ciudadanos/PER9998003/clausulas',
      ]);
      expect(adapter.jsonBodies.first, adapter.jsonBodies.last);
    });

    test('markConsentAccepted creates clauses when cached remote preference was deleted', () async {
      final adapter = _CapturingAdapter(firstWriteStatusCode: 404);
      final repository = ConsentRepositoryImpl(
        storage: _MemoryAppStorage(),
        dio: _dioWith(adapter),
      );

      await repository.fetchClauses(idAgente: 'PER9998003');
      await repository.markConsentAccepted(
        idAgente: 'PER9998003',
        clauses: const [
          Clause(id: 0, label: 'A', isSelected: true, version: '1'),
          Clause(id: 1, label: 'B', isSelected: true, version: '1'),
        ],
      );

      expect(adapter.methods, ['GET', 'PATCH', 'POST']);
      expect(adapter.paths, [
        '/api/v1/ciudadanos/PER9998003/clausulas',
        '/api/v1/ciudadanos/PER9998003/clausulas',
        '/api/v1/ciudadanos/PER9998003/clausulas',
      ]);
      expect(adapter.jsonBodies.first, adapter.jsonBodies.last);
    });

    test('fetchClauses loads backend clause ids, versions and selected state', () async {
      final adapter = _CapturingAdapter();
      final repository = ConsentRepositoryImpl(
        storage: _MemoryAppStorage(),
        dio: _dioWith(adapter),
      );

      final clauses = await repository.fetchClauses(idAgente: 'PER9998001');

      expect(adapter.methods, ['GET']);
      expect(adapter.paths, ['/api/v1/ciudadanos/PER9998001/clausulas']);
      expect(
        clauses,
        [
          const Clause(
            id: 0,
            label: 'He leído y acepto la información de protección de datos.',
            isSelected: true,
            version: '1',
          ),
          const Clause(
            id: 1,
            label: 'Autorizo la consulta de los hechos administrativos JCCM.',
            isSelected: true,
            version: '1',
          ),
          const Clause(
            id: 2,
            label: 'Autorizo la consulta de datos AGE.',
            isSelected: false,
            version: '1',
          ),
          const Clause(
            id: 3,
            label: 'Consiento recomendaciones.',
            isSelected: false,
            version: '1',
          ),
        ],
      );
    });

    test('hasAcceptedClause checks backend state before local cache', () async {
      final adapter = _CapturingAdapter();
      final storage = _MemoryAppStorage();
      await storage.write('${StorageKeys.consentAcceptedClausesPrefix}PER9998001', const ['2']);
      final repository = ConsentRepositoryImpl(
        storage: storage,
        dio: _dioWith(adapter),
      );

      final accepted = await repository.hasAcceptedClause(
        idAgente: 'PER9998001',
        clauseId: 2,
      );

      expect(accepted, isFalse);
    });

    test('hasAcceptedConsent requires required data-protection clause even when backend has no pending flag', () async {
      final adapter = _CapturingAdapter(requiredClauseSelected: false);
      final storage = _MemoryAppStorage();
      final repository = ConsentRepositoryImpl(
        storage: storage,
        dio: _dioWith(adapter),
      );

      final accepted = await repository.hasAcceptedConsent(idAgente: 'PER9998001');

      expect(accepted, isFalse);
      expect(storage.read<bool>('${StorageKeys.consentAcceptedPrefix}PER9998001'), isFalse);
    });

    test('markConsentAccepted does not cache acceptance when backend sync fails', () async {
      final adapter = _CapturingAdapter(getStatusCode: 404, firstWriteStatusCode: 500);
      final storage = _MemoryAppStorage();
      final repository = ConsentRepositoryImpl(
        storage: storage,
        dio: _dioWith(adapter),
      );

      await expectLater(
        repository.markConsentAccepted(
          idAgente: 'PER9998003',
          clauses: const [
            Clause(id: 2, label: 'A', isSelected: true),
          ],
        ),
        throwsA(isA<DioException>()),
      );

      expect(storage.read<bool>('${StorageKeys.consentAcceptedPrefix}PER9998003'), isNull);
      expect(storage.read<List<String>>('${StorageKeys.consentAcceptedClausesPrefix}PER9998003'), isNull);
    });

    test('resetConsentClauses updates existing remote clauses to false and clears local cache', () async {
      final adapter = _CapturingAdapter();
      final storage = _MemoryAppStorage();
      await storage.write('${StorageKeys.consentAcceptedPrefix}PER9998003', true);
      await storage.write('${StorageKeys.consentAcceptedClausesPrefix}PER9998003', const ['0', '1']);
      final repository = ConsentRepositoryImpl(
        storage: storage,
        dio: _dioWith(adapter),
      );

      await repository.resetConsentClauses(idAgente: 'PER9998003');

      expect(adapter.methods, ['GET', 'PATCH']);
      expect(adapter.paths, [
        '/api/v1/ciudadanos/PER9998003/clausulas',
        '/api/v1/ciudadanos/PER9998003/clausulas',
      ]);
      expect(adapter.jsonBodies.single['clausulas'], [
        {
          'idClausula': 0,
          'seleccionado': false,
          'version': '1',
        },
        {
          'idClausula': 1,
          'seleccionado': false,
          'version': '1',
        },
        {
          'idClausula': 2,
          'seleccionado': false,
          'version': '1',
        },
        {
          'idClausula': 3,
          'seleccionado': false,
          'version': '1',
        },
      ]);
      expect(storage.read<bool>('${StorageKeys.consentAcceptedPrefix}PER9998003'), isNull);
      expect(storage.read<List<String>>('${StorageKeys.consentAcceptedClausesPrefix}PER9998003'), isNull);
    });

    test('resetConsentClauses does not create remote clauses when agent has no preference', () async {
      final adapter = _CapturingAdapter(getStatusCode: 404);
      final storage = _MemoryAppStorage();
      await storage.write('${StorageKeys.consentAcceptedPrefix}PER9998003', true);
      await storage.write('${StorageKeys.consentAcceptedClausesPrefix}PER9998003', const ['0', '1']);
      final repository = ConsentRepositoryImpl(
        storage: storage,
        dio: _dioWith(adapter),
      );

      await repository.resetConsentClauses(idAgente: 'PER9998003');

      expect(adapter.methods, ['GET']);
      expect(adapter.paths, ['/api/v1/ciudadanos/PER9998003/clausulas']);
      expect(adapter.jsonBodies, isEmpty);
      expect(storage.read<bool>('${StorageKeys.consentAcceptedPrefix}PER9998003'), isNull);
      expect(storage.read<List<String>>('${StorageKeys.consentAcceptedClausesPrefix}PER9998003'), isNull);
    });
  });

  group('ConsentRepositoryImpl three-state contract (backend unavailable)', () {
    test('hasAcceptedConsent throws ConsentStatusUnknownException on 500 with no local evidence', () async {
      final repository = ConsentRepositoryImpl(
        storage: _MemoryAppStorage(),
        dio: _dioWith(_CapturingAdapter(getStatusCode: 500)),
      );

      await expectLater(
        repository.hasAcceptedConsent(idAgente: 'PER9998001'),
        throwsA(isA<ConsentStatusUnknownException>().having((final e) => e.statusCode, 'statusCode', 500)),
      );
    });

    test('hasAcceptedConsent still throws when the cached flag is false — only a positive is evidence', () async {
      final storage = _MemoryAppStorage();
      await storage.write('${StorageKeys.consentAcceptedPrefix}PER9998001', false);
      final repository = ConsentRepositoryImpl(
        storage: storage,
        dio: _dioWith(_CapturingAdapter(getStatusCode: 403)),
      );

      await expectLater(
        repository.hasAcceptedConsent(idAgente: 'PER9998001'),
        throwsA(isA<ConsentStatusUnknownException>()),
      );
    });

    test('hasAcceptedConsent returns true on failure when a confirmed acceptance is cached', () async {
      final storage = _MemoryAppStorage();
      await storage.write('${StorageKeys.consentAcceptedPrefix}PER9998001', true);
      final repository = ConsentRepositoryImpl(
        storage: storage,
        dio: _dioWith(_CapturingAdapter(getStatusCode: 500)),
      );

      expect(await repository.hasAcceptedConsent(idAgente: 'PER9998001'), isTrue);
    });

    test('hasAcceptedConsent returns false on a genuine 404', () async {
      final repository = ConsentRepositoryImpl(
        storage: _MemoryAppStorage(),
        dio: _dioWith(_CapturingAdapter(getStatusCode: 404)),
      );

      expect(await repository.hasAcceptedConsent(idAgente: 'PER9998001'), isFalse);
    });

    test('hasAcceptedClause on failure: true when cached as accepted, throws otherwise', () async {
      final storage = _MemoryAppStorage();
      await storage.write('${StorageKeys.consentAcceptedClausesPrefix}PER9998001', const ['2']);
      final repository = ConsentRepositoryImpl(
        storage: storage,
        dio: _dioWith(_CapturingAdapter(getStatusCode: 500)),
      );

      expect(await repository.hasAcceptedClause(idAgente: 'PER9998001', clauseId: 2), isTrue);
      await expectLater(
        repository.hasAcceptedClause(idAgente: 'PER9998001', clauseId: 3),
        throwsA(isA<ConsentStatusUnknownException>()),
      );
    });

    test('markConsentAccepted still writes when the verb-probe GET is unavailable', () async {
      final adapter = _CapturingAdapter(getStatusCode: 500);
      final repository = ConsentRepositoryImpl(
        storage: _MemoryAppStorage(),
        dio: _dioWith(adapter),
      );

      await repository.markConsentAccepted(
        idAgente: 'PER9998003',
        clauses: const [
          Clause(id: 0, label: 'A', isSelected: true),
        ],
      );

      expect(adapter.methods, ['GET', 'POST']);
    });

    test('fetchClauses propagates ConsentStatusUnknownException on backend failure', () async {
      final repository = ConsentRepositoryImpl(
        storage: _MemoryAppStorage(),
        dio: _dioWith(_CapturingAdapter(getStatusCode: 500)),
      );

      await expectLater(
        repository.fetchClauses(idAgente: 'PER9998001'),
        throwsA(isA<ConsentStatusUnknownException>()),
      );
    });
  });
}

Dio _dioWith(final HttpClientAdapter adapter) => Dio(
  BaseOptions(
    baseUrl: 'https://example.test',
    headers: const {
      Headers.contentTypeHeader: Headers.jsonContentType,
    },
  ),
)..httpClientAdapter = adapter;

final class _MemoryAppStorage implements AppStorage {
  final Map<String, Object> _values = {};

  @override
  T? read<T>(final String key) => _values[key] as T?;

  @override
  Future<bool> write(final String key, final Object value) async {
    _values[key] = value;
    return true;
  }

  @override
  Future<bool> remove(final String key) async {
    _values.remove(key);
    return true;
  }

  @override
  Future<bool> clear() async {
    _values.clear();
    return true;
  }
}

final class _CapturingAdapter implements HttpClientAdapter {
  _CapturingAdapter({
    this.getStatusCode = 200,
    this.firstWriteStatusCode = 200,
    this.requiredClauseSelected = true,
  });

  final int getStatusCode;
  final int firstWriteStatusCode;
  final bool requiredClauseSelected;
  final List<String> methods = [];
  final List<String> paths = [];
  final List<Map<String, dynamic>> jsonBodies = [];

  @override
  Future<ResponseBody> fetch(
    final RequestOptions options,
    final Stream<Uint8List>? requestStream,
    final Future<void>? cancelFuture,
  ) async {
    methods.add(options.method);
    paths.add(options.path);

    if (options.method != 'GET') {
      final bodyBytes = <int>[];
      await (requestStream ?? const Stream<Uint8List>.empty()).forEach(bodyBytes.addAll);
      jsonBodies.add(jsonDecode(utf8.decode(bodyBytes)) as Map<String, dynamic>);
    }

    if (options.method == 'GET') {
      if (getStatusCode != 200) {
        return ResponseBody.fromString(
          jsonEncode(<String, dynamic>{
            'codigo-respuesta': '$getStatusCode.00',
            'mensaje-respuesta': 'Error',
          }),
          getStatusCode,
          headers: {
            Headers.contentTypeHeader: [Headers.jsonContentType],
          },
        );
      }

      return ResponseBody.fromString(
        jsonEncode(<String, dynamic>{
          'body': {
            'idAgente': 'PER9998001',
            'clausulaPendiente': false,
            'textosClausulas': [
              {
                'idClausula': '0',
                'version': '1',
                'textoCheck': '<p><b>He leído y acepto la información de protección de datos.</b></p>',
                'seleccionado': requiredClauseSelected,
              },
              {
                'idClausula': '1',
                'version': '1',
                'textoCheck': '<p>Autorizo la consulta de los hechos administrativos JCCM.</p>',
                'descripcion': '<p>Texto ampliado que no debe mostrarse.</p>',
                'seleccionado': true,
              },
              {
                'idClausula': '2',
                'version': '1',
                'textoCheck': '<p>Autorizo la consulta de datos AGE.</p>',
                'seleccionado': false,
              },
              {
                'idClausula': '3',
                'version': '1',
                'textoCheck': '<p>Consiento recomendaciones.</p>',
                'seleccionado': false,
              },
            ],
          },
          'codigo-respuesta': '200.00',
          'mensaje-respuesta': 'Respuesta correcta',
          'info-error': null,
        }),
        200,
        headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType],
        },
      );
    }

    final statusCode = jsonBodies.length == 1 ? firstWriteStatusCode : 200;
    return ResponseBody.fromString(
      jsonEncode(<String, dynamic>{
        'body': true,
        'codigo-respuesta': statusCode == 200 ? '200.00' : '$statusCode.00',
        'mensaje-respuesta': statusCode == 200 ? 'Respuesta correcta' : 'Error',
        'info-error': null,
      }),
      statusCode,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({final bool force = false}) {}
}
