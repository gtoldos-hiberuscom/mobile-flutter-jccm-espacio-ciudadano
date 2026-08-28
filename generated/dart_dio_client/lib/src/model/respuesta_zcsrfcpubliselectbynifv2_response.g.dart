// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'respuesta_zcsrfcpubliselectbynifv2_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RespuestaZCSRFCPUBLISELECTBYNIFV2Response
    extends RespuestaZCSRFCPUBLISELECTBYNIFV2Response {
  @override
  final ZCSRFCPUBLISELECTBYNIFV2Response? body;
  @override
  final String? codigoRespuesta;
  @override
  final InfoError? infoError;
  @override
  final String? mensajeRespuesta;
  @override
  final DateTime? timestamp;

  factory _$RespuestaZCSRFCPUBLISELECTBYNIFV2Response(
          [void Function(RespuestaZCSRFCPUBLISELECTBYNIFV2ResponseBuilder)?
              updates]) =>
      (RespuestaZCSRFCPUBLISELECTBYNIFV2ResponseBuilder()..update(updates))
          ._build();

  _$RespuestaZCSRFCPUBLISELECTBYNIFV2Response._(
      {this.body,
      this.codigoRespuesta,
      this.infoError,
      this.mensajeRespuesta,
      this.timestamp})
      : super._();
  @override
  RespuestaZCSRFCPUBLISELECTBYNIFV2Response rebuild(
          void Function(RespuestaZCSRFCPUBLISELECTBYNIFV2ResponseBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RespuestaZCSRFCPUBLISELECTBYNIFV2ResponseBuilder toBuilder() =>
      RespuestaZCSRFCPUBLISELECTBYNIFV2ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RespuestaZCSRFCPUBLISELECTBYNIFV2Response &&
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
            r'RespuestaZCSRFCPUBLISELECTBYNIFV2Response')
          ..add('body', body)
          ..add('codigoRespuesta', codigoRespuesta)
          ..add('infoError', infoError)
          ..add('mensajeRespuesta', mensajeRespuesta)
          ..add('timestamp', timestamp))
        .toString();
  }
}

class RespuestaZCSRFCPUBLISELECTBYNIFV2ResponseBuilder
    implements
        Builder<RespuestaZCSRFCPUBLISELECTBYNIFV2Response,
            RespuestaZCSRFCPUBLISELECTBYNIFV2ResponseBuilder> {
  _$RespuestaZCSRFCPUBLISELECTBYNIFV2Response? _$v;

  ZCSRFCPUBLISELECTBYNIFV2ResponseBuilder? _body;
  ZCSRFCPUBLISELECTBYNIFV2ResponseBuilder get body =>
      _$this._body ??= ZCSRFCPUBLISELECTBYNIFV2ResponseBuilder();
  set body(ZCSRFCPUBLISELECTBYNIFV2ResponseBuilder? body) =>
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

  RespuestaZCSRFCPUBLISELECTBYNIFV2ResponseBuilder() {
    RespuestaZCSRFCPUBLISELECTBYNIFV2Response._defaults(this);
  }

  RespuestaZCSRFCPUBLISELECTBYNIFV2ResponseBuilder get _$this {
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
  void replace(RespuestaZCSRFCPUBLISELECTBYNIFV2Response other) {
    _$v = other as _$RespuestaZCSRFCPUBLISELECTBYNIFV2Response;
  }

  @override
  void update(
      void Function(RespuestaZCSRFCPUBLISELECTBYNIFV2ResponseBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  RespuestaZCSRFCPUBLISELECTBYNIFV2Response build() => _build();

  _$RespuestaZCSRFCPUBLISELECTBYNIFV2Response _build() {
    _$RespuestaZCSRFCPUBLISELECTBYNIFV2Response _$result;
    try {
      _$result = _$v ??
          _$RespuestaZCSRFCPUBLISELECTBYNIFV2Response._(
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
            r'RespuestaZCSRFCPUBLISELECTBYNIFV2Response',
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
