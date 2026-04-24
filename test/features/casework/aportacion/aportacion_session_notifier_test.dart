import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:jccm_espacio_ciudadano/features/casework/0_entity/casework_item.dart';
import 'package:jccm_espacio_ciudadano/features/casework/0_entity/casework_tab.dart';
import 'package:jccm_espacio_ciudadano/features/casework/1_domain/casework_repository.dart';
import 'package:jccm_espacio_ciudadano/features/casework/3_data/casework_repository_provider.dart';
import 'package:jccm_espacio_ciudadano/features/casework/aportacion/0_entity/aportacion_failure.dart';
import 'package:jccm_espacio_ciudadano/features/casework/aportacion/0_entity/aportacion_search_query.dart';
import 'package:jccm_espacio_ciudadano/features/casework/aportacion/0_entity/aportacion_step.dart';
import 'package:jccm_espacio_ciudadano/features/casework/aportacion/0_entity/interested_party_identification.dart';
import 'package:jccm_espacio_ciudadano/features/casework/aportacion/1_domain/aportacion_session_notifier.dart';

class _FakeRepo implements CaseworkRepository {
  _FakeRepo({this.expedienteResults, this.registroError = false});

  final List<CaseworkItem>? expedienteResults;
  final bool registroError;

  @override
  Future<List<CaseworkItem>> loadByTab(final CaseworkTab tab) async =>
      const <CaseworkItem>[];

  @override
  Future<List<CaseworkItem>> searchByNif(final String identification) async =>
      const <CaseworkItem>[];

  @override
  Future<List<CaseworkItem>> searchByExpedienteNumber(
    final String number,
  ) async =>
      expedienteResults ?? const <CaseworkItem>[];

  @override
  Future<List<CaseworkItem>> searchByRegistroNumber(
    final String number,
  ) async {
    if (registroError) {
      throw StateError('boom');
    }
    return const <CaseworkItem>[];
  }
}

CaseworkItem _item(final String number) => CaseworkItem(
  id: 'id-$number',
  type: CaseworkTab.expedientes,
  number: number,
  date: DateTime(2025, 6, 15),
  organism: 'Org',
  subject: 'Asunto',
  status: CaseworkItemStatus.enTramite,
);

ProviderContainer _container({final CaseworkRepository? repo}) {
  final c = ProviderContainer(
    overrides: [
      if (repo != null)
        caseworkRepositoryProvider.overrideWith((final ref) => repo),
    ],
  );
  addTearDown(c.dispose);
  return c;
}

