// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unidad_organica_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UnidadOrganicaDto extends UnidadOrganicaDto {
  @override
  final BuiltList<InformacionAdicionalDto>? informacionAdicional;
  @override
  final String? sistema;

  factory _$UnidadOrganicaDto(
          [void Function(UnidadOrganicaDtoBuilder)? updates]) =>
      (UnidadOrganicaDtoBuilder()..update(updates))._build();

  _$UnidadOrganicaDto._({this.informacionAdicional, this.sistema}) : super._();
  @override
  UnidadOrganicaDto rebuild(void Function(UnidadOrganicaDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UnidadOrganicaDtoBuilder toBuilder() =>
      UnidadOrganicaDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UnidadOrganicaDto &&
        informacionAdicional == other.informacionAdicional &&
        sistema == other.sistema;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, informacionAdicional.hashCode);
    _$hash = $jc(_$hash, sistema.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UnidadOrganicaDto')
          ..add('informacionAdicional', informacionAdicional)
          ..add('sistema', sistema))
        .toString();
  }
}

class UnidadOrganicaDtoBuilder
    implements Builder<UnidadOrganicaDto, UnidadOrganicaDtoBuilder> {
  _$UnidadOrganicaDto? _$v;

  ListBuilder<InformacionAdicionalDto>? _informacionAdicional;
  ListBuilder<InformacionAdicionalDto> get informacionAdicional =>
      _$this._informacionAdicional ??= ListBuilder<InformacionAdicionalDto>();
  set informacionAdicional(
          ListBuilder<InformacionAdicionalDto>? informacionAdicional) =>
      _$this._informacionAdicional = informacionAdicional;

  String? _sistema;
  String? get sistema => _$this._sistema;
  set sistema(String? sistema) => _$this._sistema = sistema;

  UnidadOrganicaDtoBuilder() {
    UnidadOrganicaDto._defaults(this);
  }

  UnidadOrganicaDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _informacionAdicional = $v.informacionAdicional?.toBuilder();
      _sistema = $v.sistema;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UnidadOrganicaDto other) {
    _$v = other as _$UnidadOrganicaDto;
  }

  @override
  void update(void Function(UnidadOrganicaDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UnidadOrganicaDto build() => _build();

  _$UnidadOrganicaDto _build() {
    _$UnidadOrganicaDto _$result;
    try {
      _$result = _$v ??
          _$UnidadOrganicaDto._(
            informacionAdicional: _informacionAdicional?.build(),
            sistema: sistema,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'informacionAdicional';
        _informacionAdicional?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'UnidadOrganicaDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
