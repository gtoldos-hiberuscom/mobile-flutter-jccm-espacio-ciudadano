// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'datospago.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DATOSPAGO extends DATOSPAGO {
  @override
  final String imprec;
  @override
  final String refdocrecur;

  factory _$DATOSPAGO([void Function(DATOSPAGOBuilder)? updates]) =>
      (DATOSPAGOBuilder()..update(updates))._build();

  _$DATOSPAGO._({required this.imprec, required this.refdocrecur}) : super._();
  @override
  DATOSPAGO rebuild(void Function(DATOSPAGOBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DATOSPAGOBuilder toBuilder() => DATOSPAGOBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DATOSPAGO &&
        imprec == other.imprec &&
        refdocrecur == other.refdocrecur;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, imprec.hashCode);
    _$hash = $jc(_$hash, refdocrecur.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DATOSPAGO')
          ..add('imprec', imprec)
          ..add('refdocrecur', refdocrecur))
        .toString();
  }
}

class DATOSPAGOBuilder implements Builder<DATOSPAGO, DATOSPAGOBuilder> {
  _$DATOSPAGO? _$v;

  String? _imprec;
  String? get imprec => _$this._imprec;
  set imprec(String? imprec) => _$this._imprec = imprec;

  String? _refdocrecur;
  String? get refdocrecur => _$this._refdocrecur;
  set refdocrecur(String? refdocrecur) => _$this._refdocrecur = refdocrecur;

  DATOSPAGOBuilder() {
    DATOSPAGO._defaults(this);
  }

  DATOSPAGOBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _imprec = $v.imprec;
      _refdocrecur = $v.refdocrecur;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DATOSPAGO other) {
    _$v = other as _$DATOSPAGO;
  }

  @override
  void update(void Function(DATOSPAGOBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DATOSPAGO build() => _build();

  _$DATOSPAGO _build() {
    final _$result = _$v ??
        _$DATOSPAGO._(
          imprec: BuiltValueNullFieldError.checkNotNull(
              imprec, r'DATOSPAGO', 'imprec'),
          refdocrecur: BuiltValueNullFieldError.checkNotNull(
              refdocrecur, r'DATOSPAGO', 'refdocrecur'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
