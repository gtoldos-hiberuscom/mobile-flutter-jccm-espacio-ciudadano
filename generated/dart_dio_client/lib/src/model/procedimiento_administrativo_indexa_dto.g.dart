// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'procedimiento_administrativo_indexa_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ProcedimientoAdministrativoIndexaDto
    extends ProcedimientoAdministrativoIndexaDto {
  @override
  final String? denominacion;
  @override
  final String? idFicha;

  factory _$ProcedimientoAdministrativoIndexaDto(
          [void Function(ProcedimientoAdministrativoIndexaDtoBuilder)?
              updates]) =>
      (ProcedimientoAdministrativoIndexaDtoBuilder()..update(updates))._build();

  _$ProcedimientoAdministrativoIndexaDto._({this.denominacion, this.idFicha})
      : super._();
  @override
  ProcedimientoAdministrativoIndexaDto rebuild(
          void Function(ProcedimientoAdministrativoIndexaDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProcedimientoAdministrativoIndexaDtoBuilder toBuilder() =>
      ProcedimientoAdministrativoIndexaDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProcedimientoAdministrativoIndexaDto &&
        denominacion == other.denominacion &&
        idFicha == other.idFicha;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, denominacion.hashCode);
    _$hash = $jc(_$hash, idFicha.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProcedimientoAdministrativoIndexaDto')
          ..add('denominacion', denominacion)
          ..add('idFicha', idFicha))
        .toString();
  }
}

class ProcedimientoAdministrativoIndexaDtoBuilder
    implements
        Builder<ProcedimientoAdministrativoIndexaDto,
            ProcedimientoAdministrativoIndexaDtoBuilder> {
  _$ProcedimientoAdministrativoIndexaDto? _$v;

  String? _denominacion;
  String? get denominacion => _$this._denominacion;
  set denominacion(String? denominacion) => _$this._denominacion = denominacion;

  String? _idFicha;
  String? get idFicha => _$this._idFicha;
  set idFicha(String? idFicha) => _$this._idFicha = idFicha;

  ProcedimientoAdministrativoIndexaDtoBuilder() {
    ProcedimientoAdministrativoIndexaDto._defaults(this);
  }

  ProcedimientoAdministrativoIndexaDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _denominacion = $v.denominacion;
      _idFicha = $v.idFicha;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProcedimientoAdministrativoIndexaDto other) {
    _$v = other as _$ProcedimientoAdministrativoIndexaDto;
  }

  @override
  void update(
      void Function(ProcedimientoAdministrativoIndexaDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProcedimientoAdministrativoIndexaDto build() => _build();

  _$ProcedimientoAdministrativoIndexaDto _build() {
    final _$result = _$v ??
        _$ProcedimientoAdministrativoIndexaDto._(
          denominacion: denominacion,
          idFicha: idFicha,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
