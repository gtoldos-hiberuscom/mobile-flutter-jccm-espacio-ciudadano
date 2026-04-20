// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'xml_registro.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$XMLRegistro extends XMLRegistro {
  @override
  final String? xmlClave;

  factory _$XMLRegistro([void Function(XMLRegistroBuilder)? updates]) =>
      (XMLRegistroBuilder()..update(updates))._build();

  _$XMLRegistro._({this.xmlClave}) : super._();
  @override
  XMLRegistro rebuild(void Function(XMLRegistroBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  XMLRegistroBuilder toBuilder() => XMLRegistroBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is XMLRegistro && xmlClave == other.xmlClave;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, xmlClave.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'XMLRegistro')
          ..add('xmlClave', xmlClave))
        .toString();
  }
}

class XMLRegistroBuilder implements Builder<XMLRegistro, XMLRegistroBuilder> {
  _$XMLRegistro? _$v;

  String? _xmlClave;
  String? get xmlClave => _$this._xmlClave;
  set xmlClave(String? xmlClave) => _$this._xmlClave = xmlClave;

  XMLRegistroBuilder() {
    XMLRegistro._defaults(this);
  }

  XMLRegistroBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _xmlClave = $v.xmlClave;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(XMLRegistro other) {
    _$v = other as _$XMLRegistro;
  }

  @override
  void update(void Function(XMLRegistroBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  XMLRegistro build() => _build();

  _$XMLRegistro _build() {
    final _$result = _$v ??
        _$XMLRegistro._(
          xmlClave: xmlClave,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
