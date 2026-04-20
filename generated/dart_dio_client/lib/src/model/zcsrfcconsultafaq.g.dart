// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'zcsrfcconsultafaq.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ZCSRFCCONSULTAFAQ extends ZCSRFCCONSULTAFAQ {
  @override
  final ZCSSPORTAL idatos;
  @override
  final RETURNS returns;
  @override
  final TFAQ tfaq;

  factory _$ZCSRFCCONSULTAFAQ(
          [void Function(ZCSRFCCONSULTAFAQBuilder)? updates]) =>
      (ZCSRFCCONSULTAFAQBuilder()..update(updates))._build();

  _$ZCSRFCCONSULTAFAQ._(
      {required this.idatos, required this.returns, required this.tfaq})
      : super._();
  @override
  ZCSRFCCONSULTAFAQ rebuild(void Function(ZCSRFCCONSULTAFAQBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ZCSRFCCONSULTAFAQBuilder toBuilder() =>
      ZCSRFCCONSULTAFAQBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ZCSRFCCONSULTAFAQ &&
        idatos == other.idatos &&
        returns == other.returns &&
        tfaq == other.tfaq;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, idatos.hashCode);
    _$hash = $jc(_$hash, returns.hashCode);
    _$hash = $jc(_$hash, tfaq.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ZCSRFCCONSULTAFAQ')
          ..add('idatos', idatos)
          ..add('returns', returns)
          ..add('tfaq', tfaq))
        .toString();
  }
}

class ZCSRFCCONSULTAFAQBuilder
    implements Builder<ZCSRFCCONSULTAFAQ, ZCSRFCCONSULTAFAQBuilder> {
  _$ZCSRFCCONSULTAFAQ? _$v;

  ZCSSPORTALBuilder? _idatos;
  ZCSSPORTALBuilder get idatos => _$this._idatos ??= ZCSSPORTALBuilder();
  set idatos(ZCSSPORTALBuilder? idatos) => _$this._idatos = idatos;

  RETURNSBuilder? _returns;
  RETURNSBuilder get returns => _$this._returns ??= RETURNSBuilder();
  set returns(RETURNSBuilder? returns) => _$this._returns = returns;

  TFAQBuilder? _tfaq;
  TFAQBuilder get tfaq => _$this._tfaq ??= TFAQBuilder();
  set tfaq(TFAQBuilder? tfaq) => _$this._tfaq = tfaq;

  ZCSRFCCONSULTAFAQBuilder() {
    ZCSRFCCONSULTAFAQ._defaults(this);
  }

  ZCSRFCCONSULTAFAQBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _idatos = $v.idatos.toBuilder();
      _returns = $v.returns.toBuilder();
      _tfaq = $v.tfaq.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ZCSRFCCONSULTAFAQ other) {
    _$v = other as _$ZCSRFCCONSULTAFAQ;
  }

  @override
  void update(void Function(ZCSRFCCONSULTAFAQBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ZCSRFCCONSULTAFAQ build() => _build();

  _$ZCSRFCCONSULTAFAQ _build() {
    _$ZCSRFCCONSULTAFAQ _$result;
    try {
      _$result = _$v ??
          _$ZCSRFCCONSULTAFAQ._(
            idatos: idatos.build(),
            returns: returns.build(),
            tfaq: tfaq.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'idatos';
        idatos.build();
        _$failedField = 'returns';
        returns.build();
        _$failedField = 'tfaq';
        tfaq.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ZCSRFCCONSULTAFAQ', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
