import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/errors/app_error.dart';
import 'package:jccm_espacio_ciudadano/core/network/result.dart';
import 'package:jccm_espacio_ciudadano/features/help/0_entity/support_form_state.dart';
import 'package:jccm_espacio_ciudadano/features/help/0_entity/support_request.dart';
import 'package:jccm_espacio_ciudadano/features/help/1_domain/support_form_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/help/1_domain/support_repository.dart';
import 'package:jccm_espacio_ciudadano/features/help/3_data/support_repository_provider.dart';

class _StubRepo implements SupportRepository {
  _StubRepo({required this.result});
  final Result<void> result;
  int calls = 0;
  SupportRequest? lastRequest;

  @override
  Future<Result<void>> submit(final SupportRequest request) async {
    calls++;
    lastRequest = request;
    return result;
  }
}

ProviderContainer _container({required final SupportRepository repo}) {
  final c = ProviderContainer(
    overrides: [
      supportRepositoryProvider.overrideWithValue(repo),
    ],
  );
  return c;
}

void main() {
  group('SupportFormNotifier.submit', () {
    test('blocks submit when validation fails', () async {
      final repo = _StubRepo(result: const Success<void>(null));
      final c = _container(repo: repo);
      addTearDown(c.dispose);

      await c.read(supportFormProvider.notifier).submit();
      final state = c.read(supportFormProvider);

      expect(repo.calls, 0);
      expect(state.errors, isNotEmpty);
      expect(state.status, SupportSubmissionStatus.validating);
    });

    test('on valid input transitions to success and calls repository', () async {
      final repo = _StubRepo(result: const Success<void>(null));
      final c = _container(repo: repo);
      addTearDown(c.dispose);

      final n = c.read(supportFormProvider.notifier)
        ..updateName('Ana')
        ..updateEmail('ana@example.com')
        ..updateEmailConfirm('ana@example.com')
        ..updateSubject('Incidencia')
        ..updateDescription('No puedo iniciar sesión.')
        ..updateConsent(true)
        ..updateCaptcha(true);

      await n.submit();

      expect(repo.calls, 1);
      expect(repo.lastRequest?.email, 'ana@example.com');
      expect(c.read(supportFormProvider).status, SupportSubmissionStatus.success);
    });

    test('on repository failure transitions to error with submission key', () async {
      final repo = _StubRepo(
        result: const Failure<void>(
          NetworkError(message: 'down', statusCode: 503),
        ),
      );
      final c = _container(repo: repo);
      addTearDown(c.dispose);

      final n = c.read(supportFormProvider.notifier)
        ..updateName('Ana')
        ..updateEmail('ana@example.com')
        ..updateEmailConfirm('ana@example.com')
        ..updateSubject('Incidencia')
        ..updateDescription('Texto')
        ..updateConsent(true)
        ..updateCaptcha(true);

      await n.submit();
      final state = c.read(supportFormProvider);
      expect(state.status, SupportSubmissionStatus.error);
      expect(state.submissionErrorKey, 'supportSubmissionGenericError');
    });

    test('reset returns the form to its initial state', () async {
      final repo = _StubRepo(result: const Success<void>(null));
      final c = _container(repo: repo);
      addTearDown(c.dispose);

      c.read(supportFormProvider.notifier)
        ..updateName('Ana')
        ..updateEmail('ana@example.com')
        ..reset();

      final state = c.read(supportFormProvider);
      expect(state.request.name, '');
      expect(state.request.email, '');
      expect(state.status, SupportSubmissionStatus.idle);
      expect(state.errors, isEmpty);
    });
  });
}
