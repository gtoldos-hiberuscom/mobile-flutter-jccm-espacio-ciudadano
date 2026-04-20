// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'zcsrfcpubliselectbynif_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ZCSRFCPUBLISELECTBYNIFResponse extends ZCSRFCPUBLISELECTBYNIFResponse {
  @override
  final int? isubrc;
  @override
  final PUBLICACIONPORTAL? publicacionportal;
  @override
  final String? resultado;

  factory _$ZCSRFCPUBLISELECTBYNIFResponse(
          [void Function(ZCSRFCPUBLISELECTBYNIFResponseBuilder)? updates]) =>
      (ZCSRFCPUBLISELECTBYNIFResponseBuilder()..update(updates))._build();

  _$ZCSRFCPUBLISELECTBYNIFResponse._(
      {this.isubrc, this.publicacionportal, this.resultado})
      : super._();
  @override
  ZCSRFCPUBLISELECTBYNIFResponse rebuild(
          void Function(ZCSRFCPUBLISELECTBYNIFResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ZCSRFCPUBLISELECTBYNIFResponseBuilder toBuilder() =>
      ZCSRFCPUBLISELECTBYNIFResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ZCSRFCPUBLISELECTBYNIFResponse &&
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
    return (newBuiltValueToStringHelper(r'ZCSRFCPUBLISELECTBYNIFResponse')
          ..add('isubrc', isubrc)
          ..add('publicacionportal', publicacionportal)
          ..add('resultado', resultado))
        .toString();
  }
}

class ZCSRFCPUBLISELECTBYNIFResponseBuilder
    implements
        Builder<ZCSRFCPUBLISELECTBYNIFResponse,
            ZCSRFCPUBLISELECTBYNIFResponseBuilder> {
  _$ZCSRFCPUBLISELECTBYNIFResponse? _$v;

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

  ZCSRFCPUBLISELECTBYNIFResponseBuilder() {
    ZCSRFCPUBLISELECTBYNIFResponse._defaults(this);
  }

  ZCSRFCPUBLISELECTBYNIFResponseBuilder get _$this {
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
  void replace(ZCSRFCPUBLISELECTBYNIFResponse other) {
    _$v = other as _$ZCSRFCPUBLISELECTBYNIFResponse;
  }

  @override
  void update(void Function(ZCSRFCPUBLISELECTBYNIFResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ZCSRFCPUBLISELECTBYNIFResponse build() => _build();

  _$ZCSRFCPUBLISELECTBYNIFResponse _build() {
    _$ZCSRFCPUBLISELECTBYNIFResponse _$result;
    try {
      _$result = _$v ??
          _$ZCSRFCPUBLISELECTBYNIFResponse._(
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
            r'ZCSRFCPUBLISELECTBYNIFResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
