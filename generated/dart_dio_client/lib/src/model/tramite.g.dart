// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tramite.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Tramite extends Tramite {
  @override
  final String? fechaPresentacionFin;
  @override
  final String? fechaPresentacionIni;
  @override
  final int? idTramite;
  @override
  final int? idUnidadResponsable;
  @override
  final String? nombreTramite;
  @override
  final String? nombreUnidadResponsable;

  factory _$Tramite([void Function(TramiteBuilder)? updates]) =>
      (TramiteBuilder()..update(updates))._build();

  _$Tramite._(
      {this.fechaPresentacionFin,
      this.fechaPresentacionIni,
      this.idTramite,
      this.idUnidadResponsable,
      this.nombreTramite,
      this.nombreUnidadResponsable})
      : super._();
  @override
  Tramite rebuild(void Function(TramiteBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TramiteBuilder toBuilder() => TramiteBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Tramite &&
        fechaPresentacionFin == other.fechaPresentacionFin &&
        fechaPresentacionIni == other.fechaPresentacionIni &&
        idTramite == other.idTramite &&
        idUnidadResponsable == other.idUnidadResponsable &&
        nombreTramite == other.nombreTramite &&
        nombreUnidadResponsable == other.nombreUnidadResponsable;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, fechaPresentacionFin.hashCode);
    _$hash = $jc(_$hash, fechaPresentacionIni.hashCode);
    _$hash = $jc(_$hash, idTramite.hashCode);
    _$hash = $jc(_$hash, idUnidadResponsable.hashCode);
    _$hash = $jc(_$hash, nombreTramite.hashCode);
    _$hash = $jc(_$hash, nombreUnidadResponsable.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Tramite')
          ..add('fechaPresentacionFin', fechaPresentacionFin)
          ..add('fechaPresentacionIni', fechaPresentacionIni)
          ..add('idTramite', idTramite)
          ..add('idUnidadResponsable', idUnidadResponsable)
          ..add('nombreTramite', nombreTramite)
          ..add('nombreUnidadResponsable', nombreUnidadResponsable))
        .toString();
  }
}

class TramiteBuilder implements Builder<Tramite, TramiteBuilder> {
  _$Tramite? _$v;

  String? _fechaPresentacionFin;
  String? get fechaPresentacionFin => _$this._fechaPresentacionFin;
  set fechaPresentacionFin(String? fechaPresentacionFin) =>
      _$this._fechaPresentacionFin = fechaPresentacionFin;

  String? _fechaPresentacionIni;
  String? get fechaPresentacionIni => _$this._fechaPresentacionIni;
  set fechaPresentacionIni(String? fechaPresentacionIni) =>
      _$this._fechaPresentacionIni = fechaPresentacionIni;

  int? _idTramite;
  int? get idTramite => _$this._idTramite;
  set idTramite(int? idTramite) => _$this._idTramite = idTramite;

  int? _idUnidadResponsable;
  int? get idUnidadResponsable => _$this._idUnidadResponsable;
  set idUnidadResponsable(int? idUnidadResponsable) =>
      _$this._idUnidadResponsable = idUnidadResponsable;

  String? _nombreTramite;
  String? get nombreTramite => _$this._nombreTramite;
  set nombreTramite(String? nombreTramite) =>
      _$this._nombreTramite = nombreTramite;

  String? _nombreUnidadResponsable;
  String? get nombreUnidadResponsable => _$this._nombreUnidadResponsable;
  set nombreUnidadResponsable(String? nombreUnidadResponsable) =>
      _$this._nombreUnidadResponsable = nombreUnidadResponsable;

  TramiteBuilder() {
    Tramite._defaults(this);
  }

  TramiteBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _fechaPresentacionFin = $v.fechaPresentacionFin;
      _fechaPresentacionIni = $v.fechaPresentacionIni;
      _idTramite = $v.idTramite;
      _idUnidadResponsable = $v.idUnidadResponsable;
      _nombreTramite = $v.nombreTramite;
      _nombreUnidadResponsable = $v.nombreUnidadResponsable;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Tramite other) {
    _$v = other as _$Tramite;
  }

  @override
  void update(void Function(TramiteBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Tramite build() => _build();

  _$Tramite _build() {
    final _$result = _$v ??
        _$Tramite._(
          fechaPresentacionFin: fechaPresentacionFin,
          fechaPresentacionIni: fechaPresentacionIni,
          idTramite: idTramite,
          idUnidadResponsable: idUnidadResponsable,
          nombreTramite: nombreTramite,
          nombreUnidadResponsable: nombreUnidadResponsable,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
