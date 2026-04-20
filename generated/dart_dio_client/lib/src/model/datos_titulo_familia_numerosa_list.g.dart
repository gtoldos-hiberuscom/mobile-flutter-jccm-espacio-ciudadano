// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'datos_titulo_familia_numerosa_list.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DatosTituloFamiliaNumerosaList extends DatosTituloFamiliaNumerosaList {
  @override
  final String? categoria;
  @override
  final String? codigoComunidadAutoma;
  @override
  final String? fechaCaducidad;
  @override
  final String? fechaEfecto;
  @override
  final int? numeroHijos;
  @override
  final String? numeroTitulo;
  @override
  final String? tituloVigente;

  factory _$DatosTituloFamiliaNumerosaList(
          [void Function(DatosTituloFamiliaNumerosaListBuilder)? updates]) =>
      (DatosTituloFamiliaNumerosaListBuilder()..update(updates))._build();

  _$DatosTituloFamiliaNumerosaList._(
      {this.categoria,
      this.codigoComunidadAutoma,
      this.fechaCaducidad,
      this.fechaEfecto,
      this.numeroHijos,
      this.numeroTitulo,
      this.tituloVigente})
      : super._();
  @override
  DatosTituloFamiliaNumerosaList rebuild(
          void Function(DatosTituloFamiliaNumerosaListBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DatosTituloFamiliaNumerosaListBuilder toBuilder() =>
      DatosTituloFamiliaNumerosaListBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DatosTituloFamiliaNumerosaList &&
        categoria == other.categoria &&
        codigoComunidadAutoma == other.codigoComunidadAutoma &&
        fechaCaducidad == other.fechaCaducidad &&
        fechaEfecto == other.fechaEfecto &&
        numeroHijos == other.numeroHijos &&
        numeroTitulo == other.numeroTitulo &&
        tituloVigente == other.tituloVigente;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, categoria.hashCode);
    _$hash = $jc(_$hash, codigoComunidadAutoma.hashCode);
    _$hash = $jc(_$hash, fechaCaducidad.hashCode);
    _$hash = $jc(_$hash, fechaEfecto.hashCode);
    _$hash = $jc(_$hash, numeroHijos.hashCode);
    _$hash = $jc(_$hash, numeroTitulo.hashCode);
    _$hash = $jc(_$hash, tituloVigente.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DatosTituloFamiliaNumerosaList')
          ..add('categoria', categoria)
          ..add('codigoComunidadAutoma', codigoComunidadAutoma)
          ..add('fechaCaducidad', fechaCaducidad)
          ..add('fechaEfecto', fechaEfecto)
          ..add('numeroHijos', numeroHijos)
          ..add('numeroTitulo', numeroTitulo)
          ..add('tituloVigente', tituloVigente))
        .toString();
  }
}

class DatosTituloFamiliaNumerosaListBuilder
    implements
        Builder<DatosTituloFamiliaNumerosaList,
            DatosTituloFamiliaNumerosaListBuilder> {
  _$DatosTituloFamiliaNumerosaList? _$v;

  String? _categoria;
  String? get categoria => _$this._categoria;
  set categoria(String? categoria) => _$this._categoria = categoria;

  String? _codigoComunidadAutoma;
  String? get codigoComunidadAutoma => _$this._codigoComunidadAutoma;
  set codigoComunidadAutoma(String? codigoComunidadAutoma) =>
      _$this._codigoComunidadAutoma = codigoComunidadAutoma;

  String? _fechaCaducidad;
  String? get fechaCaducidad => _$this._fechaCaducidad;
  set fechaCaducidad(String? fechaCaducidad) =>
      _$this._fechaCaducidad = fechaCaducidad;

  String? _fechaEfecto;
  String? get fechaEfecto => _$this._fechaEfecto;
  set fechaEfecto(String? fechaEfecto) => _$this._fechaEfecto = fechaEfecto;

  int? _numeroHijos;
  int? get numeroHijos => _$this._numeroHijos;
  set numeroHijos(int? numeroHijos) => _$this._numeroHijos = numeroHijos;

  String? _numeroTitulo;
  String? get numeroTitulo => _$this._numeroTitulo;
  set numeroTitulo(String? numeroTitulo) => _$this._numeroTitulo = numeroTitulo;

  String? _tituloVigente;
  String? get tituloVigente => _$this._tituloVigente;
  set tituloVigente(String? tituloVigente) =>
      _$this._tituloVigente = tituloVigente;

  DatosTituloFamiliaNumerosaListBuilder() {
    DatosTituloFamiliaNumerosaList._defaults(this);
  }

  DatosTituloFamiliaNumerosaListBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _categoria = $v.categoria;
      _codigoComunidadAutoma = $v.codigoComunidadAutoma;
      _fechaCaducidad = $v.fechaCaducidad;
      _fechaEfecto = $v.fechaEfecto;
      _numeroHijos = $v.numeroHijos;
      _numeroTitulo = $v.numeroTitulo;
      _tituloVigente = $v.tituloVigente;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DatosTituloFamiliaNumerosaList other) {
    _$v = other as _$DatosTituloFamiliaNumerosaList;
  }

  @override
  void update(void Function(DatosTituloFamiliaNumerosaListBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DatosTituloFamiliaNumerosaList build() => _build();

  _$DatosTituloFamiliaNumerosaList _build() {
    final _$result = _$v ??
        _$DatosTituloFamiliaNumerosaList._(
          categoria: categoria,
          codigoComunidadAutoma: codigoComunidadAutoma,
          fechaCaducidad: fechaCaducidad,
          fechaEfecto: fechaEfecto,
          numeroHijos: numeroHijos,
          numeroTitulo: numeroTitulo,
          tituloVigente: tituloVigente,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
