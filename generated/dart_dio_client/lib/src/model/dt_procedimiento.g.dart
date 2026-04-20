// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dt_procedimiento.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DTProcedimiento extends DTProcedimiento {
  @override
  final ADJUNTOS adjuntos;
  @override
  final String? asudescripcion;
  @override
  final String asunto;
  @override
  final String consejeria;
  @override
  final DATOSPAGO? datospago;
  @override
  final JsonObject datosprocedimiento;
  @override
  final DATOSSOLICITANTE datossolicitante;
  @override
  final String? firma;
  @override
  final DTIdentificacion identificacion;
  @override
  final DTIdentificacionRep identificacionrep;
  @override
  final String idunico;
  @override
  final String noexpediente;
  @override
  final String provincia;
  @override
  final REGISTRO registro;
  @override
  final String? source_;
  @override
  final String tipoprocedimiento;
  @override
  final String unidadorganica;

  factory _$DTProcedimiento([void Function(DTProcedimientoBuilder)? updates]) =>
      (DTProcedimientoBuilder()..update(updates))._build();

  _$DTProcedimiento._(
      {required this.adjuntos,
      this.asudescripcion,
      required this.asunto,
      required this.consejeria,
      this.datospago,
      required this.datosprocedimiento,
      required this.datossolicitante,
      this.firma,
      required this.identificacion,
      required this.identificacionrep,
      required this.idunico,
      required this.noexpediente,
      required this.provincia,
      required this.registro,
      this.source_,
      required this.tipoprocedimiento,
      required this.unidadorganica})
      : super._();
  @override
  DTProcedimiento rebuild(void Function(DTProcedimientoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DTProcedimientoBuilder toBuilder() => DTProcedimientoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DTProcedimiento &&
        adjuntos == other.adjuntos &&
        asudescripcion == other.asudescripcion &&
        asunto == other.asunto &&
        consejeria == other.consejeria &&
        datospago == other.datospago &&
        datosprocedimiento == other.datosprocedimiento &&
        datossolicitante == other.datossolicitante &&
        firma == other.firma &&
        identificacion == other.identificacion &&
        identificacionrep == other.identificacionrep &&
        idunico == other.idunico &&
        noexpediente == other.noexpediente &&
        provincia == other.provincia &&
        registro == other.registro &&
        source_ == other.source_ &&
        tipoprocedimiento == other.tipoprocedimiento &&
        unidadorganica == other.unidadorganica;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, adjuntos.hashCode);
    _$hash = $jc(_$hash, asudescripcion.hashCode);
    _$hash = $jc(_$hash, asunto.hashCode);
    _$hash = $jc(_$hash, consejeria.hashCode);
    _$hash = $jc(_$hash, datospago.hashCode);
    _$hash = $jc(_$hash, datosprocedimiento.hashCode);
    _$hash = $jc(_$hash, datossolicitante.hashCode);
    _$hash = $jc(_$hash, firma.hashCode);
    _$hash = $jc(_$hash, identificacion.hashCode);
    _$hash = $jc(_$hash, identificacionrep.hashCode);
    _$hash = $jc(_$hash, idunico.hashCode);
    _$hash = $jc(_$hash, noexpediente.hashCode);
    _$hash = $jc(_$hash, provincia.hashCode);
    _$hash = $jc(_$hash, registro.hashCode);
    _$hash = $jc(_$hash, source_.hashCode);
    _$hash = $jc(_$hash, tipoprocedimiento.hashCode);
    _$hash = $jc(_$hash, unidadorganica.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DTProcedimiento')
          ..add('adjuntos', adjuntos)
          ..add('asudescripcion', asudescripcion)
          ..add('asunto', asunto)
          ..add('consejeria', consejeria)
          ..add('datospago', datospago)
          ..add('datosprocedimiento', datosprocedimiento)
          ..add('datossolicitante', datossolicitante)
          ..add('firma', firma)
          ..add('identificacion', identificacion)
          ..add('identificacionrep', identificacionrep)
          ..add('idunico', idunico)
          ..add('noexpediente', noexpediente)
          ..add('provincia', provincia)
          ..add('registro', registro)
          ..add('source_', source_)
          ..add('tipoprocedimiento', tipoprocedimiento)
          ..add('unidadorganica', unidadorganica))
        .toString();
  }
}

