// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'datosregistro.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DATOSREGISTRO extends DATOSREGISTRO {
  @override
  final PREGISTRO? pregistro;

  factory _$DATOSREGISTRO([void Function(DATOSREGISTROBuilder)? updates]) =>
      (DATOSREGISTROBuilder()..update(updates))._build();

  _$DATOSREGISTRO._({this.pregistro}) : super._();
  @override
  DATOSREGISTRO rebuild(void Function(DATOSREGISTROBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DATOSREGISTROBuilder toBuilder() => DATOSREGISTROBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DATOSREGISTRO && pregistro == other.pregistro;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, pregistro.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DATOSREGISTRO')
          ..add('pregistro', pregistro))
        .toString();
  }
}

class DATOSREGISTROBuilder
    implements Builder<DATOSREGISTRO, DATOSREGISTROBuilder> {
  _$DATOSREGISTRO? _$v;

  PREGISTROBuilder? _pregistro;
  PREGISTROBuilder get pregistro => _$this._pregistro ??= PREGISTROBuilder();
  set pregistro(PREGISTROBuilder? pregistro) => _$this._pregistro = pregistro;

  DATOSREGISTROBuilder() {
    DATOSREGISTRO._defaults(this);
  }

  DATOSREGISTROBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _pregistro = $v.pregistro?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DATOSREGISTRO other) {
    _$v = other as _$DATOSREGISTRO;
  }

  @override
  void update(void Function(DATOSREGISTROBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DATOSREGISTRO build() => _build();

  _$DATOSREGISTRO _build() {
    _$DATOSREGISTRO _$result;
    try {
      _$result = _$v ??
          _$DATOSREGISTRO._(
            pregistro: _pregistro?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'pregistro';
        _pregistro?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'DATOSREGISTRO', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
