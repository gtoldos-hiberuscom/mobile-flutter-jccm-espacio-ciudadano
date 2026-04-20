//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:espacio_ciudadano_api/src/model/bapiret2.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'etreturn.g.dart';

/// ETRETURN
///
/// Properties:
/// * [item]
@BuiltValue()
abstract class ETRETURN implements Built<ETRETURN, ETRETURNBuilder> {
  @BuiltValueField(wireName: r'item')
  BuiltList<BAPIRET2>? get item;

  ETRETURN._();

  factory ETRETURN([void updates(ETRETURNBuilder b)]) = _$ETRETURN;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ETRETURNBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ETRETURN> get serializer => _$ETRETURNSerializer();
}

class _$ETRETURNSerializer implements PrimitiveSerializer<ETRETURN> {
  @override
  final Iterable<Type> types = const [ETRETURN, _$ETRETURN];

  @override
  final String wireName = r'ETRETURN';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ETRETURN object, {
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
    ETRETURN object, {
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
    required ETRETURNBuilder result,
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
  ETRETURN deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ETRETURNBuilder();
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
