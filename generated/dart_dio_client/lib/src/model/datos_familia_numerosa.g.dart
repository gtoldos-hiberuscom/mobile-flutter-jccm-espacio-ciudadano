// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'datos_familia_numerosa.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DatosFamiliaNumerosa extends DatosFamiliaNumerosa {
  @override
  final String? codError;
  @override
  final String? datos;
  @override
  final String? descError;
  @override
  final String? fechaValidezDesde;
  @override
  final String? fechaValidezHasta;
  @override
  final String? numeroTitulo;

  factory _$DatosFamiliaNumerosa(
          [void Function(DatosFamiliaNumerosaBuilder)? updates]) =>
      (DatosFamiliaNumerosaBuilder()..update(updates))._build();

  _$DatosFamiliaNumerosa._(
      {this.codError,
      this.datos,
      this.descError,
      this.fechaValidezDesde,
      this.fechaValidezHasta,
      this.numeroTitulo})
      : super._();
  @override
  DatosFamiliaNumerosa rebuild(
          void Function(DatosFamiliaNumerosaBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DatosFamiliaNumerosaBuilder toBuilder() =>
      DatosFamiliaNumerosaBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DatosFamiliaNumerosa &&
        codError == other.codError &&
        datos == other.datos &&
        descError == other.descError &&
        fechaValidezDesde == other.fechaValidezDesde &&
        fechaValidezHasta == other.fechaValidezHasta &&
        numeroTitulo == other.numeroTitulo;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, codError.hashCode);
    _$hash = $jc(_$hash, datos.hashCode);
    _$hash = $jc(_$hash, descError.hashCode);
    _$hash = $jc(_$hash, fechaValidezDesde.hashCode);
    _$hash = $jc(_$hash, fechaValidezHasta.hashCode);
    _$hash = $jc(_$hash, numeroTitulo.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DatosFamiliaNumerosa')
          ..add('codError', codError)
          ..add('datos', datos)
          ..add('descError', descError)
          ..add('fechaValidezDesde', fechaValidezDesde)
          ..add('fechaValidezHasta', fechaValidezHasta)
          ..add('numeroTitulo', numeroTitulo))
        .toString();
  }
}

class DatosFamiliaNumerosaBuilder
    implements Builder<DatosFamiliaNumerosa, DatosFamiliaNumerosaBuilder> {
  _$DatosFamiliaNumerosa? _$v;

  String? _codError;
  String? get codError => _$this._codError;
  set codError(String? codError) => _$this._codError = codError;

  String? _datos;
  String? get datos => _$this._datos;
  set datos(String? datos) => _$this._datos = datos;

  String? _descError;
  String? get descError => _$this._descError;
  set descError(String? descError) => _$this._descError = descError;

  String? _fechaValidezDesde;
  String? get fechaValidezDesde => _$this._fechaValidezDesde;
  set fechaValidezDesde(String? fechaValidezDesde) =>
      _$this._fechaValidezDesde = fechaValidezDesde;

  String? _fechaValidezHasta;
  String? get fechaValidezHasta => _$this._fechaValidezHasta;
  set fechaValidezHasta(String? fechaValidezHasta) =>
      _$this._fechaValidezHasta = fechaValidezHasta;

  String? _numeroTitulo;
  String? get numeroTitulo => _$this._numeroTitulo;
  set numeroTitulo(String? numeroTitulo) => _$this._numeroTitulo = numeroTitulo;

  DatosFamiliaNumerosaBuilder() {
    DatosFamiliaNumerosa._defaults(this);
  }

  DatosFamiliaNumerosaBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _codError = $v.codError;
      _datos = $v.datos;
      _descError = $v.descError;
      _fechaValidezDesde = $v.fechaValidezDesde;
      _fechaValidezHasta = $v.fechaValidezHasta;
      _numeroTitulo = $v.numeroTitulo;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DatosFamiliaNumerosa other) {
    _$v = other as _$DatosFamiliaNumerosa;
  }

  @override
  void update(void Function(DatosFamiliaNumerosaBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DatosFamiliaNumerosa build() => _build();

  _$DatosFamiliaNumerosa _build() {
    final _$result = _$v ??
        _$DatosFamiliaNumerosa._(
          codError: codError,
          datos: datos,
          descError: descError,
          fechaValidezDesde: fechaValidezDesde,
          fechaValidezHasta: fechaValidezHasta,
          numeroTitulo: numeroTitulo,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
