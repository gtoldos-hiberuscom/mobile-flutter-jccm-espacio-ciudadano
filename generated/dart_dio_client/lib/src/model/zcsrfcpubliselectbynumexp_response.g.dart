// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'zcsrfcpubliselectbynumexp_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ZCSRFCPUBLISELECTBYNUMEXPResponse
    extends ZCSRFCPUBLISELECTBYNUMEXPResponse {
  @override
  final String? adjuntar;
  @override
  final int? isubrc;
  @override
  final ZCSSTPUBPORTAL? publicacionportal;
  @override
  final String? resultado;

  factory _$ZCSRFCPUBLISELECTBYNUMEXPResponse(
          [void Function(ZCSRFCPUBLISELECTBYNUMEXPResponseBuilder)? updates]) =>
      (ZCSRFCPUBLISELECTBYNUMEXPResponseBuilder()..update(updates))._build();

  _$ZCSRFCPUBLISELECTBYNUMEXPResponse._(
      {this.adjuntar, this.isubrc, this.publicacionportal, this.resultado})
      : super._();
  @override
  ZCSRFCPUBLISELECTBYNUMEXPResponse rebuild(
          void Function(ZCSRFCPUBLISELECTBYNUMEXPResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ZCSRFCPUBLISELECTBYNUMEXPResponseBuilder toBuilder() =>
      ZCSRFCPUBLISELECTBYNUMEXPResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ZCSRFCPUBLISELECTBYNUMEXPResponse &&
        adjuntar == other.adjuntar &&
        isubrc == other.isubrc &&
        publicacionportal == other.publicacionportal &&
        resultado == other.resultado;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, adjuntar.hashCode);
    _$hash = $jc(_$hash, isubrc.hashCode);
    _$hash = $jc(_$hash, publicacionportal.hashCode);
    _$hash = $jc(_$hash, resultado.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ZCSRFCPUBLISELECTBYNUMEXPResponse')
          ..add('adjuntar', adjuntar)
          ..add('isubrc', isubrc)
          ..add('publicacionportal', publicacionportal)
          ..add('resultado', resultado))
        .toString();
  }
}

class ZCSRFCPUBLISELECTBYNUMEXPResponseBuilder
    implements
        Builder<ZCSRFCPUBLISELECTBYNUMEXPResponse,
            ZCSRFCPUBLISELECTBYNUMEXPResponseBuilder> {
  _$ZCSRFCPUBLISELECTBYNUMEXPResponse? _$v;

  String? _adjuntar;
  String? get adjuntar => _$this._adjuntar;
  set adjuntar(String? adjuntar) => _$this._adjuntar = adjuntar;

  int? _isubrc;
  int? get isubrc => _$this._isubrc;
  set isubrc(int? isubrc) => _$this._isubrc = isubrc;

  ZCSSTPUBPORTALBuilder? _publicacionportal;
  ZCSSTPUBPORTALBuilder get publicacionportal =>
      _$this._publicacionportal ??= ZCSSTPUBPORTALBuilder();
  set publicacionportal(ZCSSTPUBPORTALBuilder? publicacionportal) =>
      _$this._publicacionportal = publicacionportal;

  String? _resultado;
  String? get resultado => _$this._resultado;
  set resultado(String? resultado) => _$this._resultado = resultado;

  ZCSRFCPUBLISELECTBYNUMEXPResponseBuilder() {
    ZCSRFCPUBLISELECTBYNUMEXPResponse._defaults(this);
  }

  ZCSRFCPUBLISELECTBYNUMEXPResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _adjuntar = $v.adjuntar;
      _isubrc = $v.isubrc;
      _publicacionportal = $v.publicacionportal?.toBuilder();
      _resultado = $v.resultado;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ZCSRFCPUBLISELECTBYNUMEXPResponse other) {
    _$v = other as _$ZCSRFCPUBLISELECTBYNUMEXPResponse;
  }

  @override
  void update(
      void Function(ZCSRFCPUBLISELECTBYNUMEXPResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ZCSRFCPUBLISELECTBYNUMEXPResponse build() => _build();

  _$ZCSRFCPUBLISELECTBYNUMEXPResponse _build() {
    _$ZCSRFCPUBLISELECTBYNUMEXPResponse _$result;
    try {
      _$result = _$v ??
          _$ZCSRFCPUBLISELECTBYNUMEXPResponse._(
            adjuntar: adjuntar,
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
            r'ZCSRFCPUBLISELECTBYNUMEXPResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
