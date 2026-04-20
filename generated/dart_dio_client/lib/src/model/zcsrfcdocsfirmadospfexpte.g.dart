// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'zcsrfcdocsfirmadospfexpte.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ZCSRFCDOCSFIRMADOSPFEXPTE extends ZCSRFCDOCSFIRMADOSPFEXPTE {
  @override
  final ETLISTDOCS? etlistdocs;
  @override
  final ETRETURN? etreturn;
  @override
  final String? ipclase;
  @override
  final String? ipejeexp;
  @override
  final String? ipnumexp;
  @override
  final String? iprefdoc;

  factory _$ZCSRFCDOCSFIRMADOSPFEXPTE(
          [void Function(ZCSRFCDOCSFIRMADOSPFEXPTEBuilder)? updates]) =>
      (ZCSRFCDOCSFIRMADOSPFEXPTEBuilder()..update(updates))._build();

  _$ZCSRFCDOCSFIRMADOSPFEXPTE._(
      {this.etlistdocs,
      this.etreturn,
      this.ipclase,
      this.ipejeexp,
      this.ipnumexp,
      this.iprefdoc})
      : super._();
  @override
  ZCSRFCDOCSFIRMADOSPFEXPTE rebuild(
          void Function(ZCSRFCDOCSFIRMADOSPFEXPTEBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ZCSRFCDOCSFIRMADOSPFEXPTEBuilder toBuilder() =>
      ZCSRFCDOCSFIRMADOSPFEXPTEBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ZCSRFCDOCSFIRMADOSPFEXPTE &&
        etlistdocs == other.etlistdocs &&
        etreturn == other.etreturn &&
        ipclase == other.ipclase &&
        ipejeexp == other.ipejeexp &&
        ipnumexp == other.ipnumexp &&
        iprefdoc == other.iprefdoc;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, etlistdocs.hashCode);
    _$hash = $jc(_$hash, etreturn.hashCode);
    _$hash = $jc(_$hash, ipclase.hashCode);
    _$hash = $jc(_$hash, ipejeexp.hashCode);
    _$hash = $jc(_$hash, ipnumexp.hashCode);
    _$hash = $jc(_$hash, iprefdoc.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ZCSRFCDOCSFIRMADOSPFEXPTE')
          ..add('etlistdocs', etlistdocs)
          ..add('etreturn', etreturn)
          ..add('ipclase', ipclase)
          ..add('ipejeexp', ipejeexp)
          ..add('ipnumexp', ipnumexp)
          ..add('iprefdoc', iprefdoc))
        .toString();
  }
}

class ZCSRFCDOCSFIRMADOSPFEXPTEBuilder
    implements
        Builder<ZCSRFCDOCSFIRMADOSPFEXPTE, ZCSRFCDOCSFIRMADOSPFEXPTEBuilder> {
  _$ZCSRFCDOCSFIRMADOSPFEXPTE? _$v;

  ETLISTDOCSBuilder? _etlistdocs;
  ETLISTDOCSBuilder get etlistdocs =>
      _$this._etlistdocs ??= ETLISTDOCSBuilder();
  set etlistdocs(ETLISTDOCSBuilder? etlistdocs) =>
      _$this._etlistdocs = etlistdocs;

  ETRETURNBuilder? _etreturn;
  ETRETURNBuilder get etreturn => _$this._etreturn ??= ETRETURNBuilder();
  set etreturn(ETRETURNBuilder? etreturn) => _$this._etreturn = etreturn;

  String? _ipclase;
  String? get ipclase => _$this._ipclase;
  set ipclase(String? ipclase) => _$this._ipclase = ipclase;

  String? _ipejeexp;
  String? get ipejeexp => _$this._ipejeexp;
  set ipejeexp(String? ipejeexp) => _$this._ipejeexp = ipejeexp;

  String? _ipnumexp;
  String? get ipnumexp => _$this._ipnumexp;
  set ipnumexp(String? ipnumexp) => _$this._ipnumexp = ipnumexp;

  String? _iprefdoc;
  String? get iprefdoc => _$this._iprefdoc;
  set iprefdoc(String? iprefdoc) => _$this._iprefdoc = iprefdoc;

  ZCSRFCDOCSFIRMADOSPFEXPTEBuilder() {
    ZCSRFCDOCSFIRMADOSPFEXPTE._defaults(this);
  }

  ZCSRFCDOCSFIRMADOSPFEXPTEBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _etlistdocs = $v.etlistdocs?.toBuilder();
      _etreturn = $v.etreturn?.toBuilder();
      _ipclase = $v.ipclase;
      _ipejeexp = $v.ipejeexp;
      _ipnumexp = $v.ipnumexp;
      _iprefdoc = $v.iprefdoc;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ZCSRFCDOCSFIRMADOSPFEXPTE other) {
    _$v = other as _$ZCSRFCDOCSFIRMADOSPFEXPTE;
  }

  @override
  void update(void Function(ZCSRFCDOCSFIRMADOSPFEXPTEBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ZCSRFCDOCSFIRMADOSPFEXPTE build() => _build();

  _$ZCSRFCDOCSFIRMADOSPFEXPTE _build() {
    _$ZCSRFCDOCSFIRMADOSPFEXPTE _$result;
    try {
      _$result = _$v ??
          _$ZCSRFCDOCSFIRMADOSPFEXPTE._(
            etlistdocs: _etlistdocs?.build(),
            etreturn: _etreturn?.build(),
            ipclase: ipclase,
            ipejeexp: ipejeexp,
            ipnumexp: ipnumexp,
            iprefdoc: iprefdoc,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'etlistdocs';
        _etlistdocs?.build();
        _$failedField = 'etreturn';
        _etreturn?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ZCSRFCDOCSFIRMADOSPFEXPTE', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
