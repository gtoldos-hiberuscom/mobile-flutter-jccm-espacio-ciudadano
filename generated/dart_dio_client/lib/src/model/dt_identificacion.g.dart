// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dt_identificacion.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DTIdentificacion extends DTIdentificacion {
  @override
  final String category;
  @override
  final String nifcif;

  factory _$DTIdentificacion(
          [void Function(DTIdentificacionBuilder)? updates]) =>
      (DTIdentificacionBuilder()..update(updates))._build();

  _$DTIdentificacion._({required this.category, required this.nifcif})
      : super._();
  @override
  DTIdentificacion rebuild(void Function(DTIdentificacionBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DTIdentificacionBuilder toBuilder() =>
      DTIdentificacionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DTIdentificacion &&
        category == other.category &&
        nifcif == other.nifcif;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, category.hashCode);
    _$hash = $jc(_$hash, nifcif.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DTIdentificacion')
          ..add('category', category)
          ..add('nifcif', nifcif))
        .toString();
  }
}

class DTIdentificacionBuilder
    implements Builder<DTIdentificacion, DTIdentificacionBuilder> {
  _$DTIdentificacion? _$v;

  String? _category;
  String? get category => _$this._category;
  set category(String? category) => _$this._category = category;

  String? _nifcif;
  String? get nifcif => _$this._nifcif;
  set nifcif(String? nifcif) => _$this._nifcif = nifcif;

  DTIdentificacionBuilder() {
    DTIdentificacion._defaults(this);
  }

  DTIdentificacionBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _category = $v.category;
      _nifcif = $v.nifcif;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DTIdentificacion other) {
    _$v = other as _$DTIdentificacion;
  }

  @override
  void update(void Function(DTIdentificacionBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DTIdentificacion build() => _build();

  _$DTIdentificacion _build() {
    final _$result = _$v ??
        _$DTIdentificacion._(
          category: BuiltValueNullFieldError.checkNotNull(
              category, r'DTIdentificacion', 'category'),
          nifcif: BuiltValueNullFieldError.checkNotNull(
              nifcif, r'DTIdentificacion', 'nifcif'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
