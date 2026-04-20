// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dtedutuores.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DTEDUTUORES extends DTEDUTUORES {
  @override
  final String? docu;
  @override
  final BuiltList<ELEMENTO>? elemento;
  @override
  final String? fecnac;
  @override
  final String? idpeticion;
  @override
  final String? mensaje;
  @override
  final String? resul;

  factory _$DTEDUTUORES([void Function(DTEDUTUORESBuilder)? updates]) =>
      (DTEDUTUORESBuilder()..update(updates))._build();

  _$DTEDUTUORES._(
      {this.docu,
      this.elemento,
      this.fecnac,
      this.idpeticion,
      this.mensaje,
      this.resul})
      : super._();
  @override
  DTEDUTUORES rebuild(void Function(DTEDUTUORESBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DTEDUTUORESBuilder toBuilder() => DTEDUTUORESBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DTEDUTUORES &&
        docu == other.docu &&
        elemento == other.elemento &&
        fecnac == other.fecnac &&
        idpeticion == other.idpeticion &&
        mensaje == other.mensaje &&
        resul == other.resul;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, docu.hashCode);
    _$hash = $jc(_$hash, elemento.hashCode);
    _$hash = $jc(_$hash, fecnac.hashCode);
    _$hash = $jc(_$hash, idpeticion.hashCode);
    _$hash = $jc(_$hash, mensaje.hashCode);
    _$hash = $jc(_$hash, resul.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DTEDUTUORES')
          ..add('docu', docu)
          ..add('elemento', elemento)
          ..add('fecnac', fecnac)
          ..add('idpeticion', idpeticion)
          ..add('mensaje', mensaje)
          ..add('resul', resul))
        .toString();
  }
}

class DTEDUTUORESBuilder implements Builder<DTEDUTUORES, DTEDUTUORESBuilder> {
  _$DTEDUTUORES? _$v;

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

  String? _mensaje;
  String? get mensaje => _$this._mensaje;
  set mensaje(String? mensaje) => _$this._mensaje = mensaje;

  String? _resul;
  String? get resul => _$this._resul;
  set resul(String? resul) => _$this._resul = resul;

  DTEDUTUORESBuilder() {
    DTEDUTUORES._defaults(this);
  }

  DTEDUTUORESBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _docu = $v.docu;
      _elemento = $v.elemento?.toBuilder();
      _fecnac = $v.fecnac;
      _idpeticion = $v.idpeticion;
      _mensaje = $v.mensaje;
      _resul = $v.resul;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DTEDUTUORES other) {
    _$v = other as _$DTEDUTUORES;
  }

  @override
  void update(void Function(DTEDUTUORESBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DTEDUTUORES build() => _build();

  _$DTEDUTUORES _build() {
    _$DTEDUTUORES _$result;
    try {
      _$result = _$v ??
          _$DTEDUTUORES._(
            docu: docu,
            elemento: _elemento?.build(),
            fecnac: fecnac,
            idpeticion: idpeticion,
            mensaje: mensaje,
            resul: resul,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'elemento';
        _elemento?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'DTEDUTUORES', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
