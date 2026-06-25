// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'interesado_notifica_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$InteresadoNotificaDto extends InteresadoNotificaDto {
  @override
  final DocumentoDto? interesado;
  @override
  final MediosAvisoAdicionalesDto? mediosAvisoAdicionales;
  @override
  final String? tipoIdentificador;
  @override
  final String? valorIdentificador;

  factory _$InteresadoNotificaDto(
          [void Function(InteresadoNotificaDtoBuilder)? updates]) =>
      (InteresadoNotificaDtoBuilder()..update(updates))._build();

  _$InteresadoNotificaDto._(
      {this.interesado,
      this.mediosAvisoAdicionales,
      this.tipoIdentificador,
      this.valorIdentificador})
      : super._();
  @override
  InteresadoNotificaDto rebuild(
          void Function(InteresadoNotificaDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  InteresadoNotificaDtoBuilder toBuilder() =>
      InteresadoNotificaDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is InteresadoNotificaDto &&
        interesado == other.interesado &&
        mediosAvisoAdicionales == other.mediosAvisoAdicionales &&
        tipoIdentificador == other.tipoIdentificador &&
        valorIdentificador == other.valorIdentificador;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, interesado.hashCode);
    _$hash = $jc(_$hash, mediosAvisoAdicionales.hashCode);
    _$hash = $jc(_$hash, tipoIdentificador.hashCode);
    _$hash = $jc(_$hash, valorIdentificador.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'InteresadoNotificaDto')
          ..add('interesado', interesado)
          ..add('mediosAvisoAdicionales', mediosAvisoAdicionales)
          ..add('tipoIdentificador', tipoIdentificador)
          ..add('valorIdentificador', valorIdentificador))
        .toString();
  }
}

class InteresadoNotificaDtoBuilder
    implements Builder<InteresadoNotificaDto, InteresadoNotificaDtoBuilder> {
  _$InteresadoNotificaDto? _$v;

  DocumentoDtoBuilder? _interesado;
  DocumentoDtoBuilder get interesado =>
      _$this._interesado ??= DocumentoDtoBuilder();
  set interesado(DocumentoDtoBuilder? interesado) =>
      _$this._interesado = interesado;

  MediosAvisoAdicionalesDtoBuilder? _mediosAvisoAdicionales;
  MediosAvisoAdicionalesDtoBuilder get mediosAvisoAdicionales =>
      _$this._mediosAvisoAdicionales ??= MediosAvisoAdicionalesDtoBuilder();
  set mediosAvisoAdicionales(
          MediosAvisoAdicionalesDtoBuilder? mediosAvisoAdicionales) =>
      _$this._mediosAvisoAdicionales = mediosAvisoAdicionales;

  String? _tipoIdentificador;
  String? get tipoIdentificador => _$this._tipoIdentificador;
  set tipoIdentificador(String? tipoIdentificador) =>
      _$this._tipoIdentificador = tipoIdentificador;

  String? _valorIdentificador;
  String? get valorIdentificador => _$this._valorIdentificador;
  set valorIdentificador(String? valorIdentificador) =>
      _$this._valorIdentificador = valorIdentificador;

  InteresadoNotificaDtoBuilder() {
    InteresadoNotificaDto._defaults(this);
  }

  InteresadoNotificaDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _interesado = $v.interesado?.toBuilder();
      _mediosAvisoAdicionales = $v.mediosAvisoAdicionales?.toBuilder();
      _tipoIdentificador = $v.tipoIdentificador;
      _valorIdentificador = $v.valorIdentificador;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(InteresadoNotificaDto other) {
    _$v = other as _$InteresadoNotificaDto;
  }

  @override
  void update(void Function(InteresadoNotificaDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  InteresadoNotificaDto build() => _build();

  _$InteresadoNotificaDto _build() {
    _$InteresadoNotificaDto _$result;
    try {
      _$result = _$v ??
          _$InteresadoNotificaDto._(
            interesado: _interesado?.build(),
            mediosAvisoAdicionales: _mediosAvisoAdicionales?.build(),
            tipoIdentificador: tipoIdentificador,
            valorIdentificador: valorIdentificador,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'interesado';
        _interesado?.build();
        _$failedField = 'mediosAvisoAdicionales';
        _mediosAvisoAdicionales?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'InteresadoNotificaDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
