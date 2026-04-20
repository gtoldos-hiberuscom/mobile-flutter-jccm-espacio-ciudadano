// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'datos_especificos_familia_numerosa.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DatosEspecificosFamiliaNumerosa
    extends DatosEspecificosFamiliaNumerosa {
  @override
  final DatosBeneficiariosFamiliaNumerosa? beneficiarios;
  @override
  final DatosTituloFamiliaNumerosa? datosTitulo;

  factory _$DatosEspecificosFamiliaNumerosa(
          [void Function(DatosEspecificosFamiliaNumerosaBuilder)? updates]) =>
      (DatosEspecificosFamiliaNumerosaBuilder()..update(updates))._build();

  _$DatosEspecificosFamiliaNumerosa._({this.beneficiarios, this.datosTitulo})
      : super._();
  @override
  DatosEspecificosFamiliaNumerosa rebuild(
          void Function(DatosEspecificosFamiliaNumerosaBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DatosEspecificosFamiliaNumerosaBuilder toBuilder() =>
      DatosEspecificosFamiliaNumerosaBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DatosEspecificosFamiliaNumerosa &&
        beneficiarios == other.beneficiarios &&
        datosTitulo == other.datosTitulo;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, beneficiarios.hashCode);
    _$hash = $jc(_$hash, datosTitulo.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DatosEspecificosFamiliaNumerosa')
          ..add('beneficiarios', beneficiarios)
          ..add('datosTitulo', datosTitulo))
        .toString();
  }
}

class DatosEspecificosFamiliaNumerosaBuilder
    implements
        Builder<DatosEspecificosFamiliaNumerosa,
            DatosEspecificosFamiliaNumerosaBuilder> {
  _$DatosEspecificosFamiliaNumerosa? _$v;

  DatosBeneficiariosFamiliaNumerosaBuilder? _beneficiarios;
  DatosBeneficiariosFamiliaNumerosaBuilder get beneficiarios =>
      _$this._beneficiarios ??= DatosBeneficiariosFamiliaNumerosaBuilder();
  set beneficiarios(DatosBeneficiariosFamiliaNumerosaBuilder? beneficiarios) =>
      _$this._beneficiarios = beneficiarios;

  DatosTituloFamiliaNumerosaBuilder? _datosTitulo;
  DatosTituloFamiliaNumerosaBuilder get datosTitulo =>
      _$this._datosTitulo ??= DatosTituloFamiliaNumerosaBuilder();
  set datosTitulo(DatosTituloFamiliaNumerosaBuilder? datosTitulo) =>
      _$this._datosTitulo = datosTitulo;

  DatosEspecificosFamiliaNumerosaBuilder() {
    DatosEspecificosFamiliaNumerosa._defaults(this);
  }

  DatosEspecificosFamiliaNumerosaBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _beneficiarios = $v.beneficiarios?.toBuilder();
      _datosTitulo = $v.datosTitulo?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DatosEspecificosFamiliaNumerosa other) {
    _$v = other as _$DatosEspecificosFamiliaNumerosa;
  }

  @override
  void update(void Function(DatosEspecificosFamiliaNumerosaBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DatosEspecificosFamiliaNumerosa build() => _build();

  _$DatosEspecificosFamiliaNumerosa _build() {
    _$DatosEspecificosFamiliaNumerosa _$result;
    try {
      _$result = _$v ??
          _$DatosEspecificosFamiliaNumerosa._(
            beneficiarios: _beneficiarios?.build(),
            datosTitulo: _datosTitulo?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'beneficiarios';
        _beneficiarios?.build();
        _$failedField = 'datosTitulo';
        _datosTitulo?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'DatosEspecificosFamiliaNumerosa', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
