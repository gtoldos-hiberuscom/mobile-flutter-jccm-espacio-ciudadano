// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notificacion_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$NotificacionDto extends NotificacionDto {
  @override
  final String? concepto;
  @override
  final String? descripcion;
  @override
  final BuiltList<DocumentosDto>? documentos;
  @override
  final String? estado;
  @override
  final ExpedienteDto? expediente;
  @override
  final DateTime? fecAlta;
  @override
  final DateTime? fecCaducidad;
  @override
  final BuiltList<HistoricoEstadoDto>? historicoEstados;
  @override
  final int? id;
  @override
  final BuiltList<InteresadoNotificaDto>? interesados;
  @override
  final ProcedimientoAdministrativoDto? procedimientoAdministrativo;
  @override
  final String? tipoEnvio;
  @override
  final UnidadOrganicaDto? unidadOrganica;

  factory _$NotificacionDto([void Function(NotificacionDtoBuilder)? updates]) =>
      (NotificacionDtoBuilder()..update(updates))._build();

  _$NotificacionDto._(
      {this.concepto,
      this.descripcion,
      this.documentos,
      this.estado,
      this.expediente,
      this.fecAlta,
      this.fecCaducidad,
      this.historicoEstados,
      this.id,
      this.interesados,
      this.procedimientoAdministrativo,
      this.tipoEnvio,
      this.unidadOrganica})
      : super._();
  @override
  NotificacionDto rebuild(void Function(NotificacionDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  NotificacionDtoBuilder toBuilder() => NotificacionDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is NotificacionDto &&
        concepto == other.concepto &&
        descripcion == other.descripcion &&
        documentos == other.documentos &&
        estado == other.estado &&
        expediente == other.expediente &&
        fecAlta == other.fecAlta &&
        fecCaducidad == other.fecCaducidad &&
        historicoEstados == other.historicoEstados &&
        id == other.id &&
        interesados == other.interesados &&
        procedimientoAdministrativo == other.procedimientoAdministrativo &&
        tipoEnvio == other.tipoEnvio &&
        unidadOrganica == other.unidadOrganica;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, concepto.hashCode);
    _$hash = $jc(_$hash, descripcion.hashCode);
    _$hash = $jc(_$hash, documentos.hashCode);
    _$hash = $jc(_$hash, estado.hashCode);
    _$hash = $jc(_$hash, expediente.hashCode);
    _$hash = $jc(_$hash, fecAlta.hashCode);
    _$hash = $jc(_$hash, fecCaducidad.hashCode);
    _$hash = $jc(_$hash, historicoEstados.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, interesados.hashCode);
    _$hash = $jc(_$hash, procedimientoAdministrativo.hashCode);
    _$hash = $jc(_$hash, tipoEnvio.hashCode);
    _$hash = $jc(_$hash, unidadOrganica.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'NotificacionDto')
          ..add('concepto', concepto)
          ..add('descripcion', descripcion)
          ..add('documentos', documentos)
          ..add('estado', estado)
          ..add('expediente', expediente)
          ..add('fecAlta', fecAlta)
          ..add('fecCaducidad', fecCaducidad)
          ..add('historicoEstados', historicoEstados)
          ..add('id', id)
          ..add('interesados', interesados)
          ..add('procedimientoAdministrativo', procedimientoAdministrativo)
          ..add('tipoEnvio', tipoEnvio)
          ..add('unidadOrganica', unidadOrganica))
        .toString();
  }
}

