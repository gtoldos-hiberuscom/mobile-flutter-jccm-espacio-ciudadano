// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'zcssportal.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ZCSSPORTAL extends ZCSSPORTAL {
  @override
  final String? ejeexp;
  @override
  final String? numexp;
  @override
  final String? subfam;

  factory _$ZCSSPORTAL([void Function(ZCSSPORTALBuilder)? updates]) =>
      (ZCSSPORTALBuilder()..update(updates))._build();

  _$ZCSSPORTAL._({this.ejeexp, this.numexp, this.subfam}) : super._();
  @override
  ZCSSPORTAL rebuild(void Function(ZCSSPORTALBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ZCSSPORTALBuilder toBuilder() => ZCSSPORTALBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ZCSSPORTAL &&
        ejeexp == other.ejeexp &&
        numexp == other.numexp &&
        subfam == other.subfam;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, ejeexp.hashCode);
    _$hash = $jc(_$hash, numexp.hashCode);
    _$hash = $jc(_$hash, subfam.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ZCSSPORTAL')
          ..add('ejeexp', ejeexp)
          ..add('numexp', numexp)
          ..add('subfam', subfam))
        .toString();
  }
}

class ZCSSPORTALBuilder implements Builder<ZCSSPORTAL, ZCSSPORTALBuilder> {
  _$ZCSSPORTAL? _$v;

  String? _ejeexp;
  String? get ejeexp => _$this._ejeexp;
  set ejeexp(String? ejeexp) => _$this._ejeexp = ejeexp;

  String? _numexp;
  String? get numexp => _$this._numexp;
  set numexp(String? numexp) => _$this._numexp = numexp;

  String? _subfam;
  String? get subfam => _$this._subfam;
  set subfam(String? subfam) => _$this._subfam = subfam;

  ZCSSPORTALBuilder() {
    ZCSSPORTAL._defaults(this);
  }

  ZCSSPORTALBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _ejeexp = $v.ejeexp;
      _numexp = $v.numexp;
      _subfam = $v.subfam;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ZCSSPORTAL other) {
    _$v = other as _$ZCSSPORTAL;
  }

  @override
  void update(void Function(ZCSSPORTALBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ZCSSPORTAL build() => _build();

  _$ZCSSPORTAL _build() {
    final _$result = _$v ??
        _$ZCSSPORTAL._(
          ejeexp: ejeexp,
          numexp: numexp,
          subfam: subfam,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
