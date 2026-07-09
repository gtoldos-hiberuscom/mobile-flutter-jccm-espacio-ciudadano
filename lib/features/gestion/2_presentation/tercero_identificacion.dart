import 'package:meta/meta.dart';

/// Documento de la persona por la que se actúa al aportar documentación a
/// un expediente ajeno. Viaja como `extra` de `GoRoute` entre
/// `GestionAportacionPage`, `GestionExpedienteDetallePage` y
/// `GestionAportarDocumentacionPage` para sustituir, en ese recorrido, al
/// documento del JWT que usan por defecto los expedientes propios.
@immutable
final class TerceroIdentificacion {
  const TerceroIdentificacion({required this.tipodoc, required this.documentNumber});

  final String tipodoc;
  final String documentNumber;

  @override
  bool operator ==(final Object other) => other is TerceroIdentificacion && other.tipodoc == tipodoc && other.documentNumber == documentNumber;

  @override
  int get hashCode => Object.hash(tipodoc, documentNumber);
}
