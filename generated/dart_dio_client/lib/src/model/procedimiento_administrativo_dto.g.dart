// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'procedimiento_administrativo_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ProcedimientoAdministrativoDto extends ProcedimientoAdministrativoDto {
  @override
  final BuiltList<InformacionAdicionalDto>? informacionAdicional;

  factory _$ProcedimientoAdministrativoDto(
          [void Function(ProcedimientoAdministrativoDtoBuilder)? updates]) =>
      (ProcedimientoAdministrativoDtoBuilder()..update(updates))._build();

  _$ProcedimientoAdministrativoDto._({this.informacionAdicional}) : super._();
  @override
  ProcedimientoAdministrativoDto rebuild(
          void Function(ProcedimientoAdministrativoDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProcedimientoAdministrativoDtoBuilder toBuilder() =>
      ProcedimientoAdministrativoDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProcedimientoAdministrativoDto &&
        informacionAdicional == other.informacionAdicional;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, informacionAdicional.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProcedimientoAdministrativoDto')
          ..add('informacionAdicional', informacionAdicional))
        .toString();
  }
}

class ProcedimientoAdministrativoDtoBuilder
    implements
        Builder<ProcedimientoAdministrativoDto,
            ProcedimientoAdministrativoDtoBuilder> {
  _$ProcedimientoAdministrativoDto? _$v;

  ListBuilder<InformacionAdicionalDto>? _informacionAdicional;
  ListBuilder<InformacionAdicionalDto> get informacionAdicional =>
      _$this._informacionAdicional ??= ListBuilder<InformacionAdicionalDto>();
  set informacionAdicional(
          ListBuilder<InformacionAdicionalDto>? informacionAdicional) =>
      _$this._informacionAdicional = informacionAdicional;

  ProcedimientoAdministrativoDtoBuilder() {
    ProcedimientoAdministrativoDto._defaults(this);
  }

  ProcedimientoAdministrativoDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _informacionAdicional = $v.informacionAdicional?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProcedimientoAdministrativoDto other) {
    _$v = other as _$ProcedimientoAdministrativoDto;
  }

  @override
  void update(void Function(ProcedimientoAdministrativoDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProcedimientoAdministrativoDto build() => _build();

  _$ProcedimientoAdministrativoDto _build() {
    _$ProcedimientoAdministrativoDto _$result;
    try {
      _$result = _$v ??
          _$ProcedimientoAdministrativoDto._(
            informacionAdicional: _informacionAdicional?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'informacionAdicional';
        _informacionAdicional?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ProcedimientoAdministrativoDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
