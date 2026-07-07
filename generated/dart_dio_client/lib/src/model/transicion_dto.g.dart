// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transicion_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const TransicionDtoAccionEnum _$transicionDtoAccionEnum_COMPARECER =
    const TransicionDtoAccionEnum._('COMPARECER');
const TransicionDtoAccionEnum _$transicionDtoAccionEnum_ACEPTAR =
    const TransicionDtoAccionEnum._('ACEPTAR');
const TransicionDtoAccionEnum _$transicionDtoAccionEnum_RECHAZAR =
    const TransicionDtoAccionEnum._('RECHAZAR');

TransicionDtoAccionEnum _$transicionDtoAccionEnumValueOf(String name) {
  switch (name) {
    case 'COMPARECER':
      return _$transicionDtoAccionEnum_COMPARECER;
    case 'ACEPTAR':
      return _$transicionDtoAccionEnum_ACEPTAR;
    case 'RECHAZAR':
      return _$transicionDtoAccionEnum_RECHAZAR;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<TransicionDtoAccionEnum> _$transicionDtoAccionEnumValues =
    BuiltSet<TransicionDtoAccionEnum>(const <TransicionDtoAccionEnum>[
  _$transicionDtoAccionEnum_COMPARECER,
  _$transicionDtoAccionEnum_ACEPTAR,
  _$transicionDtoAccionEnum_RECHAZAR,
]);

Serializer<TransicionDtoAccionEnum> _$transicionDtoAccionEnumSerializer =
    _$TransicionDtoAccionEnumSerializer();

class _$TransicionDtoAccionEnumSerializer
    implements PrimitiveSerializer<TransicionDtoAccionEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'COMPARECER': 'COMPARECER',
    'ACEPTAR': 'ACEPTAR',
    'RECHAZAR': 'RECHAZAR',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'COMPARECER': 'COMPARECER',
    'ACEPTAR': 'ACEPTAR',
    'RECHAZAR': 'RECHAZAR',
  };

  @override
  final Iterable<Type> types = const <Type>[TransicionDtoAccionEnum];
  @override
  final String wireName = 'TransicionDtoAccionEnum';

  @override
  Object serialize(Serializers serializers, TransicionDtoAccionEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  TransicionDtoAccionEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      TransicionDtoAccionEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$TransicionDto extends TransicionDto {
  @override
  final TransicionDtoAccionEnum accion;
  @override
  final String? justificacion;

  factory _$TransicionDto([void Function(TransicionDtoBuilder)? updates]) =>
      (TransicionDtoBuilder()..update(updates))._build();

  _$TransicionDto._({required this.accion, this.justificacion}) : super._();
  @override
  TransicionDto rebuild(void Function(TransicionDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TransicionDtoBuilder toBuilder() => TransicionDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TransicionDto &&
        accion == other.accion &&
        justificacion == other.justificacion;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, accion.hashCode);
    _$hash = $jc(_$hash, justificacion.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'TransicionDto')
          ..add('accion', accion)
          ..add('justificacion', justificacion))
        .toString();
  }
}

class TransicionDtoBuilder
    implements Builder<TransicionDto, TransicionDtoBuilder> {
  _$TransicionDto? _$v;

  TransicionDtoAccionEnum? _accion;
  TransicionDtoAccionEnum? get accion => _$this._accion;
  set accion(TransicionDtoAccionEnum? accion) => _$this._accion = accion;

  String? _justificacion;
  String? get justificacion => _$this._justificacion;
  set justificacion(String? justificacion) =>
      _$this._justificacion = justificacion;

  TransicionDtoBuilder() {
    TransicionDto._defaults(this);
  }

  TransicionDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _accion = $v.accion;
      _justificacion = $v.justificacion;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TransicionDto other) {
    _$v = other as _$TransicionDto;
  }

  @override
  void update(void Function(TransicionDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TransicionDto build() => _build();

  _$TransicionDto _build() {
    final _$result = _$v ??
        _$TransicionDto._(
          accion: BuiltValueNullFieldError.checkNotNull(
              accion, r'TransicionDto', 'accion'),
          justificacion: justificacion,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
