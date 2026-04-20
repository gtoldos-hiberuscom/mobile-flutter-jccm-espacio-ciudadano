// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dtdgtlistadovehiculosreq.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DTDGTLISTADOVEHICULOSREQ extends DTDGTLISTADOVEHICULOSREQ {
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

  factory _$DTDGTLISTADOVEHICULOSREQ(
          [void Function(DTDGTLISTADOVEHICULOSREQBuilder)? updates]) =>
      (DTDGTLISTADOVEHICULOSREQBuilder()..update(updates))._build();

  _$DTDGTLISTADOVEHICULOSREQ._(
      {this.docu,
      this.documentofuncionario,
      this.idaut,
      this.nombrefuncionario,
      this.proc,
      this.tipo,
      this.tipodoc})
      : super._();
  @override
  DTDGTLISTADOVEHICULOSREQ rebuild(
          void Function(DTDGTLISTADOVEHICULOSREQBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DTDGTLISTADOVEHICULOSREQBuilder toBuilder() =>
      DTDGTLISTADOVEHICULOSREQBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DTDGTLISTADOVEHICULOSREQ &&
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
    return (newBuiltValueToStringHelper(r'DTDGTLISTADOVEHICULOSREQ')
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

class DTDGTLISTADOVEHICULOSREQBuilder
    implements
        Builder<DTDGTLISTADOVEHICULOSREQ, DTDGTLISTADOVEHICULOSREQBuilder> {
  _$DTDGTLISTADOVEHICULOSREQ? _$v;

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

  DTDGTLISTADOVEHICULOSREQBuilder() {
    DTDGTLISTADOVEHICULOSREQ._defaults(this);
  }

  DTDGTLISTADOVEHICULOSREQBuilder get _$this {
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
  void replace(DTDGTLISTADOVEHICULOSREQ other) {
    _$v = other as _$DTDGTLISTADOVEHICULOSREQ;
  }

  @override
  void update(void Function(DTDGTLISTADOVEHICULOSREQBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DTDGTLISTADOVEHICULOSREQ build() => _build();

  _$DTDGTLISTADOVEHICULOSREQ _build() {
    final _$result = _$v ??
        _$DTDGTLISTADOVEHICULOSREQ._(
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
