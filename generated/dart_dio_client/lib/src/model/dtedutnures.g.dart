// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dtedutnures.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DTEDUTNURES extends DTEDUTNURES {
  @override
  final String? docu;
  @override
  final BuiltList<ELEMENTO>? elemento;
  @override
  final String? fecnac;
  @override
  final String? idpeticion;
  @override
  final String? locnac;
  @override
  final String? mensaje;
  @override
  final String? pais;
  @override
  final String? provnac;
  @override
  final String? resul;

  factory _$DTEDUTNURES([void Function(DTEDUTNURESBuilder)? updates]) =>
      (DTEDUTNURESBuilder()..update(updates))._build();

  _$DTEDUTNURES._(
      {this.docu,
      this.elemento,
      this.fecnac,
      this.idpeticion,
      this.locnac,
      this.mensaje,
      this.pais,
      this.provnac,
      this.resul})
      : super._();
  @override
  DTEDUTNURES rebuild(void Function(DTEDUTNURESBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DTEDUTNURESBuilder toBuilder() => DTEDUTNURESBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DTEDUTNURES &&
        docu == other.docu &&
        elemento == other.elemento &&
        fecnac == other.fecnac &&
        idpeticion == other.idpeticion &&
        locnac == other.locnac &&
        mensaje == other.mensaje &&
        pais == other.pais &&
        provnac == other.provnac &&
        resul == other.resul;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, docu.hashCode);
    _$hash = $jc(_$hash, elemento.hashCode);
    _$hash = $jc(_$hash, fecnac.hashCode);
    _$hash = $jc(_$hash, idpeticion.hashCode);
    _$hash = $jc(_$hash, locnac.hashCode);
    _$hash = $jc(_$hash, mensaje.hashCode);
    _$hash = $jc(_$hash, pais.hashCode);
    _$hash = $jc(_$hash, provnac.hashCode);
    _$hash = $jc(_$hash, resul.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DTEDUTNURES')
          ..add('docu', docu)
          ..add('elemento', elemento)
          ..add('fecnac', fecnac)
          ..add('idpeticion', idpeticion)
          ..add('locnac', locnac)
          ..add('mensaje', mensaje)
          ..add('pais', pais)
          ..add('provnac', provnac)
          ..add('resul', resul))
        .toString();
  }
}

class DTEDUTNURESBuilder implements Builder<DTEDUTNURES, DTEDUTNURESBuilder> {
  _$DTEDUTNURES? _$v;

  String? _docu;
  String? get docu => _$this._docu;
  set docu(String? docu) => _$this._docu = docu;

  ListBuilder<ELEMENTO>? _elemento;
  ListBuilder<ELEMENTO> get elemento =>
      _$this._elemento ??= ListBuilder<ELEMENTO>();
  set elemento(ListBuilder<ELEMENTO>? elemento) => _$this._elemento = elemento;

  String? _fecnac;
  String? get fecnac => _$this._fecnac;
  set fecnac(String? fecnac) => _$this._fecnac = fecnac;

  String? _idpeticion;
  String? get idpeticion => _$this._idpeticion;
  set idpeticion(String? idpeticion) => _$this._idpeticion = idpeticion;

  String? _locnac;
  String? get locnac => _$this._locnac;
  set locnac(String? locnac) => _$this._locnac = locnac;

  String? _mensaje;
  String? get mensaje => _$this._mensaje;
  set mensaje(String? mensaje) => _$this._mensaje = mensaje;

  String? _pais;
  String? get pais => _$this._pais;
  set pais(String? pais) => _$this._pais = pais;

  String? _provnac;
  String? get provnac => _$this._provnac;
  set provnac(String? provnac) => _$this._provnac = provnac;

  String? _resul;
  String? get resul => _$this._resul;
  set resul(String? resul) => _$this._resul = resul;

  DTEDUTNURESBuilder() {
    DTEDUTNURES._defaults(this);
  }

  DTEDUTNURESBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _docu = $v.docu;
      _elemento = $v.elemento?.toBuilder();
      _fecnac = $v.fecnac;
      _idpeticion = $v.idpeticion;
      _locnac = $v.locnac;
      _mensaje = $v.mensaje;
      _pais = $v.pais;
      _provnac = $v.provnac;
      _resul = $v.resul;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DTEDUTNURES other) {
    _$v = other as _$DTEDUTNURES;
  }

  @override
  void update(void Function(DTEDUTNURESBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DTEDUTNURES build() => _build();

  _$DTEDUTNURES _build() {
    _$DTEDUTNURES _$result;
    try {
      _$result = _$v ??
          _$DTEDUTNURES._(
            docu: docu,
            elemento: _elemento?.build(),
            fecnac: fecnac,
            idpeticion: idpeticion,
            locnac: locnac,
            mensaje: mensaje,
            pais: pais,
            provnac: provnac,
            resul: resul,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'elemento';
        _elemento?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'DTEDUTNURES', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
