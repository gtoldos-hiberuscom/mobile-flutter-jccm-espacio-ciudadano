// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unidad_organica_indexa_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UnidadOrganicaIndexaDto extends UnidadOrganicaIndexaDto {
  @override
  final String? nombre;

  factory _$UnidadOrganicaIndexaDto(
          [void Function(UnidadOrganicaIndexaDtoBuilder)? updates]) =>
      (UnidadOrganicaIndexaDtoBuilder()..update(updates))._build();

  _$UnidadOrganicaIndexaDto._({this.nombre}) : super._();
  @override
  UnidadOrganicaIndexaDto rebuild(
          void Function(UnidadOrganicaIndexaDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UnidadOrganicaIndexaDtoBuilder toBuilder() =>
      UnidadOrganicaIndexaDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UnidadOrganicaIndexaDto && nombre == other.nombre;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, nombre.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UnidadOrganicaIndexaDto')
          ..add('nombre', nombre))
        .toString();
  }
}

class UnidadOrganicaIndexaDtoBuilder
    implements
        Builder<UnidadOrganicaIndexaDto, UnidadOrganicaIndexaDtoBuilder> {
  _$UnidadOrganicaIndexaDto? _$v;

  String? _nombre;
  String? get nombre => _$this._nombre;
  set nombre(String? nombre) => _$this._nombre = nombre;

  UnidadOrganicaIndexaDtoBuilder() {
    UnidadOrganicaIndexaDto._defaults(this);
  }

  UnidadOrganicaIndexaDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _nombre = $v.nombre;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UnidadOrganicaIndexaDto other) {
    _$v = other as _$UnidadOrganicaIndexaDto;
  }

  @override
  void update(void Function(UnidadOrganicaIndexaDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UnidadOrganicaIndexaDto build() => _build();

  _$UnidadOrganicaIndexaDto _build() {
    final _$result = _$v ??
        _$UnidadOrganicaIndexaDto._(
          nombre: nombre,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
