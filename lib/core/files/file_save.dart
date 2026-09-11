import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';

/// Guarda [bytes] en el destino que elija la persona, con el selector nativo.
///
/// Se usa `FilePicker.saveFile` y **no** `getSaveLocation` de `file_selector`
/// porque este último no está implementado en Android/iOS: en móvil lanza
/// `UnimplementedError` sin mostrar selector alguno. `FilePicker.saveFile` abre
/// el selector SAF en Android y el export picker de Archivos en iOS, y en
/// ambos casos escribe los bytes por sí mismo; en escritorio (solo entorno de
/// desarrollo) devuelve la ruta sin escribir, así que ahí se escribe a mano.
///
/// Devuelve la ruta del fichero guardado, o `null` si se canceló el selector.
/// Los fallos de escritura se propagan: quien llama decide qué traza emitir y
/// qué mensaje curado mostrar (nunca el detalle interno).
Future<String?> saveBytesWithPicker({
  required final Uint8List bytes,
  required final String fileName,
  final String? dialogTitle,
}) async {
  final extension = _extensionOf(fileName);
  final path = await FilePicker.saveFile(
    dialogTitle: dialogTitle,
    fileName: fileName,
    type: extension == null ? FileType.any : FileType.custom,
    allowedExtensions: extension == null ? null : [extension],
    bytes: bytes,
  );
  if (path == null) {
    return null;
  }
  if (!Platform.isAndroid && !Platform.isIOS) {
    await File(path).writeAsBytes(bytes);
  }
  return path;
}

/// Extensión sin punto, o `null` si el nombre no la trae: `FileType.custom`
/// exige `allowedExtensions` no vacío, así que sin extensión hay que pedir
/// `FileType.any`.
String? _extensionOf(final String fileName) {
  final dot = fileName.lastIndexOf('.');
  if (dot <= 0 || dot == fileName.length - 1) {
    return null;
  }
  return fileName.substring(dot + 1).toLowerCase();
}
