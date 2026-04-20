// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'zcsvec_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ZCSVECResponse extends ZCSVECResponse {
  @override
  final String? certificado;
  @override
  final String? denerror;
  @override
  final String? idtrans;
  @override
  final String? resul;
  @override
  final String? subject;
  @override
  final String? uriformava;
  @override
  final String? uritipofirma;

  factory _$ZCSVECResponse([void Function(ZCSVECResponseBuilder)? updates]) =>
      (ZCSVECResponseBuilder()..update(updates))._build();

  _$ZCSVECResponse._(
      {this.certificado,
      this.denerror,
      this.idtrans,
      this.resul,
      this.subject,
      this.uriformava,
      this.uritipofirma})
      : super._();
  @override
  ZCSVECResponse rebuild(void Function(ZCSVECResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ZCSVECResponseBuilder toBuilder() => ZCSVECResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ZCSVECResponse &&
        certificado == other.certificado &&
        denerror == other.denerror &&
        idtrans == other.idtrans &&
        resul == other.resul &&
        subject == other.subject &&
        uriformava == other.uriformava &&
        uritipofirma == other.uritipofirma;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, certificado.hashCode);
    _$hash = $jc(_$hash, denerror.hashCode);
    _$hash = $jc(_$hash, idtrans.hashCode);
    _$hash = $jc(_$hash, resul.hashCode);
    _$hash = $jc(_$hash, subject.hashCode);
    _$hash = $jc(_$hash, uriformava.hashCode);
    _$hash = $jc(_$hash, uritipofirma.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ZCSVECResponse')
          ..add('certificado', certificado)
          ..add('denerror', denerror)
          ..add('idtrans', idtrans)
          ..add('resul', resul)
          ..add('subject', subject)
          ..add('uriformava', uriformava)
          ..add('uritipofirma', uritipofirma))
        .toString();
  }
}

class ZCSVECResponseBuilder
    implements Builder<ZCSVECResponse, ZCSVECResponseBuilder> {
  _$ZCSVECResponse? _$v;

  String? _certificado;
  String? get certificado => _$this._certificado;
  set certificado(String? certificado) => _$this._certificado = certificado;

  String? _denerror;
  String? get denerror => _$this._denerror;
  set denerror(String? denerror) => _$this._denerror = denerror;

  String? _idtrans;
  String? get idtrans => _$this._idtrans;
  set idtrans(String? idtrans) => _$this._idtrans = idtrans;

  String? _resul;
  String? get resul => _$this._resul;
  set resul(String? resul) => _$this._resul = resul;

  String? _subject;
  String? get subject => _$this._subject;
  set subject(String? subject) => _$this._subject = subject;

  String? _uriformava;
  String? get uriformava => _$this._uriformava;
  set uriformava(String? uriformava) => _$this._uriformava = uriformava;

  String? _uritipofirma;
  String? get uritipofirma => _$this._uritipofirma;
  set uritipofirma(String? uritipofirma) => _$this._uritipofirma = uritipofirma;

  ZCSVECResponseBuilder() {
    ZCSVECResponse._defaults(this);
  }

  ZCSVECResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _certificado = $v.certificado;
      _denerror = $v.denerror;
      _idtrans = $v.idtrans;
      _resul = $v.resul;
      _subject = $v.subject;
      _uriformava = $v.uriformava;
      _uritipofirma = $v.uritipofirma;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ZCSVECResponse other) {
    _$v = other as _$ZCSVECResponse;
  }

  @override
  void update(void Function(ZCSVECResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ZCSVECResponse build() => _build();

  _$ZCSVECResponse _build() {
    final _$result = _$v ??
        _$ZCSVECResponse._(
          certificado: certificado,
          denerror: denerror,
          idtrans: idtrans,
          resul: resul,
          subject: subject,
          uriformava: uriformava,
          uritipofirma: uritipofirma,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
