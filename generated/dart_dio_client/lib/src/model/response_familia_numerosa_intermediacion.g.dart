// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response_familia_numerosa_intermediacion.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ResponseFamiliaNumerosaIntermediacion
    extends ResponseFamiliaNumerosaIntermediacion {
  @override
  final String? codestado;
  @override
  final DatosEspecificosFamiliaNumerosa? datosespecificos;
  @override
  final String? docu;
  @override
  final String? idpeticion;
  @override
  final String? mensaje;
  @override
  final String? tipodoc;

  factory _$ResponseFamiliaNumerosaIntermediacion(
          [void Function(ResponseFamiliaNumerosaIntermediacionBuilder)?
              updates]) =>
      (ResponseFamiliaNumerosaIntermediacionBuilder()..update(updates))
          ._build();

  _$ResponseFamiliaNumerosaIntermediacion._(
      {this.codestado,
      this.datosespecificos,
      this.docu,
      this.idpeticion,
      this.mensaje,
      this.tipodoc})
      : super._();
  @override
  ResponseFamiliaNumerosaIntermediacion rebuild(
          void Function(ResponseFamiliaNumerosaIntermediacionBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ResponseFamiliaNumerosaIntermediacionBuilder toBuilder() =>
      ResponseFamiliaNumerosaIntermediacionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ResponseFamiliaNumerosaIntermediacion &&
        codestado == other.codestado &&
        datosespecificos == other.datosespecificos &&
        docu == other.docu &&
        idpeticion == other.idpeticion &&
        mensaje == other.mensaje &&
        tipodoc == other.tipodoc;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, codestado.hashCode);
    _$hash = $jc(_$hash, datosespecificos.hashCode);
    _$hash = $jc(_$hash, docu.hashCode);
    _$hash = $jc(_$hash, idpeticion.hashCode);
    _$hash = $jc(_$hash, mensaje.hashCode);
    _$hash = $jc(_$hash, tipodoc.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'ResponseFamiliaNumerosaIntermediacion')
          ..add('codestado', codestado)
          ..add('datosespecificos', datosespecificos)
          ..add('docu', docu)
          ..add('idpeticion', idpeticion)
          ..add('mensaje', mensaje)
          ..add('tipodoc', tipodoc))
        .toString();
  }
}

class ResponseFamiliaNumerosaIntermediacionBuilder
    implements
        Builder<ResponseFamiliaNumerosaIntermediacion,
            ResponseFamiliaNumerosaIntermediacionBuilder> {
  _$ResponseFamiliaNumerosaIntermediacion? _$v;

  String? _codestado;
  String? get codestado => _$this._codestado;
  set codestado(String? codestado) => _$this._codestado = codestado;

  DatosEspecificosFamiliaNumerosaBuilder? _datosespecificos;
  DatosEspecificosFamiliaNumerosaBuilder get datosespecificos =>
      _$this._datosespecificos ??= DatosEspecificosFamiliaNumerosaBuilder();
  set datosespecificos(
          DatosEspecificosFamiliaNumerosaBuilder? datosespecificos) =>
      _$this._datosespecificos = datosespecificos;

  String? _docu;
  String? get docu => _$this._docu;
  set docu(String? docu) => _$this._docu = docu;

  String? _idpeticion;
  String? get idpeticion => _$this._idpeticion;
  set idpeticion(String? idpeticion) => _$this._idpeticion = idpeticion;

  String? _mensaje;
  String? get mensaje => _$this._mensaje;
  set mensaje(String? mensaje) => _$this._mensaje = mensaje;

  String? _tipodoc;
  String? get tipodoc => _$this._tipodoc;
  set tipodoc(String? tipodoc) => _$this._tipodoc = tipodoc;

  ResponseFamiliaNumerosaIntermediacionBuilder() {
    ResponseFamiliaNumerosaIntermediacion._defaults(this);
  }

  ResponseFamiliaNumerosaIntermediacionBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _codestado = $v.codestado;
      _datosespecificos = $v.datosespecificos?.toBuilder();
      _docu = $v.docu;
      _idpeticion = $v.idpeticion;
      _mensaje = $v.mensaje;
      _tipodoc = $v.tipodoc;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ResponseFamiliaNumerosaIntermediacion other) {
    _$v = other as _$ResponseFamiliaNumerosaIntermediacion;
  }

  @override
  void update(
      void Function(ResponseFamiliaNumerosaIntermediacionBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ResponseFamiliaNumerosaIntermediacion build() => _build();

  _$ResponseFamiliaNumerosaIntermediacion _build() {
    _$ResponseFamiliaNumerosaIntermediacion _$result;
    try {
      _$result = _$v ??
          _$ResponseFamiliaNumerosaIntermediacion._(
            codestado: codestado,
            datosespecificos: _datosespecificos?.build(),
            docu: docu,
            idpeticion: idpeticion,
            mensaje: mensaje,
            tipodoc: tipodoc,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'datosespecificos';
        _datosespecificos?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ResponseFamiliaNumerosaIntermediacion',
            _$failedField,
            e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
