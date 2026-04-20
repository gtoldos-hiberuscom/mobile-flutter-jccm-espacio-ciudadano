//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:espacio_ciudadano_api/src/model/zcssfaq.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'tfaq.g.dart';

/// TFAQ
///
/// Properties:
/// * [item] 
@BuiltValue()
abstract class TFAQ implements Built<TFAQ, TFAQBuilder> {
  @BuiltValueField(wireName: r'item')
  BuiltList<ZCSSFAQ>? get item;

  TFAQ._();

  factory TFAQ([void updates(TFAQBuilder b)]) = _$TFAQ;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TFAQBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TFAQ> get serializer => _$TFAQSerializer();
}

class _$TFAQSerializer implements PrimitiveSerializer<TFAQ> {
  @override
  final Iterable<Type> types = const [TFAQ, _$TFAQ];

  @override
  final String wireName = r'TFAQ';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TFAQ object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.item != null) {
      yield r'item';
      yield serializers.serialize(
        object.item,
        specifiedType: const FullType(BuiltList, [FullType(ZCSSFAQ)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    TFAQ object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TFAQBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'item':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ZCSSFAQ)]),
          ) as BuiltList<ZCSSFAQ>;
          result.item.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  TFAQ deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TFAQBuilder();
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

