// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transicion_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$TransicionDto extends TransicionDto {
  @override
  final String? accion;
  @override
  final String? justificacion;

  factory _$TransicionDto([void Function(TransicionDtoBuilder)? updates]) =>
      (TransicionDtoBuilder()..update(updates))._build();

  _$TransicionDto._({this.accion, this.justificacion}) : super._();
  @override
  TransicionDto rebuild(void Function(TransicionDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TransicionDtoBuilder toBuilder() => TransicionDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TransicionDto &&
        accion == other.accion &&
        justificacion == other.justificacion;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, accion.hashCode);
    _$hash = $jc(_$hash, justificacion.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'TransicionDto')
          ..add('accion', accion)
          ..add('justificacion', justificacion))
        .toString();
  }
}

class TransicionDtoBuilder
    implements Builder<TransicionDto, TransicionDtoBuilder> {
  _$TransicionDto? _$v;

  String? _accion;
  String? get accion => _$this._accion;
  set accion(String? accion) => _$this._accion = accion;

  String? _justificacion;
  String? get justificacion => _$this._justificacion;
  set justificacion(String? justificacion) =>
      _$this._justificacion = justificacion;

  TransicionDtoBuilder() {
    TransicionDto._defaults(this);
  }

  TransicionDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _accion = $v.accion;
      _justificacion = $v.justificacion;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TransicionDto other) {
    _$v = other as _$TransicionDto;
  }

  @override
  void update(void Function(TransicionDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TransicionDto build() => _build();

  _$TransicionDto _build() {
    final _$result = _$v ??
        _$TransicionDto._(
          accion: accion,
          justificacion: justificacion,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
