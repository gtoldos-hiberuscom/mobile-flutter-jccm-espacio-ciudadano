// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'zcsrmobtrespuestaexp.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ZCSRMOBTRESPUESTAEXP extends ZCSRMOBTRESPUESTAEXP {
  @override
  final String irefdoc;
  @override
  final TTEXTOSRESPUESTA ttextosrespuesta;

  factory _$ZCSRMOBTRESPUESTAEXP(
          [void Function(ZCSRMOBTRESPUESTAEXPBuilder)? updates]) =>
      (ZCSRMOBTRESPUESTAEXPBuilder()..update(updates))._build();

  _$ZCSRMOBTRESPUESTAEXP._(
      {required this.irefdoc, required this.ttextosrespuesta})
      : super._();
  @override
  ZCSRMOBTRESPUESTAEXP rebuild(
          void Function(ZCSRMOBTRESPUESTAEXPBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ZCSRMOBTRESPUESTAEXPBuilder toBuilder() =>
      ZCSRMOBTRESPUESTAEXPBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ZCSRMOBTRESPUESTAEXP &&
        irefdoc == other.irefdoc &&
        ttextosrespuesta == other.ttextosrespuesta;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, irefdoc.hashCode);
    _$hash = $jc(_$hash, ttextosrespuesta.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ZCSRMOBTRESPUESTAEXP')
          ..add('irefdoc', irefdoc)
          ..add('ttextosrespuesta', ttextosrespuesta))
        .toString();
  }
}

class ZCSRMOBTRESPUESTAEXPBuilder
    implements Builder<ZCSRMOBTRESPUESTAEXP, ZCSRMOBTRESPUESTAEXPBuilder> {
  _$ZCSRMOBTRESPUESTAEXP? _$v;

  String? _irefdoc;
  String? get irefdoc => _$this._irefdoc;
  set irefdoc(String? irefdoc) => _$this._irefdoc = irefdoc;

  TTEXTOSRESPUESTABuilder? _ttextosrespuesta;
  TTEXTOSRESPUESTABuilder get ttextosrespuesta =>
      _$this._ttextosrespuesta ??= TTEXTOSRESPUESTABuilder();
  set ttextosrespuesta(TTEXTOSRESPUESTABuilder? ttextosrespuesta) =>
      _$this._ttextosrespuesta = ttextosrespuesta;

  ZCSRMOBTRESPUESTAEXPBuilder() {
    ZCSRMOBTRESPUESTAEXP._defaults(this);
  }

  ZCSRMOBTRESPUESTAEXPBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _irefdoc = $v.irefdoc;
      _ttextosrespuesta = $v.ttextosrespuesta.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ZCSRMOBTRESPUESTAEXP other) {
    _$v = other as _$ZCSRMOBTRESPUESTAEXP;
  }

  @override
  void update(void Function(ZCSRMOBTRESPUESTAEXPBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ZCSRMOBTRESPUESTAEXP build() => _build();

  _$ZCSRMOBTRESPUESTAEXP _build() {
    _$ZCSRMOBTRESPUESTAEXP _$result;
    try {
      _$result = _$v ??
          _$ZCSRMOBTRESPUESTAEXP._(
            irefdoc: BuiltValueNullFieldError.checkNotNull(
                irefdoc, r'ZCSRMOBTRESPUESTAEXP', 'irefdoc'),
            ttextosrespuesta: ttextosrespuesta.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'ttextosrespuesta';
        ttextosrespuesta.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ZCSRMOBTRESPUESTAEXP', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
