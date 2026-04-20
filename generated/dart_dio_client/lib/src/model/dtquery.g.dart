// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dtquery.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DTQUERY extends DTQUERY {
  @override
  final String query;

  factory _$DTQUERY([void Function(DTQUERYBuilder)? updates]) =>
      (DTQUERYBuilder()..update(updates))._build();

  _$DTQUERY._({required this.query}) : super._();
  @override
  DTQUERY rebuild(void Function(DTQUERYBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DTQUERYBuilder toBuilder() => DTQUERYBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DTQUERY && query == other.query;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, query.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DTQUERY')..add('query', query))
        .toString();
  }
}

class DTQUERYBuilder implements Builder<DTQUERY, DTQUERYBuilder> {
  _$DTQUERY? _$v;

  String? _query;
  String? get query => _$this._query;
  set query(String? query) => _$this._query = query;

  DTQUERYBuilder() {
    DTQUERY._defaults(this);
  }

  DTQUERYBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _query = $v.query;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DTQUERY other) {
    _$v = other as _$DTQUERY;
  }

  @override
  void update(void Function(DTQUERYBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DTQUERY build() => _build();

  _$DTQUERY _build() {
    final _$result = _$v ??
        _$DTQUERY._(
          query:
              BuiltValueNullFieldError.checkNotNull(query, r'DTQUERY', 'query'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
