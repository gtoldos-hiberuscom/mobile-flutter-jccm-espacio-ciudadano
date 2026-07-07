//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'transicion_dto.g.dart';

/// Datos para realizar una transición de estado sobre una notificación electrónica
///
/// Properties:
/// * [accion] - Código de la acción a realizar sobre la notificación
/// * [justificacion] - Texto justificativo de la transición, requerido en algunas acciones como el rechazo
@BuiltValue()
abstract class TransicionDto implements Built<TransicionDto, TransicionDtoBuilder> {
  /// Código de la acción a realizar sobre la notificación
  @BuiltValueField(wireName: r'accion')
  TransicionDtoAccionEnum get accion;
  // enum accionEnum {  COMPARECER,  ACEPTAR,  RECHAZAR,  };

  /// Texto justificativo de la transición, requerido en algunas acciones como el rechazo
  @BuiltValueField(wireName: r'justificacion')
  String? get justificacion;

  TransicionDto._();

  factory TransicionDto([void updates(TransicionDtoBuilder b)]) = _$TransicionDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TransicionDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TransicionDto> get serializer => _$TransicionDtoSerializer();
}

class _$TransicionDtoSerializer implements PrimitiveSerializer<TransicionDto> {
  @override
  final Iterable<Type> types = const [TransicionDto, _$TransicionDto];

  @override
  final String wireName = r'TransicionDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TransicionDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'accion';
    yield serializers.serialize(
      object.accion,
      specifiedType: const FullType(TransicionDtoAccionEnum),
    );
    if (object.justificacion != null) {
      yield r'justificacion';
      yield serializers.serialize(
        object.justificacion,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    TransicionDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TransicionDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'accion':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(TransicionDtoAccionEnum),
          ) as TransicionDtoAccionEnum;
          result.accion = valueDes;
          break;
        case r'justificacion':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.justificacion = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  TransicionDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TransicionDtoBuilder();
    final serializedList = (serialized as Iterable<Object?>).toList();
    final unhandled = <Object?>[];
    _deserializeProperties(
      serializers,
      serialized,
      specifiedType: specifiedType,
      serializedList: serializedList,
      unhandled: unhandled,
      result: result,
    );
    return result.build();
  }
}

class TransicionDtoAccionEnum extends EnumClass {

  /// Código de la acción a realizar sobre la notificación
  @BuiltValueEnumConst(wireName: r'COMPARECER')
  static const TransicionDtoAccionEnum COMPARECER = _$transicionDtoAccionEnum_COMPARECER;
  /// Código de la acción a realizar sobre la notificación
  @BuiltValueEnumConst(wireName: r'ACEPTAR')
  static const TransicionDtoAccionEnum ACEPTAR = _$transicionDtoAccionEnum_ACEPTAR;
  /// Código de la acción a realizar sobre la notificación
  @BuiltValueEnumConst(wireName: r'RECHAZAR')
  static const TransicionDtoAccionEnum RECHAZAR = _$transicionDtoAccionEnum_RECHAZAR;

  static Serializer<TransicionDtoAccionEnum> get serializer => _$transicionDtoAccionEnumSerializer;

  const TransicionDtoAccionEnum._(String name): super(name);

  static BuiltSet<TransicionDtoAccionEnum> get values => _$transicionDtoAccionEnumValues;
  static TransicionDtoAccionEnum valueOf(String name) => _$transicionDtoAccionEnumValueOf(name);
}

