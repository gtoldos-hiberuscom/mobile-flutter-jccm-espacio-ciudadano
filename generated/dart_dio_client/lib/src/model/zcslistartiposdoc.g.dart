// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'zcslistartiposdoc.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ZCSLISTARTIPOSDOC extends ZCSLISTARTIPOSDOC {
  @override
  final ZLISTADOC zlistadoc;

  factory _$ZCSLISTARTIPOSDOC(
          [void Function(ZCSLISTARTIPOSDOCBuilder)? updates]) =>
      (ZCSLISTARTIPOSDOCBuilder()..update(updates))._build();

  _$ZCSLISTARTIPOSDOC._({required this.zlistadoc}) : super._();
  @override
  ZCSLISTARTIPOSDOC rebuild(void Function(ZCSLISTARTIPOSDOCBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ZCSLISTARTIPOSDOCBuilder toBuilder() =>
      ZCSLISTARTIPOSDOCBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ZCSLISTARTIPOSDOC && zlistadoc == other.zlistadoc;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, zlistadoc.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ZCSLISTARTIPOSDOC')
          ..add('zlistadoc', zlistadoc))
        .toString();
  }
}

class ZCSLISTARTIPOSDOCBuilder
    implements Builder<ZCSLISTARTIPOSDOC, ZCSLISTARTIPOSDOCBuilder> {
  _$ZCSLISTARTIPOSDOC? _$v;

  ZLISTADOCBuilder? _zlistadoc;
  ZLISTADOCBuilder get zlistadoc => _$this._zlistadoc ??= ZLISTADOCBuilder();
  set zlistadoc(ZLISTADOCBuilder? zlistadoc) => _$this._zlistadoc = zlistadoc;

  ZCSLISTARTIPOSDOCBuilder() {
    ZCSLISTARTIPOSDOC._defaults(this);
  }

  ZCSLISTARTIPOSDOCBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _zlistadoc = $v.zlistadoc.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ZCSLISTARTIPOSDOC other) {
    _$v = other as _$ZCSLISTARTIPOSDOC;
  }

  @override
  void update(void Function(ZCSLISTARTIPOSDOCBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ZCSLISTARTIPOSDOC build() => _build();

  _$ZCSLISTARTIPOSDOC _build() {
    _$ZCSLISTARTIPOSDOC _$result;
    try {
      _$result = _$v ??
          _$ZCSLISTARTIPOSDOC._(
            zlistadoc: zlistadoc.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'zlistadoc';
        zlistadoc.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ZCSLISTARTIPOSDOC', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
