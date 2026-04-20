// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lista_tramites_por_hechos.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ListaTramitesPorHechos extends ListaTramitesPorHechos {
  @override
  final BuiltList<TramitesPorHecho>? listaTramitesPorHechos;

  factory _$ListaTramitesPorHechos(
          [void Function(ListaTramitesPorHechosBuilder)? updates]) =>
      (ListaTramitesPorHechosBuilder()..update(updates))._build();

  _$ListaTramitesPorHechos._({this.listaTramitesPorHechos}) : super._();
  @override
  ListaTramitesPorHechos rebuild(
          void Function(ListaTramitesPorHechosBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ListaTramitesPorHechosBuilder toBuilder() =>
      ListaTramitesPorHechosBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ListaTramitesPorHechos &&
        listaTramitesPorHechos == other.listaTramitesPorHechos;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, listaTramitesPorHechos.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ListaTramitesPorHechos')
          ..add('listaTramitesPorHechos', listaTramitesPorHechos))
        .toString();
  }
}

class ListaTramitesPorHechosBuilder
    implements Builder<ListaTramitesPorHechos, ListaTramitesPorHechosBuilder> {
  _$ListaTramitesPorHechos? _$v;

  ListBuilder<TramitesPorHecho>? _listaTramitesPorHechos;
  ListBuilder<TramitesPorHecho> get listaTramitesPorHechos =>
      _$this._listaTramitesPorHechos ??= ListBuilder<TramitesPorHecho>();
  set listaTramitesPorHechos(
          ListBuilder<TramitesPorHecho>? listaTramitesPorHechos) =>
      _$this._listaTramitesPorHechos = listaTramitesPorHechos;

  ListaTramitesPorHechosBuilder() {
    ListaTramitesPorHechos._defaults(this);
  }

  ListaTramitesPorHechosBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _listaTramitesPorHechos = $v.listaTramitesPorHechos?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ListaTramitesPorHechos other) {
    _$v = other as _$ListaTramitesPorHechos;
  }

  @override
  void update(void Function(ListaTramitesPorHechosBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ListaTramitesPorHechos build() => _build();

  _$ListaTramitesPorHechos _build() {
    _$ListaTramitesPorHechos _$result;
    try {
      _$result = _$v ??
          _$ListaTramitesPorHechos._(
            listaTramitesPorHechos: _listaTramitesPorHechos?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'listaTramitesPorHechos';
        _listaTramitesPorHechos?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ListaTramitesPorHechos', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
