import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/core/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/widgets/my_data_authorization_contextual_helper.dart';

/// Estado de página para un `MyDataAuthorizationRequired`: el backend rechazó
/// la consulta por falta de cláusula (una respuesta de negocio, no un fallo).
/// Ofrece abrir el editor de autorizaciones con retorno a [returnTo].
///
/// Solo debe usarse ante la excepción tipada — un fallo de transporte se
/// muestra como estado de error reintentable, nunca como esta invitación.
class MyDataAuthorizationRequiredState extends StatelessWidget {
  const MyDataAuthorizationRequiredState({
    required this.returnTo,
    this.onAuthorized,
    this.message,
    this.scrollable = true,
    super.key,
  });

  final String returnTo;

  /// Se invoca al volver del editor de autorizaciones — normalmente para
  /// recargar el provider que falló.
  ///
  /// Sin esto la pantalla seguía diciendo "necesitas autorizar" después de
  /// haber concedido la autorización, así que el CTA era un callejón sin
  /// salida. Es el mismo patrón que ya usan los carnets.
  final VoidCallback? onAuthorized;

  final String? message;

  /// `true` cuando es el cuerpo completo de la página (lleva el margen de
  /// página y su propio scroll); `false` cuando va anidado en una página ya
  /// acolchada, donde conserva su inset propio de 16 dp.
  final bool scrollable;

  @override
  Widget build(final BuildContext context) {
    final content = Padding(
      padding: scrollable ? appPagePadding(context, top: AppDimensions.space16, bottom: AppDimensions.space16) : const EdgeInsets.all(AppDimensions.space16),
      child: MyDataAuthorizationContextualHelper(
        message: message,
        onOpenSettings: () async {
          await context.push(
            Uri(
              path: Routes.consent,
              queryParameters: {
                'mode': 'preferences',
                'returnTo': returnTo,
              },
            ).toString(),
          );
          // El `ref` que captura el callback no sobrevive al desmontaje: si el
          // ciudadano se va a otra parte en vez de volver, invalidar lanzaría.
          if (context.mounted) {
            onAuthorized?.call();
          }
        },
      ),
    );
    return scrollable ? SingleChildScrollView(child: content) : content;
  }
}
