import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/2_presentation/controllers/app_update_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/2_presentation/widgets/app_update_dialog.dart';

/// Capa por encima del router que pinta el aviso de actualización cuando
/// [appUpdateProvider] lo pide.
///
/// Va en `MaterialApp.router(builder:)` y no en `showDialog` a propósito: un
/// diálogo sobre el navigator desaparece cuando el router sustituye la página
/// de debajo (`router.go`, redirects del guard), y una actualización forzada
/// no puede desaparecer. Aquí el estado manda: mientras haya aviso, lo de
/// debajo no recibe toques, foco ni lector de pantalla.
///
/// El botón atrás de Android llega por [WidgetsBindingObserver.didPopRoute]
/// (no hay `ModalRoute` por encima del router para un `PopScope`): se registra
/// en `initState`, antes de que el `Router` hijo registre su despachador, así
/// que se consulta primero.
class AppUpdateGate extends ConsumerStatefulWidget {
  const AppUpdateGate({required this.child, super.key});

  final Widget child;

  /// Scrim compartido con los diálogos del design system.
  static const Color barrierColor = Color(0xCC031B35);

  @override
  ConsumerState<AppUpdateGate> createState() => _AppUpdateGateState();
}

class _AppUpdateGateState extends ConsumerState<AppUpdateGate> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Future<bool> didPopRoute() async {
    final current = ref.read(appUpdateProvider);
    if (current is! AppUpdateVisible) {
      // Sin aviso: que el router haga su pop normal.
      return false;
    }
    if (!current.info.isForced) {
      await ref.read(appUpdateProvider.notifier).dismiss();
    }
    // Consumido: una forzada ignora el botón atrás.
    return true;
  }

  @override
  Widget build(final BuildContext context) {
    final state = ref.watch(appUpdateProvider);
    final blocking = state is AppUpdateVisible;

    // El árbol es siempre el mismo Stack: alternar entre `child` y
    // `Stack(child)` re-inflaría el Router y perdería la pila de navegación.
    return Stack(
      fit: StackFit.expand,
      children: [
        ExcludeFocus(
          excluding: blocking,
          child: ExcludeSemantics(
            excluding: blocking,
            child: widget.child,
          ),
        ),
        if (state is AppUpdateVisible) ...[
          const ModalBarrier(dismissible: false, color: AppUpdateGate.barrierColor),
          SafeArea(
            child: Center(
              child: AppUpdateDialog(
                info: state.info,
                storeOpenFailed: state.storeOpenFailed,
                onUpdate: () => unawaited(ref.read(appUpdateProvider.notifier).openStore()),
                onLater: state.info.isForced ? null : () => unawaited(ref.read(appUpdateProvider.notifier).dismiss()),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
