// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pdatos.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PDATOS extends PDATOS {
  @override
  final String apellido1;
  @override
  final String apellido2;
  @override
  final String asuid;
  @override
  final String descrip;
  @override
  final String idunico;
  @override
  final String nombre;
  @override
  final String numdoc;
  @override
  final String uniorg;

  factory _$PDATOS([void Function(PDATOSBuilder)? updates]) =>
      (PDATOSBuilder()..update(updates))._build();

  _$PDATOS._(
      {required this.apellido1,
      required this.apellido2,
      required this.asuid,
      required this.descrip,
      required this.idunico,
      required this.nombre,
      required this.numdoc,
      required this.uniorg})
      : super._();
  @override
  PDATOS rebuild(void Function(PDATOSBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PDATOSBuilder toBuilder() => PDATOSBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PDATOS &&
        apellido1 == other.apellido1 &&
        apellido2 == other.apellido2 &&
        asuid == other.asuid &&
        descrip == other.descrip &&
        idunico == other.idunico &&
        nombre == other.nombre &&
        numdoc == other.numdoc &&
        uniorg == other.uniorg;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, apellido1.hashCode);
    _$hash = $jc(_$hash, apellido2.hashCode);
    _$hash = $jc(_$hash, asuid.hashCode);
    _$hash = $jc(_$hash, descrip.hashCode);
    _$hash = $jc(_$hash, idunico.hashCode);
    _$hash = $jc(_$hash, nombre.hashCode);
    _$hash = $jc(_$hash, numdoc.hashCode);
    _$hash = $jc(_$hash, uniorg.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PDATOS')
          ..add('apellido1', apellido1)
          ..add('apellido2', apellido2)
          ..add('asuid', asuid)
          ..add('descrip', descrip)
          ..add('idunico', idunico)
          ..add('nombre', nombre)
          ..add('numdoc', numdoc)
          ..add('uniorg', uniorg))
        .toString();
  }
}

class PDATOSBuilder implements Builder<PDATOS, PDATOSBuilder> {
  _$PDATOS? _$v;

  String? _apellido1;
  String? get apellido1 => _$this._apellido1;
  set apellido1(String? apellido1) => _$this._apellido1 = apellido1;

  String? _apellido2;
  String? get apellido2 => _$this._apellido2;
  set apellido2(String? apellido2) => _$this._apellido2 = apellido2;

  String? _asuid;
  String? get asuid => _$this._asuid;
  set asuid(String? asuid) => _$this._asuid = asuid;

  String? _descrip;
  String? get descrip => _$this._descrip;
  set descrip(String? descrip) => _$this._descrip = descrip;

  String? _idunico;
  String? get idunico => _$this._idunico;
  set idunico(String? idunico) => _$this._idunico = idunico;

  String? _nombre;
  String? get nombre => _$this._nombre;
  set nombre(String? nombre) => _$this._nombre = nombre;

  String? _numdoc;
  String? get numdoc => _$this._numdoc;
  set numdoc(String? numdoc) => _$this._numdoc = numdoc;

  String? _uniorg;
  String? get uniorg => _$this._uniorg;
  set uniorg(String? uniorg) => _$this._uniorg = uniorg;

  PDATOSBuilder() {
    PDATOS._defaults(this);
  }

  PDATOSBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _apellido1 = $v.apellido1;
      _apellido2 = $v.apellido2;
      _asuid = $v.asuid;
      _descrip = $v.descrip;
      _idunico = $v.idunico;
      _nombre = $v.nombre;
      _numdoc = $v.numdoc;
      _uniorg = $v.uniorg;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PDATOS other) {
    _$v = other as _$PDATOS;
  }

  @override
  void update(void Function(PDATOSBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PDATOS build() => _build();

  _$PDATOS _build() {
    final _$result = _$v ??
        _$PDATOS._(
          apellido1: BuiltValueNullFieldError.checkNotNull(
              apellido1, r'PDATOS', 'apellido1'),
          apellido2: BuiltValueNullFieldError.checkNotNull(
              apellido2, r'PDATOS', 'apellido2'),
          asuid:
              BuiltValueNullFieldError.checkNotNull(asuid, r'PDATOS', 'asuid'),
          descrip: BuiltValueNullFieldError.checkNotNull(
              descrip, r'PDATOS', 'descrip'),
          idunico: BuiltValueNullFieldError.checkNotNull(
              idunico, r'PDATOS', 'idunico'),
          nombre: BuiltValueNullFieldError.checkNotNull(
              nombre, r'PDATOS', 'nombre'),
          numdoc: BuiltValueNullFieldError.checkNotNull(
              numdoc, r'PDATOS', 'numdoc'),
          uniorg: BuiltValueNullFieldError.checkNotNull(
              uniorg, r'PDATOS', 'uniorg'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
