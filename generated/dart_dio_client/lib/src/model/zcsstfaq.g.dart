// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'zcsstfaq.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ZCSSTFAQ extends ZCSSTFAQ {
  @override
  final String? numseq;
  @override
  final String? textarea;
  @override
  final String? textlinea;

  factory _$ZCSSTFAQ([void Function(ZCSSTFAQBuilder)? updates]) =>
      (ZCSSTFAQBuilder()..update(updates))._build();

  _$ZCSSTFAQ._({this.numseq, this.textarea, this.textlinea}) : super._();
  @override
  ZCSSTFAQ rebuild(void Function(ZCSSTFAQBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ZCSSTFAQBuilder toBuilder() => ZCSSTFAQBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ZCSSTFAQ &&
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
    return (newBuiltValueToStringHelper(r'ZCSSTFAQ')
          ..add('numseq', numseq)
          ..add('textarea', textarea)
          ..add('textlinea', textlinea))
        .toString();
  }
}

class ZCSSTFAQBuilder implements Builder<ZCSSTFAQ, ZCSSTFAQBuilder> {
  _$ZCSSTFAQ? _$v;

  String? _numseq;
  String? get numseq => _$this._numseq;
  set numseq(String? numseq) => _$this._numseq = numseq;

  String? _textarea;
  String? get textarea => _$this._textarea;
  set textarea(String? textarea) => _$this._textarea = textarea;

  String? _textlinea;
  String? get textlinea => _$this._textlinea;
  set textlinea(String? textlinea) => _$this._textlinea = textlinea;

  ZCSSTFAQBuilder() {
    ZCSSTFAQ._defaults(this);
  }

  ZCSSTFAQBuilder get _$this {
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
  void replace(ZCSSTFAQ other) {
    _$v = other as _$ZCSSTFAQ;
  }

  @override
  void update(void Function(ZCSSTFAQBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ZCSSTFAQ build() => _build();

  _$ZCSSTFAQ _build() {
    final _$result = _$v ??
        _$ZCSSTFAQ._(
          numseq: numseq,
          textarea: textarea,
          textlinea: textlinea,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
