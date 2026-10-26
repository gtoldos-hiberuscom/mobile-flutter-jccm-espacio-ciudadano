import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/core/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/citizen_endpoint_ids_provider.dart';
import 'package:jccm_espacio_ciudadano/features/consent/0_entity/clause.dart';
import 'package:jccm_espacio_ciudadano/features/consent/1_domain/consent_status_unknown_exception.dart';
import 'package:jccm_espacio_ciudadano/features/consent/1_domain/repositories/consent_repository.dart';
import 'package:jccm_espacio_ciudadano/features/consent/1_domain/usecases/load_clauses_usecase.dart';
import 'package:jccm_espacio_ciudadano/features/consent/2_presentation/controllers/consent_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/consent/2_presentation/providers/consent_usecase_providers.dart';
import 'package:jccm_espacio_ciudadano/features/legal/2_presentation/privacy_page.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

void main() {
  late _FakeConsentRepository repository;
  late ProviderContainer container;
  late GoRouter router;

  setUp(() => repository = _FakeConsentRepository());

  Future<void> pumpPrivacyPage(final WidgetTester tester) async {
    router = GoRouter(
      routes: [
        GoRoute(path: '/', builder: (final _, final _) => const PrivacyPage()),
        GoRoute(path: Routes.consent, builder: (final _, final _) => const Text('step2')),
      ],
    );
    addTearDown(router.dispose);
    await tester.binding.setSurfaceSize(const Size(360, 640));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          citizenEndpointIdsProvider.overrideWithValue((numDocumento: 'PER1', idAgente: 'PER1')),
          loadClausesUsecaseProvider.overrideWithValue(LoadClausesUsecase(repository)),
        ],
        child: Consumer(
          builder: (final context, final ref, final _) {
            container = ProviderScope.containerOf(context);
            return MaterialApp.router(
              locale: const Locale('es'),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              routerConfig: router,
            );
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> scrollToBottom(final WidgetTester tester) async {
    await tester.fling(find.byType(SingleChildScrollView), const Offset(0, -100000), 10000);
    await tester.pumpAndSettle();
  }

  bool isContinueEnabled(final WidgetTester tester) {
    final bar = tester.widget<AppStickyBar>(find.byType(AppStickyBar));
    return bar.onPrimary != null;
  }

  testWidgets('scrolling to the bottom unlocks Continuar', (final tester) async {
    await pumpPrivacyPage(tester);
    expect(isContinueEnabled(tester), isFalse);

    await scrollToBottom(tester);

    expect(container.read(consentProvider('PER1')).status, ConsentStatus.step1Unlocked);
    expect(isContinueEnabled(tester), isTrue);
  });

  testWidgets('muestra el contenido de protección de datos definido en Figma', (final tester) async {
    await pumpPrivacyPage(tester);

    expect(
      find.text('Información de protección de datos sobre el tratamiento de datos personales en Espacio Ciudadano', findRichText: true),
      findsNothing,
    );
    expect(find.text('¿Quién es el responsable del tratamiento?', findRichText: true), findsOneWidget);
    expect(
      find.text(
        '1. La Agencia de Transformación Digital es responsable del tratamiento de datos de los servicios que se prestan directamente desde Espacio Ciudadano y que son los siguientes:',
        findRichText: true,
      ),
      findsOneWidget,
    );
    expect(find.text('Visualización de las notificaciones y registro', findRichText: true), findsOneWidget);
    expect(find.text('¿Cuál es la denominación y finalidad del tratamiento?', findRichText: true), findsOneWidget);
    expect(find.text('Información de contacto de la Delegada de Protección de Datos', findRichText: true), findsOneWidget);

    final firstHeading = tester.widget<RichText>(
      find.text('¿Quién es el responsable del tratamiento?', findRichText: true),
    );
    final body = tester.widget<RichText>(
      find.text(
        '1. La Agencia de Transformación Digital es responsable del tratamiento de datos de los servicios que se prestan directamente desde Espacio Ciudadano y que son los siguientes:',
        findRichText: true,
      ),
    );
    final finalHeading = tester.widget<RichText>(
      find.text('Información de contacto de la Delegada de Protección de Datos', findRichText: true),
    );
    expect(firstHeading.text.style?.color, AppColors.primary);
    expect(body.text.style?.color, AppColors.primaryDark);
    expect(finalHeading.text.style?.color, AppColors.textBase);
  });

  testWidgets('a failed clause load still unlocks Continuar at the bottom, and tapping it retries', (final tester) async {
    repository.fetchError = const ConsentStatusUnknownException(statusCode: 429, message: 'Clausulas endpoint unavailable');
    await pumpPrivacyPage(tester);
    expect(container.read(consentProvider('PER1')).status, ConsentStatus.loadError);
    expect(find.text('No se han podido cargar las autorizaciones. Comprueba tu conexión e inténtalo de nuevo.'), findsOneWidget);

    await scrollToBottom(tester);
    expect(isContinueEnabled(tester), isTrue);

    repository.fetchError = null;
    tester.widget<AppStickyBar>(find.byType(AppStickyBar)).onPrimary!();
    await tester.pumpAndSettle();

    expect(repository.fetchCalls, 2);
    expect(container.read(consentProvider('PER1')).status, ConsentStatus.step2);
    expect(find.text('step2'), findsOneWidget);
  });
}

final class _FakeConsentRepository implements ConsentRepository {
  Exception? fetchError;
  int fetchCalls = 0;

  @override
  Future<List<Clause>> fetchClauses({final String? idAgente}) async {
    fetchCalls++;
    final pendingError = fetchError;
    if (pendingError != null) {
      throw pendingError;
    }
    return const [Clause(id: requiredConsentClauseId, label: 'Protección de datos', isSelected: false)];
  }

  @override
  dynamic noSuchMethod(final Invocation invocation) => throw UnimplementedError();
}
