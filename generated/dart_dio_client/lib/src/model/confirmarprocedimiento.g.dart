// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'confirmarprocedimiento.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CONFIRMARPROCEDIMIENTO extends CONFIRMARPROCEDIMIENTO {
  @override
  final PDATOS pdatos;
  @override
  final DTProcedimiento procedimiento;

  factory _$CONFIRMARPROCEDIMIENTO(
          [void Function(CONFIRMARPROCEDIMIENTOBuilder)? updates]) =>
      (CONFIRMARPROCEDIMIENTOBuilder()..update(updates))._build();

  _$CONFIRMARPROCEDIMIENTO._(
      {required this.pdatos, required this.procedimiento})
      : super._();
  @override
  CONFIRMARPROCEDIMIENTO rebuild(
          void Function(CONFIRMARPROCEDIMIENTOBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CONFIRMARPROCEDIMIENTOBuilder toBuilder() =>
      CONFIRMARPROCEDIMIENTOBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CONFIRMARPROCEDIMIENTO &&
        pdatos == other.pdatos &&
        procedimiento == other.procedimiento;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, pdatos.hashCode);
    _$hash = $jc(_$hash, procedimiento.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CONFIRMARPROCEDIMIENTO')
          ..add('pdatos', pdatos)
          ..add('procedimiento', procedimiento))
        .toString();
  }
}

class CONFIRMARPROCEDIMIENTOBuilder
    implements Builder<CONFIRMARPROCEDIMIENTO, CONFIRMARPROCEDIMIENTOBuilder> {
  _$CONFIRMARPROCEDIMIENTO? _$v;

  PDATOSBuilder? _pdatos;
  PDATOSBuilder get pdatos => _$this._pdatos ??= PDATOSBuilder();
  set pdatos(PDATOSBuilder? pdatos) => _$this._pdatos = pdatos;

  DTProcedimientoBuilder? _procedimiento;
  DTProcedimientoBuilder get procedimiento =>
      _$this._procedimiento ??= DTProcedimientoBuilder();
  set procedimiento(DTProcedimientoBuilder? procedimiento) =>
      _$this._procedimiento = procedimiento;

  CONFIRMARPROCEDIMIENTOBuilder() {
    CONFIRMARPROCEDIMIENTO._defaults(this);
  }

  CONFIRMARPROCEDIMIENTOBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _pdatos = $v.pdatos.toBuilder();
      _procedimiento = $v.procedimiento.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CONFIRMARPROCEDIMIENTO other) {
    _$v = other as _$CONFIRMARPROCEDIMIENTO;
  }

  @override
  void update(void Function(CONFIRMARPROCEDIMIENTOBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CONFIRMARPROCEDIMIENTO build() => _build();

  _$CONFIRMARPROCEDIMIENTO _build() {
    _$CONFIRMARPROCEDIMIENTO _$result;
    try {
      _$result = _$v ??
          _$CONFIRMARPROCEDIMIENTO._(
            pdatos: pdatos.build(),
            procedimiento: procedimiento.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'pdatos';
        pdatos.build();
        _$failedField = 'procedimiento';
        procedimiento.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'CONFIRMARPROCEDIMIENTO', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
