// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lista_hechos.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ListaHechos extends ListaHechos {
  @override
  final BuiltList<Hecho>? listaHechos;

  factory _$ListaHechos([void Function(ListaHechosBuilder)? updates]) =>
      (ListaHechosBuilder()..update(updates))._build();

  _$ListaHechos._({this.listaHechos}) : super._();
  @override
  ListaHechos rebuild(void Function(ListaHechosBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ListaHechosBuilder toBuilder() => ListaHechosBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ListaHechos && listaHechos == other.listaHechos;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, listaHechos.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ListaHechos')
          ..add('listaHechos', listaHechos))
        .toString();
  }
}

class ListaHechosBuilder implements Builder<ListaHechos, ListaHechosBuilder> {
  _$ListaHechos? _$v;

  ListBuilder<Hecho>? _listaHechos;
  ListBuilder<Hecho> get listaHechos =>
      _$this._listaHechos ??= ListBuilder<Hecho>();
  set listaHechos(ListBuilder<Hecho>? listaHechos) =>
      _$this._listaHechos = listaHechos;

  ListaHechosBuilder() {
    ListaHechos._defaults(this);
  }

  ListaHechosBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _listaHechos = $v.listaHechos?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ListaHechos other) {
    _$v = other as _$ListaHechos;
  }

  @override
  void update(void Function(ListaHechosBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ListaHechos build() => _build();

  _$ListaHechos _build() {
    _$ListaHechos _$result;
    try {
      _$result = _$v ??
          _$ListaHechos._(
            listaHechos: _listaHechos?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'listaHechos';
        _listaHechos?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ListaHechos', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
