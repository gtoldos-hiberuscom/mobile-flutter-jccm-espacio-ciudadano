// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_fachada_discapacidad_interm.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RequestFachadaDiscapacidadInterm
    extends RequestFachadaDiscapacidadInterm {
  @override
  final String? docFuncionario;
  @override
  final String? docu;
  @override
  final String? nombreFuncionario;
  @override
  final String? tipodoc;

  factory _$RequestFachadaDiscapacidadInterm(
          [void Function(RequestFachadaDiscapacidadIntermBuilder)? updates]) =>
      (RequestFachadaDiscapacidadIntermBuilder()..update(updates))._build();

  _$RequestFachadaDiscapacidadInterm._(
      {this.docFuncionario, this.docu, this.nombreFuncionario, this.tipodoc})
      : super._();
  @override
  RequestFachadaDiscapacidadInterm rebuild(
          void Function(RequestFachadaDiscapacidadIntermBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RequestFachadaDiscapacidadIntermBuilder toBuilder() =>
      RequestFachadaDiscapacidadIntermBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RequestFachadaDiscapacidadInterm &&
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
    return (newBuiltValueToStringHelper(r'RequestFachadaDiscapacidadInterm')
          ..add('docFuncionario', docFuncionario)
          ..add('docu', docu)
          ..add('nombreFuncionario', nombreFuncionario)
          ..add('tipodoc', tipodoc))
        .toString();
  }
}

class RequestFachadaDiscapacidadIntermBuilder
    implements
        Builder<RequestFachadaDiscapacidadInterm,
            RequestFachadaDiscapacidadIntermBuilder> {
  _$RequestFachadaDiscapacidadInterm? _$v;

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

  RequestFachadaDiscapacidadIntermBuilder() {
    RequestFachadaDiscapacidadInterm._defaults(this);
  }

  RequestFachadaDiscapacidadIntermBuilder get _$this {
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
  void replace(RequestFachadaDiscapacidadInterm other) {
    _$v = other as _$RequestFachadaDiscapacidadInterm;
  }

  @override
  void update(void Function(RequestFachadaDiscapacidadIntermBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RequestFachadaDiscapacidadInterm build() => _build();

  _$RequestFachadaDiscapacidadInterm _build() {
    final _$result = _$v ??
        _$RequestFachadaDiscapacidadInterm._(
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