class NotificacionDtoBuilder
    implements Builder<NotificacionDto, NotificacionDtoBuilder> {
  _$NotificacionDto? _$v;

  String? _concepto;
  String? get concepto => _$this._concepto;
  set concepto(String? concepto) => _$this._concepto = concepto;

  String? _descripcion;
  String? get descripcion => _$this._descripcion;
  set descripcion(String? descripcion) => _$this._descripcion = descripcion;

  ListBuilder<DocumentosDto>? _documentos;
  ListBuilder<DocumentosDto> get documentos =>
      _$this._documentos ??= ListBuilder<DocumentosDto>();
  set documentos(ListBuilder<DocumentosDto>? documentos) =>
      _$this._documentos = documentos;

  String? _estado;
  String? get estado => _$this._estado;
  set estado(String? estado) => _$this._estado = estado;

  ExpedienteDtoBuilder? _expediente;
  ExpedienteDtoBuilder get expediente =>
      _$this._expediente ??= ExpedienteDtoBuilder();
  set expediente(ExpedienteDtoBuilder? expediente) =>
      _$this._expediente = expediente;

  DateTime? _fecAlta;
  DateTime? get fecAlta => _$this._fecAlta;
  set fecAlta(DateTime? fecAlta) => _$this._fecAlta = fecAlta;

  DateTime? _fecCaducidad;
  DateTime? get fecCaducidad => _$this._fecCaducidad;
  set fecCaducidad(DateTime? fecCaducidad) =>
      _$this._fecCaducidad = fecCaducidad;

  ListBuilder<HistoricoEstadoDto>? _historicoEstados;
  ListBuilder<HistoricoEstadoDto> get historicoEstados =>
      _$this._historicoEstados ??= ListBuilder<HistoricoEstadoDto>();
  set historicoEstados(ListBuilder<HistoricoEstadoDto>? historicoEstados) =>
      _$this._historicoEstados = historicoEstados;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  ListBuilder<InteresadoNotificaDto>? _interesados;
  ListBuilder<InteresadoNotificaDto> get interesados =>
      _$this._interesados ??= ListBuilder<InteresadoNotificaDto>();
  set interesados(ListBuilder<InteresadoNotificaDto>? interesados) =>
      _$this._interesados = interesados;

  ProcedimientoAdministrativoDtoBuilder? _procedimientoAdministrativo;
  ProcedimientoAdministrativoDtoBuilder get procedimientoAdministrativo =>
      _$this._procedimientoAdministrativo ??=
          ProcedimientoAdministrativoDtoBuilder();
  set procedimientoAdministrativo(
          ProcedimientoAdministrativoDtoBuilder? procedimientoAdministrativo) =>
      _$this._procedimientoAdministrativo = procedimientoAdministrativo;

  String? _tipoEnvio;
  String? get tipoEnvio => _$this._tipoEnvio;
  set tipoEnvio(String? tipoEnvio) => _$this._tipoEnvio = tipoEnvio;

  UnidadOrganicaDtoBuilder? _unidadOrganica;
  UnidadOrganicaDtoBuilder get unidadOrganica =>
      _$this._unidadOrganica ??= UnidadOrganicaDtoBuilder();
  set unidadOrganica(UnidadOrganicaDtoBuilder? unidadOrganica) =>
      _$this._unidadOrganica = unidadOrganica;

  NotificacionDtoBuilder() {
    NotificacionDto._defaults(this);
  }

  NotificacionDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _concepto = $v.concepto;
      _descripcion = $v.descripcion;
      _documentos = $v.documentos?.toBuilder();
      _estado = $v.estado;
      _expediente = $v.expediente?.toBuilder();
      _fecAlta = $v.fecAlta;
      _fecCaducidad = $v.fecCaducidad;
      _historicoEstados = $v.historicoEstados?.toBuilder();
      _id = $v.id;
      _interesados = $v.interesados?.toBuilder();
      _procedimientoAdministrativo =
          $v.procedimientoAdministrativo?.toBuilder();
      _tipoEnvio = $v.tipoEnvio;
      _unidadOrganica = $v.unidadOrganica?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(NotificacionDto other) {
    _$v = other as _$NotificacionDto;
  }

  @override
  void update(void Function(NotificacionDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  NotificacionDto build() => _build();

  _$NotificacionDto _build() {
    _$NotificacionDto _$result;
    try {
      _$result = _$v ??
          _$NotificacionDto._(
            concepto: concepto,
            descripcion: descripcion,
            documentos: _documentos?.build(),
            estado: estado,
            expediente: _expediente?.build(),
            fecAlta: fecAlta,
            fecCaducidad: fecCaducidad,
            historicoEstados: _historicoEstados?.build(),
            id: id,
            interesados: _interesados?.build(),
            procedimientoAdministrativo: _procedimientoAdministrativo?.build(),
            tipoEnvio: tipoEnvio,
            unidadOrganica: _unidadOrganica?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'documentos';
        _documentos?.build();

        _$failedField = 'expediente';
        _expediente?.build();

        _$failedField = 'historicoEstados';
        _historicoEstados?.build();

        _$failedField = 'interesados';
        _interesados?.build();
        _$failedField = 'procedimientoAdministrativo';
        _procedimientoAdministrativo?.build();

        _$failedField = 'unidadOrganica';
        _unidadOrganica?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'NotificacionDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
