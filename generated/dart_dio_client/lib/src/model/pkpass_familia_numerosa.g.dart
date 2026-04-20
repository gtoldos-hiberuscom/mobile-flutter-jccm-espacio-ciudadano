// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pkpass_familia_numerosa.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PkpassFamiliaNumerosa extends PkpassFamiliaNumerosa {
  @override
  final String? codError;
  @override
  final String? datos;
  @override
  final String? descError;
  @override
  final String? pkpass;

  factory _$PkpassFamiliaNumerosa(
          [void Function(PkpassFamiliaNumerosaBuilder)? updates]) =>
      (PkpassFamiliaNumerosaBuilder()..update(updates))._build();

  _$PkpassFamiliaNumerosa._(
      {this.codError, this.datos, this.descError, this.pkpass})
      : super._();
  @override
  PkpassFamiliaNumerosa rebuild(
          void Function(PkpassFamiliaNumerosaBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PkpassFamiliaNumerosaBuilder toBuilder() =>
      PkpassFamiliaNumerosaBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PkpassFamiliaNumerosa &&
        codError == other.codError &&
        datos == other.datos &&
        descError == other.descError &&
        pkpass == other.pkpass;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, codError.hashCode);
    _$hash = $jc(_$hash, datos.hashCode);
    _$hash = $jc(_$hash, descError.hashCode);
    _$hash = $jc(_$hash, pkpass.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PkpassFamiliaNumerosa')
          ..add('codError', codError)
          ..add('datos', datos)
          ..add('descError', descError)
          ..add('pkpass', pkpass))
        .toString();
  }
}

class PkpassFamiliaNumerosaBuilder
    implements Builder<PkpassFamiliaNumerosa, PkpassFamiliaNumerosaBuilder> {
  _$PkpassFamiliaNumerosa? _$v;

  String? _codError;
  String? get codError => _$this._codError;
  set codError(String? codError) => _$this._codError = codError;

  String? _datos;
  String? get datos => _$this._datos;
  set datos(String? datos) => _$this._datos = datos;

  String? _descError;
  String? get descError => _$this._descError;
  set descError(String? descError) => _$this._descError = descError;

  String? _pkpass;
  String? get pkpass => _$this._pkpass;
  set pkpass(String? pkpass) => _$this._pkpass = pkpass;

  PkpassFamiliaNumerosaBuilder() {
    PkpassFamiliaNumerosa._defaults(this);
  }

  PkpassFamiliaNumerosaBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _codError = $v.codError;
      _datos = $v.datos;
      _descError = $v.descError;
      _pkpass = $v.pkpass;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PkpassFamiliaNumerosa other) {
    _$v = other as _$PkpassFamiliaNumerosa;
  }

  @override
  void update(void Function(PkpassFamiliaNumerosaBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PkpassFamiliaNumerosa build() => _build();

  _$PkpassFamiliaNumerosa _build() {
    final _$result = _$v ??
        _$PkpassFamiliaNumerosa._(
          codError: codError,
          datos: datos,
          descError: descError,
          pkpass: pkpass,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
