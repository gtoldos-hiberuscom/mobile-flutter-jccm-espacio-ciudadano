// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'respuesta.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Respuesta extends Respuesta {
  @override
  final JsonObject? body;
  @override
  final String? codigoRespuesta;
  @override
  final InfoError? infoError;
  @override
  final String? mensajeRespuesta;
  @override
  final DateTime? timestamp;

  factory _$Respuesta([void Function(RespuestaBuilder)? updates]) =>
      (RespuestaBuilder()..update(updates))._build();

  _$Respuesta._(
      {this.body,
      this.codigoRespuesta,
      this.infoError,
      this.mensajeRespuesta,
      this.timestamp})
      : super._();
  @override
  Respuesta rebuild(void Function(RespuestaBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RespuestaBuilder toBuilder() => RespuestaBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Respuesta &&
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
    return (newBuiltValueToStringHelper(r'Respuesta')
          ..add('body', body)
          ..add('codigoRespuesta', codigoRespuesta)
          ..add('infoError', infoError)
          ..add('mensajeRespuesta', mensajeRespuesta)
          ..add('timestamp', timestamp))
        .toString();
  }
}

class RespuestaBuilder implements Builder<Respuesta, RespuestaBuilder> {
  _$Respuesta? _$v;

  JsonObject? _body;
  JsonObject? get body => _$this._body;
  set body(JsonObject? body) => _$this._body = body;

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

  RespuestaBuilder() {
    Respuesta._defaults(this);
  }

  RespuestaBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _body = $v.body;
      _codigoRespuesta = $v.codigoRespuesta;
      _infoError = $v.infoError?.toBuilder();
      _mensajeRespuesta = $v.mensajeRespuesta;
      _timestamp = $v.timestamp;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Respuesta other) {
    _$v = other as _$Respuesta;
  }

  @override
  void update(void Function(RespuestaBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Respuesta build() => _build();

  _$Respuesta _build() {
    _$Respuesta _$result;
    try {
      _$result = _$v ??
          _$Respuesta._(
            body: body,
            codigoRespuesta: codigoRespuesta,
            infoError: _infoError?.build(),
            mensajeRespuesta: mensajeRespuesta,
            timestamp: timestamp,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'infoError';
        _infoError?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'Respuesta', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
