// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'datos_beneficiarios_familia_numerosa_list.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DatosBeneficiariosFamiliaNumerosaList
    extends DatosBeneficiariosFamiliaNumerosaList {
  @override
  final String? apellido1;
  @override
  final String? apellido2;
  @override
  final String? documentacion;
  @override
  final String? fechaNacimiento;
  @override
  final String? nombre;
  @override
  final String? tipoDocumentacion;
  @override
  final String? titular;

  factory _$DatosBeneficiariosFamiliaNumerosaList(
          [void Function(DatosBeneficiariosFamiliaNumerosaListBuilder)?
              updates]) =>
      (DatosBeneficiariosFamiliaNumerosaListBuilder()..update(updates))
          ._build();

  _$DatosBeneficiariosFamiliaNumerosaList._(
      {this.apellido1,
      this.apellido2,
      this.documentacion,
      this.fechaNacimiento,
      this.nombre,
      this.tipoDocumentacion,
      this.titular})
      : super._();
  @override
  DatosBeneficiariosFamiliaNumerosaList rebuild(
          void Function(DatosBeneficiariosFamiliaNumerosaListBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DatosBeneficiariosFamiliaNumerosaListBuilder toBuilder() =>
      DatosBeneficiariosFamiliaNumerosaListBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DatosBeneficiariosFamiliaNumerosaList &&
        apellido1 == other.apellido1 &&
        apellido2 == other.apellido2 &&
        documentacion == other.documentacion &&
        fechaNacimiento == other.fechaNacimiento &&
        nombre == other.nombre &&
        tipoDocumentacion == other.tipoDocumentacion &&
        titular == other.titular;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, apellido1.hashCode);
    _$hash = $jc(_$hash, apellido2.hashCode);
    _$hash = $jc(_$hash, documentacion.hashCode);
    _$hash = $jc(_$hash, fechaNacimiento.hashCode);
    _$hash = $jc(_$hash, nombre.hashCode);
    _$hash = $jc(_$hash, tipoDocumentacion.hashCode);
    _$hash = $jc(_$hash, titular.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'DatosBeneficiariosFamiliaNumerosaList')
          ..add('apellido1', apellido1)
          ..add('apellido2', apellido2)
          ..add('documentacion', documentacion)
          ..add('fechaNacimiento', fechaNacimiento)
          ..add('nombre', nombre)
          ..add('tipoDocumentacion', tipoDocumentacion)
          ..add('titular', titular))
        .toString();
  }
}

class DatosBeneficiariosFamiliaNumerosaListBuilder
    implements
        Builder<DatosBeneficiariosFamiliaNumerosaList,
            DatosBeneficiariosFamiliaNumerosaListBuilder> {
  _$DatosBeneficiariosFamiliaNumerosaList? _$v;

  String? _apellido1;
  String? get apellido1 => _$this._apellido1;
  set apellido1(String? apellido1) => _$this._apellido1 = apellido1;

  String? _apellido2;
  String? get apellido2 => _$this._apellido2;
  set apellido2(String? apellido2) => _$this._apellido2 = apellido2;

  String? _documentacion;
  String? get documentacion => _$this._documentacion;
  set documentacion(String? documentacion) =>
      _$this._documentacion = documentacion;

  String? _fechaNacimiento;
  String? get fechaNacimiento => _$this._fechaNacimiento;
  set fechaNacimiento(String? fechaNacimiento) =>
      _$this._fechaNacimiento = fechaNacimiento;

  String? _nombre;
  String? get nombre => _$this._nombre;
  set nombre(String? nombre) => _$this._nombre = nombre;

  String? _tipoDocumentacion;
  String? get tipoDocumentacion => _$this._tipoDocumentacion;
  set tipoDocumentacion(String? tipoDocumentacion) =>
      _$this._tipoDocumentacion = tipoDocumentacion;

  String? _titular;
  String? get titular => _$this._titular;
  set titular(String? titular) => _$this._titular = titular;

  DatosBeneficiariosFamiliaNumerosaListBuilder() {
    DatosBeneficiariosFamiliaNumerosaList._defaults(this);
  }

  DatosBeneficiariosFamiliaNumerosaListBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _apellido1 = $v.apellido1;
      _apellido2 = $v.apellido2;
      _documentacion = $v.documentacion;
      _fechaNacimiento = $v.fechaNacimiento;
      _nombre = $v.nombre;
      _tipoDocumentacion = $v.tipoDocumentacion;
      _titular = $v.titular;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DatosBeneficiariosFamiliaNumerosaList other) {
    _$v = other as _$DatosBeneficiariosFamiliaNumerosaList;
  }

  @override
  void update(
      void Function(DatosBeneficiariosFamiliaNumerosaListBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DatosBeneficiariosFamiliaNumerosaList build() => _build();

  _$DatosBeneficiariosFamiliaNumerosaList _build() {
    final _$result = _$v ??
        _$DatosBeneficiariosFamiliaNumerosaList._(
          apellido1: apellido1,
          apellido2: apellido2,
          documentacion: documentacion,
          fechaNacimiento: fechaNacimiento,
          nombre: nombre,
          tipoDocumentacion: tipoDocumentacion,
          titular: titular,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
