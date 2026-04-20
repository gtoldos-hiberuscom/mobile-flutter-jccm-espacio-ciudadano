// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ttextosrespuesta.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$TTEXTOSRESPUESTA extends TTEXTOSRESPUESTA {
  @override
  final BuiltList<ZCSSTFAQ>? item;

  factory _$TTEXTOSRESPUESTA(
          [void Function(TTEXTOSRESPUESTABuilder)? updates]) =>
      (TTEXTOSRESPUESTABuilder()..update(updates))._build();

  _$TTEXTOSRESPUESTA._({this.item}) : super._();
  @override
  TTEXTOSRESPUESTA rebuild(void Function(TTEXTOSRESPUESTABuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TTEXTOSRESPUESTABuilder toBuilder() =>
      TTEXTOSRESPUESTABuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TTEXTOSRESPUESTA && item == other.item;
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
    return (newBuiltValueToStringHelper(r'TTEXTOSRESPUESTA')..add('item', item))
        .toString();
  }
}

class TTEXTOSRESPUESTABuilder
    implements Builder<TTEXTOSRESPUESTA, TTEXTOSRESPUESTABuilder> {
  _$TTEXTOSRESPUESTA? _$v;

  ListBuilder<ZCSSTFAQ>? _item;
  ListBuilder<ZCSSTFAQ> get item => _$this._item ??= ListBuilder<ZCSSTFAQ>();
  set item(ListBuilder<ZCSSTFAQ>? item) => _$this._item = item;

  TTEXTOSRESPUESTABuilder() {
    TTEXTOSRESPUESTA._defaults(this);
  }

  TTEXTOSRESPUESTABuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _item = $v.item?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TTEXTOSRESPUESTA other) {
    _$v = other as _$TTEXTOSRESPUESTA;
  }

  @override
  void update(void Function(TTEXTOSRESPUESTABuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TTEXTOSRESPUESTA build() => _build();

  _$TTEXTOSRESPUESTA _build() {
    _$TTEXTOSRESPUESTA _$result;
    try {
      _$result = _$v ??
          _$TTEXTOSRESPUESTA._(
            item: _item?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'item';
        _item?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'TTEXTOSRESPUESTA', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
