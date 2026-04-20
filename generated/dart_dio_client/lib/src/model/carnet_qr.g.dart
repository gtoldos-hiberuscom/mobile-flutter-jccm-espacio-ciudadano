// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'carnet_qr.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CarnetQr extends CarnetQr {
  @override
  final String? qr;

  factory _$CarnetQr([void Function(CarnetQrBuilder)? updates]) =>
      (CarnetQrBuilder()..update(updates))._build();

  _$CarnetQr._({this.qr}) : super._();
  @override
  CarnetQr rebuild(void Function(CarnetQrBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CarnetQrBuilder toBuilder() => CarnetQrBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CarnetQr && qr == other.qr;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, qr.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CarnetQr')..add('qr', qr)).toString();
  }
}

class CarnetQrBuilder implements Builder<CarnetQr, CarnetQrBuilder> {
  _$CarnetQr? _$v;

  String? _qr;
  String? get qr => _$this._qr;
  set qr(String? qr) => _$this._qr = qr;

  CarnetQrBuilder() {
    CarnetQr._defaults(this);
  }

  CarnetQrBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _qr = $v.qr;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CarnetQr other) {
    _$v = other as _$CarnetQr;
  }

  @override
  void update(void Function(CarnetQrBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CarnetQr build() => _build();

  _$CarnetQr _build() {
    final _$result = _$v ??
        _$CarnetQr._(
          qr: qr,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
