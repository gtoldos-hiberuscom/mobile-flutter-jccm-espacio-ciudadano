// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dt_identificacion_rep.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DTIdentificacionRep extends DTIdentificacionRep {
  @override
  final String categoryrep;
  @override
  final String nifcifrep;

  factory _$DTIdentificacionRep(
          [void Function(DTIdentificacionRepBuilder)? updates]) =>
      (DTIdentificacionRepBuilder()..update(updates))._build();

  _$DTIdentificacionRep._({required this.categoryrep, required this.nifcifrep})
      : super._();
  @override
  DTIdentificacionRep rebuild(
          void Function(DTIdentificacionRepBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DTIdentificacionRepBuilder toBuilder() =>
      DTIdentificacionRepBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DTIdentificacionRep &&
        categoryrep == other.categoryrep &&
        nifcifrep == other.nifcifrep;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, categoryrep.hashCode);
    _$hash = $jc(_$hash, nifcifrep.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DTIdentificacionRep')
          ..add('categoryrep', categoryrep)
          ..add('nifcifrep', nifcifrep))
        .toString();
  }
}

class DTIdentificacionRepBuilder
    implements Builder<DTIdentificacionRep, DTIdentificacionRepBuilder> {
  _$DTIdentificacionRep? _$v;

  String? _categoryrep;
  String? get categoryrep => _$this._categoryrep;
  set categoryrep(String? categoryrep) => _$this._categoryrep = categoryrep;

  String? _nifcifrep;
  String? get nifcifrep => _$this._nifcifrep;
  set nifcifrep(String? nifcifrep) => _$this._nifcifrep = nifcifrep;

  DTIdentificacionRepBuilder() {
    DTIdentificacionRep._defaults(this);
  }

  DTIdentificacionRepBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _categoryrep = $v.categoryrep;
      _nifcifrep = $v.nifcifrep;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DTIdentificacionRep other) {
    _$v = other as _$DTIdentificacionRep;
  }

  @override
  void update(void Function(DTIdentificacionRepBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DTIdentificacionRep build() => _build();

  _$DTIdentificacionRep _build() {
    final _$result = _$v ??
        _$DTIdentificacionRep._(
          categoryrep: BuiltValueNullFieldError.checkNotNull(
              categoryrep, r'DTIdentificacionRep', 'categoryrep'),
          nifcifrep: BuiltValueNullFieldError.checkNotNull(
              nifcifrep, r'DTIdentificacionRep', 'nifcifrep'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
