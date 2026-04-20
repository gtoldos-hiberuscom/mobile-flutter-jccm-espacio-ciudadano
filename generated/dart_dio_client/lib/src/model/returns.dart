//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:espacio_ciudadano_api/src/model/bapiret2.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'returns.g.dart';

/// RETURNS
///
/// Properties:
/// * [item] 
@BuiltValue()
abstract class RETURNS implements Built<RETURNS, RETURNSBuilder> {
  @BuiltValueField(wireName: r'item')
  BuiltList<BAPIRET2>? get item;

  RETURNS._();

  factory RETURNS([void updates(RETURNSBuilder b)]) = _$RETURNS;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RETURNSBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RETURNS> get serializer => _$RETURNSSerializer();
}

class _$RETURNSSerializer implements PrimitiveSerializer<RETURNS> {
  @override
  final Iterable<Type> types = const [RETURNS, _$RETURNS];

  @override
  final String wireName = r'RETURNS';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RETURNS object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.item != null) {
      yield r'item';
      yield serializers.serialize(
        object.item,
        specifiedType: const FullType(BuiltList, [FullType(BAPIRET2)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    RETURNS object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required RETURNSBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'item':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(BAPIRET2)]),
          ) as BuiltList<BAPIRET2>;
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
  RETURNS deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RETURNSBuilder();
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

