// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dtdgtlistadovehiculosres.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DTDGTLISTADOVEHICULOSRES extends DTDGTLISTADOVEHICULOSRES {
  @override
  final String? idepeticion;
  @override
  final LISTAVEHICULOS? listavehiculos;
  @override
  final String? mensaje;
  @override
  final String? resul;

  factory _$DTDGTLISTADOVEHICULOSRES(
          [void Function(DTDGTLISTADOVEHICULOSRESBuilder)? updates]) =>
      (DTDGTLISTADOVEHICULOSRESBuilder()..update(updates))._build();

  _$DTDGTLISTADOVEHICULOSRES._(
      {this.idepeticion, this.listavehiculos, this.mensaje, this.resul})
      : super._();
  @override
  DTDGTLISTADOVEHICULOSRES rebuild(
          void Function(DTDGTLISTADOVEHICULOSRESBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DTDGTLISTADOVEHICULOSRESBuilder toBuilder() =>
      DTDGTLISTADOVEHICULOSRESBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DTDGTLISTADOVEHICULOSRES &&
        idepeticion == other.idepeticion &&
        listavehiculos == other.listavehiculos &&
        mensaje == other.mensaje &&
        resul == other.resul;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, idepeticion.hashCode);
    _$hash = $jc(_$hash, listavehiculos.hashCode);
    _$hash = $jc(_$hash, mensaje.hashCode);
    _$hash = $jc(_$hash, resul.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DTDGTLISTADOVEHICULOSRES')
          ..add('idepeticion', idepeticion)
          ..add('listavehiculos', listavehiculos)
          ..add('mensaje', mensaje)
          ..add('resul', resul))
        .toString();
  }
}

class DTDGTLISTADOVEHICULOSRESBuilder
    implements
        Builder<DTDGTLISTADOVEHICULOSRES, DTDGTLISTADOVEHICULOSRESBuilder> {
  _$DTDGTLISTADOVEHICULOSRES? _$v;

  String? _idepeticion;
  String? get idepeticion => _$this._idepeticion;
  set idepeticion(String? idepeticion) => _$this._idepeticion = idepeticion;

  LISTAVEHICULOSBuilder? _listavehiculos;
  LISTAVEHICULOSBuilder get listavehiculos =>
      _$this._listavehiculos ??= LISTAVEHICULOSBuilder();
  set listavehiculos(LISTAVEHICULOSBuilder? listavehiculos) =>
      _$this._listavehiculos = listavehiculos;

  String? _mensaje;
  String? get mensaje => _$this._mensaje;
  set mensaje(String? mensaje) => _$this._mensaje = mensaje;

  String? _resul;
  String? get resul => _$this._resul;
  set resul(String? resul) => _$this._resul = resul;

  DTDGTLISTADOVEHICULOSRESBuilder() {
    DTDGTLISTADOVEHICULOSRES._defaults(this);
  }

  DTDGTLISTADOVEHICULOSRESBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _idepeticion = $v.idepeticion;
      _listavehiculos = $v.listavehiculos?.toBuilder();
      _mensaje = $v.mensaje;
      _resul = $v.resul;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DTDGTLISTADOVEHICULOSRES other) {
    _$v = other as _$DTDGTLISTADOVEHICULOSRES;
  }

  @override
  void update(void Function(DTDGTLISTADOVEHICULOSRESBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DTDGTLISTADOVEHICULOSRES build() => _build();

  _$DTDGTLISTADOVEHICULOSRES _build() {
    _$DTDGTLISTADOVEHICULOSRES _$result;
    try {
      _$result = _$v ??
          _$DTDGTLISTADOVEHICULOSRES._(
            idepeticion: idepeticion,
            listavehiculos: _listavehiculos?.build(),
            mensaje: mensaje,
            resul: resul,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'listavehiculos';
        _listavehiculos?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'DTDGTLISTADOVEHICULOSRES', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
