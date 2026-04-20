// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'zcsrfcconsultafaq_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ZCSRFCCONSULTAFAQResponse extends ZCSRFCCONSULTAFAQResponse {
  @override
  final int? isubrc;
  @override
  final String? return_;
  @override
  final RETURNS returns;
  @override
  final TFAQ tfaq;

  factory _$ZCSRFCCONSULTAFAQResponse(
          [void Function(ZCSRFCCONSULTAFAQResponseBuilder)? updates]) =>
      (ZCSRFCCONSULTAFAQResponseBuilder()..update(updates))._build();

  _$ZCSRFCCONSULTAFAQResponse._(
      {this.isubrc, this.return_, required this.returns, required this.tfaq})
      : super._();
  @override
  ZCSRFCCONSULTAFAQResponse rebuild(
          void Function(ZCSRFCCONSULTAFAQResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ZCSRFCCONSULTAFAQResponseBuilder toBuilder() =>
      ZCSRFCCONSULTAFAQResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ZCSRFCCONSULTAFAQResponse &&
        isubrc == other.isubrc &&
        return_ == other.return_ &&
        returns == other.returns &&
        tfaq == other.tfaq;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, isubrc.hashCode);
    _$hash = $jc(_$hash, return_.hashCode);
    _$hash = $jc(_$hash, returns.hashCode);
    _$hash = $jc(_$hash, tfaq.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ZCSRFCCONSULTAFAQResponse')
          ..add('isubrc', isubrc)
          ..add('return_', return_)
          ..add('returns', returns)
          ..add('tfaq', tfaq))
        .toString();
  }
}

class ZCSRFCCONSULTAFAQResponseBuilder
    implements
        Builder<ZCSRFCCONSULTAFAQResponse, ZCSRFCCONSULTAFAQResponseBuilder> {
  _$ZCSRFCCONSULTAFAQResponse? _$v;

  int? _isubrc;
  int? get isubrc => _$this._isubrc;
  set isubrc(int? isubrc) => _$this._isubrc = isubrc;

  String? _return_;
  String? get return_ => _$this._return_;
  set return_(String? return_) => _$this._return_ = return_;

  RETURNSBuilder? _returns;
  RETURNSBuilder get returns => _$this._returns ??= RETURNSBuilder();
  set returns(RETURNSBuilder? returns) => _$this._returns = returns;

  TFAQBuilder? _tfaq;
  TFAQBuilder get tfaq => _$this._tfaq ??= TFAQBuilder();
  set tfaq(TFAQBuilder? tfaq) => _$this._tfaq = tfaq;

  ZCSRFCCONSULTAFAQResponseBuilder() {
    ZCSRFCCONSULTAFAQResponse._defaults(this);
  }

  ZCSRFCCONSULTAFAQResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _isubrc = $v.isubrc;
      _return_ = $v.return_;
      _returns = $v.returns.toBuilder();
      _tfaq = $v.tfaq.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ZCSRFCCONSULTAFAQResponse other) {
    _$v = other as _$ZCSRFCCONSULTAFAQResponse;
  }

  @override
  void update(void Function(ZCSRFCCONSULTAFAQResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ZCSRFCCONSULTAFAQResponse build() => _build();

  _$ZCSRFCCONSULTAFAQResponse _build() {
    _$ZCSRFCCONSULTAFAQResponse _$result;
    try {
      _$result = _$v ??
          _$ZCSRFCCONSULTAFAQResponse._(
            isubrc: isubrc,
            return_: return_,
            returns: returns.build(),
            tfaq: tfaq.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'returns';
        returns.build();
        _$failedField = 'tfaq';
        tfaq.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ZCSRFCCONSULTAFAQResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
