// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tfaq.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$TFAQ extends TFAQ {
  @override
  final BuiltList<ZCSSFAQ>? item;

  factory _$TFAQ([void Function(TFAQBuilder)? updates]) =>
      (TFAQBuilder()..update(updates))._build();

  _$TFAQ._({this.item}) : super._();
  @override
  TFAQ rebuild(void Function(TFAQBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TFAQBuilder toBuilder() => TFAQBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TFAQ && item == other.item;
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
    return (newBuiltValueToStringHelper(r'TFAQ')..add('item', item)).toString();
  }
}

class TFAQBuilder implements Builder<TFAQ, TFAQBuilder> {
  _$TFAQ? _$v;

  ListBuilder<ZCSSFAQ>? _item;
  ListBuilder<ZCSSFAQ> get item => _$this._item ??= ListBuilder<ZCSSFAQ>();
  set item(ListBuilder<ZCSSFAQ>? item) => _$this._item = item;

  TFAQBuilder() {
    TFAQ._defaults(this);
  }

  TFAQBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _item = $v.item?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TFAQ other) {
    _$v = other as _$TFAQ;
  }

  @override
  void update(void Function(TFAQBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TFAQ build() => _build();

  _$TFAQ _build() {
    _$TFAQ _$result;
    try {
      _$result = _$v ??
          _$TFAQ._(
            item: _item?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'item';
        _item?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'TFAQ', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
