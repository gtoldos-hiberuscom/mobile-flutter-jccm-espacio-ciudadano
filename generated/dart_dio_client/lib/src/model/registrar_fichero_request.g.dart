// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'registrar_fichero_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RegistrarFicheroRequest extends RegistrarFicheroRequest {
  @override
  final CONFIRMARPROCEDIMIENTO? confirmarProcedimiento;
  @override
  final String? consejeriaTramitadora;
  @override
  final DatosRepresentante? datosRepresentante;
  @override
  final BuiltList<DocumentoRegistro>? documentos;
  @override
  final bool? esPorContraste;
  @override
  final String? estadoTramitacion;
  @override
  final String? fechaCierreTramitacion;
  @override
  final String? fechaInicioTramitacion;
  @override
  final String? oficinaTramitadora;
  @override
  final String? procedimiento;
  @override
  final XMLRegistro? xmlRegistro;

  factory _$RegistrarFicheroRequest(
          [void Function(RegistrarFicheroRequestBuilder)? updates]) =>
      (RegistrarFicheroRequestBuilder()..update(updates))._build();

  _$RegistrarFicheroRequest._(
      {this.confirmarProcedimiento,
      this.consejeriaTramitadora,
      this.datosRepresentante,
      this.documentos,
      this.esPorContraste,
      this.estadoTramitacion,
      this.fechaCierreTramitacion,
      this.fechaInicioTramitacion,
      this.oficinaTramitadora,
      this.procedimiento,
      this.xmlRegistro})
      : super._();
  @override
  RegistrarFicheroRequest rebuild(
          void Function(RegistrarFicheroRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RegistrarFicheroRequestBuilder toBuilder() =>
      RegistrarFicheroRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RegistrarFicheroRequest &&
        confirmarProcedimiento == other.confirmarProcedimiento &&
        consejeriaTramitadora == other.consejeriaTramitadora &&
        datosRepresentante == other.datosRepresentante &&
        documentos == other.documentos &&
        esPorContraste == other.esPorContraste &&
        estadoTramitacion == other.estadoTramitacion &&
        fechaCierreTramitacion == other.fechaCierreTramitacion &&
        fechaInicioTramitacion == other.fechaInicioTramitacion &&
        oficinaTramitadora == other.oficinaTramitadora &&
        procedimiento == other.procedimiento &&
        xmlRegistro == other.xmlRegistro;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, confirmarProcedimiento.hashCode);
    _$hash = $jc(_$hash, consejeriaTramitadora.hashCode);
    _$hash = $jc(_$hash, datosRepresentante.hashCode);
    _$hash = $jc(_$hash, documentos.hashCode);
    _$hash = $jc(_$hash, esPorContraste.hashCode);
    _$hash = $jc(_$hash, estadoTramitacion.hashCode);
    _$hash = $jc(_$hash, fechaCierreTramitacion.hashCode);
    _$hash = $jc(_$hash, fechaInicioTramitacion.hashCode);
    _$hash = $jc(_$hash, oficinaTramitadora.hashCode);
    _$hash = $jc(_$hash, procedimiento.hashCode);
    _$hash = $jc(_$hash, xmlRegistro.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RegistrarFicheroRequest')
          ..add('confirmarProcedimiento', confirmarProcedimiento)
          ..add('consejeriaTramitadora', consejeriaTramitadora)
          ..add('datosRepresentante', datosRepresentante)
          ..add('documentos', documentos)
          ..add('esPorContraste', esPorContraste)
          ..add('estadoTramitacion', estadoTramitacion)
          ..add('fechaCierreTramitacion', fechaCierreTramitacion)
          ..add('fechaInicioTramitacion', fechaInicioTramitacion)
          ..add('oficinaTramitadora', oficinaTramitadora)
          ..add('procedimiento', procedimiento)
          ..add('xmlRegistro', xmlRegistro))
        .toString();
  }
}

