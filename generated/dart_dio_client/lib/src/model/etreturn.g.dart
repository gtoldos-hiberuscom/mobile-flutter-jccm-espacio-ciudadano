// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'etreturn.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ETRETURN extends ETRETURN {
  @override
  final BuiltList<BAPIRET2>? item;

  factory _$ETRETURN([void Function(ETRETURNBuilder)? updates]) =>
      (ETRETURNBuilder()..update(updates))._build();

  _$ETRETURN._({this.item}) : super._();
  @override
  ETRETURN rebuild(void Function(ETRETURNBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ETRETURNBuilder toBuilder() => ETRETURNBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ETRETURN && item == other.item;
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
    return (newBuiltValueToStringHelper(r'ETRETURN')..add('item', item))
        .toString();
  }
}

class ETRETURNBuilder implements Builder<ETRETURN, ETRETURNBuilder> {
  _$ETRETURN? _$v;

  ListBuilder<BAPIRET2>? _item;
  ListBuilder<BAPIRET2> get item => _$this._item ??= ListBuilder<BAPIRET2>();
  set item(ListBuilder<BAPIRET2>? item) => _$this._item = item;

  ETRETURNBuilder() {
    ETRETURN._defaults(this);
  }

  ETRETURNBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _item = $v.item?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ETRETURN other) {
    _$v = other as _$ETRETURN;
  }

  @override
  void update(void Function(ETRETURNBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ETRETURN build() => _build();

  _$ETRETURN _build() {
    _$ETRETURN _$result;
    try {
      _$result = _$v ??
          _$ETRETURN._(
            item: _item?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'item';
        _item?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ETRETURN', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
