// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medios_aviso_adicionales_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MediosAvisoAdicionalesDto extends MediosAvisoAdicionalesDto {
  @override
  final BuiltList<EmailAvisoDto>? emailsAviso;
  @override
  final BuiltList<TelefonoAvisoDto>? telefonosAviso;

  factory _$MediosAvisoAdicionalesDto(
          [void Function(MediosAvisoAdicionalesDtoBuilder)? updates]) =>
      (MediosAvisoAdicionalesDtoBuilder()..update(updates))._build();

  _$MediosAvisoAdicionalesDto._({this.emailsAviso, this.telefonosAviso})
      : super._();
  @override
  MediosAvisoAdicionalesDto rebuild(
          void Function(MediosAvisoAdicionalesDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MediosAvisoAdicionalesDtoBuilder toBuilder() =>
      MediosAvisoAdicionalesDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MediosAvisoAdicionalesDto &&
        emailsAviso == other.emailsAviso &&
        telefonosAviso == other.telefonosAviso;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, emailsAviso.hashCode);
    _$hash = $jc(_$hash, telefonosAviso.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MediosAvisoAdicionalesDto')
          ..add('emailsAviso', emailsAviso)
          ..add('telefonosAviso', telefonosAviso))
        .toString();
  }
}

class MediosAvisoAdicionalesDtoBuilder
    implements
        Builder<MediosAvisoAdicionalesDto, MediosAvisoAdicionalesDtoBuilder> {
  _$MediosAvisoAdicionalesDto? _$v;

  ListBuilder<EmailAvisoDto>? _emailsAviso;
  ListBuilder<EmailAvisoDto> get emailsAviso =>
      _$this._emailsAviso ??= ListBuilder<EmailAvisoDto>();
  set emailsAviso(ListBuilder<EmailAvisoDto>? emailsAviso) =>
      _$this._emailsAviso = emailsAviso;

  ListBuilder<TelefonoAvisoDto>? _telefonosAviso;
  ListBuilder<TelefonoAvisoDto> get telefonosAviso =>
      _$this._telefonosAviso ??= ListBuilder<TelefonoAvisoDto>();
  set telefonosAviso(ListBuilder<TelefonoAvisoDto>? telefonosAviso) =>
      _$this._telefonosAviso = telefonosAviso;

  MediosAvisoAdicionalesDtoBuilder() {
    MediosAvisoAdicionalesDto._defaults(this);
  }

  MediosAvisoAdicionalesDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _emailsAviso = $v.emailsAviso?.toBuilder();
      _telefonosAviso = $v.telefonosAviso?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MediosAvisoAdicionalesDto other) {
    _$v = other as _$MediosAvisoAdicionalesDto;
  }

  @override
  void update(void Function(MediosAvisoAdicionalesDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MediosAvisoAdicionalesDto build() => _build();

  _$MediosAvisoAdicionalesDto _build() {
    _$MediosAvisoAdicionalesDto _$result;
    try {
      _$result = _$v ??
          _$MediosAvisoAdicionalesDto._(
            emailsAviso: _emailsAviso?.build(),
            telefonosAviso: _telefonosAviso?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'emailsAviso';
        _emailsAviso?.build();
        _$failedField = 'telefonosAviso';
        _telefonosAviso?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'MediosAvisoAdicionalesDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
