// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'zcssfaq.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ZCSSFAQ extends ZCSSFAQ {
  @override
  final String? numseq;
  @override
  final String? textarea;
  @override
  final String? textlinea;

  factory _$ZCSSFAQ([void Function(ZCSSFAQBuilder)? updates]) =>
      (ZCSSFAQBuilder()..update(updates))._build();

  _$ZCSSFAQ._({this.numseq, this.textarea, this.textlinea}) : super._();
  @override
  ZCSSFAQ rebuild(void Function(ZCSSFAQBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ZCSSFAQBuilder toBuilder() => ZCSSFAQBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ZCSSFAQ &&
        numseq == other.numseq &&
        textarea == other.textarea &&
        textlinea == other.textlinea;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, numseq.hashCode);
    _$hash = $jc(_$hash, textarea.hashCode);
    _$hash = $jc(_$hash, textlinea.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ZCSSFAQ')
          ..add('numseq', numseq)
          ..add('textarea', textarea)
          ..add('textlinea', textlinea))
        .toString();
  }
}

class ZCSSFAQBuilder implements Builder<ZCSSFAQ, ZCSSFAQBuilder> {
  _$ZCSSFAQ? _$v;

  String? _numseq;
  String? get numseq => _$this._numseq;
  set numseq(String? numseq) => _$this._numseq = numseq;

  String? _textarea;
  String? get textarea => _$this._textarea;
  set textarea(String? textarea) => _$this._textarea = textarea;

  String? _textlinea;
  String? get textlinea => _$this._textlinea;
  set textlinea(String? textlinea) => _$this._textlinea = textlinea;

  ZCSSFAQBuilder() {
    ZCSSFAQ._defaults(this);
  }

  ZCSSFAQBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _numseq = $v.numseq;
      _textarea = $v.textarea;
      _textlinea = $v.textlinea;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ZCSSFAQ other) {
    _$v = other as _$ZCSSFAQ;
  }

  @override
  void update(void Function(ZCSSFAQBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ZCSSFAQ build() => _build();

  _$ZCSSFAQ _build() {
    final _$result = _$v ??
        _$ZCSSFAQ._(
          numseq: numseq,
          textarea: textarea,
          textlinea: textlinea,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
