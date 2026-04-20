//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:espacio_ciudadano_api/src/model/zcstbtdocfirma.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'zlistadoc.g.dart';

/// ZLISTADOC
///
/// Properties:
/// * [item] 
@BuiltValue()
abstract class ZLISTADOC implements Built<ZLISTADOC, ZLISTADOCBuilder> {
  @BuiltValueField(wireName: r'item')
  BuiltList<ZCSTBTDOCFIRMA>? get item;

  ZLISTADOC._();

  factory ZLISTADOC([void updates(ZLISTADOCBuilder b)]) = _$ZLISTADOC;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ZLISTADOCBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ZLISTADOC> get serializer => _$ZLISTADOCSerializer();
}

class _$ZLISTADOCSerializer implements PrimitiveSerializer<ZLISTADOC> {
  @override
  final Iterable<Type> types = const [ZLISTADOC, _$ZLISTADOC];

  @override
  final String wireName = r'ZLISTADOC';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ZLISTADOC object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.item != null) {
      yield r'item';
      yield serializers.serialize(
        object.item,
        specifiedType: const FullType(BuiltList, [FullType(ZCSTBTDOCFIRMA)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ZLISTADOC object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ZLISTADOCBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'item':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ZCSTBTDOCFIRMA)]),
          ) as BuiltList<ZCSTBTDOCFIRMA>;
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
  ZLISTADOC deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ZLISTADOCBuilder();
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

