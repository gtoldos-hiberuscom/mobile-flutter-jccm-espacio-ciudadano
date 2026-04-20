// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dtctrocdatreq.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DTCTROCDATREQ extends DTCTROCDATREQ {
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
  final String? tipdoc;
  @override
  final String? tipo;

  factory _$DTCTROCDATREQ([void Function(DTCTROCDATREQBuilder)? updates]) =>
      (DTCTROCDATREQBuilder()..update(updates))._build();

  _$DTCTROCDATREQ._(
      {this.docu,
      this.documentofuncionario,
      this.idaut,
      this.nombrefuncionario,
      this.proc,
      this.tipdoc,
      this.tipo})
      : super._();
  @override
  DTCTROCDATREQ rebuild(void Function(DTCTROCDATREQBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DTCTROCDATREQBuilder toBuilder() => DTCTROCDATREQBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DTCTROCDATREQ &&
        docu == other.docu &&
        documentofuncionario == other.documentofuncionario &&
        idaut == other.idaut &&
        nombrefuncionario == other.nombrefuncionario &&
        proc == other.proc &&
        tipdoc == other.tipdoc &&
        tipo == other.tipo;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, docu.hashCode);
    _$hash = $jc(_$hash, documentofuncionario.hashCode);
    _$hash = $jc(_$hash, idaut.hashCode);
    _$hash = $jc(_$hash, nombrefuncionario.hashCode);
    _$hash = $jc(_$hash, proc.hashCode);
    _$hash = $jc(_$hash, tipdoc.hashCode);
    _$hash = $jc(_$hash, tipo.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DTCTROCDATREQ')
          ..add('docu', docu)
          ..add('documentofuncionario', documentofuncionario)
          ..add('idaut', idaut)
          ..add('nombrefuncionario', nombrefuncionario)
          ..add('proc', proc)
          ..add('tipdoc', tipdoc)
          ..add('tipo', tipo))
        .toString();
  }
}

class DTCTROCDATREQBuilder
    implements Builder<DTCTROCDATREQ, DTCTROCDATREQBuilder> {
  _$DTCTROCDATREQ? _$v;

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

  String? _tipdoc;
  String? get tipdoc => _$this._tipdoc;
  set tipdoc(String? tipdoc) => _$this._tipdoc = tipdoc;

  String? _tipo;
  String? get tipo => _$this._tipo;
  set tipo(String? tipo) => _$this._tipo = tipo;

  DTCTROCDATREQBuilder() {
    DTCTROCDATREQ._defaults(this);
  }

  DTCTROCDATREQBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _docu = $v.docu;
      _documentofuncionario = $v.documentofuncionario;
      _idaut = $v.idaut;
      _nombrefuncionario = $v.nombrefuncionario;
      _proc = $v.proc;
      _tipdoc = $v.tipdoc;
      _tipo = $v.tipo;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DTCTROCDATREQ other) {
    _$v = other as _$DTCTROCDATREQ;
  }

  @override
  void update(void Function(DTCTROCDATREQBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DTCTROCDATREQ build() => _build();

  _$DTCTROCDATREQ _build() {
    final _$result = _$v ??
        _$DTCTROCDATREQ._(
          docu: docu,
          documentofuncionario: documentofuncionario,
          idaut: idaut,
          nombrefuncionario: nombrefuncionario,
          proc: proc,
          tipdoc: tipdoc,
          tipo: tipo,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
