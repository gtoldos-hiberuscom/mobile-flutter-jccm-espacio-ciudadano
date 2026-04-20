// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expedientes.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$EXPEDIENTES extends EXPEDIENTES {
  @override
  final BuiltList<ZCSAUXSTEXPEDIENTES>? item;

  factory _$EXPEDIENTES([void Function(EXPEDIENTESBuilder)? updates]) =>
      (EXPEDIENTESBuilder()..update(updates))._build();

  _$EXPEDIENTES._({this.item}) : super._();
  @override
  EXPEDIENTES rebuild(void Function(EXPEDIENTESBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  EXPEDIENTESBuilder toBuilder() => EXPEDIENTESBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is EXPEDIENTES && item == other.item;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, item.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'EXPEDIENTES')..add('item', item))
        .toString();
  }
}

class EXPEDIENTESBuilder implements Builder<EXPEDIENTES, EXPEDIENTESBuilder> {
  _$EXPEDIENTES? _$v;

  ListBuilder<ZCSAUXSTEXPEDIENTES>? _item;
  ListBuilder<ZCSAUXSTEXPEDIENTES> get item =>
      _$this._item ??= ListBuilder<ZCSAUXSTEXPEDIENTES>();
  set item(ListBuilder<ZCSAUXSTEXPEDIENTES>? item) => _$this._item = item;

  EXPEDIENTESBuilder() {
    EXPEDIENTES._defaults(this);
  }

  EXPEDIENTESBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _item = $v.item?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(EXPEDIENTES other) {
    _$v = other as _$EXPEDIENTES;
  }

  @override
  void update(void Function(EXPEDIENTESBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  EXPEDIENTES build() => _build();

  _$EXPEDIENTES _build() {
    _$EXPEDIENTES _$result;
    try {
      _$result = _$v ??
          _$EXPEDIENTES._(
            item: _item?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'item';
        _item?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'EXPEDIENTES', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
