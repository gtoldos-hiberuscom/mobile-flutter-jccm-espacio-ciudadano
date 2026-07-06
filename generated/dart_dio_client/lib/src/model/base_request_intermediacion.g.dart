// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_request_intermediacion.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$BaseRequestIntermediacion extends BaseRequestIntermediacion {
  @override
  final String? docFuncionario;
  @override
  final String? docu;
  @override
  final String? nombreFuncionario;
  @override
  final String? tipodoc;

  factory _$BaseRequestIntermediacion(
          [void Function(BaseRequestIntermediacionBuilder)? updates]) =>
      (BaseRequestIntermediacionBuilder()..update(updates))._build();

  _$BaseRequestIntermediacion._(
      {this.docFuncionario, this.docu, this.nombreFuncionario, this.tipodoc})
      : super._();
  @override
  BaseRequestIntermediacion rebuild(
          void Function(BaseRequestIntermediacionBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BaseRequestIntermediacionBuilder toBuilder() =>
      BaseRequestIntermediacionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BaseRequestIntermediacion &&
        docFuncionario == other.docFuncionario &&
        docu == other.docu &&
        nombreFuncionario == other.nombreFuncionario &&
        tipodoc == other.tipodoc;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, docFuncionario.hashCode);
    _$hash = $jc(_$hash, docu.hashCode);
    _$hash = $jc(_$hash, nombreFuncionario.hashCode);
    _$hash = $jc(_$hash, tipodoc.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'BaseRequestIntermediacion')
          ..add('docFuncionario', docFuncionario)
          ..add('docu', docu)
          ..add('nombreFuncionario', nombreFuncionario)
          ..add('tipodoc', tipodoc))
        .toString();
  }
}

class BaseRequestIntermediacionBuilder
    implements
        Builder<BaseRequestIntermediacion, BaseRequestIntermediacionBuilder> {
  _$BaseRequestIntermediacion? _$v;

  String? _docFuncionario;
  String? get docFuncionario => _$this._docFuncionario;
  set docFuncionario(String? docFuncionario) =>
      _$this._docFuncionario = docFuncionario;

  String? _docu;
  String? get docu => _$this._docu;
  set docu(String? docu) => _$this._docu = docu;

  String? _nombreFuncionario;
  String? get nombreFuncionario => _$this._nombreFuncionario;
  set nombreFuncionario(String? nombreFuncionario) =>
      _$this._nombreFuncionario = nombreFuncionario;

  String? _tipodoc;
  String? get tipodoc => _$this._tipodoc;
  set tipodoc(String? tipodoc) => _$this._tipodoc = tipodoc;

  BaseRequestIntermediacionBuilder() {
    BaseRequestIntermediacion._defaults(this);
  }

  BaseRequestIntermediacionBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _docFuncionario = $v.docFuncionario;
      _docu = $v.docu;
      _nombreFuncionario = $v.nombreFuncionario;
      _tipodoc = $v.tipodoc;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BaseRequestIntermediacion other) {
    _$v = other as _$BaseRequestIntermediacion;
  }

  @override
  void update(void Function(BaseRequestIntermediacionBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BaseRequestIntermediacion build() => _build();

  _$BaseRequestIntermediacion _build() {
    final _$result = _$v ??
        _$BaseRequestIntermediacion._(
          docFuncionario: docFuncionario,
          docu: docu,
          nombreFuncionario: nombreFuncionario,
          tipodoc: tipodoc,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
