// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lista_hechos_agente.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ListaHechosAgente extends ListaHechosAgente {
  @override
  final String? idAgente;
  @override
  final BuiltList<Hecho>? listaHechos;

  factory _$ListaHechosAgente(
          [void Function(ListaHechosAgenteBuilder)? updates]) =>
      (ListaHechosAgenteBuilder()..update(updates))._build();

  _$ListaHechosAgente._({this.idAgente, this.listaHechos}) : super._();
  @override
  ListaHechosAgente rebuild(void Function(ListaHechosAgenteBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ListaHechosAgenteBuilder toBuilder() =>
      ListaHechosAgenteBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ListaHechosAgente &&
        idAgente == other.idAgente &&
        listaHechos == other.listaHechos;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, idAgente.hashCode);
    _$hash = $jc(_$hash, listaHechos.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ListaHechosAgente')
          ..add('idAgente', idAgente)
          ..add('listaHechos', listaHechos))
        .toString();
  }
}

class ListaHechosAgenteBuilder
    implements Builder<ListaHechosAgente, ListaHechosAgenteBuilder> {
  _$ListaHechosAgente? _$v;

  String? _idAgente;
  String? get idAgente => _$this._idAgente;
  set idAgente(String? idAgente) => _$this._idAgente = idAgente;

  ListBuilder<Hecho>? _listaHechos;
  ListBuilder<Hecho> get listaHechos =>
      _$this._listaHechos ??= ListBuilder<Hecho>();
  set listaHechos(ListBuilder<Hecho>? listaHechos) =>
      _$this._listaHechos = listaHechos;

  ListaHechosAgenteBuilder() {
    ListaHechosAgente._defaults(this);
  }

  ListaHechosAgenteBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _idAgente = $v.idAgente;
      _listaHechos = $v.listaHechos?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ListaHechosAgente other) {
    _$v = other as _$ListaHechosAgente;
  }

  @override
  void update(void Function(ListaHechosAgenteBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ListaHechosAgente build() => _build();

  _$ListaHechosAgente _build() {
    _$ListaHechosAgente _$result;
    try {
      _$result = _$v ??
          _$ListaHechosAgente._(
            idAgente: idAgente,
            listaHechos: _listaHechos?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'listaHechos';
        _listaHechos?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ListaHechosAgente', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
