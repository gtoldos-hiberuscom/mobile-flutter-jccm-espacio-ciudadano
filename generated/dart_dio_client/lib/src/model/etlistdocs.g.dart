// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'etlistdocs.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ETLISTDOCS extends ETLISTDOCS {
  @override
  final BuiltList<ZCSLISTADODOCSEXPTE>? item;

  factory _$ETLISTDOCS([void Function(ETLISTDOCSBuilder)? updates]) =>
      (ETLISTDOCSBuilder()..update(updates))._build();

  _$ETLISTDOCS._({this.item}) : super._();
  @override
  ETLISTDOCS rebuild(void Function(ETLISTDOCSBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ETLISTDOCSBuilder toBuilder() => ETLISTDOCSBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ETLISTDOCS && item == other.item;
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
    return (newBuiltValueToStringHelper(r'ETLISTDOCS')..add('item', item))
        .toString();
  }
}

class ETLISTDOCSBuilder implements Builder<ETLISTDOCS, ETLISTDOCSBuilder> {
  _$ETLISTDOCS? _$v;

  ListBuilder<ZCSLISTADODOCSEXPTE>? _item;
  ListBuilder<ZCSLISTADODOCSEXPTE> get item =>
      _$this._item ??= ListBuilder<ZCSLISTADODOCSEXPTE>();
  set item(ListBuilder<ZCSLISTADODOCSEXPTE>? item) => _$this._item = item;

  ETLISTDOCSBuilder() {
    ETLISTDOCS._defaults(this);
  }

  ETLISTDOCSBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _item = $v.item?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ETLISTDOCS other) {
    _$v = other as _$ETLISTDOCS;
  }

  @override
  void update(void Function(ETLISTDOCSBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ETLISTDOCS build() => _build();

  _$ETLISTDOCS _build() {
    _$ETLISTDOCS _$result;
    try {
      _$result = _$v ??
          _$ETLISTDOCS._(
            item: _item?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'item';
        _item?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ETLISTDOCS', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