class DTProcedimientoBuilder
    implements Builder<DTProcedimiento, DTProcedimientoBuilder> {
  _$DTProcedimiento? _$v;

  ADJUNTOSBuilder? _adjuntos;
  ADJUNTOSBuilder get adjuntos => _$this._adjuntos ??= ADJUNTOSBuilder();
  set adjuntos(ADJUNTOSBuilder? adjuntos) => _$this._adjuntos = adjuntos;

  String? _asudescripcion;
  String? get asudescripcion => _$this._asudescripcion;
  set asudescripcion(String? asudescripcion) =>
      _$this._asudescripcion = asudescripcion;

  String? _asunto;
  String? get asunto => _$this._asunto;
  set asunto(String? asunto) => _$this._asunto = asunto;

  String? _consejeria;
  String? get consejeria => _$this._consejeria;
  set consejeria(String? consejeria) => _$this._consejeria = consejeria;

  DATOSPAGOBuilder? _datospago;
  DATOSPAGOBuilder get datospago => _$this._datospago ??= DATOSPAGOBuilder();
  set datospago(DATOSPAGOBuilder? datospago) => _$this._datospago = datospago;

  JsonObject? _datosprocedimiento;
  JsonObject? get datosprocedimiento => _$this._datosprocedimiento;
  set datosprocedimiento(JsonObject? datosprocedimiento) =>
      _$this._datosprocedimiento = datosprocedimiento;

  DATOSSOLICITANTEBuilder? _datossolicitante;
  DATOSSOLICITANTEBuilder get datossolicitante =>
      _$this._datossolicitante ??= DATOSSOLICITANTEBuilder();
  set datossolicitante(DATOSSOLICITANTEBuilder? datossolicitante) =>
      _$this._datossolicitante = datossolicitante;

  String? _firma;
  String? get firma => _$this._firma;
  set firma(String? firma) => _$this._firma = firma;

  DTIdentificacionBuilder? _identificacion;
  DTIdentificacionBuilder get identificacion =>
      _$this._identificacion ??= DTIdentificacionBuilder();
  set identificacion(DTIdentificacionBuilder? identificacion) =>
      _$this._identificacion = identificacion;

  DTIdentificacionRepBuilder? _identificacionrep;
  DTIdentificacionRepBuilder get identificacionrep =>
      _$this._identificacionrep ??= DTIdentificacionRepBuilder();
  set identificacionrep(DTIdentificacionRepBuilder? identificacionrep) =>
      _$this._identificacionrep = identificacionrep;

  String? _idunico;
  String? get idunico => _$this._idunico;
  set idunico(String? idunico) => _$this._idunico = idunico;

  String? _noexpediente;
  String? get noexpediente => _$this._noexpediente;
  set noexpediente(String? noexpediente) => _$this._noexpediente = noexpediente;

  String? _provincia;
  String? get provincia => _$this._provincia;
  set provincia(String? provincia) => _$this._provincia = provincia;

  REGISTROBuilder? _registro;
  REGISTROBuilder get registro => _$this._registro ??= REGISTROBuilder();
  set registro(REGISTROBuilder? registro) => _$this._registro = registro;

  String? _source_;
  String? get source_ => _$this._source_;
  set source_(String? source_) => _$this._source_ = source_;

  String? _tipoprocedimiento;
  String? get tipoprocedimiento => _$this._tipoprocedimiento;
  set tipoprocedimiento(String? tipoprocedimiento) =>
      _$this._tipoprocedimiento = tipoprocedimiento;

  String? _unidadorganica;
  String? get unidadorganica => _$this._unidadorganica;
  set unidadorganica(String? unidadorganica) =>
      _$this._unidadorganica = unidadorganica;

  DTProcedimientoBuilder() {
    DTProcedimiento._defaults(this);
  }

  DTProcedimientoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _adjuntos = $v.adjuntos.toBuilder();
      _asudescripcion = $v.asudescripcion;
      _asunto = $v.asunto;
      _consejeria = $v.consejeria;
      _datospago = $v.datospago?.toBuilder();
      _datosprocedimiento = $v.datosprocedimiento;
      _datossolicitante = $v.datossolicitante.toBuilder();
      _firma = $v.firma;
      _identificacion = $v.identificacion.toBuilder();
      _identificacionrep = $v.identificacionrep.toBuilder();
      _idunico = $v.idunico;
      _noexpediente = $v.noexpediente;
      _provincia = $v.provincia;
      _registro = $v.registro.toBuilder();
      _source_ = $v.source_;
      _tipoprocedimiento = $v.tipoprocedimiento;
      _unidadorganica = $v.unidadorganica;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DTProcedimiento other) {
    _$v = other as _$DTProcedimiento;
  }

  @override
  void update(void Function(DTProcedimientoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DTProcedimiento build() => _build();

  _$DTProcedimiento _build() {
    _$DTProcedimiento _$result;
    try {
      _$result = _$v ??
          _$DTProcedimiento._(
            adjuntos: adjuntos.build(),
            asudescripcion: asudescripcion,
            asunto: BuiltValueNullFieldError.checkNotNull(
                asunto, r'DTProcedimiento', 'asunto'),
            consejeria: BuiltValueNullFieldError.checkNotNull(
                consejeria, r'DTProcedimiento', 'consejeria'),
            datospago: _datospago?.build(),
            datosprocedimiento: BuiltValueNullFieldError.checkNotNull(
                datosprocedimiento, r'DTProcedimiento', 'datosprocedimiento'),
            datossolicitante: datossolicitante.build(),
            firma: firma,
            identificacion: identificacion.build(),
            identificacionrep: identificacionrep.build(),
            idunico: BuiltValueNullFieldError.checkNotNull(
                idunico, r'DTProcedimiento', 'idunico'),
            noexpediente: BuiltValueNullFieldError.checkNotNull(
                noexpediente, r'DTProcedimiento', 'noexpediente'),
            provincia: BuiltValueNullFieldError.checkNotNull(
                provincia, r'DTProcedimiento', 'provincia'),
            registro: registro.build(),
            source_: source_,
            tipoprocedimiento: BuiltValueNullFieldError.checkNotNull(
                tipoprocedimiento, r'DTProcedimiento', 'tipoprocedimiento'),
            unidadorganica: BuiltValueNullFieldError.checkNotNull(
                unidadorganica, r'DTProcedimiento', 'unidadorganica'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'adjuntos';
        adjuntos.build();

        _$failedField = 'datospago';
        _datospago?.build();

        _$failedField = 'datossolicitante';
        datossolicitante.build();

        _$failedField = 'identificacion';
        identificacion.build();
        _$failedField = 'identificacionrep';
        identificacionrep.build();

        _$failedField = 'registro';
        registro.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'DTProcedimiento', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
