// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'zcsrmobtrespuestaexp_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ZCSRMOBTRESPUESTAEXPResponse extends ZCSRMOBTRESPUESTAEXPResponse {
  @override
  final int? esubrc;
  @override
  final String? return_;
  @override
  final TTEXTOSRESPUESTA ttextosrespuesta;

  factory _$ZCSRMOBTRESPUESTAEXPResponse(
          [void Function(ZCSRMOBTRESPUESTAEXPResponseBuilder)? updates]) =>
      (ZCSRMOBTRESPUESTAEXPResponseBuilder()..update(updates))._build();

  _$ZCSRMOBTRESPUESTAEXPResponse._(
      {this.esubrc, this.return_, required this.ttextosrespuesta})
      : super._();
  @override
  ZCSRMOBTRESPUESTAEXPResponse rebuild(
          void Function(ZCSRMOBTRESPUESTAEXPResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ZCSRMOBTRESPUESTAEXPResponseBuilder toBuilder() =>
      ZCSRMOBTRESPUESTAEXPResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ZCSRMOBTRESPUESTAEXPResponse &&
        esubrc == other.esubrc &&
        return_ == other.return_ &&
        ttextosrespuesta == other.ttextosrespuesta;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, esubrc.hashCode);
    _$hash = $jc(_$hash, return_.hashCode);
    _$hash = $jc(_$hash, ttextosrespuesta.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ZCSRMOBTRESPUESTAEXPResponse')
          ..add('esubrc', esubrc)
          ..add('return_', return_)
          ..add('ttextosrespuesta', ttextosrespuesta))
        .toString();
  }
}

class ZCSRMOBTRESPUESTAEXPResponseBuilder
    implements
        Builder<ZCSRMOBTRESPUESTAEXPResponse,
            ZCSRMOBTRESPUESTAEXPResponseBuilder> {
  _$ZCSRMOBTRESPUESTAEXPResponse? _$v;

  int? _esubrc;
  int? get esubrc => _$this._esubrc;
  set esubrc(int? esubrc) => _$this._esubrc = esubrc;

  String? _return_;
  String? get return_ => _$this._return_;
  set return_(String? return_) => _$this._return_ = return_;

  TTEXTOSRESPUESTABuilder? _ttextosrespuesta;
  TTEXTOSRESPUESTABuilder get ttextosrespuesta =>
      _$this._ttextosrespuesta ??= TTEXTOSRESPUESTABuilder();
  set ttextosrespuesta(TTEXTOSRESPUESTABuilder? ttextosrespuesta) =>
      _$this._ttextosrespuesta = ttextosrespuesta;

  ZCSRMOBTRESPUESTAEXPResponseBuilder() {
    ZCSRMOBTRESPUESTAEXPResponse._defaults(this);
  }

  ZCSRMOBTRESPUESTAEXPResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _esubrc = $v.esubrc;
      _return_ = $v.return_;
      _ttextosrespuesta = $v.ttextosrespuesta.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ZCSRMOBTRESPUESTAEXPResponse other) {
    _$v = other as _$ZCSRMOBTRESPUESTAEXPResponse;
  }

  @override
  void update(void Function(ZCSRMOBTRESPUESTAEXPResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ZCSRMOBTRESPUESTAEXPResponse build() => _build();

  _$ZCSRMOBTRESPUESTAEXPResponse _build() {
    _$ZCSRMOBTRESPUESTAEXPResponse _$result;
    try {
      _$result = _$v ??
          _$ZCSRMOBTRESPUESTAEXPResponse._(
            esubrc: esubrc,
            return_: return_,
            ttextosrespuesta: ttextosrespuesta.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'ttextosrespuesta';
        ttextosrespuesta.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ZCSRMOBTRESPUESTAEXPResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
