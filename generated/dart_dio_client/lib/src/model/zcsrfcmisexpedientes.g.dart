// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'zcsrfcmisexpedientes.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ZCSRFCMISEXPEDIENTES extends ZCSRFCMISEXPEDIENTES {
  @override
  final String? pdescproc;
  @override
  final String? pestado;
  @override
  final String? pfechadesde;
  @override
  final String? pfechahasta;
  @override
  final String pnumdoc;

  factory _$ZCSRFCMISEXPEDIENTES(
          [void Function(ZCSRFCMISEXPEDIENTESBuilder)? updates]) =>
      (ZCSRFCMISEXPEDIENTESBuilder()..update(updates))._build();

  _$ZCSRFCMISEXPEDIENTES._(
      {this.pdescproc,
      this.pestado,
      this.pfechadesde,
      this.pfechahasta,
      required this.pnumdoc})
      : super._();
  @override
  ZCSRFCMISEXPEDIENTES rebuild(
          void Function(ZCSRFCMISEXPEDIENTESBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ZCSRFCMISEXPEDIENTESBuilder toBuilder() =>
      ZCSRFCMISEXPEDIENTESBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ZCSRFCMISEXPEDIENTES &&
        pdescproc == other.pdescproc &&
        pestado == other.pestado &&
        pfechadesde == other.pfechadesde &&
        pfechahasta == other.pfechahasta &&
        pnumdoc == other.pnumdoc;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, pdescproc.hashCode);
    _$hash = $jc(_$hash, pestado.hashCode);
    _$hash = $jc(_$hash, pfechadesde.hashCode);
    _$hash = $jc(_$hash, pfechahasta.hashCode);
    _$hash = $jc(_$hash, pnumdoc.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ZCSRFCMISEXPEDIENTES')
          ..add('pdescproc', pdescproc)
          ..add('pestado', pestado)
          ..add('pfechadesde', pfechadesde)
          ..add('pfechahasta', pfechahasta)
          ..add('pnumdoc', pnumdoc))
        .toString();
  }
}

class ZCSRFCMISEXPEDIENTESBuilder
    implements Builder<ZCSRFCMISEXPEDIENTES, ZCSRFCMISEXPEDIENTESBuilder> {
  _$ZCSRFCMISEXPEDIENTES? _$v;

  String? _pdescproc;
  String? get pdescproc => _$this._pdescproc;
  set pdescproc(String? pdescproc) => _$this._pdescproc = pdescproc;

  String? _pestado;
  String? get pestado => _$this._pestado;
  set pestado(String? pestado) => _$this._pestado = pestado;

  String? _pfechadesde;
  String? get pfechadesde => _$this._pfechadesde;
  set pfechadesde(String? pfechadesde) => _$this._pfechadesde = pfechadesde;

  String? _pfechahasta;
  String? get pfechahasta => _$this._pfechahasta;
  set pfechahasta(String? pfechahasta) => _$this._pfechahasta = pfechahasta;

  String? _pnumdoc;
  String? get pnumdoc => _$this._pnumdoc;
  set pnumdoc(String? pnumdoc) => _$this._pnumdoc = pnumdoc;

  ZCSRFCMISEXPEDIENTESBuilder() {
    ZCSRFCMISEXPEDIENTES._defaults(this);
  }

  ZCSRFCMISEXPEDIENTESBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _pdescproc = $v.pdescproc;
      _pestado = $v.pestado;
      _pfechadesde = $v.pfechadesde;
      _pfechahasta = $v.pfechahasta;
      _pnumdoc = $v.pnumdoc;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ZCSRFCMISEXPEDIENTES other) {
    _$v = other as _$ZCSRFCMISEXPEDIENTES;
  }

  @override
  void update(void Function(ZCSRFCMISEXPEDIENTESBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ZCSRFCMISEXPEDIENTES build() => _build();

  _$ZCSRFCMISEXPEDIENTES _build() {
    final _$result = _$v ??
        _$ZCSRFCMISEXPEDIENTES._(
          pdescproc: pdescproc,
          pestado: pestado,
          pfechadesde: pfechadesde,
          pfechahasta: pfechahasta,
          pnumdoc: BuiltValueNullFieldError.checkNotNull(
              pnumdoc, r'ZCSRFCMISEXPEDIENTES', 'pnumdoc'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
