// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'returns.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RETURNS extends RETURNS {
  @override
  final BuiltList<BAPIRET2>? item;

  factory _$RETURNS([void Function(RETURNSBuilder)? updates]) =>
      (RETURNSBuilder()..update(updates))._build();

  _$RETURNS._({this.item}) : super._();
  @override
  RETURNS rebuild(void Function(RETURNSBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RETURNSBuilder toBuilder() => RETURNSBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RETURNS && item == other.item;
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
    return (newBuiltValueToStringHelper(r'RETURNS')..add('item', item))
        .toString();
  }
}

class RETURNSBuilder implements Builder<RETURNS, RETURNSBuilder> {
  _$RETURNS? _$v;

  ListBuilder<BAPIRET2>? _item;
  ListBuilder<BAPIRET2> get item => _$this._item ??= ListBuilder<BAPIRET2>();
  set item(ListBuilder<BAPIRET2>? item) => _$this._item = item;

  RETURNSBuilder() {
    RETURNS._defaults(this);
  }

  RETURNSBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _item = $v.item?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RETURNS other) {
    _$v = other as _$RETURNS;
  }

  @override
  void update(void Function(RETURNSBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RETURNS build() => _build();

  _$RETURNS _build() {
    _$RETURNS _$result;
    try {
      _$result = _$v ??
          _$RETURNS._(
            item: _item?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'item';
        _item?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'RETURNS', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
