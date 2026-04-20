// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clausulas.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Clausulas extends Clausulas {
  @override
  final int? idClausula;
  @override
  final bool? seleccionado;
  @override
  final String? version;

  factory _$Clausulas([void Function(ClausulasBuilder)? updates]) =>
      (ClausulasBuilder()..update(updates))._build();

  _$Clausulas._({this.idClausula, this.seleccionado, this.version}) : super._();
  @override
  Clausulas rebuild(void Function(ClausulasBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ClausulasBuilder toBuilder() => ClausulasBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Clausulas &&
        idClausula == other.idClausula &&
        seleccionado == other.seleccionado &&
        version == other.version;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, idClausula.hashCode);
    _$hash = $jc(_$hash, seleccionado.hashCode);
    _$hash = $jc(_$hash, version.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Clausulas')
          ..add('idClausula', idClausula)
          ..add('seleccionado', seleccionado)
          ..add('version', version))
        .toString();
  }
}

class ClausulasBuilder implements Builder<Clausulas, ClausulasBuilder> {
  _$Clausulas? _$v;

  int? _idClausula;
  int? get idClausula => _$this._idClausula;
  set idClausula(int? idClausula) => _$this._idClausula = idClausula;

  bool? _seleccionado;
  bool? get seleccionado => _$this._seleccionado;
  set seleccionado(bool? seleccionado) => _$this._seleccionado = seleccionado;

  String? _version;
  String? get version => _$this._version;
  set version(String? version) => _$this._version = version;

  ClausulasBuilder() {
    Clausulas._defaults(this);
  }

  ClausulasBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _idClausula = $v.idClausula;
      _seleccionado = $v.seleccionado;
      _version = $v.version;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Clausulas other) {
    _$v = other as _$Clausulas;
  }

  @override
  void update(void Function(ClausulasBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Clausulas build() => _build();

  _$Clausulas _build() {
    final _$result = _$v ??
        _$Clausulas._(
          idClausula: idClausula,
          seleccionado: seleccionado,
          version: version,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
