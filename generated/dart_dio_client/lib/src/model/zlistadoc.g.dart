// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'zlistadoc.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ZLISTADOC extends ZLISTADOC {
  @override
  final BuiltList<ZCSTBTDOCFIRMA>? item;

  factory _$ZLISTADOC([void Function(ZLISTADOCBuilder)? updates]) =>
      (ZLISTADOCBuilder()..update(updates))._build();

  _$ZLISTADOC._({this.item}) : super._();
  @override
  ZLISTADOC rebuild(void Function(ZLISTADOCBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ZLISTADOCBuilder toBuilder() => ZLISTADOCBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ZLISTADOC && item == other.item;
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
    return (newBuiltValueToStringHelper(r'ZLISTADOC')..add('item', item))
        .toString();
  }
}

class ZLISTADOCBuilder implements Builder<ZLISTADOC, ZLISTADOCBuilder> {
  _$ZLISTADOC? _$v;

  ListBuilder<ZCSTBTDOCFIRMA>? _item;
  ListBuilder<ZCSTBTDOCFIRMA> get item =>
      _$this._item ??= ListBuilder<ZCSTBTDOCFIRMA>();
  set item(ListBuilder<ZCSTBTDOCFIRMA>? item) => _$this._item = item;

  ZLISTADOCBuilder() {
    ZLISTADOC._defaults(this);
  }

  ZLISTADOCBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _item = $v.item?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ZLISTADOC other) {
    _$v = other as _$ZLISTADOC;
  }

  @override
  void update(void Function(ZLISTADOCBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ZLISTADOC build() => _build();

  _$ZLISTADOC _build() {
    _$ZLISTADOC _$result;
    try {
      _$result = _$v ??
          _$ZLISTADOC._(
            item: _item?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'item';
        _item?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ZLISTADOC', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
