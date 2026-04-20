// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'zcstbtdocfirma.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ZCSTBTDOCFIRMA extends ZCSTBTDOCFIRMA {
  @override
  final String? codtdf;
  @override
  final String? dentdf;

  factory _$ZCSTBTDOCFIRMA([void Function(ZCSTBTDOCFIRMABuilder)? updates]) =>
      (ZCSTBTDOCFIRMABuilder()..update(updates))._build();

  _$ZCSTBTDOCFIRMA._({this.codtdf, this.dentdf}) : super._();
  @override
  ZCSTBTDOCFIRMA rebuild(void Function(ZCSTBTDOCFIRMABuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ZCSTBTDOCFIRMABuilder toBuilder() => ZCSTBTDOCFIRMABuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ZCSTBTDOCFIRMA &&
        codtdf == other.codtdf &&
        dentdf == other.dentdf;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, codtdf.hashCode);
    _$hash = $jc(_$hash, dentdf.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ZCSTBTDOCFIRMA')
          ..add('codtdf', codtdf)
          ..add('dentdf', dentdf))
        .toString();
  }
}

class ZCSTBTDOCFIRMABuilder
    implements Builder<ZCSTBTDOCFIRMA, ZCSTBTDOCFIRMABuilder> {
  _$ZCSTBTDOCFIRMA? _$v;

  String? _codtdf;
  String? get codtdf => _$this._codtdf;
  set codtdf(String? codtdf) => _$this._codtdf = codtdf;

  String? _dentdf;
  String? get dentdf => _$this._dentdf;
  set dentdf(String? dentdf) => _$this._dentdf = dentdf;

  ZCSTBTDOCFIRMABuilder() {
    ZCSTBTDOCFIRMA._defaults(this);
  }

  ZCSTBTDOCFIRMABuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _codtdf = $v.codtdf;
      _dentdf = $v.dentdf;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ZCSTBTDOCFIRMA other) {
    _$v = other as _$ZCSTBTDOCFIRMA;
  }

  @override
  void update(void Function(ZCSTBTDOCFIRMABuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ZCSTBTDOCFIRMA build() => _build();

  _$ZCSTBTDOCFIRMA _build() {
    final _$result = _$v ??
        _$ZCSTBTDOCFIRMA._(
          codtdf: codtdf,
          dentdf: dentdf,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
