// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'zcsrfcpubliselectbynumreg.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ZCSRFCPUBLISELECTBYNUMREG extends ZCSRFCPUBLISELECTBYNUMREG {
  @override
  final String pnumdoc;
  @override
  final String pregistro;
  @override
  final String ptipodoc;

  factory _$ZCSRFCPUBLISELECTBYNUMREG(
          [void Function(ZCSRFCPUBLISELECTBYNUMREGBuilder)? updates]) =>
      (ZCSRFCPUBLISELECTBYNUMREGBuilder()..update(updates))._build();

  _$ZCSRFCPUBLISELECTBYNUMREG._(
      {required this.pnumdoc, required this.pregistro, required this.ptipodoc})
      : super._();
  @override
  ZCSRFCPUBLISELECTBYNUMREG rebuild(
          void Function(ZCSRFCPUBLISELECTBYNUMREGBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ZCSRFCPUBLISELECTBYNUMREGBuilder toBuilder() =>
      ZCSRFCPUBLISELECTBYNUMREGBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ZCSRFCPUBLISELECTBYNUMREG &&
        pnumdoc == other.pnumdoc &&
        pregistro == other.pregistro &&
        ptipodoc == other.ptipodoc;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, pnumdoc.hashCode);
    _$hash = $jc(_$hash, pregistro.hashCode);
    _$hash = $jc(_$hash, ptipodoc.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ZCSRFCPUBLISELECTBYNUMREG')
          ..add('pnumdoc', pnumdoc)
          ..add('pregistro', pregistro)
          ..add('ptipodoc', ptipodoc))
        .toString();
  }
}

class ZCSRFCPUBLISELECTBYNUMREGBuilder
    implements
        Builder<ZCSRFCPUBLISELECTBYNUMREG, ZCSRFCPUBLISELECTBYNUMREGBuilder> {
  _$ZCSRFCPUBLISELECTBYNUMREG? _$v;

  String? _pnumdoc;
  String? get pnumdoc => _$this._pnumdoc;
  set pnumdoc(String? pnumdoc) => _$this._pnumdoc = pnumdoc;

  String? _pregistro;
  String? get pregistro => _$this._pregistro;
  set pregistro(String? pregistro) => _$this._pregistro = pregistro;

  String? _ptipodoc;
  String? get ptipodoc => _$this._ptipodoc;
  set ptipodoc(String? ptipodoc) => _$this._ptipodoc = ptipodoc;

  ZCSRFCPUBLISELECTBYNUMREGBuilder() {
    ZCSRFCPUBLISELECTBYNUMREG._defaults(this);
  }

  ZCSRFCPUBLISELECTBYNUMREGBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _pnumdoc = $v.pnumdoc;
      _pregistro = $v.pregistro;
      _ptipodoc = $v.ptipodoc;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ZCSRFCPUBLISELECTBYNUMREG other) {
    _$v = other as _$ZCSRFCPUBLISELECTBYNUMREG;
  }

  @override
  void update(void Function(ZCSRFCPUBLISELECTBYNUMREGBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ZCSRFCPUBLISELECTBYNUMREG build() => _build();

  _$ZCSRFCPUBLISELECTBYNUMREG _build() {
    final _$result = _$v ??
        _$ZCSRFCPUBLISELECTBYNUMREG._(
          pnumdoc: BuiltValueNullFieldError.checkNotNull(
              pnumdoc, r'ZCSRFCPUBLISELECTBYNUMREG', 'pnumdoc'),
          pregistro: BuiltValueNullFieldError.checkNotNull(
              pregistro, r'ZCSRFCPUBLISELECTBYNUMREG', 'pregistro'),
          ptipodoc: BuiltValueNullFieldError.checkNotNull(
              ptipodoc, r'ZCSRFCPUBLISELECTBYNUMREG', 'ptipodoc'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
