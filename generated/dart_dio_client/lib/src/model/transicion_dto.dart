//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'transicion_dto.g.dart';

/// TransicionDto
///
/// Properties:
/// * [accion]
/// * [justificacion]
@BuiltValue()
abstract class TransicionDto
    implements Built<TransicionDto, TransicionDtoBuilder> {
  @BuiltValueField(wireName: r'accion')
  String? get accion;

  @BuiltValueField(wireName: r'justificacion')
  String? get justificacion;

  TransicionDto._();

  factory TransicionDto([void updates(TransicionDtoBuilder b)]) =
      _$TransicionDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TransicionDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TransicionDto> get serializer =>
      _$TransicionDtoSerializer();
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
    if (object.accion != null) {
      yield r'accion';
      yield serializers.serialize(
        object.accion,
        specifiedType: const FullType(String),
      );
    }
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
    return _serializeProperties(serializers, object,
            specifiedType: specifiedType)
        .toList();
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
            specifiedType: const FullType(String),
          ) as String;
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
