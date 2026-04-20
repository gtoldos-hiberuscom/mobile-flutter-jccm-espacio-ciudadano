// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resultadoprocedimiento.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RESULTADOPROCEDIMIENTO extends RESULTADOPROCEDIMIENTO {
  @override
  final DATOSREGISTRO datosregistro;
  @override
  final String estado;
  @override
  final String idregistro;
  @override
  final String idunico;
  @override
  final String mensaje;

  factory _$RESULTADOPROCEDIMIENTO(
          [void Function(RESULTADOPROCEDIMIENTOBuilder)? updates]) =>
      (RESULTADOPROCEDIMIENTOBuilder()..update(updates))._build();

  _$RESULTADOPROCEDIMIENTO._(
      {required this.datosregistro,
      required this.estado,
      required this.idregistro,
      required this.idunico,
      required this.mensaje})
      : super._();
  @override
  RESULTADOPROCEDIMIENTO rebuild(
          void Function(RESULTADOPROCEDIMIENTOBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RESULTADOPROCEDIMIENTOBuilder toBuilder() =>
      RESULTADOPROCEDIMIENTOBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RESULTADOPROCEDIMIENTO &&
        datosregistro == other.datosregistro &&
        estado == other.estado &&
        idregistro == other.idregistro &&
        idunico == other.idunico &&
        mensaje == other.mensaje;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, datosregistro.hashCode);
    _$hash = $jc(_$hash, estado.hashCode);
    _$hash = $jc(_$hash, idregistro.hashCode);
    _$hash = $jc(_$hash, idunico.hashCode);
    _$hash = $jc(_$hash, mensaje.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RESULTADOPROCEDIMIENTO')
          ..add('datosregistro', datosregistro)
          ..add('estado', estado)
          ..add('idregistro', idregistro)
          ..add('idunico', idunico)
          ..add('mensaje', mensaje))
        .toString();
  }
}

class RESULTADOPROCEDIMIENTOBuilder
    implements Builder<RESULTADOPROCEDIMIENTO, RESULTADOPROCEDIMIENTOBuilder> {
  _$RESULTADOPROCEDIMIENTO? _$v;

  DATOSREGISTROBuilder? _datosregistro;
  DATOSREGISTROBuilder get datosregistro =>
      _$this._datosregistro ??= DATOSREGISTROBuilder();
  set datosregistro(DATOSREGISTROBuilder? datosregistro) =>
      _$this._datosregistro = datosregistro;

  String? _estado;
  String? get estado => _$this._estado;
  set estado(String? estado) => _$this._estado = estado;

  String? _idregistro;
  String? get idregistro => _$this._idregistro;
  set idregistro(String? idregistro) => _$this._idregistro = idregistro;

  String? _idunico;
  String? get idunico => _$this._idunico;
  set idunico(String? idunico) => _$this._idunico = idunico;

  String? _mensaje;
  String? get mensaje => _$this._mensaje;
  set mensaje(String? mensaje) => _$this._mensaje = mensaje;

  RESULTADOPROCEDIMIENTOBuilder() {
    RESULTADOPROCEDIMIENTO._defaults(this);
  }

  RESULTADOPROCEDIMIENTOBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _datosregistro = $v.datosregistro.toBuilder();
      _estado = $v.estado;
      _idregistro = $v.idregistro;
      _idunico = $v.idunico;
      _mensaje = $v.mensaje;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RESULTADOPROCEDIMIENTO other) {
    _$v = other as _$RESULTADOPROCEDIMIENTO;
  }

  @override
  void update(void Function(RESULTADOPROCEDIMIENTOBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RESULTADOPROCEDIMIENTO build() => _build();

  _$RESULTADOPROCEDIMIENTO _build() {
    _$RESULTADOPROCEDIMIENTO _$result;
    try {
      _$result = _$v ??
          _$RESULTADOPROCEDIMIENTO._(
            datosregistro: datosregistro.build(),
            estado: BuiltValueNullFieldError.checkNotNull(
                estado, r'RESULTADOPROCEDIMIENTO', 'estado'),
            idregistro: BuiltValueNullFieldError.checkNotNull(
                idregistro, r'RESULTADOPROCEDIMIENTO', 'idregistro'),
            idunico: BuiltValueNullFieldError.checkNotNull(
                idunico, r'RESULTADOPROCEDIMIENTO', 'idunico'),
            mensaje: BuiltValueNullFieldError.checkNotNull(
                mensaje, r'RESULTADOPROCEDIMIENTO', 'mensaje'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'datosregistro';
        datosregistro.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'RESULTADOPROCEDIMIENTO', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
