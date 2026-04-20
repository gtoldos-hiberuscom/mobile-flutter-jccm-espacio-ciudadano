// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bapiret2.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$BAPIRET2 extends BAPIRET2 {
  @override
  final String? field;
  @override
  final String? id;
  @override
  final String? logmsgno;
  @override
  final String? logno;
  @override
  final String? message;
  @override
  final String? messagev1;
  @override
  final String? messagev2;
  @override
  final String? messagev3;
  @override
  final String? messagev4;
  @override
  final String? number;
  @override
  final String? parameter;
  @override
  final int? row;
  @override
  final String? system;
  @override
  final String? type;

  factory _$BAPIRET2([void Function(BAPIRET2Builder)? updates]) =>
      (BAPIRET2Builder()..update(updates))._build();

  _$BAPIRET2._(
      {this.field,
      this.id,
      this.logmsgno,
      this.logno,
      this.message,
      this.messagev1,
      this.messagev2,
      this.messagev3,
      this.messagev4,
      this.number,
      this.parameter,
      this.row,
      this.system,
      this.type})
      : super._();
  @override
  BAPIRET2 rebuild(void Function(BAPIRET2Builder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BAPIRET2Builder toBuilder() => BAPIRET2Builder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BAPIRET2 &&
        field == other.field &&
        id == other.id &&
        logmsgno == other.logmsgno &&
        logno == other.logno &&
        message == other.message &&
        messagev1 == other.messagev1 &&
        messagev2 == other.messagev2 &&
        messagev3 == other.messagev3 &&
        messagev4 == other.messagev4 &&
        number == other.number &&
        parameter == other.parameter &&
        row == other.row &&
        system == other.system &&
        type == other.type;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, field.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, logmsgno.hashCode);
    _$hash = $jc(_$hash, logno.hashCode);
    _$hash = $jc(_$hash, message.hashCode);
    _$hash = $jc(_$hash, messagev1.hashCode);
    _$hash = $jc(_$hash, messagev2.hashCode);
    _$hash = $jc(_$hash, messagev3.hashCode);
    _$hash = $jc(_$hash, messagev4.hashCode);
    _$hash = $jc(_$hash, number.hashCode);
    _$hash = $jc(_$hash, parameter.hashCode);
    _$hash = $jc(_$hash, row.hashCode);
    _$hash = $jc(_$hash, system.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'BAPIRET2')
          ..add('field', field)
          ..add('id', id)
          ..add('logmsgno', logmsgno)
          ..add('logno', logno)
          ..add('message', message)
          ..add('messagev1', messagev1)
          ..add('messagev2', messagev2)
          ..add('messagev3', messagev3)
          ..add('messagev4', messagev4)
          ..add('number', number)
          ..add('parameter', parameter)
          ..add('row', row)
          ..add('system', system)
          ..add('type', type))
        .toString();
  }
}

class BAPIRET2Builder implements Builder<BAPIRET2, BAPIRET2Builder> {
  _$BAPIRET2? _$v;

  String? _field;
  String? get field => _$this._field;
  set field(String? field) => _$this._field = field;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _logmsgno;
  String? get logmsgno => _$this._logmsgno;
  set logmsgno(String? logmsgno) => _$this._logmsgno = logmsgno;

  String? _logno;
  String? get logno => _$this._logno;
  set logno(String? logno) => _$this._logno = logno;

  String? _message;
  String? get message => _$this._message;
  set message(String? message) => _$this._message = message;

  String? _messagev1;
  String? get messagev1 => _$this._messagev1;
  set messagev1(String? messagev1) => _$this._messagev1 = messagev1;

  String? _messagev2;
  String? get messagev2 => _$this._messagev2;
  set messagev2(String? messagev2) => _$this._messagev2 = messagev2;

  String? _messagev3;
  String? get messagev3 => _$this._messagev3;
  set messagev3(String? messagev3) => _$this._messagev3 = messagev3;

  String? _messagev4;
  String? get messagev4 => _$this._messagev4;
  set messagev4(String? messagev4) => _$this._messagev4 = messagev4;

  String? _number;
  String? get number => _$this._number;
  set number(String? number) => _$this._number = number;

  String? _parameter;
  String? get parameter => _$this._parameter;
  set parameter(String? parameter) => _$this._parameter = parameter;

  int? _row;
  int? get row => _$this._row;
  set row(int? row) => _$this._row = row;

  String? _system;
  String? get system => _$this._system;
  set system(String? system) => _$this._system = system;

  String? _type;
  String? get type => _$this._type;
  set type(String? type) => _$this._type = type;

  BAPIRET2Builder() {
    BAPIRET2._defaults(this);
  }

  BAPIRET2Builder get _$this {
    final $v = _$v;
    if ($v != null) {
      _field = $v.field;
      _id = $v.id;
      _logmsgno = $v.logmsgno;
      _logno = $v.logno;
      _message = $v.message;
      _messagev1 = $v.messagev1;
      _messagev2 = $v.messagev2;
      _messagev3 = $v.messagev3;
      _messagev4 = $v.messagev4;
      _number = $v.number;
      _parameter = $v.parameter;
      _row = $v.row;
      _system = $v.system;
      _type = $v.type;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BAPIRET2 other) {
    _$v = other as _$BAPIRET2;
  }

  @override
  void update(void Function(BAPIRET2Builder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BAPIRET2 build() => _build();

  _$BAPIRET2 _build() {
    final _$result = _$v ??
        _$BAPIRET2._(
          field: field,
          id: id,
          logmsgno: logmsgno,
          logno: logno,
          message: message,
          messagev1: messagev1,
          messagev2: messagev2,
          messagev3: messagev3,
          messagev4: messagev4,
          number: number,
          parameter: parameter,
          row: row,
          system: system,
          type: type,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
