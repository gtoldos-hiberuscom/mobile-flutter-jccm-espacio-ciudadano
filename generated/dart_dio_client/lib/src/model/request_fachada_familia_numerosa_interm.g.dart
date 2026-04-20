// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_fachada_familia_numerosa_interm.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RequestFachadaFamiliaNumerosaInterm
    extends RequestFachadaFamiliaNumerosaInterm {
  @override
  final String? docFuncionario;
  @override
  final String? docu;
  @override
  final String? idaut;
  @override
  final String? nombreFuncionario;
  @override
  final String? proc;
  @override
  final String? tipo;
  @override
  final String? tipodoc;

  factory _$RequestFachadaFamiliaNumerosaInterm(
          [void Function(RequestFachadaFamiliaNumerosaIntermBuilder)?
              updates]) =>
      (RequestFachadaFamiliaNumerosaIntermBuilder()..update(updates))._build();

  _$RequestFachadaFamiliaNumerosaInterm._(
      {this.docFuncionario,
      this.docu,
      this.idaut,
      this.nombreFuncionario,
      this.proc,
      this.tipo,
      this.tipodoc})
      : super._();
  @override
  RequestFachadaFamiliaNumerosaInterm rebuild(
          void Function(RequestFachadaFamiliaNumerosaIntermBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RequestFachadaFamiliaNumerosaIntermBuilder toBuilder() =>
      RequestFachadaFamiliaNumerosaIntermBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RequestFachadaFamiliaNumerosaInterm &&
        docFuncionario == other.docFuncionario &&
        docu == other.docu &&
        idaut == other.idaut &&
        nombreFuncionario == other.nombreFuncionario &&
        proc == other.proc &&
        tipo == other.tipo &&
        tipodoc == other.tipodoc;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, docFuncionario.hashCode);
    _$hash = $jc(_$hash, docu.hashCode);
    _$hash = $jc(_$hash, idaut.hashCode);
    _$hash = $jc(_$hash, nombreFuncionario.hashCode);
    _$hash = $jc(_$hash, proc.hashCode);
    _$hash = $jc(_$hash, tipo.hashCode);
    _$hash = $jc(_$hash, tipodoc.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RequestFachadaFamiliaNumerosaInterm')
          ..add('docFuncionario', docFuncionario)
          ..add('docu', docu)
          ..add('idaut', idaut)
          ..add('nombreFuncionario', nombreFuncionario)
          ..add('proc', proc)
          ..add('tipo', tipo)
          ..add('tipodoc', tipodoc))
        .toString();
  }
}

class RequestFachadaFamiliaNumerosaIntermBuilder
    implements
        Builder<RequestFachadaFamiliaNumerosaInterm,
            RequestFachadaFamiliaNumerosaIntermBuilder> {
  _$RequestFachadaFamiliaNumerosaInterm? _$v;

  String? _docFuncionario;
  String? get docFuncionario => _$this._docFuncionario;
  set docFuncionario(String? docFuncionario) =>
      _$this._docFuncionario = docFuncionario;

  String? _docu;
  String? get docu => _$this._docu;
  set docu(String? docu) => _$this._docu = docu;

  String? _idaut;
  String? get idaut => _$this._idaut;
  set idaut(String? idaut) => _$this._idaut = idaut;

  String? _nombreFuncionario;
  String? get nombreFuncionario => _$this._nombreFuncionario;
  set nombreFuncionario(String? nombreFuncionario) =>
      _$this._nombreFuncionario = nombreFuncionario;

  String? _proc;
  String? get proc => _$this._proc;
  set proc(String? proc) => _$this._proc = proc;

  String? _tipo;
  String? get tipo => _$this._tipo;
  set tipo(String? tipo) => _$this._tipo = tipo;

  String? _tipodoc;
  String? get tipodoc => _$this._tipodoc;
  set tipodoc(String? tipodoc) => _$this._tipodoc = tipodoc;

  RequestFachadaFamiliaNumerosaIntermBuilder() {
    RequestFachadaFamiliaNumerosaInterm._defaults(this);
  }

  RequestFachadaFamiliaNumerosaIntermBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _docFuncionario = $v.docFuncionario;
      _docu = $v.docu;
      _idaut = $v.idaut;
      _nombreFuncionario = $v.nombreFuncionario;
      _proc = $v.proc;
      _tipo = $v.tipo;
      _tipodoc = $v.tipodoc;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RequestFachadaFamiliaNumerosaInterm other) {
    _$v = other as _$RequestFachadaFamiliaNumerosaInterm;
  }

  @override
  void update(
      void Function(RequestFachadaFamiliaNumerosaIntermBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RequestFachadaFamiliaNumerosaInterm build() => _build();

  _$RequestFachadaFamiliaNumerosaInterm _build() {
    final _$result = _$v ??
        _$RequestFachadaFamiliaNumerosaInterm._(
          docFuncionario: docFuncionario,
          docu: docu,
          idaut: idaut,
          nombreFuncionario: nombreFuncionario,
          proc: proc,
          tipo: tipo,
          tipodoc: tipodoc,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
