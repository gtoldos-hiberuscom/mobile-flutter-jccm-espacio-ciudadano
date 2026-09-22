import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/notificacion.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/notificacion_detalle.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/notificacion_estado.dart';

typedef NotificacionArchivoDescargado = ({Uint8List bytes, String? nombreFichero});

/// Máximo de notificaciones que se cargan inicialmente para un estado.
///
/// Alcanzar este valor no implica que el listado esté completo, por lo que la
/// interfaz debe presentarlo como un límite inferior (por ejemplo, `+500`).
const int gestionNotificacionesInitialLoadLimit = 500;

abstract interface class GestionNotificacionesRepository {
  /// Listado de notificaciones. `estado` null = "Todo": como el listado
  /// indexado del backend no informa el estado de cada elemento, "Todo" se
  /// construye consultando todos los estados y fusionando, de modo que cada
  /// elemento llega etiquetado con el suyo.
  ///
  /// [cancelToken] aborta el barrido: "Todo" lanza cuatro en paralelo y cada
  /// uno puede pedir varias páginas, así que salir de la pantalla tiene que
  /// poder cortarlos.
  Future<List<Notificacion>> loadNotificaciones({
    required final String citizenId,
    final NotificacionEstado? estado,
    final CancelToken? cancelToken,
  });

  /// Detalle de una notificación.
  ///
  /// [resumen] es el elemento del listado desde el que se abrió el detalle, o
  /// `null` cuando no se conoce (deep link, restauración de estado). Actúa
  /// **solo como respaldo** de lo que el detalle no informe, y por una razón de
  /// contrato: el swagger no tipa la respuesta de este endpoint
  /// (`Respuesta.body: {type: object}`) y sus dos ejemplos oficiales se
  /// contradicen, mientras que el listado sí está tipado
  /// (`NotificacionIndexaDto`) y trae garantizados procedimiento, fecha de
  /// caducidad, sistema de origen y —por el estado consultado— el estado.
  ///
  /// Respaldar no es inventar: si un dato falta en el detalle y en el resumen,
  /// se queda a `null` y la pantalla no lo pinta. El estado tiene además una
  /// regla propia (ver la implementación): un valor presente pero ilegible
  /// **no** hereda el del resumen.
  Future<NotificacionDetalle> loadNotificacion({
    required final String citizenId,
    required final int notificacionId,
    final Notificacion? resumen,
  });

  Future<void> transitionNotificacion({
    required final String citizenId,
    required final int notificacionId,
    required final String accion,
    final String? sistemaOrigen,
    final String? justificacion,
  });

  /// Bytes de un documento de la notificación, identificado por su [orden].
  ///
  /// `Uint8List` y no `List<int>` porque es lo que entrega el cliente generado
  /// (`ResponseType.bytes`) y lo que pide el guardado nativo: una conversión
  /// intermedia solo duplicaría el fichero en memoria.
  Future<NotificacionArchivoDescargado> downloadDocumento({
    required final String citizenId,
    required final int notificacionId,
    required final int orden,
    final String? sistemaOrigen,
  });

  /// Justificante PDF que acredita la comparecencia en la notificación.
  Future<NotificacionArchivoDescargado> downloadJustificante({
    required final String citizenId,
    required final int notificacionId,
    final String? sistemaOrigen,
  });
}
