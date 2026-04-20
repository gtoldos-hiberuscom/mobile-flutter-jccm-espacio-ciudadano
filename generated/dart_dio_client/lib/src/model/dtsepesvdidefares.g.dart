// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dtsepesvdidefares.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DTSEPESVDIDEFARES extends DTSEPESVDIDEFARES {
  @override
  final String? idpeticion;
  @override
  final String? inscrito;
  @override
  final String? mensaje;
  @override
  final String? resul;
  @override
  final String? ultimainscrip;

  factory _$DTSEPESVDIDEFARES(
          [void Function(DTSEPESVDIDEFARESBuilder)? updates]) =>
      (DTSEPESVDIDEFARESBuilder()..update(updates))._build();

  _$DTSEPESVDIDEFARES._(
      {this.idpeticion,
      this.inscrito,
      this.mensaje,
      this.resul,
      this.ultimainscrip})
      : super._();
  @override
  DTSEPESVDIDEFARES rebuild(void Function(DTSEPESVDIDEFARESBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DTSEPESVDIDEFARESBuilder toBuilder() =>
      DTSEPESVDIDEFARESBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DTSEPESVDIDEFARES &&
        idpeticion == other.idpeticion &&
        inscrito == other.inscrito &&
        mensaje == other.mensaje &&
        resul == other.resul &&
        ultimainscrip == other.ultimainscrip;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, idpeticion.hashCode);
    _$hash = $jc(_$hash, inscrito.hashCode);
    _$hash = $jc(_$hash, mensaje.hashCode);
    _$hash = $jc(_$hash, resul.hashCode);
    _$hash = $jc(_$hash, ultimainscrip.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DTSEPESVDIDEFARES')
          ..add('idpeticion', idpeticion)
          ..add('inscrito', inscrito)
          ..add('mensaje', mensaje)
          ..add('resul', resul)
          ..add('ultimainscrip', ultimainscrip))
        .toString();
  }
}

class DTSEPESVDIDEFARESBuilder
    implements Builder<DTSEPESVDIDEFARES, DTSEPESVDIDEFARESBuilder> {
  _$DTSEPESVDIDEFARES? _$v;

  String? _idpeticion;
  String? get idpeticion => _$this._idpeticion;
  set idpeticion(String? idpeticion) => _$this._idpeticion = idpeticion;

  String? _inscrito;
  String? get inscrito => _$this._inscrito;
  set inscrito(String? inscrito) => _$this._inscrito = inscrito;

  String? _mensaje;
  String? get mensaje => _$this._mensaje;
  set mensaje(String? mensaje) => _$this._mensaje = mensaje;

  String? _resul;
  String? get resul => _$this._resul;
  set resul(String? resul) => _$this._resul = resul;

  String? _ultimainscrip;
  String? get ultimainscrip => _$this._ultimainscrip;
  set ultimainscrip(String? ultimainscrip) =>
      _$this._ultimainscrip = ultimainscrip;

  DTSEPESVDIDEFARESBuilder() {
    DTSEPESVDIDEFARES._defaults(this);
  }

  DTSEPESVDIDEFARESBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _idpeticion = $v.idpeticion;
      _inscrito = $v.inscrito;
      _mensaje = $v.mensaje;
      _resul = $v.resul;
      _ultimainscrip = $v.ultimainscrip;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DTSEPESVDIDEFARES other) {
    _$v = other as _$DTSEPESVDIDEFARES;
  }

  @override
  void update(void Function(DTSEPESVDIDEFARESBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DTSEPESVDIDEFARES build() => _build();

  _$DTSEPESVDIDEFARES _build() {
    final _$result = _$v ??
        _$DTSEPESVDIDEFARES._(
          idpeticion: idpeticion,
          inscrito: inscrito,
          mensaje: mensaje,
          resul: resul,
          ultimainscrip: ultimainscrip,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
