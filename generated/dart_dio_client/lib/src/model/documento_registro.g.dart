// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'documento_registro.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DocumentoRegistro extends DocumentoRegistro {
  @override
  final String? algoritmo;
  @override
  final String? fileSize;
  @override
  final String? hash;
  @override
  final String? nombre;

  factory _$DocumentoRegistro(
          [void Function(DocumentoRegistroBuilder)? updates]) =>
      (DocumentoRegistroBuilder()..update(updates))._build();

  _$DocumentoRegistro._({this.algoritmo, this.fileSize, this.hash, this.nombre})
      : super._();
  @override
  DocumentoRegistro rebuild(void Function(DocumentoRegistroBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DocumentoRegistroBuilder toBuilder() =>
      DocumentoRegistroBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DocumentoRegistro &&
        algoritmo == other.algoritmo &&
        fileSize == other.fileSize &&
        hash == other.hash &&
        nombre == other.nombre;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, algoritmo.hashCode);
    _$hash = $jc(_$hash, fileSize.hashCode);
    _$hash = $jc(_$hash, hash.hashCode);
    _$hash = $jc(_$hash, nombre.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DocumentoRegistro')
          ..add('algoritmo', algoritmo)
          ..add('fileSize', fileSize)
          ..add('hash', hash)
          ..add('nombre', nombre))
        .toString();
  }
}

class DocumentoRegistroBuilder
    implements Builder<DocumentoRegistro, DocumentoRegistroBuilder> {
  _$DocumentoRegistro? _$v;

  String? _algoritmo;
  String? get algoritmo => _$this._algoritmo;
  set algoritmo(String? algoritmo) => _$this._algoritmo = algoritmo;

  String? _fileSize;
  String? get fileSize => _$this._fileSize;
  set fileSize(String? fileSize) => _$this._fileSize = fileSize;

  String? _hash;
  String? get hash => _$this._hash;
  set hash(String? hash) => _$this._hash = hash;

  String? _nombre;
  String? get nombre => _$this._nombre;
  set nombre(String? nombre) => _$this._nombre = nombre;

  DocumentoRegistroBuilder() {
    DocumentoRegistro._defaults(this);
  }

  DocumentoRegistroBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _algoritmo = $v.algoritmo;
      _fileSize = $v.fileSize;
      _hash = $v.hash;
      _nombre = $v.nombre;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DocumentoRegistro other) {
    _$v = other as _$DocumentoRegistro;
  }

  @override
  void update(void Function(DocumentoRegistroBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DocumentoRegistro build() => _build();

  _$DocumentoRegistro _build() {
    final _$result = _$v ??
        _$DocumentoRegistro._(
          algoritmo: algoritmo,
          fileSize: fileSize,
          hash: hash,
          nombre: nombre,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
