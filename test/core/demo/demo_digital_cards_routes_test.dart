import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/demo/demo_backend.dart';
import 'package:jccm_espacio_ciudadano/core/demo/demo_http_client_adapter.dart';
import 'package:jccm_espacio_ciudadano/core/demo/demo_session.dart';
import 'package:jccm_espacio_ciudadano/core/demo/fixtures/demo_binaries.dart';
import 'package:jccm_espacio_ciudadano/core/demo/fixtures/demo_digital_cards_fixtures.dart';
import 'package:jccm_espacio_ciudadano/core/demo/routes/demo_digital_cards_routes.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/0_entity/digital_card.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/3_data/digital_cards_repository_impl.dart';

void main() {
  final fixedNow = DateTime(2026, 10, 16, 10, 30);
  late DigitalCardsRepositoryImpl repository;

  setUp(() {
    // El mismo repositorio que construye `digitalCardsRepositoryProvider`, con
    // el transporte demo debajo: se ejercita la cadena real de decodificación
    // (cliente generado, compat, mappers), no un doble del repositorio.
    final dio = Dio(BaseOptions(baseUrl: 'https://demo.invalid'))
      ..httpClientAdapter = DemoHttpClientAdapter(
        DemoBackend(
          routes: demoDigitalCardsRoutes(now: () => fixedNow),
          now: () => fixedNow,
        ),
        latency: Duration.zero,
      );
    repository = DigitalCardsRepositoryImpl(dio: dio);
  });

  test('la persona ficticia tiene los tres carnés, con fechas relativas al reloj', () async {
    final snapshot = await repository.loadCards(citizenId: DemoSession.idAgente);

    expect(snapshot.failedCount, 0);
    expect(snapshot.cards.map((final card) => card.type), [
      DigitalCardType.largeFamily,
      DigitalCardType.youth,
      DigitalCardType.disability,
    ]);

    final youth = snapshot.cards.singleWhere((final card) => card.type == DigitalCardType.youth);
    expect(youth.number, DemoDigitalCardsFixtures.youthCardNumber);
    // develop no mapea la fecha de inicio del Carné Joven: `validFrom` sale
    // `null` aunque la fachada (y la fixture) envíen `FechaInicioValidez`.
    expect(youth.validFrom, isNull);
    expect(youth.expiresAt, DateTime(2028, 10, 16));

    final largeFamily = snapshot.cards.singleWhere((final card) => card.type == DigitalCardType.largeFamily);
    expect(largeFamily.number, DemoDigitalCardsFixtures.largeFamilyTitleNumber);
    expect(largeFamily.validFrom, DateTime(2024, 10, 16));
    expect(largeFamily.expiresAt, DateTime(2029, 10, 16));

    final disability = snapshot.cards.singleWhere((final card) => card.type == DigitalCardType.disability);
    expect(disability.number, isNull);
    expect(disability.isDefinitive, isTrue);
    expect(disability.validFrom, DateTime(2021, 10, 16));
    expect(disability.expiresAt, isNull);
  });

  test('el segmento {dni} no está fijado: cualquier identificador carga los carnés', () async {
    final snapshot = await repository.loadCards(citizenId: 'otro-identificador');

    expect(snapshot.failedCount, 0);
    expect(snapshot.cards, hasLength(3));
  });

  test('pdf, pkpass y qr del Carné Joven devuelven los binarios demo', () async {
    final youth = (await repository.loadCards(citizenId: DemoSession.idAgente)).cards.singleWhere((final card) => card.type == DigitalCardType.youth);

    final pdf = await repository.downloadPdf(citizenId: DemoSession.idAgente, card: youth);
    expect(pdf.bytes, isNotEmpty);
    expect(pdf.bytes, DemoBinaries.pdf);
    expect(pdf.extension, 'pdf');
    expect(pdf.fileName, endsWith('.pdf'));

    final pkPass = await repository.downloadPkPass(citizenId: DemoSession.idAgente, card: youth);
    expect(pkPass.bytes, isNotEmpty);
    expect(pkPass.bytes, DemoBinaries.pkpass);
    expect(pkPass.extension, 'pkpass');

    final qr = await repository.downloadQr(citizenId: DemoSession.idAgente, card: youth);
    expect(qr.bytes, isNotEmpty);
    expect(qr.bytes, DemoBinaries.qrPng);
    expect(qr.extension, 'png');

    // La imagen QR que pinta la tarjeta sale del mismo endpoint.
    expect(await repository.loadQrImage(citizenId: DemoSession.idAgente, card: youth), DemoBinaries.qrPng);
  });

  test('los pkpass de familia numerosa y discapacidad devuelven el pkpass demo', () async {
    final cards = (await repository.loadCards(citizenId: DemoSession.idAgente)).cards;

    for (final type in [DigitalCardType.largeFamily, DigitalCardType.disability]) {
      final card = cards.singleWhere((final candidate) => candidate.type == type);
      final artifact = await repository.downloadPkPass(citizenId: DemoSession.idAgente, card: card);
      expect(artifact.bytes, isNotEmpty, reason: '${type.name} pkpass');
      expect(artifact.bytes, DemoBinaries.pkpass, reason: '${type.name} pkpass');
      expect(artifact.extension, 'pkpass');
    }
  });
}
