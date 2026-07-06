// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'respuesta_fachada_interm.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RespuestaFachadaInterm extends RespuestaFachadaInterm {
  @override
  final JsonObject? respuesta;

  factory _$RespuestaFachadaInterm(
          [void Function(RespuestaFachadaIntermBuilder)? updates]) =>
      (RespuestaFachadaIntermBuilder()..update(updates))._build();

  _$RespuestaFachadaInterm._({this.respuesta}) : super._();
  @override
  RespuestaFachadaInterm rebuild(
          void Function(RespuestaFachadaIntermBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RespuestaFachadaIntermBuilder toBuilder() =>
      RespuestaFachadaIntermBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RespuestaFachadaInterm && respuesta == other.respuesta;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, respuesta.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RespuestaFachadaInterm')
          ..add('respuesta', respuesta))
        .toString();
  }
}

class RespuestaFachadaIntermBuilder
    implements Builder<RespuestaFachadaInterm, RespuestaFachadaIntermBuilder> {
  _$RespuestaFachadaInterm? _$v;

  JsonObject? _respuesta;
  JsonObject? get respuesta => _$this._respuesta;
  set respuesta(JsonObject? respuesta) => _$this._respuesta = respuesta;

  RespuestaFachadaIntermBuilder() {
    RespuestaFachadaInterm._defaults(this);
  }

  RespuestaFachadaIntermBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _respuesta = $v.respuesta;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RespuestaFachadaInterm other) {
    _$v = other as _$RespuestaFachadaInterm;
  }

  @override
  void update(void Function(RespuestaFachadaIntermBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RespuestaFachadaInterm build() => _build();

  _$RespuestaFachadaInterm _build() {
    final _$result = _$v ??
        _$RespuestaFachadaInterm._(
          respuesta: respuesta,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
