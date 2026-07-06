// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'telefono_aviso_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$TelefonoAvisoDto extends TelefonoAvisoDto {
  @override
  final String? telefono;

  factory _$TelefonoAvisoDto(
          [void Function(TelefonoAvisoDtoBuilder)? updates]) =>
      (TelefonoAvisoDtoBuilder()..update(updates))._build();

  _$TelefonoAvisoDto._({this.telefono}) : super._();
  @override
  TelefonoAvisoDto rebuild(void Function(TelefonoAvisoDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TelefonoAvisoDtoBuilder toBuilder() =>
      TelefonoAvisoDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TelefonoAvisoDto && telefono == other.telefono;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, telefono.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'TelefonoAvisoDto')
          ..add('telefono', telefono))
        .toString();
  }
}

class TelefonoAvisoDtoBuilder
    implements Builder<TelefonoAvisoDto, TelefonoAvisoDtoBuilder> {
  _$TelefonoAvisoDto? _$v;

  String? _telefono;
  String? get telefono => _$this._telefono;
  set telefono(String? telefono) => _$this._telefono = telefono;

  TelefonoAvisoDtoBuilder() {
    TelefonoAvisoDto._defaults(this);
  }

  TelefonoAvisoDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _telefono = $v.telefono;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TelefonoAvisoDto other) {
    _$v = other as _$TelefonoAvisoDto;
  }

  @override
  void update(void Function(TelefonoAvisoDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TelefonoAvisoDto build() => _build();

  _$TelefonoAvisoDto _build() {
    final _$result = _$v ??
        _$TelefonoAvisoDto._(
          telefono: telefono,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
