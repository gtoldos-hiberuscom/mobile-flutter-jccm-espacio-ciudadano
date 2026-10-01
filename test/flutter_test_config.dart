import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// Los tests de accesibilidad simulan la navegación con teclado físico
/// pidiendo el foco por programa. `AppFocusRing` sólo se pinta en el modo de
/// resaltado de teclado, así que se fija ese modo antes de cada test (el
/// binding de pruebas restablece el gestor de foco entre tests).
///
/// Los tests de Dart puro no inicializan ningún binding: para ellos no se
/// hace nada, y así no se les impone el binding de widgets.
Future<void> testExecutable(final FutureOr<void> Function() testMain) async {
  setUp(() {
    if (BindingBase.debugBindingType() == null) {
      return;
    }
    FocusManager.instance.highlightStrategy = FocusHighlightStrategy.alwaysTraditional;
  });
  await testMain();
}
