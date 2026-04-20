// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'listavehiculos.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$LISTAVEHICULOS extends LISTAVEHICULOS {
  @override
  final BuiltList<VEHICULO>? vehiculo;

  factory _$LISTAVEHICULOS([void Function(LISTAVEHICULOSBuilder)? updates]) =>
      (LISTAVEHICULOSBuilder()..update(updates))._build();

  _$LISTAVEHICULOS._({this.vehiculo}) : super._();
  @override
  LISTAVEHICULOS rebuild(void Function(LISTAVEHICULOSBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  LISTAVEHICULOSBuilder toBuilder() => LISTAVEHICULOSBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is LISTAVEHICULOS && vehiculo == other.vehiculo;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, vehiculo.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'LISTAVEHICULOS')
          ..add('vehiculo', vehiculo))
        .toString();
  }
}

class LISTAVEHICULOSBuilder
    implements Builder<LISTAVEHICULOS, LISTAVEHICULOSBuilder> {
  _$LISTAVEHICULOS? _$v;

  ListBuilder<VEHICULO>? _vehiculo;
  ListBuilder<VEHICULO> get vehiculo =>
      _$this._vehiculo ??= ListBuilder<VEHICULO>();
  set vehiculo(ListBuilder<VEHICULO>? vehiculo) => _$this._vehiculo = vehiculo;

  LISTAVEHICULOSBuilder() {
    LISTAVEHICULOS._defaults(this);
  }

  LISTAVEHICULOSBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _vehiculo = $v.vehiculo?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(LISTAVEHICULOS other) {
    _$v = other as _$LISTAVEHICULOS;
  }

  @override
  void update(void Function(LISTAVEHICULOSBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  LISTAVEHICULOS build() => _build();

  _$LISTAVEHICULOS _build() {
    _$LISTAVEHICULOS _$result;
    try {
      _$result = _$v ??
          _$LISTAVEHICULOS._(
            vehiculo: _vehiculo?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'vehiculo';
        _vehiculo?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'LISTAVEHICULOS', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
