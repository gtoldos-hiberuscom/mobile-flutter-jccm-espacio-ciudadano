// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expediente_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ExpedienteDto extends ExpedienteDto {
  @override
  final String? identificador;

  factory _$ExpedienteDto([void Function(ExpedienteDtoBuilder)? updates]) =>
      (ExpedienteDtoBuilder()..update(updates))._build();

  _$ExpedienteDto._({this.identificador}) : super._();
  @override
  ExpedienteDto rebuild(void Function(ExpedienteDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ExpedienteDtoBuilder toBuilder() => ExpedienteDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ExpedienteDto && identificador == other.identificador;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, identificador.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ExpedienteDto')
          ..add('identificador', identificador))
        .toString();
  }
}

class ExpedienteDtoBuilder
    implements Builder<ExpedienteDto, ExpedienteDtoBuilder> {
  _$ExpedienteDto? _$v;

  String? _identificador;
  String? get identificador => _$this._identificador;
  set identificador(String? identificador) =>
      _$this._identificador = identificador;

  ExpedienteDtoBuilder() {
    ExpedienteDto._defaults(this);
  }

  ExpedienteDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _identificador = $v.identificador;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ExpedienteDto other) {
    _$v = other as _$ExpedienteDto;
  }

  @override
  void update(void Function(ExpedienteDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ExpedienteDto build() => _build();

  _$ExpedienteDto _build() {
    final _$result = _$v ??
        _$ExpedienteDto._(
          identificador: identificador,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
