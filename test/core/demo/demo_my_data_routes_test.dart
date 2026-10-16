import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/demo/demo_backend.dart';
import 'package:jccm_espacio_ciudadano/core/demo/demo_http_client_adapter.dart';
import 'package:jccm_espacio_ciudadano/core/demo/demo_session.dart';
import 'package:jccm_espacio_ciudadano/core/demo/routes/demo_agenda_routes.dart';
import 'package:jccm_espacio_ciudadano/core/demo/routes/demo_my_data_routes.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/real_estate_property.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/1_domain/repositories/my_data_health_repository.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/3_data/my_data_education_repository_impl.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/3_data/my_data_employment_repository_impl.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/3_data/my_data_health_repository_impl.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/3_data/my_data_housing_repository_impl.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/3_data/my_data_social_welfare_repository_impl.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/3_data/my_data_vehicles_repository_impl.dart';

/// Reloj fijo: las fixtures relativas tienen que valer para cualquier `now`,
/// y fijarlo hace reproducibles las aserciones sobre fechas.
final _now = DateTime(2026, 10, 16, 10, 30);

/// El identificador que `citizenEndpointIdsProvider` pone en todas las rutas
/// durante una sesión demo (`sub_alt`), y el documento que viaja en los
/// cuerpos.
const _citizenId = DemoSession.idAgente;
const _documentNumber = DemoSession.personIdentifier;

/// El mismo `Dio` que en los tests de repositorio, con el transporte demo y
/// **las dos** listas de rutas, que es como las registra `DemoBackend.seeded`.
Dio _demoDio() => Dio(BaseOptions(baseUrl: 'https://demo.invalid'))
  ..httpClientAdapter = DemoHttpClientAdapter(
    DemoBackend(
      routes: [
        ...demoMyDataRoutes(now: () => _now),
        ...demoAgendaRoutes(now: () => _now),
      ],
      now: () => _now,
    ),
    latency: Duration.zero,
  );

