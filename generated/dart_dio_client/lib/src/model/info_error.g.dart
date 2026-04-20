// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'info_error.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$InfoError extends InfoError {
  @override
  final BuiltList<ApiError>? errores;
  @override
  final String? idError;

  factory _$InfoError([void Function(InfoErrorBuilder)? updates]) =>
      (InfoErrorBuilder()..update(updates))._build();

  _$InfoError._({this.errores, this.idError}) : super._();
  @override
  InfoError rebuild(void Function(InfoErrorBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  InfoErrorBuilder toBuilder() => InfoErrorBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is InfoError &&
        errores == other.errores &&
        idError == other.idError;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, errores.hashCode);
    _$hash = $jc(_$hash, idError.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'InfoError')
          ..add('errores', errores)
          ..add('idError', idError))
        .toString();
  }
}

class InfoErrorBuilder implements Builder<InfoError, InfoErrorBuilder> {
  _$InfoError? _$v;

  ListBuilder<ApiError>? _errores;
  ListBuilder<ApiError> get errores =>
      _$this._errores ??= ListBuilder<ApiError>();
  set errores(ListBuilder<ApiError>? errores) => _$this._errores = errores;

  String? _idError;
  String? get idError => _$this._idError;
  set idError(String? idError) => _$this._idError = idError;

  InfoErrorBuilder() {
    InfoError._defaults(this);
  }

  InfoErrorBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _errores = $v.errores?.toBuilder();
      _idError = $v.idError;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(InfoError other) {
    _$v = other as _$InfoError;
  }

  @override
  void update(void Function(InfoErrorBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  InfoError build() => _build();

  _$InfoError _build() {
    _$InfoError _$result;
    try {
      _$result = _$v ??
          _$InfoError._(
            errores: _errores?.build(),
            idError: idError,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'errores';
        _errores?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'InfoError', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
