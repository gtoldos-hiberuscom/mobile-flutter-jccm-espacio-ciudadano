// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tercero_n2_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$TerceroN2Dto extends TerceroN2Dto {
  @override
  final String? dni;
  @override
  final String? email;
  @override
  final int? idTercero;
  @override
  final int? telefono;

  factory _$TerceroN2Dto([void Function(TerceroN2DtoBuilder)? updates]) =>
      (TerceroN2DtoBuilder()..update(updates))._build();

  _$TerceroN2Dto._({this.dni, this.email, this.idTercero, this.telefono})
      : super._();
  @override
  TerceroN2Dto rebuild(void Function(TerceroN2DtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TerceroN2DtoBuilder toBuilder() => TerceroN2DtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TerceroN2Dto &&
        dni == other.dni &&
        email == other.email &&
        idTercero == other.idTercero &&
        telefono == other.telefono;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, dni.hashCode);
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, idTercero.hashCode);
    _$hash = $jc(_$hash, telefono.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'TerceroN2Dto')
          ..add('dni', dni)
          ..add('email', email)
          ..add('idTercero', idTercero)
          ..add('telefono', telefono))
        .toString();
  }
}

class TerceroN2DtoBuilder
    implements Builder<TerceroN2Dto, TerceroN2DtoBuilder> {
  _$TerceroN2Dto? _$v;

  String? _dni;
  String? get dni => _$this._dni;
  set dni(String? dni) => _$this._dni = dni;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  int? _idTercero;
  int? get idTercero => _$this._idTercero;
  set idTercero(int? idTercero) => _$this._idTercero = idTercero;

  int? _telefono;
  int? get telefono => _$this._telefono;
  set telefono(int? telefono) => _$this._telefono = telefono;

  TerceroN2DtoBuilder() {
    TerceroN2Dto._defaults(this);
  }

  TerceroN2DtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _dni = $v.dni;
      _email = $v.email;
      _idTercero = $v.idTercero;
      _telefono = $v.telefono;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TerceroN2Dto other) {
    _$v = other as _$TerceroN2Dto;
  }

  @override
  void update(void Function(TerceroN2DtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TerceroN2Dto build() => _build();

  _$TerceroN2Dto _build() {
    final _$result = _$v ??
        _$TerceroN2Dto._(
          dni: dni,
          email: email,
          idTercero: idTercero,
          telefono: telefono,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