void main() {
  group('demoMyDataRoutes · bienestar social', () {
    test('familia numerosa: título general vigente con la titular y tres hijos', () async {
      final repository = MyDataSocialWelfareRepositoryImpl(dio: _demoDio());

      final title = await repository.loadLargeFamilyTitle(citizenId: _citizenId, documentNumber: _documentNumber);

      expect(title, isNotNull);
      expect(title!.region, 'Castilla-La Mancha');
      expect(title.titleNumber, isNotEmpty);
      expect(title.category, 'G');
      expect(title.isValid, isTrue);
      expect(title.issueDate!.isBefore(_now), isTrue);
      expect(title.expiryDate!.isAfter(_now), isTrue);
      expect(title.childrenCount, 3);
      expect(title.beneficiaries, hasLength(4));
      expect(title.beneficiaries.where((final beneficiary) => beneficiary.isHolder).single.documentNumber, DemoSession.personIdentifier);
    });

    test('discapacidad: grado reconocido con validez definitiva y movilidad reducida', () async {
      final repository = MyDataSocialWelfareRepositoryImpl(dio: _demoDio());

      final disability = await repository.loadDisabilityTitle(citizenId: _citizenId, documentNumber: _documentNumber);

      expect(disability, isNotNull);
      expect(disability!.degreePercent, 42);
      expect(disability.fileNumber, isNotEmpty);
      expect(disability.effectiveDate, DateTime(2019, 5, 20));
      expect(disability.hasPermanentValidity, isTrue);
      expect(disability.hasReducedMobility, isTrue);
      expect(disability.hasThirdPersonAssistance, isFalse);
      expect(disability.royalDecree, isNotEmpty);
    });

    test('termalismo: una estancia futura con el formato de fecha de Oracle', () async {
      final repository = MyDataSocialWelfareRepositoryImpl(dio: _demoDio());

      final award = await repository.loadThermalSpaAward(citizenId: _citizenId, documentNumber: _documentNumber);

      expect(award, isNotNull);
      expect(award!.name, isNotEmpty);
      expect(award.startDate!.isAfter(_now), isTrue);
      expect(award.endDate!.isAfter(award.startDate!), isTrue);
    });

    test('dependencia: grado I con una prestación económica', () async {
      final repository = MyDataSocialWelfareRepositoryImpl(dio: _demoDio());

      final status = await repository.loadDependencyCareStatus(citizenId: _citizenId, documentNumber: _documentNumber);

      expect(status, isNotNull);
      expect(status!.recognizedDegree, 'Grado 1');
      expect(status.requestDate, DateTime(2023, 1, 10));
      expect(status.resolutionDate, DateTime(2023, 6, 22));
      expect(status.baremo, isNotEmpty);
      expect(status.benefits, hasLength(1));
      expect(status.benefits.single.name, isNotEmpty);
      expect(status.benefits.single.amount, isNotEmpty);
    });

    test('tarjeta de estacionamiento: vigente hoy y con caducidad próxima', () async {
      final repository = MyDataSocialWelfareRepositoryImpl(dio: _demoDio());

      final card = await repository.loadParkingCard(citizenId: _citizenId, documentNumber: _documentNumber);

      expect(card, isNotNull);
      expect(card!.cardCode, isNotEmpty);
      expect(card.modality, isNotEmpty);
      expect(card.validFrom!.isBefore(_now), isTrue);
      expect(card.validUntil!.isAfter(_now), isTrue);
    });
  });

  group('demoMyDataRoutes · educación', () {
    test('un título universitario y dos no universitarios', () async {
      final repository = MyDataEducationRepositoryImpl(dio: _demoDio());

      final university = await repository.loadUniversityTitles(citizenId: _citizenId, documentNumber: _documentNumber);
      final nonUniversity = await repository.loadNonUniversityTitles(citizenId: _citizenId, documentNumber: _documentNumber);

      expect(university, hasLength(1));
      expect(university.single.titleName, isNotEmpty);
      expect(university.single.universityName, 'Universidad de Castilla-La Mancha');
      expect(university.single.titleNumber, isNotEmpty);
      expect(university.single.expeditionDate, DateTime(2009, 11, 14));
      expect(nonUniversity, hasLength(2));
      expect(nonUniversity.map((final title) => title.centerName), everyElement(isNotEmpty));
      expect(nonUniversity.map((final title) => title.province), everyElement('Toledo'));
    });
  });

  group('demoMyDataRoutes · empleo', () {
    test('demanda activa y dos ofertas inscritas', () async {
      final repository = MyDataEmploymentRepositoryImpl(dio: _demoDio());

      final demand = await repository.loadDemand(
        citizenId: _citizenId,
        documentNumber: _documentNumber,
        givenName: DemoSession.givenName,
        firstSurname: DemoSession.firstSurname,
        secondSurname: DemoSession.secondSurname,
      );
      final offers = await repository.loadOfferRegistrations(citizenId: _citizenId, documentNumber: _documentNumber);

      expect(demand, isNotNull);
      expect(demand!.status, 'Activa');
      expect(demand.uninterruptedRegistrationDate, DateTime(2024, 3, 15));
      expect(offers, hasLength(2));
      expect(offers.map((final offer) => offer.title), everyElement(isNotEmpty));
      expect(offers.map((final offer) => offer.applicationStatus), everyElement('Inscrita'));
      expect(offers.every((final offer) => offer.registrationDate!.isBefore(_now)), isTrue);
      expect(offers.first.selectionEndDate, isNull);
      expect(offers.last.selectionEndDate!.isAfter(_now), isTrue);
    });
  });

  group('demoMyDataRoutes · vivienda', () {
    test('domicilio compuesto desde los componentes del INE', () async {
      final repository = MyDataHousingRepositoryImpl(dio: _demoDio());

      final address = await repository.loadAddress(citizenId: _citizenId, documentNumber: _documentNumber);

      expect(address, isNotNull);
      expect(address!.address, 'CALLE DE LA DEMOSTRACIÓN Num 12 Planta 02 Puerta B');
      expect(address.postalCode, '45003');
      expect(address.municipality, 'TOLEDO');
      expect(address.province, 'TOLEDO');
      expect(address.variationType, isNotEmpty);
      expect(address.variationDate, DateTime(2021, 9, 14));
    });

    test('inmuebles de Catastro: uno urbano y uno rústico, sin enlace a cartografía', () async {
      final repository = MyDataHousingRepositoryImpl(dio: _demoDio());

      final properties = await repository.loadRealEstateProperties(citizenId: _citizenId, documentNumber: _documentNumber);

      expect(properties, hasLength(2));
      expect(properties.first.kind, RealEstatePropertyKind.urban);
      expect(properties.first.cadastralReference, '0000001VK1111S0002DM');
      expect(properties.first.address, isNotEmpty);
      expect(properties.first.cadastralValue, '68.420,15€');
      expect(properties.first.use, 'RESIDENCIAL');
      expect(properties.first.holders, hasLength(1));
      expect(properties.first.cartographyUrl, isNull);
      expect(properties.last.kind, RealEstatePropertyKind.rustic);
      expect(properties.last.holders, hasLength(2));
    });
  });

  group('demoMyDataRoutes · vehículos', () {
    test('un vehículo', () async {
      final repository = MyDataVehiclesRepositoryImpl(dio: _demoDio());

      final vehicles = await repository.loadVehicles(citizenId: _citizenId, documentNumber: _documentNumber);

      expect(vehicles.map((final vehicle) => vehicle.licensePlate), ['1234DEM']);
    });
  });

  group('demoMyDataRoutes · salud', () {
    test('CIP', () async {
      final repository = MyDataHealthRepositoryImpl(dio: _demoDio());

      expect(await repository.loadCip(citizenId: _citizenId), isNotEmpty);
    });

    test('primaria pendientes: dos citas futuras, ascendentes y con centro', () async {
      final repository = MyDataHealthRepositoryImpl(dio: _demoDio());

      final pending = await repository.loadPrimaryCareAppointments(citizenId: _citizenId, filter: HealthAppointmentFilter.pending);

      expect(pending, hasLength(2));
      expect(pending.every((final appointment) => appointment.dateTime.isAfter(_now)), isTrue);
      expect(pending.first.dateTime.isBefore(pending.last.dateTime), isTrue);
      expect(pending.first.professional, isNotEmpty);
      expect(pending.first.center, isNotEmpty);
      expect(pending.first.modality, 'Presencial');
    });

    test('primaria pasadas: la página 0 trae tres citas pasadas, de más reciente a más antigua', () async {
      final repository = MyDataHealthRepositoryImpl(dio: _demoDio());

      final past = await repository.loadPrimaryCareAppointments(citizenId: _citizenId, filter: HealthAppointmentFilter.past);

      expect(past, hasLength(3));
      expect(past.every((final appointment) => appointment.dateTime.isBefore(_now)), isTrue);
      for (var i = 1; i < past.length; i++) {
        expect(past[i - 1].dateTime.isAfter(past[i].dateTime), isTrue);
      }
    });

    test('primaria pasadas: desde la página 1 viene vacío, que es lo que corta el scroll infinito', () async {
      final repository = MyDataHealthRepositoryImpl(dio: _demoDio());

      expect(await repository.loadPrimaryCareAppointments(citizenId: _citizenId, filter: HealthAppointmentFilter.past, page: 1), isEmpty);
      expect(await repository.loadPrimaryCareAppointments(citizenId: _citizenId, filter: HealthAppointmentFilter.past, page: 7), isEmpty);
    });

    test('hospitalaria: una pendiente futura y dos pasadas, de más reciente a más antigua', () async {
      final repository = MyDataHealthRepositoryImpl(dio: _demoDio());

      final pending = await repository.loadHospitalAppointments(citizenId: _citizenId, filter: HealthAppointmentFilter.pending);
      final past = await repository.loadHospitalAppointments(citizenId: _citizenId, filter: HealthAppointmentFilter.past);

      expect(pending, hasLength(1));
      expect(pending.single.dateTime.isAfter(_now), isTrue);
      expect(pending.single.status, 'PENDIENTE');
      expect(pending.single.service, isNotEmpty);
      expect(pending.single.center, isNotEmpty);
      expect(pending.single.agendaDescription, isNotEmpty);
      expect(past, hasLength(2));
      expect(past.every((final appointment) => appointment.dateTime.isBefore(_now)), isTrue);
      expect(past.first.dateTime.isAfter(past.last.dateTime), isTrue);
    });
  });

  test('el segmento {id} acepta cualquier identificador', () async {
    // La fachada declara `numDocumento` o `idAgente` según la operación; el
    // backend demo no se ata a ninguno.
    final repository = MyDataVehiclesRepositoryImpl(dio: _demoDio());

    expect(await repository.loadVehicles(citizenId: DemoSession.personIdentifier, documentNumber: _documentNumber), hasLength(1));
  });
}
