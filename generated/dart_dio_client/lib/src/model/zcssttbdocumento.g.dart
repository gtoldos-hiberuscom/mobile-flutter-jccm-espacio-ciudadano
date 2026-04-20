// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'zcssttbdocumento.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ZCSSTTBDOCUMENTO extends ZCSSTTBDOCUMENTO {
  @override
  final BuiltList<ZCSTBDOCUMENTO>? item;

  factory _$ZCSSTTBDOCUMENTO(
          [void Function(ZCSSTTBDOCUMENTOBuilder)? updates]) =>
      (ZCSSTTBDOCUMENTOBuilder()..update(updates))._build();

  _$ZCSSTTBDOCUMENTO._({this.item}) : super._();
  @override
  ZCSSTTBDOCUMENTO rebuild(void Function(ZCSSTTBDOCUMENTOBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ZCSSTTBDOCUMENTOBuilder toBuilder() =>
      ZCSSTTBDOCUMENTOBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ZCSSTTBDOCUMENTO && item == other.item;
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
    return (newBuiltValueToStringHelper(r'ZCSSTTBDOCUMENTO')..add('item', item))
        .toString();
  }
}

class ZCSSTTBDOCUMENTOBuilder
    implements Builder<ZCSSTTBDOCUMENTO, ZCSSTTBDOCUMENTOBuilder> {
  _$ZCSSTTBDOCUMENTO? _$v;

  ListBuilder<ZCSTBDOCUMENTO>? _item;
  ListBuilder<ZCSTBDOCUMENTO> get item =>
      _$this._item ??= ListBuilder<ZCSTBDOCUMENTO>();
  set item(ListBuilder<ZCSTBDOCUMENTO>? item) => _$this._item = item;

  ZCSSTTBDOCUMENTOBuilder() {
    ZCSSTTBDOCUMENTO._defaults(this);
  }

  ZCSSTTBDOCUMENTOBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _item = $v.item?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ZCSSTTBDOCUMENTO other) {
    _$v = other as _$ZCSSTTBDOCUMENTO;
  }

  @override
  void update(void Function(ZCSSTTBDOCUMENTOBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ZCSSTTBDOCUMENTO build() => _build();

  _$ZCSSTTBDOCUMENTO _build() {
    _$ZCSSTTBDOCUMENTO _$result;
    try {
      _$result = _$v ??
          _$ZCSSTTBDOCUMENTO._(
            item: _item?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'item';
        _item?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ZCSSTTBDOCUMENTO', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
