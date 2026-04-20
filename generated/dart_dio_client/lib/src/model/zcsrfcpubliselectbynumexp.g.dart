// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'zcsrfcpubliselectbynumexp.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ZCSRFCPUBLISELECTBYNUMEXP extends ZCSRFCPUBLISELECTBYNUMEXP {
  @override
  final String pnumdoc;
  @override
  final String pnumexp;
  @override
  final String ptipodoc;

  factory _$ZCSRFCPUBLISELECTBYNUMEXP(
          [void Function(ZCSRFCPUBLISELECTBYNUMEXPBuilder)? updates]) =>
      (ZCSRFCPUBLISELECTBYNUMEXPBuilder()..update(updates))._build();

  _$ZCSRFCPUBLISELECTBYNUMEXP._(
      {required this.pnumdoc, required this.pnumexp, required this.ptipodoc})
      : super._();
  @override
  ZCSRFCPUBLISELECTBYNUMEXP rebuild(
          void Function(ZCSRFCPUBLISELECTBYNUMEXPBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ZCSRFCPUBLISELECTBYNUMEXPBuilder toBuilder() =>
      ZCSRFCPUBLISELECTBYNUMEXPBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ZCSRFCPUBLISELECTBYNUMEXP &&
        pnumdoc == other.pnumdoc &&
        pnumexp == other.pnumexp &&
        ptipodoc == other.ptipodoc;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, pnumdoc.hashCode);
    _$hash = $jc(_$hash, pnumexp.hashCode);
    _$hash = $jc(_$hash, ptipodoc.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ZCSRFCPUBLISELECTBYNUMEXP')
          ..add('pnumdoc', pnumdoc)
          ..add('pnumexp', pnumexp)
          ..add('ptipodoc', ptipodoc))
        .toString();
  }
}

class ZCSRFCPUBLISELECTBYNUMEXPBuilder
    implements
        Builder<ZCSRFCPUBLISELECTBYNUMEXP, ZCSRFCPUBLISELECTBYNUMEXPBuilder> {
  _$ZCSRFCPUBLISELECTBYNUMEXP? _$v;

  String? _pnumdoc;
  String? get pnumdoc => _$this._pnumdoc;
  set pnumdoc(String? pnumdoc) => _$this._pnumdoc = pnumdoc;

  String? _pnumexp;
  String? get pnumexp => _$this._pnumexp;
  set pnumexp(String? pnumexp) => _$this._pnumexp = pnumexp;

  String? _ptipodoc;
  String? get ptipodoc => _$this._ptipodoc;
  set ptipodoc(String? ptipodoc) => _$this._ptipodoc = ptipodoc;

  ZCSRFCPUBLISELECTBYNUMEXPBuilder() {
    ZCSRFCPUBLISELECTBYNUMEXP._defaults(this);
  }

  ZCSRFCPUBLISELECTBYNUMEXPBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _pnumdoc = $v.pnumdoc;
      _pnumexp = $v.pnumexp;
      _ptipodoc = $v.ptipodoc;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ZCSRFCPUBLISELECTBYNUMEXP other) {
    _$v = other as _$ZCSRFCPUBLISELECTBYNUMEXP;
  }

  @override
  void update(void Function(ZCSRFCPUBLISELECTBYNUMEXPBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ZCSRFCPUBLISELECTBYNUMEXP build() => _build();

  _$ZCSRFCPUBLISELECTBYNUMEXP _build() {
    final _$result = _$v ??
        _$ZCSRFCPUBLISELECTBYNUMEXP._(
          pnumdoc: BuiltValueNullFieldError.checkNotNull(
              pnumdoc, r'ZCSRFCPUBLISELECTBYNUMEXP', 'pnumdoc'),
          pnumexp: BuiltValueNullFieldError.checkNotNull(
              pnumexp, r'ZCSRFCPUBLISELECTBYNUMEXP', 'pnumexp'),
          ptipodoc: BuiltValueNullFieldError.checkNotNull(
              ptipodoc, r'ZCSRFCPUBLISELECTBYNUMEXP', 'ptipodoc'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
