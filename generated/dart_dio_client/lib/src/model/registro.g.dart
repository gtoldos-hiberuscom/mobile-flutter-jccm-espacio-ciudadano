// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'registro.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$REGISTRO extends REGISTRO {
  @override
  final String fecha;
  @override
  final String noregistro;

  factory _$REGISTRO([void Function(REGISTROBuilder)? updates]) =>
      (REGISTROBuilder()..update(updates))._build();

  _$REGISTRO._({required this.fecha, required this.noregistro}) : super._();
  @override
  REGISTRO rebuild(void Function(REGISTROBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  REGISTROBuilder toBuilder() => REGISTROBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is REGISTRO &&
        fecha == other.fecha &&
        noregistro == other.noregistro;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, fecha.hashCode);
    _$hash = $jc(_$hash, noregistro.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'REGISTRO')
          ..add('fecha', fecha)
          ..add('noregistro', noregistro))
        .toString();
  }
}

class REGISTROBuilder implements Builder<REGISTRO, REGISTROBuilder> {
  _$REGISTRO? _$v;

  String? _fecha;
  String? get fecha => _$this._fecha;
  set fecha(String? fecha) => _$this._fecha = fecha;

  String? _noregistro;
  String? get noregistro => _$this._noregistro;
  set noregistro(String? noregistro) => _$this._noregistro = noregistro;

  REGISTROBuilder() {
    REGISTRO._defaults(this);
  }

  REGISTROBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _fecha = $v.fecha;
      _noregistro = $v.noregistro;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(REGISTRO other) {
    _$v = other as _$REGISTRO;
  }

  @override
  void update(void Function(REGISTROBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  REGISTRO build() => _build();

  _$REGISTRO _build() {
    final _$result = _$v ??
        _$REGISTRO._(
          fecha: BuiltValueNullFieldError.checkNotNull(
              fecha, r'REGISTRO', 'fecha'),
          noregistro: BuiltValueNullFieldError.checkNotNull(
              noregistro, r'REGISTRO', 'noregistro'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
