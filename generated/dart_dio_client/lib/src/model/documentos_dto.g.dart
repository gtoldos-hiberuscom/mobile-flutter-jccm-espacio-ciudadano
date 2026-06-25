// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'documentos_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DocumentosDto extends DocumentosDto {
  @override
  final DocumentoDto? documento;
  @override
  final String? identificadorReferencia;
  @override
  final int? orden;

  factory _$DocumentosDto([void Function(DocumentosDtoBuilder)? updates]) =>
      (DocumentosDtoBuilder()..update(updates))._build();

  _$DocumentosDto._({this.documento, this.identificadorReferencia, this.orden})
      : super._();
  @override
  DocumentosDto rebuild(void Function(DocumentosDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DocumentosDtoBuilder toBuilder() => DocumentosDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DocumentosDto &&
        documento == other.documento &&
        identificadorReferencia == other.identificadorReferencia &&
        orden == other.orden;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, documento.hashCode);
    _$hash = $jc(_$hash, identificadorReferencia.hashCode);
    _$hash = $jc(_$hash, orden.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DocumentosDto')
          ..add('documento', documento)
          ..add('identificadorReferencia', identificadorReferencia)
          ..add('orden', orden))
        .toString();
  }
}

class DocumentosDtoBuilder
    implements Builder<DocumentosDto, DocumentosDtoBuilder> {
  _$DocumentosDto? _$v;

  DocumentoDtoBuilder? _documento;
  DocumentoDtoBuilder get documento =>
      _$this._documento ??= DocumentoDtoBuilder();
  set documento(DocumentoDtoBuilder? documento) =>
      _$this._documento = documento;

  String? _identificadorReferencia;
  String? get identificadorReferencia => _$this._identificadorReferencia;
  set identificadorReferencia(String? identificadorReferencia) =>
      _$this._identificadorReferencia = identificadorReferencia;

  int? _orden;
  int? get orden => _$this._orden;
  set orden(int? orden) => _$this._orden = orden;

  DocumentosDtoBuilder() {
    DocumentosDto._defaults(this);
  }

  DocumentosDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _documento = $v.documento?.toBuilder();
      _identificadorReferencia = $v.identificadorReferencia;
      _orden = $v.orden;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DocumentosDto other) {
    _$v = other as _$DocumentosDto;
  }

  @override
  void update(void Function(DocumentosDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DocumentosDto build() => _build();

  _$DocumentosDto _build() {
    _$DocumentosDto _$result;
    try {
      _$result = _$v ??
          _$DocumentosDto._(
            documento: _documento?.build(),
            identificadorReferencia: identificadorReferencia,
            orden: orden,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'documento';
        _documento?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'DocumentosDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
