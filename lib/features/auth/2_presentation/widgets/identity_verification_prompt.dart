import 'dart:async' show unawaited;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/core/storage/app_storage.dart';
import 'package:jccm_espacio_ciudadano/core/storage/storage_keys.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/citizen_endpoint_ids_provider.dart';

/// Pregunta al ciudadano si quiere ir a Cl@ve a elevar su nivel de seguridad.
///
/// Devuelve `true` si hay que lanzar la elevación. Es el aviso compartido por
/// todas las consultas que la exigen (Mis datos → Citas hospitalarias y el
/// aviso de Agenda), con su «No volver a mostrar» guardado **por ciudadano**:
///
/// - quien lo marcó se salta la explicación y va directo a Cl@ve. Omite **la
///   explicación, no el control**: el gate sigue decidiendo;
/// - con [message] —el motivo de un intento anterior— el diálogo sale siempre,
///   aunque se pidiera no volver a verlo: es otro mensaje, y saltárselo
///   relanzaría Cl@ve sin que el ciudadano lo pida;
/// - la preferencia se guarda con cualquiera de los dos botones: es sobre el
///   aviso, no sobre la decisión de ir o no a Cl@ve;
/// - sin elección (el botón atrás del sistema) cuenta como «Volver».
Future<bool> confirmIdentityVerification(
  final BuildContext context,
  final WidgetRef ref, {
  final String? message,
}) async {
  final idAgente = ref.read(citizenEndpointIdsProvider).idAgente;
  final suppressionKey = idAgente == null || idAgente.isEmpty ? null : '${StorageKeys.identityVerificationNoticeSuppressedPrefix}$idAgente';
  if (message == null && suppressionKey != null && (ref.read(appStorageProvider).read<bool>(suppressionKey) ?? false)) {
    return true;
  }

  final choice = await AppIdentityVerificationDialog.show(context, message: message);
  if (choice == null) {
    return false;
  }
  if (choice.suppressFuture && suppressionKey != null) {
    unawaited(ref.read(appStorageProvider).write(suppressionKey, true));
  }
  return choice.accepted;
}
