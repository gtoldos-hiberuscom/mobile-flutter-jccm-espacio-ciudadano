import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/0_entity/digital_card.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/3_data/digital_cards_repository_impl.dart';

void main() {
  late _DigitalCardsAdapter adapter;
  late DigitalCardsRepositoryImpl repository;

  setUp(() {
    adapter = _DigitalCardsAdapter();
    final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))..httpClientAdapter = adapter;
    repository = DigitalCardsRepositoryImpl(dio: dio);
  });

  test('loads every card using the generated client endpoints', () async {
    final cards = await repository.loadCards(documentNumber: '12345678Z');

    expect(cards.map((final card) => card.type), [
      DigitalCardType.largeFamily,
      DigitalCardType.youth,
      DigitalCardType.disability,
    ]);
    expect(
      adapter.paths,
      containsAll(<String>[
        '/api/v1/carnet-digital/familia-numerosa/12345678Z',
        '/api/v1/carnet-digital/joven/12345678Z',
        '/api/v1/carnet-digital/grado-discapacidad/12345678Z',
      ]),
    );
  });

  test('uses the card-specific PKPASS endpoint', () async {
    for (final type in DigitalCardType.values) {
      adapter.paths.clear();
      final artifact = await repository.downloadPkPass(
        documentNumber: '12345678Z',
        card: _card(type),
      );
      expect(artifact.bytes, Uint8List.fromList([1, 2, 3]));
      expect(artifact.extension, 'pkpass');
      expect(adapter.paths.single, switch (type) {
        DigitalCardType.youth => '/api/v1/carnet-digital/pkpass/12345678Z',
        DigitalCardType.largeFamily => '/api/v1/carnet-digital/familia-numerosa-pkpass/12345678Z',
        DigitalCardType.disability => '/api/v1/carnet-digital/discapacidad-pkpass/12345678Z',
      });
    }
  });

  test('only youth card supports QR and PDF', () async {
    final youth = _card(DigitalCardType.youth);
    expect((await repository.downloadQr(documentNumber: '12345678Z', card: youth)).extension, 'png');
    expect((await repository.downloadPdf(documentNumber: '12345678Z', card: youth)).extension, 'pdf');

    expect(
      () => repository.downloadQr(documentNumber: '12345678Z', card: _card(DigitalCardType.largeFamily)),
      throwsUnsupportedError,
    );
    expect(
      () => repository.downloadPdf(documentNumber: '12345678Z', card: _card(DigitalCardType.disability)),
      throwsUnsupportedError,
    );
  });

  test('keeps a valid youth card when another card endpoint fails', () async {
    adapter.failingPaths.add('/api/v1/carnet-digital/familia-numerosa/12345678Z');

    final cards = await repository.loadCards(documentNumber: '12345678Z');

    final youthCard = cards.singleWhere((final card) => card.type == DigitalCardType.youth);
    expect(youthCard.number, '99999999R-R955-C233-J452-Z864');
    expect(youthCard.expiresAt, DateTime(2030, 1, 30));
  });

  test('keeps a valid youth card when the other cards return business code 3033', () async {
    adapter.noDataPaths.addAll({
      '/api/v1/carnet-digital/familia-numerosa/12345678Z',
      '/api/v1/carnet-digital/grado-discapacidad/12345678Z',
    });

    final cards = await repository.loadCards(documentNumber: '12345678Z');

    expect(cards, hasLength(1));
    expect(cards.single.type, DigitalCardType.youth);
    expect(cards.single.number, '99999999R-R955-C233-J452-Z864');
  });
}

DigitalCard _card(final DigitalCardType type) => DigitalCard(
  type: type,
  title: type.name,
  number: 'CARD-1',
  validFrom: null,
  expiresAt: null,
);

final class _DigitalCardsAdapter implements HttpClientAdapter {
  final List<String> paths = [];
  final Set<String> failingPaths = {};
  final Set<String> noDataPaths = {};

  @override
  Future<ResponseBody> fetch(
    final RequestOptions options,
    final Stream<Uint8List>? requestStream,
    final Future<void>? cancelFuture,
  ) async {
    paths.add(options.path);
    if (failingPaths.contains(options.path)) {
      return ResponseBody.fromString('Service unavailable', 500);
    }
    if (noDataPaths.contains(options.path)) {
      return ResponseBody.fromString(
        jsonEncode({
          'body': null,
          'codigo-respuesta': '400.00',
          'mensaje-respuesta': 'No se pudo procesar la petición recibida',
          'info-error': {
            'errores': [
              {
                'mensaje-error': 'El documento indicado no existe, no es válido o no tiene datos asociados',
                'codigo-error': 3033,
              },
            ],
          },
        }),
        400,
        headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType],
        },
      );
    }
    final body = switch (options.path) {
      final path when path.contains('/familia-numerosa/') => {
        'numeroTitulo': 'FN-1',
        'fechaValidezHasta': '30/11/2026',
      },
      final path when path.contains('/joven/') => {
        'enTramitacion': 'E',
        'FechaFinValidez': '30/01/2030',
        'FechaNacimiento': '26/06/2006',
        'Numero': '99999999R-R955-C233-J452-Z864',
        'Titular': 'USUARIO CMD PRUEBAS',
      },
      final path when path.contains('/grado-discapacidad/') => {
        'validezDefinitiva': 'S',
        'fechaEfectos': '26/07/2011',
      },
      final path when path.contains('/qr/') => base64Encode([1, 2, 3]),
      final path when path.contains('/pdf/') => {
        'pdf': base64Encode([1, 2, 3]),
      },
      _ => {
        'pkpass': base64Encode([1, 2, 3]),
      },
    };
    return ResponseBody.fromString(
      jsonEncode({
        'body': body,
        'codigo-respuesta': '200.00',
        'mensaje-respuesta': 'Respuesta correcta',
      }),
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({final bool force = false}) {}
}
