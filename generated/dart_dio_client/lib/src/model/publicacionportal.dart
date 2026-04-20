//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:espacio_ciudadano_api/src/model/zcsstpubportal.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'publicacionportal.g.dart';

/// PUBLICACIONPORTAL
///
/// Properties:
/// * [item]
@BuiltValue()
abstract class PUBLICACIONPORTAL
    implements Built<PUBLICACIONPORTAL, PUBLICACIONPORTALBuilder> {
  @BuiltValueField(wireName: r'item')
  BuiltList<ZCSSTPUBPORTAL>? get item;

  PUBLICACIONPORTAL._();

  factory PUBLICACIONPORTAL([void updates(PUBLICACIONPORTALBuilder b)]) =
      _$PUBLICACIONPORTAL;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PUBLICACIONPORTALBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PUBLICACIONPORTAL> get serializer =>
      _$PUBLICACIONPORTALSerializer();
}

class _$PUBLICACIONPORTALSerializer
    implements PrimitiveSerializer<PUBLICACIONPORTAL> {
  @override
  final Iterable<Type> types = const [PUBLICACIONPORTAL, _$PUBLICACIONPORTAL];

  @override
  final String wireName = r'PUBLICACIONPORTAL';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PUBLICACIONPORTAL object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.item != null) {
      yield r'item';
      yield serializers.serialize(
        object.item,
        specifiedType: const FullType(BuiltList, [FullType(ZCSSTPUBPORTAL)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    PUBLICACIONPORTAL object, {
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
    required PUBLICACIONPORTALBuilder result,
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
                const FullType(BuiltList, [FullType(ZCSSTPUBPORTAL)]),
          ) as BuiltList<ZCSSTPUBPORTAL>;
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
  PUBLICACIONPORTAL deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PUBLICACIONPORTALBuilder();
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
