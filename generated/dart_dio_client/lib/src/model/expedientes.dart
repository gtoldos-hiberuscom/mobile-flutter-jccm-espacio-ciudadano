//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:espacio_ciudadano_api/src/model/zcsauxstexpedientes.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'expedientes.g.dart';

/// EXPEDIENTES
///
/// Properties:
/// * [item]
@BuiltValue()
abstract class EXPEDIENTES implements Built<EXPEDIENTES, EXPEDIENTESBuilder> {
  @BuiltValueField(wireName: r'item')
  BuiltList<ZCSAUXSTEXPEDIENTES>? get item;

  EXPEDIENTES._();

  factory EXPEDIENTES([void updates(EXPEDIENTESBuilder b)]) = _$EXPEDIENTES;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(EXPEDIENTESBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<EXPEDIENTES> get serializer => _$EXPEDIENTESSerializer();
}

class _$EXPEDIENTESSerializer implements PrimitiveSerializer<EXPEDIENTES> {
  @override
  final Iterable<Type> types = const [EXPEDIENTES, _$EXPEDIENTES];

  @override
  final String wireName = r'EXPEDIENTES';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    EXPEDIENTES object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.item != null) {
      yield r'item';
      yield serializers.serialize(
        object.item,
        specifiedType:
            const FullType(BuiltList, [FullType(ZCSAUXSTEXPEDIENTES)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    EXPEDIENTES object, {
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
    required EXPEDIENTESBuilder result,
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
                const FullType(BuiltList, [FullType(ZCSAUXSTEXPEDIENTES)]),
          ) as BuiltList<ZCSAUXSTEXPEDIENTES>;
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
  EXPEDIENTES deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = EXPEDIENTESBuilder();
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
