// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'informacion_adicional_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$InformacionAdicionalDto extends InformacionAdicionalDto {
  @override
  final String? clave;
  @override
  final String? valor;

  factory _$InformacionAdicionalDto(
          [void Function(InformacionAdicionalDtoBuilder)? updates]) =>
      (InformacionAdicionalDtoBuilder()..update(updates))._build();

  _$InformacionAdicionalDto._({this.clave, this.valor}) : super._();
  @override
  InformacionAdicionalDto rebuild(
          void Function(InformacionAdicionalDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  InformacionAdicionalDtoBuilder toBuilder() =>
      InformacionAdicionalDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is InformacionAdicionalDto &&
        clave == other.clave &&
        valor == other.valor;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, clave.hashCode);
    _$hash = $jc(_$hash, valor.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'InformacionAdicionalDto')
          ..add('clave', clave)
          ..add('valor', valor))
        .toString();
  }
}

class InformacionAdicionalDtoBuilder
    implements
        Builder<InformacionAdicionalDto, InformacionAdicionalDtoBuilder> {
  _$InformacionAdicionalDto? _$v;

  String? _clave;
  String? get clave => _$this._clave;
  set clave(String? clave) => _$this._clave = clave;

  String? _valor;
  String? get valor => _$this._valor;
  set valor(String? valor) => _$this._valor = valor;

  InformacionAdicionalDtoBuilder() {
    InformacionAdicionalDto._defaults(this);
  }

  InformacionAdicionalDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _clave = $v.clave;
      _valor = $v.valor;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(InformacionAdicionalDto other) {
    _$v = other as _$InformacionAdicionalDto;
  }

  @override
  void update(void Function(InformacionAdicionalDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  InformacionAdicionalDto build() => _build();

  _$InformacionAdicionalDto _build() {
    final _$result = _$v ??
        _$InformacionAdicionalDto._(
          clave: clave,
          valor: valor,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