class RegistrarFicheroRequestBuilder
    implements
        Builder<RegistrarFicheroRequest, RegistrarFicheroRequestBuilder> {
  _$RegistrarFicheroRequest? _$v;

  CONFIRMARPROCEDIMIENTOBuilder? _confirmarProcedimiento;
  CONFIRMARPROCEDIMIENTOBuilder get confirmarProcedimiento =>
      _$this._confirmarProcedimiento ??= CONFIRMARPROCEDIMIENTOBuilder();
  set confirmarProcedimiento(
          CONFIRMARPROCEDIMIENTOBuilder? confirmarProcedimiento) =>
      _$this._confirmarProcedimiento = confirmarProcedimiento;

  String? _consejeriaTramitadora;
  String? get consejeriaTramitadora => _$this._consejeriaTramitadora;
  set consejeriaTramitadora(String? consejeriaTramitadora) =>
      _$this._consejeriaTramitadora = consejeriaTramitadora;

  DatosRepresentanteBuilder? _datosRepresentante;
  DatosRepresentanteBuilder get datosRepresentante =>
      _$this._datosRepresentante ??= DatosRepresentanteBuilder();
  set datosRepresentante(DatosRepresentanteBuilder? datosRepresentante) =>
      _$this._datosRepresentante = datosRepresentante;

  ListBuilder<DocumentoRegistro>? _documentos;
  ListBuilder<DocumentoRegistro> get documentos =>
      _$this._documentos ??= ListBuilder<DocumentoRegistro>();
  set documentos(ListBuilder<DocumentoRegistro>? documentos) =>
      _$this._documentos = documentos;

  bool? _esPorContraste;
  bool? get esPorContraste => _$this._esPorContraste;
  set esPorContraste(bool? esPorContraste) =>
      _$this._esPorContraste = esPorContraste;

  String? _estadoTramitacion;
  String? get estadoTramitacion => _$this._estadoTramitacion;
  set estadoTramitacion(String? estadoTramitacion) =>
      _$this._estadoTramitacion = estadoTramitacion;

  String? _fechaCierreTramitacion;
  String? get fechaCierreTramitacion => _$this._fechaCierreTramitacion;
  set fechaCierreTramitacion(String? fechaCierreTramitacion) =>
      _$this._fechaCierreTramitacion = fechaCierreTramitacion;

  String? _fechaInicioTramitacion;
  String? get fechaInicioTramitacion => _$this._fechaInicioTramitacion;
  set fechaInicioTramitacion(String? fechaInicioTramitacion) =>
      _$this._fechaInicioTramitacion = fechaInicioTramitacion;

  String? _oficinaTramitadora;
  String? get oficinaTramitadora => _$this._oficinaTramitadora;
  set oficinaTramitadora(String? oficinaTramitadora) =>
      _$this._oficinaTramitadora = oficinaTramitadora;

  String? _procedimiento;
  String? get procedimiento => _$this._procedimiento;
  set procedimiento(String? procedimiento) =>
      _$this._procedimiento = procedimiento;

  XMLRegistroBuilder? _xmlRegistro;
  XMLRegistroBuilder get xmlRegistro =>
      _$this._xmlRegistro ??= XMLRegistroBuilder();
  set xmlRegistro(XMLRegistroBuilder? xmlRegistro) =>
      _$this._xmlRegistro = xmlRegistro;

  RegistrarFicheroRequestBuilder() {
    RegistrarFicheroRequest._defaults(this);
  }

  RegistrarFicheroRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _confirmarProcedimiento = $v.confirmarProcedimiento?.toBuilder();
      _consejeriaTramitadora = $v.consejeriaTramitadora;
      _datosRepresentante = $v.datosRepresentante?.toBuilder();
      _documentos = $v.documentos?.toBuilder();
      _esPorContraste = $v.esPorContraste;
      _estadoTramitacion = $v.estadoTramitacion;
      _fechaCierreTramitacion = $v.fechaCierreTramitacion;
      _fechaInicioTramitacion = $v.fechaInicioTramitacion;
      _oficinaTramitadora = $v.oficinaTramitadora;
      _procedimiento = $v.procedimiento;
      _xmlRegistro = $v.xmlRegistro?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RegistrarFicheroRequest other) {
    _$v = other as _$RegistrarFicheroRequest;
  }

  @override
  void update(void Function(RegistrarFicheroRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RegistrarFicheroRequest build() => _build();

  _$RegistrarFicheroRequest _build() {
    _$RegistrarFicheroRequest _$result;
    try {
      _$result = _$v ??
          _$RegistrarFicheroRequest._(
            confirmarProcedimiento: _confirmarProcedimiento?.build(),
            consejeriaTramitadora: consejeriaTramitadora,
            datosRepresentante: _datosRepresentante?.build(),
            documentos: _documentos?.build(),
            esPorContraste: esPorContraste,
            estadoTramitacion: estadoTramitacion,
            fechaCierreTramitacion: fechaCierreTramitacion,
            fechaInicioTramitacion: fechaInicioTramitacion,
            oficinaTramitadora: oficinaTramitadora,
            procedimiento: procedimiento,
            xmlRegistro: _xmlRegistro?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'confirmarProcedimiento';
        _confirmarProcedimiento?.build();

        _$failedField = 'datosRepresentante';
        _datosRepresentante?.build();
        _$failedField = 'documentos';
        _documentos?.build();

        _$failedField = 'xmlRegistro';
        _xmlRegistro?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'RegistrarFicheroRequest', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
