// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehiculo.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VEHICULO extends VEHICULO {
  @override
  final String? matricula;

  factory _$VEHICULO([void Function(VEHICULOBuilder)? updates]) =>
      (VEHICULOBuilder()..update(updates))._build();

  _$VEHICULO._({this.matricula}) : super._();
  @override
  VEHICULO rebuild(void Function(VEHICULOBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VEHICULOBuilder toBuilder() => VEHICULOBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VEHICULO && matricula == other.matricula;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, matricula.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VEHICULO')
          ..add('matricula', matricula))
        .toString();
  }
}

class VEHICULOBuilder implements Builder<VEHICULO, VEHICULOBuilder> {
  _$VEHICULO? _$v;

  String? _matricula;
  String? get matricula => _$this._matricula;
  set matricula(String? matricula) => _$this._matricula = matricula;

  VEHICULOBuilder() {
    VEHICULO._defaults(this);
  }

  VEHICULOBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _matricula = $v.matricula;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VEHICULO other) {
    _$v = other as _$VEHICULO;
  }

  @override
  void update(void Function(VEHICULOBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VEHICULO build() => _build();

  _$VEHICULO _build() {
    final _$result = _$v ??
        _$VEHICULO._(
          matricula: matricula,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
