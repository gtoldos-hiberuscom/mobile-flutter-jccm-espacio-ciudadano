// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'beneficiarios.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$BENEFICIARIOS extends BENEFICIARIOS {
  @override
  final String? apellido1;
  @override
  final String? apellido2;
  @override
  final String? fecnac;
  @override
  final String? nombre;
  @override
  final String? numdoc;
  @override
  final String? tipdoc;
  @override
  final String? titular;

  factory _$BENEFICIARIOS([void Function(BENEFICIARIOSBuilder)? updates]) =>
      (BENEFICIARIOSBuilder()..update(updates))._build();

  _$BENEFICIARIOS._(
      {this.apellido1,
      this.apellido2,
      this.fecnac,
      this.nombre,
      this.numdoc,
      this.tipdoc,
      this.titular})
      : super._();
  @override
  BENEFICIARIOS rebuild(void Function(BENEFICIARIOSBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BENEFICIARIOSBuilder toBuilder() => BENEFICIARIOSBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BENEFICIARIOS &&
        apellido1 == other.apellido1 &&
        apellido2 == other.apellido2 &&
        fecnac == other.fecnac &&
        nombre == other.nombre &&
        numdoc == other.numdoc &&
        tipdoc == other.tipdoc &&
        titular == other.titular;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, apellido1.hashCode);
    _$hash = $jc(_$hash, apellido2.hashCode);
    _$hash = $jc(_$hash, fecnac.hashCode);
    _$hash = $jc(_$hash, nombre.hashCode);
    _$hash = $jc(_$hash, numdoc.hashCode);
    _$hash = $jc(_$hash, tipdoc.hashCode);
    _$hash = $jc(_$hash, titular.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'BENEFICIARIOS')
          ..add('apellido1', apellido1)
          ..add('apellido2', apellido2)
          ..add('fecnac', fecnac)
          ..add('nombre', nombre)
          ..add('numdoc', numdoc)
          ..add('tipdoc', tipdoc)
          ..add('titular', titular))
        .toString();
  }
}

class BENEFICIARIOSBuilder
    implements Builder<BENEFICIARIOS, BENEFICIARIOSBuilder> {
  _$BENEFICIARIOS? _$v;

  String? _apellido1;
  String? get apellido1 => _$this._apellido1;
  set apellido1(String? apellido1) => _$this._apellido1 = apellido1;

  String? _apellido2;
  String? get apellido2 => _$this._apellido2;
  set apellido2(String? apellido2) => _$this._apellido2 = apellido2;

  String? _fecnac;
  String? get fecnac => _$this._fecnac;
  set fecnac(String? fecnac) => _$this._fecnac = fecnac;

  String? _nombre;
  String? get nombre => _$this._nombre;
  set nombre(String? nombre) => _$this._nombre = nombre;

  String? _numdoc;
  String? get numdoc => _$this._numdoc;
  set numdoc(String? numdoc) => _$this._numdoc = numdoc;

  String? _tipdoc;
  String? get tipdoc => _$this._tipdoc;
  set tipdoc(String? tipdoc) => _$this._tipdoc = tipdoc;

  String? _titular;
  String? get titular => _$this._titular;
  set titular(String? titular) => _$this._titular = titular;

  BENEFICIARIOSBuilder() {
    BENEFICIARIOS._defaults(this);
  }

  BENEFICIARIOSBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _apellido1 = $v.apellido1;
      _apellido2 = $v.apellido2;
      _fecnac = $v.fecnac;
      _nombre = $v.nombre;
      _numdoc = $v.numdoc;
      _tipdoc = $v.tipdoc;
      _titular = $v.titular;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BENEFICIARIOS other) {
    _$v = other as _$BENEFICIARIOS;
  }

  @override
  void update(void Function(BENEFICIARIOSBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BENEFICIARIOS build() => _build();

  _$BENEFICIARIOS _build() {
    final _$result = _$v ??
        _$BENEFICIARIOS._(
          apellido1: apellido1,
          apellido2: apellido2,
          fecnac: fecnac,
          nombre: nombre,
          numdoc: numdoc,
          tipdoc: tipdoc,
          titular: titular,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
