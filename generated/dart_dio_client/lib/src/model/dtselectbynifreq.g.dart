// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dtselectbynifreq.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DTSELECTBYNIFREQ extends DTSELECTBYNIFREQ {
  @override
  final String? numerodocumento;
  @override
  final String? tipodoc;

  factory _$DTSELECTBYNIFREQ(
          [void Function(DTSELECTBYNIFREQBuilder)? updates]) =>
      (DTSELECTBYNIFREQBuilder()..update(updates))._build();

  _$DTSELECTBYNIFREQ._({this.numerodocumento, this.tipodoc}) : super._();
  @override
  DTSELECTBYNIFREQ rebuild(void Function(DTSELECTBYNIFREQBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DTSELECTBYNIFREQBuilder toBuilder() =>
      DTSELECTBYNIFREQBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DTSELECTBYNIFREQ &&
        numerodocumento == other.numerodocumento &&
        tipodoc == other.tipodoc;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, numerodocumento.hashCode);
    _$hash = $jc(_$hash, tipodoc.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DTSELECTBYNIFREQ')
          ..add('numerodocumento', numerodocumento)
          ..add('tipodoc', tipodoc))
        .toString();
  }
}

class DTSELECTBYNIFREQBuilder
    implements Builder<DTSELECTBYNIFREQ, DTSELECTBYNIFREQBuilder> {
  _$DTSELECTBYNIFREQ? _$v;

  String? _numerodocumento;
  String? get numerodocumento => _$this._numerodocumento;
  set numerodocumento(String? numerodocumento) =>
      _$this._numerodocumento = numerodocumento;

  String? _tipodoc;
  String? get tipodoc => _$this._tipodoc;
  set tipodoc(String? tipodoc) => _$this._tipodoc = tipodoc;

  DTSELECTBYNIFREQBuilder() {
    DTSELECTBYNIFREQ._defaults(this);
  }

  DTSELECTBYNIFREQBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _numerodocumento = $v.numerodocumento;
      _tipodoc = $v.tipodoc;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DTSELECTBYNIFREQ other) {
    _$v = other as _$DTSELECTBYNIFREQ;
  }

  @override
  void update(void Function(DTSELECTBYNIFREQBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DTSELECTBYNIFREQ build() => _build();

  _$DTSELECTBYNIFREQ _build() {
    final _$result = _$v ??
        _$DTSELECTBYNIFREQ._(
          numerodocumento: numerodocumento,
          tipodoc: tipodoc,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
