import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/casework/registro/0_entity/registro_detail.dart';
import 'package:jccm_espacio_ciudadano/features/casework/registro/0_entity/registro_fichero.dart';
import 'package:jccm_espacio_ciudadano/features/casework/registro/0_entity/registro_kind.dart';
import 'package:jccm_espacio_ciudadano/features/casework/registro/1_domain/registro_detail_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/casework/registro/1_domain/registro_repository.dart';
import 'package:jccm_espacio_ciudadano/features/casework/registro/3_data/registro_repository_provider.dart';

class _FakeRepo implements RegistroRepository {
  _FakeRepo({required this.responses});
  final Map<String, RegistroDetail Function()> responses;

  @override
  Future<RegistroDetail> loadByNumber({
    required final String numreg,
    required final RegistroKind kind,
  }) async {
    final key = '${kind.token}:${numreg.toUpperCase()}';
    final builder = responses[key];
    if (builder == null) {
      throw StateError('fake: $key not configured');
    }
    return builder();
  }
}

ProviderContainer _container(final RegistroRepository repo) {
  final c = ProviderContainer(
    overrides: [
      registroRepositoryProvider.overrideWith((final ref) => repo),
    ],
  );
  addTearDown(c.dispose);
  return c;
}

RegistroDetail _detail({
  required final String numero,
  required final RegistroKind kind,
  final List<RegistroFichero> ficheros = const <RegistroFichero>[],
}) => RegistroDetail(
  id: 'id-$numero',
  numero: numero,
  fecha: DateTime(2025, 6, 12, 9, 30),
  kind: kind,
  consejeriaDestino: 'Consejería Test',
  asunto: 'Asunto test',
  oficina: 'Oficina test',
  ficheros: ficheros,
);

void main() {
  test('loads entrada detail successfully', () async {
    final repo = _FakeRepo(
      responses: {
        'entrada:REG/E/45612': () => _detail(
          numero: 'REG/E/45612',
          kind: RegistroKind.entrada,
          ficheros: const <RegistroFichero>[
            RegistroFichero(
              id: 'f1',
              nombre: 'a.pdf',
              mimeType: 'application/pdf',
              descargaRef: 'r',
            ),
          ],
        ),
      },
    );
    final container = _container(repo);

    final value = await container.read(
      registroDetailProvider('REG/E/45612', RegistroKind.entrada).future,
    );

    expect(value.numero, 'REG/E/45612');
    expect(value.kind, RegistroKind.entrada);
    expect(value.ficheros, hasLength(1));
  });

  test('loads salida detail successfully', () async {
    final repo = _FakeRepo(
      responses: {
        'salida:REG/S/12044': () => _detail(
          numero: 'REG/S/12044',
          kind: RegistroKind.salida,
          ficheros: const <RegistroFichero>[
            RegistroFichero(
              id: 'f1',
              nombre: 'r.pdf',
              mimeType: 'application/pdf',
              descargaRef: 'r',
            ),
          ],
        ),
      },
    );
    final container = _container(repo);

    final value = await container.read(
      registroDetailProvider('REG/S/12044', RegistroKind.salida).future,
    );

    expect(value.kind, RegistroKind.salida);
    expect(value.numero, 'REG/S/12044');
  });

  test('exposes empty ficheros list as data state', () async {
    final repo = _FakeRepo(
      responses: {
        'entrada:REG/E/00000': () => _detail(
          numero: 'REG/E/00000',
          kind: RegistroKind.entrada,
        ),
      },
    );
    final container = _container(repo);

    final value = await container.read(
      registroDetailProvider('REG/E/00000', RegistroKind.entrada).future,
    );

    expect(value.ficheros, isEmpty);
  });

  test('surfaces repository failures as AsyncError', () async {
    final repo = _FakeRepo(responses: const <String, RegistroDetail Function()>{});
    final container = _container(repo);

    await expectLater(
      container.read(
        registroDetailProvider('REG/E/UNKNOWN', RegistroKind.entrada).future,
      ),
      throwsA(isA<StateError>()),
    );
  });
}
