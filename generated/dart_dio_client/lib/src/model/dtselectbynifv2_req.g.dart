// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dtselectbynifv2_req.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DTSELECTBYNIFV2REQ extends DTSELECTBYNIFV2REQ {
  @override
  final String? numerodocumento;
  @override
  final String? tipodocumento;
  @override
  final String? tipoprocedimiento;

  factory _$DTSELECTBYNIFV2REQ(
          [void Function(DTSELECTBYNIFV2REQBuilder)? updates]) =>
      (DTSELECTBYNIFV2REQBuilder()..update(updates))._build();

  _$DTSELECTBYNIFV2REQ._(
      {this.numerodocumento, this.tipodocumento, this.tipoprocedimiento})
      : super._();
  @override
  DTSELECTBYNIFV2REQ rebuild(
          void Function(DTSELECTBYNIFV2REQBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DTSELECTBYNIFV2REQBuilder toBuilder() =>
      DTSELECTBYNIFV2REQBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DTSELECTBYNIFV2REQ &&
        numerodocumento == other.numerodocumento &&
        tipodocumento == other.tipodocumento &&
        tipoprocedimiento == other.tipoprocedimiento;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, numerodocumento.hashCode);
    _$hash = $jc(_$hash, tipodocumento.hashCode);
    _$hash = $jc(_$hash, tipoprocedimiento.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DTSELECTBYNIFV2REQ')
          ..add('numerodocumento', numerodocumento)
          ..add('tipodocumento', tipodocumento)
          ..add('tipoprocedimiento', tipoprocedimiento))
        .toString();
  }
}

class DTSELECTBYNIFV2REQBuilder
    implements Builder<DTSELECTBYNIFV2REQ, DTSELECTBYNIFV2REQBuilder> {
  _$DTSELECTBYNIFV2REQ? _$v;

  String? _numerodocumento;
  String? get numerodocumento => _$this._numerodocumento;
  set numerodocumento(String? numerodocumento) =>
      _$this._numerodocumento = numerodocumento;

  String? _tipodocumento;
  String? get tipodocumento => _$this._tipodocumento;
  set tipodocumento(String? tipodocumento) =>
      _$this._tipodocumento = tipodocumento;

  String? _tipoprocedimiento;
  String? get tipoprocedimiento => _$this._tipoprocedimiento;
  set tipoprocedimiento(String? tipoprocedimiento) =>
      _$this._tipoprocedimiento = tipoprocedimiento;

  DTSELECTBYNIFV2REQBuilder() {
    DTSELECTBYNIFV2REQ._defaults(this);
  }

  DTSELECTBYNIFV2REQBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _numerodocumento = $v.numerodocumento;
      _tipodocumento = $v.tipodocumento;
      _tipoprocedimiento = $v.tipoprocedimiento;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DTSELECTBYNIFV2REQ other) {
    _$v = other as _$DTSELECTBYNIFV2REQ;
  }

  @override
  void update(void Function(DTSELECTBYNIFV2REQBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DTSELECTBYNIFV2REQ build() => _build();

  _$DTSELECTBYNIFV2REQ _build() {
    final _$result = _$v ??
        _$DTSELECTBYNIFV2REQ._(
          numerodocumento: numerodocumento,
          tipodocumento: tipodocumento,
          tipoprocedimiento: tipoprocedimiento,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
