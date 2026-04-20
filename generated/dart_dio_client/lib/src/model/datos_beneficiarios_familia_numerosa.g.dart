// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'datos_beneficiarios_familia_numerosa.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DatosBeneficiariosFamiliaNumerosa
    extends DatosBeneficiariosFamiliaNumerosa {
  @override
  final BuiltList<DatosBeneficiariosFamiliaNumerosaList>? row;

  factory _$DatosBeneficiariosFamiliaNumerosa(
          [void Function(DatosBeneficiariosFamiliaNumerosaBuilder)? updates]) =>
      (DatosBeneficiariosFamiliaNumerosaBuilder()..update(updates))._build();

  _$DatosBeneficiariosFamiliaNumerosa._({this.row}) : super._();
  @override
  DatosBeneficiariosFamiliaNumerosa rebuild(
          void Function(DatosBeneficiariosFamiliaNumerosaBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DatosBeneficiariosFamiliaNumerosaBuilder toBuilder() =>
      DatosBeneficiariosFamiliaNumerosaBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DatosBeneficiariosFamiliaNumerosa && row == other.row;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, row.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DatosBeneficiariosFamiliaNumerosa')
          ..add('row', row))
        .toString();
  }
}

class DatosBeneficiariosFamiliaNumerosaBuilder
    implements
        Builder<DatosBeneficiariosFamiliaNumerosa,
            DatosBeneficiariosFamiliaNumerosaBuilder> {
  _$DatosBeneficiariosFamiliaNumerosa? _$v;

  ListBuilder<DatosBeneficiariosFamiliaNumerosaList>? _row;
  ListBuilder<DatosBeneficiariosFamiliaNumerosaList> get row =>
      _$this._row ??= ListBuilder<DatosBeneficiariosFamiliaNumerosaList>();
  set row(ListBuilder<DatosBeneficiariosFamiliaNumerosaList>? row) =>
      _$this._row = row;

  DatosBeneficiariosFamiliaNumerosaBuilder() {
    DatosBeneficiariosFamiliaNumerosa._defaults(this);
  }

  DatosBeneficiariosFamiliaNumerosaBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _row = $v.row?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DatosBeneficiariosFamiliaNumerosa other) {
    _$v = other as _$DatosBeneficiariosFamiliaNumerosa;
  }

  @override
  void update(
      void Function(DatosBeneficiariosFamiliaNumerosaBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DatosBeneficiariosFamiliaNumerosa build() => _build();

  _$DatosBeneficiariosFamiliaNumerosa _build() {
    _$DatosBeneficiariosFamiliaNumerosa _$result;
    try {
      _$result = _$v ??
          _$DatosBeneficiariosFamiliaNumerosa._(
            row: _row?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'row';
        _row?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'DatosBeneficiariosFamiliaNumerosa', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