void main() {
  group('AportacionSessionNotifier', () {
    test('starts on the intro step', () {
      final c = _container();
      final state = c.read(aportacionSessionProvider);
      expect(state.currentStep, AportacionStep.intro);
      expect(state.identificacion, isNull);
      expect(state.expedienteRef, isNull);
      expect(state.completed, isFalse);
      expect(state.failure, isNull);
    });

    test('happy-path traverses every step', () async {
      final c = _container(
        repo: _FakeRepo(
          expedienteResults: <CaseworkItem>[_item('EXP/2025/00123')],
        ),
      );
      final notifier = c.read(aportacionSessionProvider.notifier);

      notifier.confirmIntro();
      expect(c.read(aportacionSessionProvider).currentStep,
          AportacionStep.identificacion);

      notifier.setIdentification(
        const InterestedPartyIdentification(
          idType: InterestedPartyIdType.nif,
          idNumber: '12345678Z',
        ),
      );
      var state = c.read(aportacionSessionProvider);
      expect(state.currentStep, AportacionStep.searchExpediente);
      expect(state.identificacion?.normalizedNumber, '12345678Z');

      await notifier.resolveQuery(
        const AportacionSearchQuery.byExpediente('EXP/2025/00123'),
      );
      state = c.read(aportacionSessionProvider);
      expect(state.currentStep, AportacionStep.detail);
      expect(state.expedienteRef, 'EXP/2025/00123');
      expect(state.failure, isNull);

      notifier.onUploadFinalized();
      state = c.read(aportacionSessionProvider);
      expect(state.currentStep, AportacionStep.uploadComplete);
      expect(state.completed, isTrue);
    });

    test('back walks the wizard backwards', () async {
      final c = _container(
        repo: _FakeRepo(
          expedienteResults: <CaseworkItem>[_item('EXP/2025/00123')],
        ),
      );
      final notifier = c.read(aportacionSessionProvider.notifier);

      notifier.confirmIntro();
      notifier.setIdentification(
        const InterestedPartyIdentification(
          idType: InterestedPartyIdType.nif,
          idNumber: '12345678Z',
        ),
      );
      await notifier.resolveQuery(
        const AportacionSearchQuery.byExpediente('EXP/2025/00123'),
      );
      expect(c.read(aportacionSessionProvider).currentStep,
          AportacionStep.detail);

      notifier.back();
      var state = c.read(aportacionSessionProvider);
      expect(state.currentStep, AportacionStep.searchExpediente);
      expect(state.expedienteRef, isNull);

      notifier.back();
      state = c.read(aportacionSessionProvider);
      expect(state.currentStep, AportacionStep.identificacion);

      notifier.back();
      state = c.read(aportacionSessionProvider);
      expect(state.currentStep, AportacionStep.intro);

      // Intro is the floor.
      notifier.back();
      expect(c.read(aportacionSessionProvider).currentStep,
          AportacionStep.intro);
    });

    test('invalid identification raises invalidIdentification failure', () {
      final c = _container();
      final notifier = c.read(aportacionSessionProvider.notifier);
      notifier.confirmIntro();
      notifier.setIdentification(
        const InterestedPartyIdentification(
          idType: InterestedPartyIdType.nif,
          idNumber: 'not-a-nif',
        ),
      );
      final state = c.read(aportacionSessionProvider);
      expect(state.currentStep, AportacionStep.identificacion);
      expect(state.failure, AportacionFailure.invalidIdentification);
    });

    test('empty results raise notFound failure and stay on search step',
        () async {
      final c = _container(
        repo: _FakeRepo(expedienteResults: const <CaseworkItem>[]),
      );
      final notifier = c.read(aportacionSessionProvider.notifier);
      notifier.confirmIntro();
      notifier.setIdentification(
        const InterestedPartyIdentification(
          idType: InterestedPartyIdType.nif,
          idNumber: '12345678Z',
        ),
      );
      await notifier.resolveQuery(
        const AportacionSearchQuery.byExpediente('EXP/2025/99999'),
      );
      final state = c.read(aportacionSessionProvider);
      expect(state.currentStep, AportacionStep.searchExpediente);
      expect(state.failure, AportacionFailure.notFound);
      expect(state.isResolving, isFalse);
    });

    test('repository error raises networkError failure', () async {
      final c = _container(repo: _FakeRepo(registroError: true));
      final notifier = c.read(aportacionSessionProvider.notifier);
      notifier.confirmIntro();
      notifier.setIdentification(
        const InterestedPartyIdentification(
          idType: InterestedPartyIdType.nif,
          idNumber: '12345678Z',
        ),
      );
      await notifier.resolveQuery(
        const AportacionSearchQuery.byRegistro('REG/E/00001'),
      );
      final state = c.read(aportacionSessionProvider);
      expect(state.currentStep, AportacionStep.searchExpediente);
      expect(state.failure, AportacionFailure.networkError);
    });

    test('start resets the wizard', () async {
      final c = _container(
        repo: _FakeRepo(
          expedienteResults: <CaseworkItem>[_item('EXP/2025/00123')],
        ),
      );
      final notifier = c.read(aportacionSessionProvider.notifier);
      notifier.confirmIntro();
      notifier.start();
      final state = c.read(aportacionSessionProvider);
      expect(state.currentStep, AportacionStep.intro);
      expect(state.identificacion, isNull);
    });
  });
}
