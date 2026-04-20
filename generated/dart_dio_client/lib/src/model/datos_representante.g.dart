// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'datos_representante.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DatosRepresentante extends DatosRepresentante {
  @override
  final String? apellido1;
  @override
  final String? apellido2;
  @override
  final String? nifcif;
  @override
  final String? nombre;
  @override
  final String? tipodoc;

  factory _$DatosRepresentante(
          [void Function(DatosRepresentanteBuilder)? updates]) =>
      (DatosRepresentanteBuilder()..update(updates))._build();

  _$DatosRepresentante._(
      {this.apellido1, this.apellido2, this.nifcif, this.nombre, this.tipodoc})
      : super._();
  @override
  DatosRepresentante rebuild(
          void Function(DatosRepresentanteBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DatosRepresentanteBuilder toBuilder() =>
      DatosRepresentanteBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DatosRepresentante &&
        apellido1 == other.apellido1 &&
        apellido2 == other.apellido2 &&
        nifcif == other.nifcif &&
        nombre == other.nombre &&
        tipodoc == other.tipodoc;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, apellido1.hashCode);
    _$hash = $jc(_$hash, apellido2.hashCode);
    _$hash = $jc(_$hash, nifcif.hashCode);
    _$hash = $jc(_$hash, nombre.hashCode);
    _$hash = $jc(_$hash, tipodoc.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DatosRepresentante')
          ..add('apellido1', apellido1)
          ..add('apellido2', apellido2)
          ..add('nifcif', nifcif)
          ..add('nombre', nombre)
          ..add('tipodoc', tipodoc))
        .toString();
  }
}

class DatosRepresentanteBuilder
    implements Builder<DatosRepresentante, DatosRepresentanteBuilder> {
  _$DatosRepresentante? _$v;

  String? _apellido1;
  String? get apellido1 => _$this._apellido1;
  set apellido1(String? apellido1) => _$this._apellido1 = apellido1;

  String? _apellido2;
  String? get apellido2 => _$this._apellido2;
  set apellido2(String? apellido2) => _$this._apellido2 = apellido2;

  String? _nifcif;
  String? get nifcif => _$this._nifcif;
  set nifcif(String? nifcif) => _$this._nifcif = nifcif;

  String? _nombre;
  String? get nombre => _$this._nombre;
  set nombre(String? nombre) => _$this._nombre = nombre;

  String? _tipodoc;
  String? get tipodoc => _$this._tipodoc;
  set tipodoc(String? tipodoc) => _$this._tipodoc = tipodoc;

  DatosRepresentanteBuilder() {
    DatosRepresentante._defaults(this);
  }

  DatosRepresentanteBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _apellido1 = $v.apellido1;
      _apellido2 = $v.apellido2;
      _nifcif = $v.nifcif;
      _nombre = $v.nombre;
      _tipodoc = $v.tipodoc;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DatosRepresentante other) {
    _$v = other as _$DatosRepresentante;
  }

  @override
  void update(void Function(DatosRepresentanteBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DatosRepresentante build() => _build();

  _$DatosRepresentante _build() {
    final _$result = _$v ??
        _$DatosRepresentante._(
          apellido1: apellido1,
          apellido2: apellido2,
          nifcif: nifcif,
          nombre: nombre,
          tipodoc: tipodoc,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
