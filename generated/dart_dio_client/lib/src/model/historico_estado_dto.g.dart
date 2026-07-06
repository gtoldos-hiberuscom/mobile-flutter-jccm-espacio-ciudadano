// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'historico_estado_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$HistoricoEstadoDto extends HistoricoEstadoDto {
  @override
  final String? estado;
  @override
  final DateTime? fechaCambio;

  factory _$HistoricoEstadoDto(
          [void Function(HistoricoEstadoDtoBuilder)? updates]) =>
      (HistoricoEstadoDtoBuilder()..update(updates))._build();

  _$HistoricoEstadoDto._({this.estado, this.fechaCambio}) : super._();
  @override
  HistoricoEstadoDto rebuild(
          void Function(HistoricoEstadoDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  HistoricoEstadoDtoBuilder toBuilder() =>
      HistoricoEstadoDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is HistoricoEstadoDto &&
        estado == other.estado &&
        fechaCambio == other.fechaCambio;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, estado.hashCode);
    _$hash = $jc(_$hash, fechaCambio.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'HistoricoEstadoDto')
          ..add('estado', estado)
          ..add('fechaCambio', fechaCambio))
        .toString();
  }
}

class HistoricoEstadoDtoBuilder
    implements Builder<HistoricoEstadoDto, HistoricoEstadoDtoBuilder> {
  _$HistoricoEstadoDto? _$v;

  String? _estado;
  String? get estado => _$this._estado;
  set estado(String? estado) => _$this._estado = estado;

  DateTime? _fechaCambio;
  DateTime? get fechaCambio => _$this._fechaCambio;
  set fechaCambio(DateTime? fechaCambio) => _$this._fechaCambio = fechaCambio;

  HistoricoEstadoDtoBuilder() {
    HistoricoEstadoDto._defaults(this);
  }

  HistoricoEstadoDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _estado = $v.estado;
      _fechaCambio = $v.fechaCambio;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(HistoricoEstadoDto other) {
    _$v = other as _$HistoricoEstadoDto;
  }

  @override
  void update(void Function(HistoricoEstadoDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  HistoricoEstadoDto build() => _build();

  _$HistoricoEstadoDto _build() {
    final _$result = _$v ??
        _$HistoricoEstadoDto._(
          estado: estado,
          fechaCambio: fechaCambio,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
