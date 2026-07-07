// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'respuesta_resultadoprocedimiento.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RespuestaRESULTADOPROCEDIMIENTO
    extends RespuestaRESULTADOPROCEDIMIENTO {
  @override
  final RESULTADOPROCEDIMIENTO? body;
  @override
  final String? codigoRespuesta;
  @override
  final InfoError? infoError;
  @override
  final String? mensajeRespuesta;
  @override
  final DateTime? timestamp;

  factory _$RespuestaRESULTADOPROCEDIMIENTO(
          [void Function(RespuestaRESULTADOPROCEDIMIENTOBuilder)? updates]) =>
      (RespuestaRESULTADOPROCEDIMIENTOBuilder()..update(updates))._build();

  _$RespuestaRESULTADOPROCEDIMIENTO._(
      {this.body,
      this.codigoRespuesta,
      this.infoError,
      this.mensajeRespuesta,
      this.timestamp})
      : super._();
  @override
  RespuestaRESULTADOPROCEDIMIENTO rebuild(
          void Function(RespuestaRESULTADOPROCEDIMIENTOBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RespuestaRESULTADOPROCEDIMIENTOBuilder toBuilder() =>
      RespuestaRESULTADOPROCEDIMIENTOBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RespuestaRESULTADOPROCEDIMIENTO &&
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
    return (newBuiltValueToStringHelper(r'RespuestaRESULTADOPROCEDIMIENTO')
          ..add('body', body)
          ..add('codigoRespuesta', codigoRespuesta)
          ..add('infoError', infoError)
          ..add('mensajeRespuesta', mensajeRespuesta)
          ..add('timestamp', timestamp))
        .toString();
  }
}

class RespuestaRESULTADOPROCEDIMIENTOBuilder
    implements
        Builder<RespuestaRESULTADOPROCEDIMIENTO,
            RespuestaRESULTADOPROCEDIMIENTOBuilder> {
  _$RespuestaRESULTADOPROCEDIMIENTO? _$v;

  RESULTADOPROCEDIMIENTOBuilder? _body;
  RESULTADOPROCEDIMIENTOBuilder get body =>
      _$this._body ??= RESULTADOPROCEDIMIENTOBuilder();
  set body(RESULTADOPROCEDIMIENTOBuilder? body) => _$this._body = body;

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

  RespuestaRESULTADOPROCEDIMIENTOBuilder() {
    RespuestaRESULTADOPROCEDIMIENTO._defaults(this);
  }

  RespuestaRESULTADOPROCEDIMIENTOBuilder get _$this {
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
  void replace(RespuestaRESULTADOPROCEDIMIENTO other) {
    _$v = other as _$RespuestaRESULTADOPROCEDIMIENTO;
  }

  @override
  void update(void Function(RespuestaRESULTADOPROCEDIMIENTOBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RespuestaRESULTADOPROCEDIMIENTO build() => _build();

  _$RespuestaRESULTADOPROCEDIMIENTO _build() {
    _$RespuestaRESULTADOPROCEDIMIENTO _$result;
    try {
      _$result = _$v ??
          _$RespuestaRESULTADOPROCEDIMIENTO._(
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
            r'RespuestaRESULTADOPROCEDIMIENTO', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
