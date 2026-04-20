// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'respuesta_fachada_familia_numerosa_interm.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RespuestaFachadaFamiliaNumerosaInterm
    extends RespuestaFachadaFamiliaNumerosaInterm {
  @override
  final ResponseFamiliaNumerosaIntermediacion? respuesta;

  factory _$RespuestaFachadaFamiliaNumerosaInterm(
          [void Function(RespuestaFachadaFamiliaNumerosaIntermBuilder)?
              updates]) =>
      (RespuestaFachadaFamiliaNumerosaIntermBuilder()..update(updates))
          ._build();

  _$RespuestaFachadaFamiliaNumerosaInterm._({this.respuesta}) : super._();
  @override
  RespuestaFachadaFamiliaNumerosaInterm rebuild(
          void Function(RespuestaFachadaFamiliaNumerosaIntermBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RespuestaFachadaFamiliaNumerosaIntermBuilder toBuilder() =>
      RespuestaFachadaFamiliaNumerosaIntermBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RespuestaFachadaFamiliaNumerosaInterm &&
        respuesta == other.respuesta;
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
    return (newBuiltValueToStringHelper(
            r'RespuestaFachadaFamiliaNumerosaInterm')
          ..add('respuesta', respuesta))
        .toString();
  }
}

class RespuestaFachadaFamiliaNumerosaIntermBuilder
    implements
        Builder<RespuestaFachadaFamiliaNumerosaInterm,
            RespuestaFachadaFamiliaNumerosaIntermBuilder> {
  _$RespuestaFachadaFamiliaNumerosaInterm? _$v;

  ResponseFamiliaNumerosaIntermediacionBuilder? _respuesta;
  ResponseFamiliaNumerosaIntermediacionBuilder get respuesta =>
      _$this._respuesta ??= ResponseFamiliaNumerosaIntermediacionBuilder();
  set respuesta(ResponseFamiliaNumerosaIntermediacionBuilder? respuesta) =>
      _$this._respuesta = respuesta;

  RespuestaFachadaFamiliaNumerosaIntermBuilder() {
    RespuestaFachadaFamiliaNumerosaInterm._defaults(this);
  }

  RespuestaFachadaFamiliaNumerosaIntermBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _respuesta = $v.respuesta?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RespuestaFachadaFamiliaNumerosaInterm other) {
    _$v = other as _$RespuestaFachadaFamiliaNumerosaInterm;
  }

  @override
  void update(
      void Function(RespuestaFachadaFamiliaNumerosaIntermBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RespuestaFachadaFamiliaNumerosaInterm build() => _build();

  _$RespuestaFachadaFamiliaNumerosaInterm _build() {
    _$RespuestaFachadaFamiliaNumerosaInterm _$result;
    try {
      _$result = _$v ??
          _$RespuestaFachadaFamiliaNumerosaInterm._(
            respuesta: _respuesta?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'respuesta';
        _respuesta?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'RespuestaFachadaFamiliaNumerosaInterm',
            _$failedField,
            e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
