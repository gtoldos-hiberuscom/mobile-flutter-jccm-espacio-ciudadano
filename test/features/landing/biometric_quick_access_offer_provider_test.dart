import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/storage/app_storage.dart';
import 'package:jccm_espacio_ciudadano/core/storage/storage_keys.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/token_response_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/landing/2_presentation/providers/biometric_quick_access_offer_provider.dart';

void main() {
  const idAgente = '12345678Z';
  late _FakeAppStorage storage;
  late ProviderContainer container;

  setUp(() {
    storage = _FakeAppStorage();
    container = ProviderContainer(overrides: [appStorageProvider.overrideWithValue(storage)]);
    addTearDown(container.dispose);
    // Mantiene vivo el provider como lo hace la home al leerlo.
    container.listen(biometricQuickAccessOfferProvider, (_, _) {});
  });

  BiometricQuickAccessOfferNotifier offer() => container.read(biometricQuickAccessOfferProvider.notifier);

  void startSession() => container.read(tokenResponseProvider.notifier).update(TokenResponse('access', 'refresh', null, 'id', null, null, null));

  void endSession() => container.read(tokenResponseProvider.notifier).update(null);

  test('se ofrece a quien no lo ha activado ni rechazado', () {
    expect(offer().shouldOffer(idAgente), isTrue);
  });

  test('no se ofrece a quien ya lo tiene activado', () async {
    await storage.write('${StorageKeys.biometricQuickAccessEnabledPrefix}$idAgente', true);

    expect(offer().shouldOffer(idAgente), isFalse);
  });

  test('tras rechazarlo no se vuelve a ofrecer, ni en otra sesión', () async {
    startSession();
    offer().markShown();
    await offer().recordDeclined(idAgente);
    endSession();
    startSession();

    expect(offer().shouldOffer(idAgente), isFalse);
  });

  test('el rechazo es por ciudadano: no alcanza al siguiente en el mismo móvil', () async {
    await offer().recordDeclined(idAgente);

    expect(offer().shouldOffer('87654321X'), isTrue);
  });

  test('ya mostrada sin respuesta guardada: no se repite dentro de la sesión', () {
    startSession();
    offer().markShown();

    expect(offer().shouldOffer(idAgente), isFalse);
  });

  test('ya mostrada sin respuesta guardada: cerrar sesión la rearma sin matar la app', () {
    startSession();
    offer().markShown();
    endSession();
    startSession();

    expect(offer().shouldOffer(idAgente), isTrue);
  });

  test('un refresco de token no rearma la oferta', () {
    startSession();
    offer().markShown();
    startSession();

    expect(offer().shouldOffer(idAgente), isFalse);
  });
}

final class _FakeAppStorage implements AppStorage {
  final Map<String, Object> values = {};

  @override
  T? read<T>(final String key) => values[key] as T?;

  @override
  Future<bool> write(final String key, final Object value) async {
    values[key] = value;
    return true;
  }

  @override
  Future<bool> remove(final String key) async {
    values.remove(key);
    return true;
  }

  @override
  Future<bool> clear() async {
    values.clear();
    return true;
  }
}
