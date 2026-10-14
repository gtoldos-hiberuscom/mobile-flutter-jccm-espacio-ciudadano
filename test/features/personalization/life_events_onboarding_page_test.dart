import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/core/storage/app_storage.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/citizen_endpoint_ids_provider.dart';
import 'package:jccm_espacio_ciudadano/features/personalization/0_entity/life_event.dart';
import 'package:jccm_espacio_ciudadano/features/personalization/1_domain/repositories/life_events_repository.dart';
import 'package:jccm_espacio_ciudadano/features/personalization/2_presentation/life_events_page.dart';
import 'package:jccm_espacio_ciudadano/features/personalization/2_presentation/providers/life_events_repository_provider.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

void main() {
  testWidgets('el primer acceso reproduce el contenido y estados del diseño de Figma', (final tester) async {
    tester.view.physicalSize = const Size(390, 1100);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          lifeEventsRepositoryProvider.overrideWithValue(_LifeEventsRepository()),
          citizenEndpointIdsProvider.overrideWithValue((numDocumento: '12345678A', idAgente: 'agente-1')),
          appStorageProvider.overrideWithValue(_MemoryStorage()),
        ],
        child: const MaterialApp(
          locale: Locale('es'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: LifeEventsPage(isOnboarding: true),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Mis hechos vitales'), findsOneWidget);
    expect(find.text('Recomendaciones personalizadas'), findsOneWidget);
    expect(
      find.text('Selecciona las situaciones, intereses o necesidades que más se ajustan a ti para recibir recomendaciones personalizadas.'),
      findsOneWidget,
    );
    expect(find.byType(SvgPicture), findsNWidgets(3));

    final clearButton = tester.widget<AppButton>(find.widgetWithText(AppButton, 'Desmarcar todo'));
    final acceptButton = tester.widget<AppButton>(find.widgetWithText(AppButton, 'Aceptar'));
    expect(clearButton.onPressed, isNull);
    expect(acceptButton.onPressed, isNull);

    await tester.tap(find.text('He tenido un hijo/a'));
    await tester.pumpAndSettle();

    expect(tester.widget<AppButton>(find.widgetWithText(AppButton, 'Desmarcar todo')).onPressed, isNotNull);
    expect(tester.widget<AppButton>(find.widgetWithText(AppButton, 'Aceptar')).onPressed, isNotNull);
  });
}

final class _LifeEventsRepository implements LifeEventsRepository {
  @override
  Future<List<LifeEvent>> loadLifeEvents({required final String idAgente}) async => const [
    LifeEvent(id: 1, label: 'He tenido un hijo/a', selected: true),
    LifeEvent(id: 2, label: 'Tengo un familiar dependiente', selected: false),
    LifeEvent(id: 3, label: 'Me gustaría independizarme', selected: false),
  ];

  @override
  Future<void> resetPreferences({required final String idAgente}) async {}

  @override
  Future<void> saveLifeEvents({required final String idAgente, required final List<LifeEvent> events}) async {}
}

final class _MemoryStorage implements AppStorage {
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
