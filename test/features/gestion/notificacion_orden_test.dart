import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/notificacion.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/notificacion_estado.dart';

void main() {
  group('compareNotificacionesForInbox', () {
    test('las pendientes van primero, por vencimiento más cercano', () {
      final notifications = [
        _notification(id: 1, estado: NotificacionEstado.aceptada, caducidad: '2026-09-30T23:59:59Z'),
        _notification(id: 2, estado: NotificacionEstado.pendiente, caducidad: '2026-09-21T23:59:59Z'),
        _notification(id: 3, estado: NotificacionEstado.expirada, caducidad: '2026-07-03T23:59:59Z'),
        _notification(id: 4, estado: NotificacionEstado.pendiente, caducidad: '2026-09-04T23:59:59Z'),
        _notification(id: 5, estado: NotificacionEstado.aceptada, caducidad: '2026-08-28T23:59:59Z'),
      ]..sort(compareNotificacionesForInbox);

      // Arriba lo que hay que atender y cuánto queda; debajo el histórico con lo
      // más reciente primero. Una aceptada puede caducar más tarde que una
      // pendiente (se aceptó a tiempo) y aun así va debajo.
      expect(notifications.map((final notification) => notification.id), [4, 2, 1, 5, 3]);
    });

    test('sin fecha de caducidad, al final de su grupo', () {
      final notifications = [
        _notification(id: 10, estado: NotificacionEstado.pendiente),
        _notification(id: 11, estado: NotificacionEstado.pendiente, caducidad: '2026-09-21T23:59:59Z'),
        _notification(id: 12, estado: NotificacionEstado.expirada),
        _notification(id: 13, estado: NotificacionEstado.aceptada, caducidad: '2026-08-28T23:59:59Z'),
      ]..sort(compareNotificacionesForInbox);

      expect(notifications.map((final notification) => notification.id), [11, 10, 13, 12]);
    });

    test('el estado desconocido cuenta como no pendiente', () {
      final notifications = [
        _notification(id: 20, caducidad: '2026-09-30T23:59:59Z'),
        _notification(id: 21, estado: NotificacionEstado.pendiente, caducidad: '2026-12-31T23:59:59Z'),
      ]..sort(compareNotificacionesForInbox);

      expect(notifications.map((final notification) => notification.id), [21, 20]);
    });

    test('empate de fecha y de grupo: id descendente, orden total y estable', () {
      final notifications = [
        _notification(id: 30, estado: NotificacionEstado.pendiente, caducidad: '2026-09-21T23:59:59Z'),
        _notification(id: 32, estado: NotificacionEstado.pendiente, caducidad: '2026-09-21T23:59:59Z'),
        _notification(id: 31, estado: NotificacionEstado.pendiente, caducidad: '2026-09-21T23:59:59Z'),
      ]..sort(compareNotificacionesForInbox);

      expect(notifications.map((final notification) => notification.id), [32, 31, 30]);
    });

    test('compara instantes, no husos horarios', () {
      final utc = _notification(id: 40, estado: NotificacionEstado.pendiente, caducidad: '2026-09-21T10:00:00Z');
      final local = Notificacion(
        id: 41,
        concepto: 'Notificación 41',
        procedimientoDenominacion: 'Proc',
        estado: NotificacionEstado.pendiente,
        fechaCaducidad: DateTime.parse('2026-09-21T10:00:00Z').toLocal().add(const Duration(hours: 1)),
      );
      final notifications = [local, utc]..sort(compareNotificacionesForInbox);

      expect(notifications.map((final notification) => notification.id), [40, 41]);
    });
  });
}

Notificacion _notification({
  required final int id,
  final NotificacionEstado? estado,
  final String? caducidad,
}) => Notificacion(
  id: id,
  concepto: 'Notificación $id',
  procedimientoDenominacion: 'Proc',
  estado: estado,
  fechaCaducidad: caducidad == null ? null : DateTime.parse(caducidad),
);
