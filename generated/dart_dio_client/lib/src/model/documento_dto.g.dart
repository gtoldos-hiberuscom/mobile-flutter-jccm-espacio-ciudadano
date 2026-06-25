// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'documento_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DocumentoDto extends DocumentoDto {
  @override
  final String? aplicacion;
  @override
  final int? id;
  @override
  final String? identificador;
  @override
  final BuiltList<InformacionAdicionalDto>? informacionAdicional;
  @override
  final String? tipoEntidad;

  factory _$DocumentoDto([void Function(DocumentoDtoBuilder)? updates]) =>
      (DocumentoDtoBuilder()..update(updates))._build();

  _$DocumentoDto._(
      {this.aplicacion,
      this.id,
      this.identificador,
      this.informacionAdicional,
      this.tipoEntidad})
      : super._();
  @override
  DocumentoDto rebuild(void Function(DocumentoDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DocumentoDtoBuilder toBuilder() => DocumentoDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DocumentoDto &&
        aplicacion == other.aplicacion &&
        id == other.id &&
        identificador == other.identificador &&
        informacionAdicional == other.informacionAdicional &&
        tipoEntidad == other.tipoEntidad;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, aplicacion.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, identificador.hashCode);
    _$hash = $jc(_$hash, informacionAdicional.hashCode);
    _$hash = $jc(_$hash, tipoEntidad.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DocumentoDto')
          ..add('aplicacion', aplicacion)
          ..add('id', id)
          ..add('identificador', identificador)
          ..add('informacionAdicional', informacionAdicional)
          ..add('tipoEntidad', tipoEntidad))
        .toString();
  }
}

class DocumentoDtoBuilder
    implements Builder<DocumentoDto, DocumentoDtoBuilder> {
  _$DocumentoDto? _$v;

  String? _aplicacion;
  String? get aplicacion => _$this._aplicacion;
  set aplicacion(String? aplicacion) => _$this._aplicacion = aplicacion;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _identificador;
  String? get identificador => _$this._identificador;
  set identificador(String? identificador) =>
      _$this._identificador = identificador;

  ListBuilder<InformacionAdicionalDto>? _informacionAdicional;
  ListBuilder<InformacionAdicionalDto> get informacionAdicional =>
      _$this._informacionAdicional ??= ListBuilder<InformacionAdicionalDto>();
  set informacionAdicional(
          ListBuilder<InformacionAdicionalDto>? informacionAdicional) =>
      _$this._informacionAdicional = informacionAdicional;

  String? _tipoEntidad;
  String? get tipoEntidad => _$this._tipoEntidad;
  set tipoEntidad(String? tipoEntidad) => _$this._tipoEntidad = tipoEntidad;

  DocumentoDtoBuilder() {
    DocumentoDto._defaults(this);
  }

  DocumentoDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _aplicacion = $v.aplicacion;
      _id = $v.id;
      _identificador = $v.identificador;
      _informacionAdicional = $v.informacionAdicional?.toBuilder();
      _tipoEntidad = $v.tipoEntidad;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DocumentoDto other) {
    _$v = other as _$DocumentoDto;
  }

  @override
  void update(void Function(DocumentoDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DocumentoDto build() => _build();

  _$DocumentoDto _build() {
    _$DocumentoDto _$result;
    try {
      _$result = _$v ??
          _$DocumentoDto._(
            aplicacion: aplicacion,
            id: id,
            identificador: identificador,
            informacionAdicional: _informacionAdicional?.build(),
            tipoEntidad: tipoEntidad,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'informacionAdicional';
        _informacionAdicional?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'DocumentoDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
