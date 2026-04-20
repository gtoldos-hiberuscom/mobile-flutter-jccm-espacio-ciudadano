// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'zcsrfcpubliselectbynumreg_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ZCSRFCPUBLISELECTBYNUMREGResponse
    extends ZCSRFCPUBLISELECTBYNUMREGResponse {
  @override
  final String? adjuntar;
  @override
  final int? isubrc;
  @override
  final PUBLICACIONPORTAL? publicacionportal;
  @override
  final String? resultado;

  factory _$ZCSRFCPUBLISELECTBYNUMREGResponse(
          [void Function(ZCSRFCPUBLISELECTBYNUMREGResponseBuilder)? updates]) =>
      (ZCSRFCPUBLISELECTBYNUMREGResponseBuilder()..update(updates))._build();

  _$ZCSRFCPUBLISELECTBYNUMREGResponse._(
      {this.adjuntar, this.isubrc, this.publicacionportal, this.resultado})
      : super._();
  @override
  ZCSRFCPUBLISELECTBYNUMREGResponse rebuild(
          void Function(ZCSRFCPUBLISELECTBYNUMREGResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ZCSRFCPUBLISELECTBYNUMREGResponseBuilder toBuilder() =>
      ZCSRFCPUBLISELECTBYNUMREGResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ZCSRFCPUBLISELECTBYNUMREGResponse &&
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
    return (newBuiltValueToStringHelper(r'ZCSRFCPUBLISELECTBYNUMREGResponse')
          ..add('adjuntar', adjuntar)
          ..add('isubrc', isubrc)
          ..add('publicacionportal', publicacionportal)
          ..add('resultado', resultado))
        .toString();
  }
}

class ZCSRFCPUBLISELECTBYNUMREGResponseBuilder
    implements
        Builder<ZCSRFCPUBLISELECTBYNUMREGResponse,
            ZCSRFCPUBLISELECTBYNUMREGResponseBuilder> {
  _$ZCSRFCPUBLISELECTBYNUMREGResponse? _$v;

  String? _adjuntar;
  String? get adjuntar => _$this._adjuntar;
  set adjuntar(String? adjuntar) => _$this._adjuntar = adjuntar;

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

  ZCSRFCPUBLISELECTBYNUMREGResponseBuilder() {
    ZCSRFCPUBLISELECTBYNUMREGResponse._defaults(this);
  }

  ZCSRFCPUBLISELECTBYNUMREGResponseBuilder get _$this {
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
  void replace(ZCSRFCPUBLISELECTBYNUMREGResponse other) {
    _$v = other as _$ZCSRFCPUBLISELECTBYNUMREGResponse;
  }

  @override
  void update(
      void Function(ZCSRFCPUBLISELECTBYNUMREGResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ZCSRFCPUBLISELECTBYNUMREGResponse build() => _build();

  _$ZCSRFCPUBLISELECTBYNUMREGResponse _build() {
    _$ZCSRFCPUBLISELECTBYNUMREGResponse _$result;
    try {
      _$result = _$v ??
          _$ZCSRFCPUBLISELECTBYNUMREGResponse._(
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
            r'ZCSRFCPUBLISELECTBYNUMREGResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
