// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'zcsrfcpubliselectbynifv2_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ZCSRFCPUBLISELECTBYNIFV2Response
    extends ZCSRFCPUBLISELECTBYNIFV2Response {
  @override
  final int? isubrc;
  @override
  final PUBLICACIONPORTAL? publicacionportal;
  @override
  final String? resultado;

  factory _$ZCSRFCPUBLISELECTBYNIFV2Response(
          [void Function(ZCSRFCPUBLISELECTBYNIFV2ResponseBuilder)? updates]) =>
      (ZCSRFCPUBLISELECTBYNIFV2ResponseBuilder()..update(updates))._build();

  _$ZCSRFCPUBLISELECTBYNIFV2Response._(
      {this.isubrc, this.publicacionportal, this.resultado})
      : super._();
  @override
  ZCSRFCPUBLISELECTBYNIFV2Response rebuild(
          void Function(ZCSRFCPUBLISELECTBYNIFV2ResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ZCSRFCPUBLISELECTBYNIFV2ResponseBuilder toBuilder() =>
      ZCSRFCPUBLISELECTBYNIFV2ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ZCSRFCPUBLISELECTBYNIFV2Response &&
        isubrc == other.isubrc &&
        publicacionportal == other.publicacionportal &&
        resultado == other.resultado;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, isubrc.hashCode);
    _$hash = $jc(_$hash, publicacionportal.hashCode);
    _$hash = $jc(_$hash, resultado.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ZCSRFCPUBLISELECTBYNIFV2Response')
          ..add('isubrc', isubrc)
          ..add('publicacionportal', publicacionportal)
          ..add('resultado', resultado))
        .toString();
  }
}

class ZCSRFCPUBLISELECTBYNIFV2ResponseBuilder
    implements
        Builder<ZCSRFCPUBLISELECTBYNIFV2Response,
            ZCSRFCPUBLISELECTBYNIFV2ResponseBuilder> {
  _$ZCSRFCPUBLISELECTBYNIFV2Response? _$v;

  int? _isubrc;
  int? get isubrc => _$this._isubrc;
  set isubrc(int? isubrc) => _$this._isubrc = isubrc;

  PUBLICACIONPORTALBuilder? _publicacionportal;
  PUBLICACIONPORTALBuilder get publicacionportal =>
      _$this._publicacionportal ??= PUBLICACIONPORTALBuilder();
  set publicacionportal(PUBLICACIONPORTALBuilder? publicacionportal) =>
      _$this._publicacionportal = publicacionportal;

  String? _resultado;
  String? get resultado => _$this._resultado;
  set resultado(String? resultado) => _$this._resultado = resultado;

  ZCSRFCPUBLISELECTBYNIFV2ResponseBuilder() {
    ZCSRFCPUBLISELECTBYNIFV2Response._defaults(this);
  }

  ZCSRFCPUBLISELECTBYNIFV2ResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _isubrc = $v.isubrc;
      _publicacionportal = $v.publicacionportal?.toBuilder();
      _resultado = $v.resultado;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ZCSRFCPUBLISELECTBYNIFV2Response other) {
    _$v = other as _$ZCSRFCPUBLISELECTBYNIFV2Response;
  }

  @override
  void update(void Function(ZCSRFCPUBLISELECTBYNIFV2ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ZCSRFCPUBLISELECTBYNIFV2Response build() => _build();

  _$ZCSRFCPUBLISELECTBYNIFV2Response _build() {
    _$ZCSRFCPUBLISELECTBYNIFV2Response _$result;
    try {
      _$result = _$v ??
          _$ZCSRFCPUBLISELECTBYNIFV2Response._(
            isubrc: isubrc,
            publicacionportal: _publicacionportal?.build(),
            resultado: resultado,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'publicacionportal';
        _publicacionportal?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ZCSRFCPUBLISELECTBYNIFV2Response', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
