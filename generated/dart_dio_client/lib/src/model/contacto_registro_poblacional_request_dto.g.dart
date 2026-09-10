// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contacto_registro_poblacional_request_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ContactoRegistroPoblacionalRequestDto
    extends ContactoRegistroPoblacionalRequestDto {
  @override
  final String? correo;
  @override
  final String? telefono;

  factory _$ContactoRegistroPoblacionalRequestDto(
          [void Function(ContactoRegistroPoblacionalRequestDtoBuilder)?
              updates]) =>
      (ContactoRegistroPoblacionalRequestDtoBuilder()..update(updates))
          ._build();

  _$ContactoRegistroPoblacionalRequestDto._({this.correo, this.telefono})
      : super._();
  @override
  ContactoRegistroPoblacionalRequestDto rebuild(
          void Function(ContactoRegistroPoblacionalRequestDtoBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ContactoRegistroPoblacionalRequestDtoBuilder toBuilder() =>
      ContactoRegistroPoblacionalRequestDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ContactoRegistroPoblacionalRequestDto &&
        correo == other.correo &&
        telefono == other.telefono;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, correo.hashCode);
    _$hash = $jc(_$hash, telefono.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'ContactoRegistroPoblacionalRequestDto')
          ..add('correo', correo)
          ..add('telefono', telefono))
        .toString();
  }
}

class ContactoRegistroPoblacionalRequestDtoBuilder
    implements
        Builder<ContactoRegistroPoblacionalRequestDto,
            ContactoRegistroPoblacionalRequestDtoBuilder> {
  _$ContactoRegistroPoblacionalRequestDto? _$v;

  String? _correo;
  String? get correo => _$this._correo;
  set correo(String? correo) => _$this._correo = correo;

  String? _telefono;
  String? get telefono => _$this._telefono;
  set telefono(String? telefono) => _$this._telefono = telefono;

  ContactoRegistroPoblacionalRequestDtoBuilder() {
    ContactoRegistroPoblacionalRequestDto._defaults(this);
  }

  ContactoRegistroPoblacionalRequestDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _correo = $v.correo;
      _telefono = $v.telefono;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ContactoRegistroPoblacionalRequestDto other) {
    _$v = other as _$ContactoRegistroPoblacionalRequestDto;
  }

  @override
  void update(
      void Function(ContactoRegistroPoblacionalRequestDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ContactoRegistroPoblacionalRequestDto build() => _build();

  _$ContactoRegistroPoblacionalRequestDto _build() {
    final _$result = _$v ??
        _$ContactoRegistroPoblacionalRequestDto._(
          correo: correo,
          telefono: telefono,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
