// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'email_aviso_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$EmailAvisoDto extends EmailAvisoDto {
  @override
  final String? email;

  factory _$EmailAvisoDto([void Function(EmailAvisoDtoBuilder)? updates]) =>
      (EmailAvisoDtoBuilder()..update(updates))._build();

  _$EmailAvisoDto._({this.email}) : super._();
  @override
  EmailAvisoDto rebuild(void Function(EmailAvisoDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  EmailAvisoDtoBuilder toBuilder() => EmailAvisoDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is EmailAvisoDto && email == other.email;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'EmailAvisoDto')..add('email', email))
        .toString();
  }
}

class EmailAvisoDtoBuilder
    implements Builder<EmailAvisoDto, EmailAvisoDtoBuilder> {
  _$EmailAvisoDto? _$v;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  EmailAvisoDtoBuilder() {
    EmailAvisoDto._defaults(this);
  }

  EmailAvisoDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _email = $v.email;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(EmailAvisoDto other) {
    _$v = other as _$EmailAvisoDto;
  }

  @override
  void update(void Function(EmailAvisoDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  EmailAvisoDto build() => _build();

  _$EmailAvisoDto _build() {
    final _$result = _$v ??
        _$EmailAvisoDto._(
          email: email,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
