// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'zcsrfcmisexpedientes_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ZCSRFCMISEXPEDIENTESResponse extends ZCSRFCMISEXPEDIENTESResponse {
  @override
  final String? error;
  @override
  final EXPEDIENTES? expedientes;
  @override
  final int? subrc;

  factory _$ZCSRFCMISEXPEDIENTESResponse(
          [void Function(ZCSRFCMISEXPEDIENTESResponseBuilder)? updates]) =>
      (ZCSRFCMISEXPEDIENTESResponseBuilder()..update(updates))._build();

  _$ZCSRFCMISEXPEDIENTESResponse._({this.error, this.expedientes, this.subrc})
      : super._();
  @override
  ZCSRFCMISEXPEDIENTESResponse rebuild(
          void Function(ZCSRFCMISEXPEDIENTESResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ZCSRFCMISEXPEDIENTESResponseBuilder toBuilder() =>
      ZCSRFCMISEXPEDIENTESResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ZCSRFCMISEXPEDIENTESResponse &&
        error == other.error &&
        expedientes == other.expedientes &&
        subrc == other.subrc;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, error.hashCode);
    _$hash = $jc(_$hash, expedientes.hashCode);
    _$hash = $jc(_$hash, subrc.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ZCSRFCMISEXPEDIENTESResponse')
          ..add('error', error)
          ..add('expedientes', expedientes)
          ..add('subrc', subrc))
        .toString();
  }
}

class ZCSRFCMISEXPEDIENTESResponseBuilder
    implements
        Builder<ZCSRFCMISEXPEDIENTESResponse,
            ZCSRFCMISEXPEDIENTESResponseBuilder> {
  _$ZCSRFCMISEXPEDIENTESResponse? _$v;

  String? _error;
  String? get error => _$this._error;
  set error(String? error) => _$this._error = error;

  EXPEDIENTESBuilder? _expedientes;
  EXPEDIENTESBuilder get expedientes =>
      _$this._expedientes ??= EXPEDIENTESBuilder();
  set expedientes(EXPEDIENTESBuilder? expedientes) =>
      _$this._expedientes = expedientes;

  int? _subrc;
  int? get subrc => _$this._subrc;
  set subrc(int? subrc) => _$this._subrc = subrc;

  ZCSRFCMISEXPEDIENTESResponseBuilder() {
    ZCSRFCMISEXPEDIENTESResponse._defaults(this);
  }

  ZCSRFCMISEXPEDIENTESResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _error = $v.error;
      _expedientes = $v.expedientes?.toBuilder();
      _subrc = $v.subrc;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ZCSRFCMISEXPEDIENTESResponse other) {
    _$v = other as _$ZCSRFCMISEXPEDIENTESResponse;
  }

  @override
  void update(void Function(ZCSRFCMISEXPEDIENTESResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ZCSRFCMISEXPEDIENTESResponse build() => _build();

  _$ZCSRFCMISEXPEDIENTESResponse _build() {
    _$ZCSRFCMISEXPEDIENTESResponse _$result;
    try {
      _$result = _$v ??
          _$ZCSRFCMISEXPEDIENTESResponse._(
            error: error,
            expedientes: _expedientes?.build(),
            subrc: subrc,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'expedientes';
        _expedientes?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ZCSRFCMISEXPEDIENTESResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
