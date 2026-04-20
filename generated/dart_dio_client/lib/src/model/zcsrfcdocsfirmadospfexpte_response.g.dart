// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'zcsrfcdocsfirmadospfexpte_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ZCSRFCDOCSFIRMADOSPFEXPTEResponse
    extends ZCSRFCDOCSFIRMADOSPFEXPTEResponse {
  @override
  final ETLISTDOCS? etlistdocs;
  @override
  final ETRETURN? etreturn;

  factory _$ZCSRFCDOCSFIRMADOSPFEXPTEResponse(
          [void Function(ZCSRFCDOCSFIRMADOSPFEXPTEResponseBuilder)? updates]) =>
      (ZCSRFCDOCSFIRMADOSPFEXPTEResponseBuilder()..update(updates))._build();

  _$ZCSRFCDOCSFIRMADOSPFEXPTEResponse._({this.etlistdocs, this.etreturn})
      : super._();
  @override
  ZCSRFCDOCSFIRMADOSPFEXPTEResponse rebuild(
          void Function(ZCSRFCDOCSFIRMADOSPFEXPTEResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ZCSRFCDOCSFIRMADOSPFEXPTEResponseBuilder toBuilder() =>
      ZCSRFCDOCSFIRMADOSPFEXPTEResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ZCSRFCDOCSFIRMADOSPFEXPTEResponse &&
        etlistdocs == other.etlistdocs &&
        etreturn == other.etreturn;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, etlistdocs.hashCode);
    _$hash = $jc(_$hash, etreturn.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ZCSRFCDOCSFIRMADOSPFEXPTEResponse')
          ..add('etlistdocs', etlistdocs)
          ..add('etreturn', etreturn))
        .toString();
  }
}

class ZCSRFCDOCSFIRMADOSPFEXPTEResponseBuilder
    implements
        Builder<ZCSRFCDOCSFIRMADOSPFEXPTEResponse,
            ZCSRFCDOCSFIRMADOSPFEXPTEResponseBuilder> {
  _$ZCSRFCDOCSFIRMADOSPFEXPTEResponse? _$v;

  ETLISTDOCSBuilder? _etlistdocs;
  ETLISTDOCSBuilder get etlistdocs =>
      _$this._etlistdocs ??= ETLISTDOCSBuilder();
  set etlistdocs(ETLISTDOCSBuilder? etlistdocs) =>
      _$this._etlistdocs = etlistdocs;

  ETRETURNBuilder? _etreturn;
  ETRETURNBuilder get etreturn => _$this._etreturn ??= ETRETURNBuilder();
  set etreturn(ETRETURNBuilder? etreturn) => _$this._etreturn = etreturn;

  ZCSRFCDOCSFIRMADOSPFEXPTEResponseBuilder() {
    ZCSRFCDOCSFIRMADOSPFEXPTEResponse._defaults(this);
  }

  ZCSRFCDOCSFIRMADOSPFEXPTEResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _etlistdocs = $v.etlistdocs?.toBuilder();
      _etreturn = $v.etreturn?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ZCSRFCDOCSFIRMADOSPFEXPTEResponse other) {
    _$v = other as _$ZCSRFCDOCSFIRMADOSPFEXPTEResponse;
  }

  @override
  void update(
      void Function(ZCSRFCDOCSFIRMADOSPFEXPTEResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ZCSRFCDOCSFIRMADOSPFEXPTEResponse build() => _build();

  _$ZCSRFCDOCSFIRMADOSPFEXPTEResponse _build() {
    _$ZCSRFCDOCSFIRMADOSPFEXPTEResponse _$result;
    try {
      _$result = _$v ??
          _$ZCSRFCDOCSFIRMADOSPFEXPTEResponse._(
            etlistdocs: _etlistdocs?.build(),
            etreturn: _etreturn?.build(),
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
            r'ZCSRFCDOCSFIRMADOSPFEXPTEResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
