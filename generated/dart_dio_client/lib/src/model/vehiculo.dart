//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vehiculo.g.dart';

/// VEHICULO
///
/// Properties:
/// * [matricula] 
@BuiltValue()
abstract class VEHICULO implements Built<VEHICULO, VEHICULOBuilder> {
  @BuiltValueField(wireName: r'matricula')
  String? get matricula;

  VEHICULO._();

  factory VEHICULO([void updates(VEHICULOBuilder b)]) = _$VEHICULO;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VEHICULOBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VEHICULO> get serializer => _$VEHICULOSerializer();
}

class _$VEHICULOSerializer implements PrimitiveSerializer<VEHICULO> {
  @override
  final Iterable<Type> types = const [VEHICULO, _$VEHICULO];

  @override
  final String wireName = r'VEHICULO';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VEHICULO object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.matricula != null) {
      yield r'matricula';
      yield serializers.serialize(
        object.matricula,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    VEHICULO object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VEHICULOBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'matricula':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.matricula = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VEHICULO deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VEHICULOBuilder();
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

