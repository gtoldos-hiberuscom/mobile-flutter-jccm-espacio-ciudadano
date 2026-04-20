// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tramites_por_hecho.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$TramitesPorHecho extends TramitesPorHecho {
  @override
  final int? idHecho;
  @override
  final String? nombreHecho;
  @override
  final BuiltList<Tramite>? tramites;

  factory _$TramitesPorHecho(
          [void Function(TramitesPorHechoBuilder)? updates]) =>
      (TramitesPorHechoBuilder()..update(updates))._build();

  _$TramitesPorHecho._({this.idHecho, this.nombreHecho, this.tramites})
      : super._();
  @override
  TramitesPorHecho rebuild(void Function(TramitesPorHechoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TramitesPorHechoBuilder toBuilder() =>
      TramitesPorHechoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TramitesPorHecho &&
        idHecho == other.idHecho &&
        nombreHecho == other.nombreHecho &&
        tramites == other.tramites;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, idHecho.hashCode);
    _$hash = $jc(_$hash, nombreHecho.hashCode);
    _$hash = $jc(_$hash, tramites.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'TramitesPorHecho')
          ..add('idHecho', idHecho)
          ..add('nombreHecho', nombreHecho)
          ..add('tramites', tramites))
        .toString();
  }
}

class TramitesPorHechoBuilder
    implements Builder<TramitesPorHecho, TramitesPorHechoBuilder> {
  _$TramitesPorHecho? _$v;

  int? _idHecho;
  int? get idHecho => _$this._idHecho;
  set idHecho(int? idHecho) => _$this._idHecho = idHecho;

  String? _nombreHecho;
  String? get nombreHecho => _$this._nombreHecho;
  set nombreHecho(String? nombreHecho) => _$this._nombreHecho = nombreHecho;

  ListBuilder<Tramite>? _tramites;
  ListBuilder<Tramite> get tramites =>
      _$this._tramites ??= ListBuilder<Tramite>();
  set tramites(ListBuilder<Tramite>? tramites) => _$this._tramites = tramites;

  TramitesPorHechoBuilder() {
    TramitesPorHecho._defaults(this);
  }

  TramitesPorHechoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _idHecho = $v.idHecho;
      _nombreHecho = $v.nombreHecho;
      _tramites = $v.tramites?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TramitesPorHecho other) {
    _$v = other as _$TramitesPorHecho;
  }

  @override
  void update(void Function(TramitesPorHechoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TramitesPorHecho build() => _build();

  _$TramitesPorHecho _build() {
    _$TramitesPorHecho _$result;
    try {
      _$result = _$v ??
          _$TramitesPorHecho._(
            idHecho: idHecho,
            nombreHecho: nombreHecho,
            tramites: _tramites?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'tramites';
        _tramites?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'TramitesPorHecho', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
