//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:espacio_ciudadano_api/src/model/zlistadoc.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'zcslistartiposdoc.g.dart';

/// ZCSLISTARTIPOSDOC
///
/// Properties:
/// * [zlistadoc]
@BuiltValue()
abstract class ZCSLISTARTIPOSDOC
    implements Built<ZCSLISTARTIPOSDOC, ZCSLISTARTIPOSDOCBuilder> {
  @BuiltValueField(wireName: r'zlistadoc')
  ZLISTADOC get zlistadoc;

  ZCSLISTARTIPOSDOC._();

  factory ZCSLISTARTIPOSDOC([void updates(ZCSLISTARTIPOSDOCBuilder b)]) =
      _$ZCSLISTARTIPOSDOC;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ZCSLISTARTIPOSDOCBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ZCSLISTARTIPOSDOC> get serializer =>
      _$ZCSLISTARTIPOSDOCSerializer();
}

class _$ZCSLISTARTIPOSDOCSerializer
    implements PrimitiveSerializer<ZCSLISTARTIPOSDOC> {
  @override
  final Iterable<Type> types = const [ZCSLISTARTIPOSDOC, _$ZCSLISTARTIPOSDOC];

  @override
  final String wireName = r'ZCSLISTARTIPOSDOC';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ZCSLISTARTIPOSDOC object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'zlistadoc';
    yield serializers.serialize(
      object.zlistadoc,
      specifiedType: const FullType(ZLISTADOC),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ZCSLISTARTIPOSDOC object, {
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
    required ZCSLISTARTIPOSDOCBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'zlistadoc':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ZLISTADOC),
          ) as ZLISTADOC;
          result.zlistadoc.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ZCSLISTARTIPOSDOC deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ZCSLISTARTIPOSDOCBuilder();
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
