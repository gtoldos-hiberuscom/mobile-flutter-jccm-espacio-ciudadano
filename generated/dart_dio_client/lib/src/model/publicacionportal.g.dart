// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'publicacionportal.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PUBLICACIONPORTAL extends PUBLICACIONPORTAL {
  @override
  final BuiltList<ZCSSTPUBPORTAL>? item;

  factory _$PUBLICACIONPORTAL(
          [void Function(PUBLICACIONPORTALBuilder)? updates]) =>
      (PUBLICACIONPORTALBuilder()..update(updates))._build();

  _$PUBLICACIONPORTAL._({this.item}) : super._();
  @override
  PUBLICACIONPORTAL rebuild(void Function(PUBLICACIONPORTALBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PUBLICACIONPORTALBuilder toBuilder() =>
      PUBLICACIONPORTALBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PUBLICACIONPORTAL && item == other.item;
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
    return (newBuiltValueToStringHelper(r'PUBLICACIONPORTAL')
          ..add('item', item))
        .toString();
  }
}

class PUBLICACIONPORTALBuilder
    implements Builder<PUBLICACIONPORTAL, PUBLICACIONPORTALBuilder> {
  _$PUBLICACIONPORTAL? _$v;

  ListBuilder<ZCSSTPUBPORTAL>? _item;
  ListBuilder<ZCSSTPUBPORTAL> get item =>
      _$this._item ??= ListBuilder<ZCSSTPUBPORTAL>();
  set item(ListBuilder<ZCSSTPUBPORTAL>? item) => _$this._item = item;

  PUBLICACIONPORTALBuilder() {
    PUBLICACIONPORTAL._defaults(this);
  }

  PUBLICACIONPORTALBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _item = $v.item?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PUBLICACIONPORTAL other) {
    _$v = other as _$PUBLICACIONPORTAL;
  }

  @override
  void update(void Function(PUBLICACIONPORTALBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PUBLICACIONPORTAL build() => _build();

  _$PUBLICACIONPORTAL _build() {
    _$PUBLICACIONPORTAL _$result;
    try {
      _$result = _$v ??
          _$PUBLICACIONPORTAL._(
            item: _item?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'item';
        _item?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'PUBLICACIONPORTAL', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
