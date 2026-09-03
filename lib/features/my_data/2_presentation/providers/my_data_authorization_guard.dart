import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/core/network/authorization_envelope.dart';
import 'package:jccm_espacio_ciudadano/features/consent/1_domain/usecases/resolve_authorization_failure_usecase.dart';
import 'package:jccm_espacio_ciudadano/features/consent/2_presentation/providers/authorization_guard.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/my_data_authorization_required.dart';

/// [withAuthorizationGuard] para Mis Datos.
///
/// Existe por los dos extremos de la traducción:
///
/// - Los repositorios de Mis Datos señalan el rechazo con
///   [MyDataAuthorizationRequired], su propio tipo, y el guard común espera
///   [AuthorizationRequiredException].
/// - Las pantallas ya saben pintar [MyDataAuthorizationRequired] con su acción
///   a Preferencias, así que la cláusula que falte vuelve a salir con ese tipo.
///
/// Lo que aporta frente a dejar pasar el rechazo tal cual: el sobre de la
/// fachada **no distingue** una cláusula retirada de un fallo del servicio de
/// preferencias — el gateway falla cerrado y devuelve lo mismo en los dos
/// casos. Sin resolverlo, un fallo del gateway invitaba a autorizar algo que ya
/// estaba autorizado, y el ciudadano se quedaba dando vueltas entre
/// Preferencias y la pantalla. Ahora:
///
/// - cláusula concreta retirada → [MyDataAuthorizationRequired] (acción a
///   Preferencias, que es donde se concede);
/// - cláusula **obligatoria** retirada → [ConsentRevoked], y el guard cierra la
///   sesión: no hay nada que el ciudadano pueda conceder desde dentro;
/// - no se pudo comprobar → [AuthorizationUnknown], error reintentable sin
///   acusar al ciudadano de no haber autorizado.
Future<T> withMyDataAuthorizationGuard<T>(
  final Ref ref, {
  required final Set<int> requiredClauseIds,
  required final Future<T> Function() request,
}) async {
  try {
    return await withAuthorizationGuard(
      ref,
      requiredClauseIds: requiredClauseIds,
      request: () async {
        try {
          return await request();
        } on MyDataAuthorizationRequired {
          // El sobre ya se reconoció en la capa de datos; aquí solo se cambia
          // de moneda para que el guard común pueda resolverlo.
          throw const AuthorizationRequiredException(statusCode: 403, path: 'mis-datos');
        }
      },
    );
  } on ClauseMissing {
    throw const MyDataAuthorizationRequired();
  }
}
