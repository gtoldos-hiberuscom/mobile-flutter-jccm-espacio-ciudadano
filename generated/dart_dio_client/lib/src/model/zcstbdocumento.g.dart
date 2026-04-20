// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'zcstbdocumento.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ZCSTBDOCUMENTO extends ZCSTBDOCUMENTO {
  @override
  final String? ejeexp;
  @override
  final String? iddoc;
  @override
  final String? numexp;
  @override
  final String? tipoproc;

  factory _$ZCSTBDOCUMENTO([void Function(ZCSTBDOCUMENTOBuilder)? updates]) =>
      (ZCSTBDOCUMENTOBuilder()..update(updates))._build();

  _$ZCSTBDOCUMENTO._({this.ejeexp, this.iddoc, this.numexp, this.tipoproc})
      : super._();
  @override
  ZCSTBDOCUMENTO rebuild(void Function(ZCSTBDOCUMENTOBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ZCSTBDOCUMENTOBuilder toBuilder() => ZCSTBDOCUMENTOBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ZCSTBDOCUMENTO &&
        ejeexp == other.ejeexp &&
        iddoc == other.iddoc &&
        numexp == other.numexp &&
        tipoproc == other.tipoproc;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, ejeexp.hashCode);
    _$hash = $jc(_$hash, iddoc.hashCode);
    _$hash = $jc(_$hash, numexp.hashCode);
    _$hash = $jc(_$hash, tipoproc.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ZCSTBDOCUMENTO')
          ..add('ejeexp', ejeexp)
          ..add('iddoc', iddoc)
          ..add('numexp', numexp)
          ..add('tipoproc', tipoproc))
        .toString();
  }
}

class ZCSTBDOCUMENTOBuilder
    implements Builder<ZCSTBDOCUMENTO, ZCSTBDOCUMENTOBuilder> {
  _$ZCSTBDOCUMENTO? _$v;

  String? _ejeexp;
  String? get ejeexp => _$this._ejeexp;
  set ejeexp(String? ejeexp) => _$this._ejeexp = ejeexp;

  String? _iddoc;
  String? get iddoc => _$this._iddoc;
  set iddoc(String? iddoc) => _$this._iddoc = iddoc;

  String? _numexp;
  String? get numexp => _$this._numexp;
  set numexp(String? numexp) => _$this._numexp = numexp;

  String? _tipoproc;
  String? get tipoproc => _$this._tipoproc;
  set tipoproc(String? tipoproc) => _$this._tipoproc = tipoproc;

  ZCSTBDOCUMENTOBuilder() {
    ZCSTBDOCUMENTO._defaults(this);
  }

  ZCSTBDOCUMENTOBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _ejeexp = $v.ejeexp;
      _iddoc = $v.iddoc;
      _numexp = $v.numexp;
      _tipoproc = $v.tipoproc;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ZCSTBDOCUMENTO other) {
    _$v = other as _$ZCSTBDOCUMENTO;
  }

  @override
  void update(void Function(ZCSTBDOCUMENTOBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ZCSTBDOCUMENTO build() => _build();

  _$ZCSTBDOCUMENTO _build() {
    final _$result = _$v ??
        _$ZCSTBDOCUMENTO._(
          ejeexp: ejeexp,
          iddoc: iddoc,
          numexp: numexp,
          tipoproc: tipoproc,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
