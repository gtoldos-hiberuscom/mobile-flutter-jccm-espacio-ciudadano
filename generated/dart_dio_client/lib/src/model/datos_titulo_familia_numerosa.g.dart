// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'datos_titulo_familia_numerosa.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DatosTituloFamiliaNumerosa extends DatosTituloFamiliaNumerosa {
  @override
  final BuiltList<DatosTituloFamiliaNumerosaList>? row;

  factory _$DatosTituloFamiliaNumerosa(
          [void Function(DatosTituloFamiliaNumerosaBuilder)? updates]) =>
      (DatosTituloFamiliaNumerosaBuilder()..update(updates))._build();

  _$DatosTituloFamiliaNumerosa._({this.row}) : super._();
  @override
  DatosTituloFamiliaNumerosa rebuild(
          void Function(DatosTituloFamiliaNumerosaBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DatosTituloFamiliaNumerosaBuilder toBuilder() =>
      DatosTituloFamiliaNumerosaBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DatosTituloFamiliaNumerosa && row == other.row;
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
    return (newBuiltValueToStringHelper(r'DatosTituloFamiliaNumerosa')
          ..add('row', row))
        .toString();
  }
}

class DatosTituloFamiliaNumerosaBuilder
    implements
        Builder<DatosTituloFamiliaNumerosa, DatosTituloFamiliaNumerosaBuilder> {
  _$DatosTituloFamiliaNumerosa? _$v;

  ListBuilder<DatosTituloFamiliaNumerosaList>? _row;
  ListBuilder<DatosTituloFamiliaNumerosaList> get row =>
      _$this._row ??= ListBuilder<DatosTituloFamiliaNumerosaList>();
  set row(ListBuilder<DatosTituloFamiliaNumerosaList>? row) =>
      _$this._row = row;

  DatosTituloFamiliaNumerosaBuilder() {
    DatosTituloFamiliaNumerosa._defaults(this);
  }

  DatosTituloFamiliaNumerosaBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _row = $v.row?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DatosTituloFamiliaNumerosa other) {
    _$v = other as _$DatosTituloFamiliaNumerosa;
  }

  @override
  void update(void Function(DatosTituloFamiliaNumerosaBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DatosTituloFamiliaNumerosa build() => _build();

  _$DatosTituloFamiliaNumerosa _build() {
    _$DatosTituloFamiliaNumerosa _$result;
    try {
      _$result = _$v ??
          _$DatosTituloFamiliaNumerosa._(
            row: _row?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'row';
        _row?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'DatosTituloFamiliaNumerosa', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
