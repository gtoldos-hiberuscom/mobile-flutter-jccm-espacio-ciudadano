// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notificacion_indexa_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$NotificacionIndexaDto extends NotificacionIndexaDto {
  @override
  final String? concepto;
  @override
  final DateTime? fechaCaducidad;
  @override
  final int? idNotificacion;
  @override
  final ProcedimientoAdministrativoIndexaDto? procedimientoAdministrativo;
  @override
  final String? sistemaOrigen;
  @override
  final UnidadOrganicaIndexaDto? unidadOrganica;

  factory _$NotificacionIndexaDto(
          [void Function(NotificacionIndexaDtoBuilder)? updates]) =>
      (NotificacionIndexaDtoBuilder()..update(updates))._build();

  _$NotificacionIndexaDto._(
      {this.concepto,
      this.fechaCaducidad,
      this.idNotificacion,
      this.procedimientoAdministrativo,
      this.sistemaOrigen,
      this.unidadOrganica})
      : super._();
  @override
  NotificacionIndexaDto rebuild(
          void Function(NotificacionIndexaDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  NotificacionIndexaDtoBuilder toBuilder() =>
      NotificacionIndexaDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is NotificacionIndexaDto &&
        concepto == other.concepto &&
        fechaCaducidad == other.fechaCaducidad &&
        idNotificacion == other.idNotificacion &&
        procedimientoAdministrativo == other.procedimientoAdministrativo &&
        sistemaOrigen == other.sistemaOrigen &&
        unidadOrganica == other.unidadOrganica;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, concepto.hashCode);
    _$hash = $jc(_$hash, fechaCaducidad.hashCode);
    _$hash = $jc(_$hash, idNotificacion.hashCode);
    _$hash = $jc(_$hash, procedimientoAdministrativo.hashCode);
    _$hash = $jc(_$hash, sistemaOrigen.hashCode);
    _$hash = $jc(_$hash, unidadOrganica.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'NotificacionIndexaDto')
          ..add('concepto', concepto)
          ..add('fechaCaducidad', fechaCaducidad)
          ..add('idNotificacion', idNotificacion)
          ..add('procedimientoAdministrativo', procedimientoAdministrativo)
          ..add('sistemaOrigen', sistemaOrigen)
          ..add('unidadOrganica', unidadOrganica))
        .toString();
  }
}

class NotificacionIndexaDtoBuilder
    implements Builder<NotificacionIndexaDto, NotificacionIndexaDtoBuilder> {
  _$NotificacionIndexaDto? _$v;

  String? _concepto;
  String? get concepto => _$this._concepto;
  set concepto(String? concepto) => _$this._concepto = concepto;

  DateTime? _fechaCaducidad;
  DateTime? get fechaCaducidad => _$this._fechaCaducidad;
  set fechaCaducidad(DateTime? fechaCaducidad) =>
      _$this._fechaCaducidad = fechaCaducidad;

  int? _idNotificacion;
  int? get idNotificacion => _$this._idNotificacion;
  set idNotificacion(int? idNotificacion) =>
      _$this._idNotificacion = idNotificacion;

  ProcedimientoAdministrativoIndexaDtoBuilder? _procedimientoAdministrativo;
  ProcedimientoAdministrativoIndexaDtoBuilder get procedimientoAdministrativo =>
      _$this._procedimientoAdministrativo ??=
          ProcedimientoAdministrativoIndexaDtoBuilder();
  set procedimientoAdministrativo(
          ProcedimientoAdministrativoIndexaDtoBuilder?
              procedimientoAdministrativo) =>
      _$this._procedimientoAdministrativo = procedimientoAdministrativo;

  String? _sistemaOrigen;
  String? get sistemaOrigen => _$this._sistemaOrigen;
  set sistemaOrigen(String? sistemaOrigen) =>
      _$this._sistemaOrigen = sistemaOrigen;

  UnidadOrganicaIndexaDtoBuilder? _unidadOrganica;
  UnidadOrganicaIndexaDtoBuilder get unidadOrganica =>
      _$this._unidadOrganica ??= UnidadOrganicaIndexaDtoBuilder();
  set unidadOrganica(UnidadOrganicaIndexaDtoBuilder? unidadOrganica) =>
      _$this._unidadOrganica = unidadOrganica;

  NotificacionIndexaDtoBuilder() {
    NotificacionIndexaDto._defaults(this);
  }

  NotificacionIndexaDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _concepto = $v.concepto;
      _fechaCaducidad = $v.fechaCaducidad;
      _idNotificacion = $v.idNotificacion;
      _procedimientoAdministrativo =
          $v.procedimientoAdministrativo?.toBuilder();
      _sistemaOrigen = $v.sistemaOrigen;
      _unidadOrganica = $v.unidadOrganica?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(NotificacionIndexaDto other) {
    _$v = other as _$NotificacionIndexaDto;
  }

  @override
  void update(void Function(NotificacionIndexaDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  NotificacionIndexaDto build() => _build();

  _$NotificacionIndexaDto _build() {
    _$NotificacionIndexaDto _$result;
    try {
      _$result = _$v ??
          _$NotificacionIndexaDto._(
            concepto: concepto,
            fechaCaducidad: fechaCaducidad,
            idNotificacion: idNotificacion,
            procedimientoAdministrativo: _procedimientoAdministrativo?.build(),
            sistemaOrigen: sistemaOrigen,
            unidadOrganica: _unidadOrganica?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'procedimientoAdministrativo';
        _procedimientoAdministrativo?.build();

        _$failedField = 'unidadOrganica';
        _unidadOrganica?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'NotificacionIndexaDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
