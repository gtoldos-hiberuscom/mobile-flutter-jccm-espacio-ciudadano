// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'respuesta_respuesta_fachada_familia_numerosa_interm.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RespuestaRespuestaFachadaFamiliaNumerosaInterm
    extends RespuestaRespuestaFachadaFamiliaNumerosaInterm {
  @override
  final RespuestaFachadaFamiliaNumerosaInterm? body;
  @override
  final String? codigoRespuesta;
  @override
  final InfoError? infoError;
  @override
  final String? mensajeRespuesta;
  @override
  final DateTime? timestamp;

  factory _$RespuestaRespuestaFachadaFamiliaNumerosaInterm(
          [void Function(RespuestaRespuestaFachadaFamiliaNumerosaIntermBuilder)?
              updates]) =>
      (RespuestaRespuestaFachadaFamiliaNumerosaIntermBuilder()..update(updates))
          ._build();

  _$RespuestaRespuestaFachadaFamiliaNumerosaInterm._(
      {this.body,
      this.codigoRespuesta,
      this.infoError,
      this.mensajeRespuesta,
      this.timestamp})
      : super._();
  @override
  RespuestaRespuestaFachadaFamiliaNumerosaInterm rebuild(
          void Function(RespuestaRespuestaFachadaFamiliaNumerosaIntermBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RespuestaRespuestaFachadaFamiliaNumerosaIntermBuilder toBuilder() =>
      RespuestaRespuestaFachadaFamiliaNumerosaIntermBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RespuestaRespuestaFachadaFamiliaNumerosaInterm &&
        body == other.body &&
        codigoRespuesta == other.codigoRespuesta &&
        infoError == other.infoError &&
        mensajeRespuesta == other.mensajeRespuesta &&
        timestamp == other.timestamp;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, body.hashCode);
    _$hash = $jc(_$hash, codigoRespuesta.hashCode);
    _$hash = $jc(_$hash, infoError.hashCode);
    _$hash = $jc(_$hash, mensajeRespuesta.hashCode);
    _$hash = $jc(_$hash, timestamp.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'RespuestaRespuestaFachadaFamiliaNumerosaInterm')
          ..add('body', body)
          ..add('codigoRespuesta', codigoRespuesta)
          ..add('infoError', infoError)
          ..add('mensajeRespuesta', mensajeRespuesta)
          ..add('timestamp', timestamp))
        .toString();
  }
}

class RespuestaRespuestaFachadaFamiliaNumerosaIntermBuilder
    implements
        Builder<RespuestaRespuestaFachadaFamiliaNumerosaInterm,
            RespuestaRespuestaFachadaFamiliaNumerosaIntermBuilder> {
  _$RespuestaRespuestaFachadaFamiliaNumerosaInterm? _$v;

  RespuestaFachadaFamiliaNumerosaIntermBuilder? _body;
  RespuestaFachadaFamiliaNumerosaIntermBuilder get body =>
      _$this._body ??= RespuestaFachadaFamiliaNumerosaIntermBuilder();
  set body(RespuestaFachadaFamiliaNumerosaIntermBuilder? body) =>
      _$this._body = body;

  String? _codigoRespuesta;
  String? get codigoRespuesta => _$this._codigoRespuesta;
  set codigoRespuesta(String? codigoRespuesta) =>
      _$this._codigoRespuesta = codigoRespuesta;

  InfoErrorBuilder? _infoError;
  InfoErrorBuilder get infoError => _$this._infoError ??= InfoErrorBuilder();
  set infoError(InfoErrorBuilder? infoError) => _$this._infoError = infoError;

  String? _mensajeRespuesta;
  String? get mensajeRespuesta => _$this._mensajeRespuesta;
  set mensajeRespuesta(String? mensajeRespuesta) =>
      _$this._mensajeRespuesta = mensajeRespuesta;

  DateTime? _timestamp;
  DateTime? get timestamp => _$this._timestamp;
  set timestamp(DateTime? timestamp) => _$this._timestamp = timestamp;

  RespuestaRespuestaFachadaFamiliaNumerosaIntermBuilder() {
    RespuestaRespuestaFachadaFamiliaNumerosaInterm._defaults(this);
  }

  RespuestaRespuestaFachadaFamiliaNumerosaIntermBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _body = $v.body?.toBuilder();
      _codigoRespuesta = $v.codigoRespuesta;
      _infoError = $v.infoError?.toBuilder();
      _mensajeRespuesta = $v.mensajeRespuesta;
      _timestamp = $v.timestamp;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RespuestaRespuestaFachadaFamiliaNumerosaInterm other) {
    _$v = other as _$RespuestaRespuestaFachadaFamiliaNumerosaInterm;
  }

  @override
  void update(
      void Function(RespuestaRespuestaFachadaFamiliaNumerosaIntermBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  RespuestaRespuestaFachadaFamiliaNumerosaInterm build() => _build();

  _$RespuestaRespuestaFachadaFamiliaNumerosaInterm _build() {
    _$RespuestaRespuestaFachadaFamiliaNumerosaInterm _$result;
    try {
      _$result = _$v ??
          _$RespuestaRespuestaFachadaFamiliaNumerosaInterm._(
            body: _body?.build(),
            codigoRespuesta: codigoRespuesta,
            infoError: _infoError?.build(),
            mensajeRespuesta: mensajeRespuesta,
            timestamp: timestamp,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'body';
        _body?.build();

        _$failedField = 'infoError';
        _infoError?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'RespuestaRespuestaFachadaFamiliaNumerosaInterm',
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
