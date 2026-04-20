// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'carnet_joven.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CarnetJoven extends CarnetJoven {
  @override
  final String? fechaFinValidez;
  @override
  final String? fechaNacimiento;
  @override
  final String? numero;
  @override
  final String? titular;
  @override
  final String? enTramitacion;

  factory _$CarnetJoven([void Function(CarnetJovenBuilder)? updates]) =>
      (CarnetJovenBuilder()..update(updates))._build();

  _$CarnetJoven._(
      {this.fechaFinValidez,
      this.fechaNacimiento,
      this.numero,
      this.titular,
      this.enTramitacion})
      : super._();
  @override
  CarnetJoven rebuild(void Function(CarnetJovenBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CarnetJovenBuilder toBuilder() => CarnetJovenBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CarnetJoven &&
        fechaFinValidez == other.fechaFinValidez &&
        fechaNacimiento == other.fechaNacimiento &&
        numero == other.numero &&
        titular == other.titular &&
        enTramitacion == other.enTramitacion;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, fechaFinValidez.hashCode);
    _$hash = $jc(_$hash, fechaNacimiento.hashCode);
    _$hash = $jc(_$hash, numero.hashCode);
    _$hash = $jc(_$hash, titular.hashCode);
    _$hash = $jc(_$hash, enTramitacion.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CarnetJoven')
          ..add('fechaFinValidez', fechaFinValidez)
          ..add('fechaNacimiento', fechaNacimiento)
          ..add('numero', numero)
          ..add('titular', titular)
          ..add('enTramitacion', enTramitacion))
        .toString();
  }
}

class CarnetJovenBuilder implements Builder<CarnetJoven, CarnetJovenBuilder> {
  _$CarnetJoven? _$v;

  String? _fechaFinValidez;
  String? get fechaFinValidez => _$this._fechaFinValidez;
  set fechaFinValidez(String? fechaFinValidez) =>
      _$this._fechaFinValidez = fechaFinValidez;

  String? _fechaNacimiento;
  String? get fechaNacimiento => _$this._fechaNacimiento;
  set fechaNacimiento(String? fechaNacimiento) =>
      _$this._fechaNacimiento = fechaNacimiento;

  String? _numero;
  String? get numero => _$this._numero;
  set numero(String? numero) => _$this._numero = numero;

  String? _titular;
  String? get titular => _$this._titular;
  set titular(String? titular) => _$this._titular = titular;

  String? _enTramitacion;
  String? get enTramitacion => _$this._enTramitacion;
  set enTramitacion(String? enTramitacion) =>
      _$this._enTramitacion = enTramitacion;

  CarnetJovenBuilder() {
    CarnetJoven._defaults(this);
  }

  CarnetJovenBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _fechaFinValidez = $v.fechaFinValidez;
      _fechaNacimiento = $v.fechaNacimiento;
      _numero = $v.numero;
      _titular = $v.titular;
      _enTramitacion = $v.enTramitacion;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CarnetJoven other) {
    _$v = other as _$CarnetJoven;
  }

  @override
  void update(void Function(CarnetJovenBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CarnetJoven build() => _build();

  _$CarnetJoven _build() {
    final _$result = _$v ??
        _$CarnetJoven._(
          fechaFinValidez: fechaFinValidez,
          fechaNacimiento: fechaNacimiento,
          numero: numero,
          titular: titular,
          enTramitacion: enTramitacion,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
