import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Emite cada vez que la app vuelve a primer plano **tras haber estado en
/// segundo plano** (pantalla bloqueada o salir de la app).
///
/// Solo cuenta haber pasado por `paused`: bajar el centro de control deja la
/// app `inactive` sin suspenderla, y eso no corta ninguna conexión.
///
/// Nació en gestión (reanudar subidas) y se subió a core cuando el aviso de
/// actualización necesitó la misma señal.
final appResumedFromBackgroundProvider = Provider<Stream<void>>((final ref) {
  final controller = StreamController<void>.broadcast();
  var suspendida = false;
  final listener = AppLifecycleListener(
    onPause: () => suspendida = true,
    onResume: () {
      if (suspendida) {
        suspendida = false;
        controller.add(null);
      }
    },
  );
  ref.onDispose(() {
    listener.dispose();
    unawaited(controller.close());
  });
  return controller.stream;
});
