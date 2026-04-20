//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:espacio_ciudadano_api/src/model/zcstbdocumento.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'zcssttbdocumento.g.dart';

/// ZCSSTTBDOCUMENTO
///
/// Properties:
/// * [item]
@BuiltValue()
abstract class ZCSSTTBDOCUMENTO
    implements Built<ZCSSTTBDOCUMENTO, ZCSSTTBDOCUMENTOBuilder> {
  @BuiltValueField(wireName: r'item')
  BuiltList<ZCSTBDOCUMENTO>? get item;

  ZCSSTTBDOCUMENTO._();

  factory ZCSSTTBDOCUMENTO([void updates(ZCSSTTBDOCUMENTOBuilder b)]) =
      _$ZCSSTTBDOCUMENTO;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ZCSSTTBDOCUMENTOBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ZCSSTTBDOCUMENTO> get serializer =>
      _$ZCSSTTBDOCUMENTOSerializer();
}

class _$ZCSSTTBDOCUMENTOSerializer
    implements PrimitiveSerializer<ZCSSTTBDOCUMENTO> {
  @override
  final Iterable<Type> types = const [ZCSSTTBDOCUMENTO, _$ZCSSTTBDOCUMENTO];

  @override
  final String wireName = r'ZCSSTTBDOCUMENTO';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ZCSSTTBDOCUMENTO object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.item != null) {
      yield r'item';
      yield serializers.serialize(
        object.item,
        specifiedType: const FullType(BuiltList, [FullType(ZCSTBDOCUMENTO)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ZCSSTTBDOCUMENTO object, {
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
    required ZCSSTTBDOCUMENTOBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'item':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType(BuiltList, [FullType(ZCSTBDOCUMENTO)]),
          ) as BuiltList<ZCSTBDOCUMENTO>;
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
  ZCSSTTBDOCUMENTO deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ZCSSTTBDOCUMENTOBuilder();
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
