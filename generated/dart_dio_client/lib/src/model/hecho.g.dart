// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hecho.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Hecho extends Hecho {
  @override
  final int? idHecho;
  @override
  final String? nombreHecho;
  @override
  final bool? seleccionado;

  factory _$Hecho([void Function(HechoBuilder)? updates]) =>
      (HechoBuilder()..update(updates))._build();

  _$Hecho._({this.idHecho, this.nombreHecho, this.seleccionado}) : super._();
  @override
  Hecho rebuild(void Function(HechoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  HechoBuilder toBuilder() => HechoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Hecho &&
        idHecho == other.idHecho &&
        nombreHecho == other.nombreHecho &&
        seleccionado == other.seleccionado;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, idHecho.hashCode);
    _$hash = $jc(_$hash, nombreHecho.hashCode);
    _$hash = $jc(_$hash, seleccionado.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Hecho')
          ..add('idHecho', idHecho)
          ..add('nombreHecho', nombreHecho)
          ..add('seleccionado', seleccionado))
        .toString();
  }
}

class HechoBuilder implements Builder<Hecho, HechoBuilder> {
  _$Hecho? _$v;

  int? _idHecho;
  int? get idHecho => _$this._idHecho;
  set idHecho(int? idHecho) => _$this._idHecho = idHecho;

  String? _nombreHecho;
  String? get nombreHecho => _$this._nombreHecho;
  set nombreHecho(String? nombreHecho) => _$this._nombreHecho = nombreHecho;

  bool? _seleccionado;
  bool? get seleccionado => _$this._seleccionado;
  set seleccionado(bool? seleccionado) => _$this._seleccionado = seleccionado;

  HechoBuilder() {
    Hecho._defaults(this);
  }

  HechoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _idHecho = $v.idHecho;
      _nombreHecho = $v.nombreHecho;
      _seleccionado = $v.seleccionado;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Hecho other) {
    _$v = other as _$Hecho;
  }

  @override
  void update(void Function(HechoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Hecho build() => _build();

  _$Hecho _build() {
    final _$result = _$v ??
        _$Hecho._(
          idHecho: idHecho,
          nombreHecho: nombreHecho,
          seleccionado: seleccionado,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
