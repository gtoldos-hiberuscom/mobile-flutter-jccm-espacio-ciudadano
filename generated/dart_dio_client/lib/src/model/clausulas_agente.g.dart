// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clausulas_agente.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ClausulasAgente extends ClausulasAgente {
  @override
  final BuiltList<Clausulas>? clausulas;
  @override
  final String? idAgente;

  factory _$ClausulasAgente([void Function(ClausulasAgenteBuilder)? updates]) =>
      (ClausulasAgenteBuilder()..update(updates))._build();

  _$ClausulasAgente._({this.clausulas, this.idAgente}) : super._();
  @override
  ClausulasAgente rebuild(void Function(ClausulasAgenteBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ClausulasAgenteBuilder toBuilder() => ClausulasAgenteBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ClausulasAgente &&
        clausulas == other.clausulas &&
        idAgente == other.idAgente;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, clausulas.hashCode);
    _$hash = $jc(_$hash, idAgente.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ClausulasAgente')
          ..add('clausulas', clausulas)
          ..add('idAgente', idAgente))
        .toString();
  }
}

class ClausulasAgenteBuilder
    implements Builder<ClausulasAgente, ClausulasAgenteBuilder> {
  _$ClausulasAgente? _$v;

  ListBuilder<Clausulas>? _clausulas;
  ListBuilder<Clausulas> get clausulas =>
      _$this._clausulas ??= ListBuilder<Clausulas>();
  set clausulas(ListBuilder<Clausulas>? clausulas) =>
      _$this._clausulas = clausulas;

  String? _idAgente;
  String? get idAgente => _$this._idAgente;
  set idAgente(String? idAgente) => _$this._idAgente = idAgente;

  ClausulasAgenteBuilder() {
    ClausulasAgente._defaults(this);
  }

  ClausulasAgenteBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _clausulas = $v.clausulas?.toBuilder();
      _idAgente = $v.idAgente;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ClausulasAgente other) {
    _$v = other as _$ClausulasAgente;
  }

  @override
  void update(void Function(ClausulasAgenteBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ClausulasAgente build() => _build();

  _$ClausulasAgente _build() {
    _$ClausulasAgente _$result;
    try {
      _$result = _$v ??
          _$ClausulasAgente._(
            clausulas: _clausulas?.build(),
            idAgente: idAgente,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'clausulas';
        _clausulas?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ClausulasAgente', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
