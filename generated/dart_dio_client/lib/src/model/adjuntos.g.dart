// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'adjuntos.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ADJUNTOS extends ADJUNTOS {
  @override
  final BuiltList<String> adjunto;

  factory _$ADJUNTOS([void Function(ADJUNTOSBuilder)? updates]) =>
      (ADJUNTOSBuilder()..update(updates))._build();

  _$ADJUNTOS._({required this.adjunto}) : super._();
  @override
  ADJUNTOS rebuild(void Function(ADJUNTOSBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ADJUNTOSBuilder toBuilder() => ADJUNTOSBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ADJUNTOS && adjunto == other.adjunto;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, adjunto.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ADJUNTOS')..add('adjunto', adjunto))
        .toString();
  }
}

class ADJUNTOSBuilder implements Builder<ADJUNTOS, ADJUNTOSBuilder> {
  _$ADJUNTOS? _$v;

  ListBuilder<String>? _adjunto;
  ListBuilder<String> get adjunto => _$this._adjunto ??= ListBuilder<String>();
  set adjunto(ListBuilder<String>? adjunto) => _$this._adjunto = adjunto;

  ADJUNTOSBuilder() {
    ADJUNTOS._defaults(this);
  }

  ADJUNTOSBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _adjunto = $v.adjunto.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ADJUNTOS other) {
    _$v = other as _$ADJUNTOS;
  }

  @override
  void update(void Function(ADJUNTOSBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ADJUNTOS build() => _build();

  _$ADJUNTOS _build() {
    _$ADJUNTOS _$result;
    try {
      _$result = _$v ??
          _$ADJUNTOS._(
            adjunto: adjunto.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'adjunto';
        adjunto.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ADJUNTOS', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
