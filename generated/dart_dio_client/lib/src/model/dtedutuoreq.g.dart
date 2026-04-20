// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dtedutuoreq.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DTEDUTUOREQ extends DTEDUTUOREQ {
  @override
  final String? docu;
  @override
  final String? documentofuncionario;
  @override
  final String? idaut;
  @override
  final String? nombrefuncionario;
  @override
  final String? proc;
  @override
  final String? tipo;
  @override
  final String? tipodoc;

  factory _$DTEDUTUOREQ([void Function(DTEDUTUOREQBuilder)? updates]) =>
      (DTEDUTUOREQBuilder()..update(updates))._build();

  _$DTEDUTUOREQ._(
      {this.docu,
      this.documentofuncionario,
      this.idaut,
      this.nombrefuncionario,
      this.proc,
      this.tipo,
      this.tipodoc})
      : super._();
  @override
  DTEDUTUOREQ rebuild(void Function(DTEDUTUOREQBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DTEDUTUOREQBuilder toBuilder() => DTEDUTUOREQBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DTEDUTUOREQ &&
        docu == other.docu &&
        documentofuncionario == other.documentofuncionario &&
        idaut == other.idaut &&
        nombrefuncionario == other.nombrefuncionario &&
        proc == other.proc &&
        tipo == other.tipo &&
        tipodoc == other.tipodoc;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, docu.hashCode);
    _$hash = $jc(_$hash, documentofuncionario.hashCode);
    _$hash = $jc(_$hash, idaut.hashCode);
    _$hash = $jc(_$hash, nombrefuncionario.hashCode);
    _$hash = $jc(_$hash, proc.hashCode);
    _$hash = $jc(_$hash, tipo.hashCode);
    _$hash = $jc(_$hash, tipodoc.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DTEDUTUOREQ')
          ..add('docu', docu)
          ..add('documentofuncionario', documentofuncionario)
          ..add('idaut', idaut)
          ..add('nombrefuncionario', nombrefuncionario)
          ..add('proc', proc)
          ..add('tipo', tipo)
          ..add('tipodoc', tipodoc))
        .toString();
  }
}

class DTEDUTUOREQBuilder implements Builder<DTEDUTUOREQ, DTEDUTUOREQBuilder> {
  _$DTEDUTUOREQ? _$v;

  String? _docu;
  String? get docu => _$this._docu;
  set docu(String? docu) => _$this._docu = docu;

  String? _documentofuncionario;
  String? get documentofuncionario => _$this._documentofuncionario;
  set documentofuncionario(String? documentofuncionario) =>
      _$this._documentofuncionario = documentofuncionario;

  String? _idaut;
  String? get idaut => _$this._idaut;
  set idaut(String? idaut) => _$this._idaut = idaut;

  String? _nombrefuncionario;
  String? get nombrefuncionario => _$this._nombrefuncionario;
  set nombrefuncionario(String? nombrefuncionario) =>
      _$this._nombrefuncionario = nombrefuncionario;

  String? _proc;
  String? get proc => _$this._proc;
  set proc(String? proc) => _$this._proc = proc;

  String? _tipo;
  String? get tipo => _$this._tipo;
  set tipo(String? tipo) => _$this._tipo = tipo;

  String? _tipodoc;
  String? get tipodoc => _$this._tipodoc;
  set tipodoc(String? tipodoc) => _$this._tipodoc = tipodoc;

  DTEDUTUOREQBuilder() {
    DTEDUTUOREQ._defaults(this);
  }

  DTEDUTUOREQBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _docu = $v.docu;
      _documentofuncionario = $v.documentofuncionario;
      _idaut = $v.idaut;
      _nombrefuncionario = $v.nombrefuncionario;
      _proc = $v.proc;
      _tipo = $v.tipo;
      _tipodoc = $v.tipodoc;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DTEDUTUOREQ other) {
    _$v = other as _$DTEDUTUOREQ;
  }

  @override
  void update(void Function(DTEDUTUOREQBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DTEDUTUOREQ build() => _build();

  _$DTEDUTUOREQ _build() {
    final _$result = _$v ??
        _$DTEDUTUOREQ._(
          docu: docu,
          documentofuncionario: documentofuncionario,
          idaut: idaut,
          nombrefuncionario: nombrefuncionario,
          proc: proc,
          tipo: tipo,
          tipodoc: tipodoc,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
