//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:espacio_ciudadano_api/src/model/zcsstfaq.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'ttextosrespuesta.g.dart';

/// TTEXTOSRESPUESTA
///
/// Properties:
/// * [item]
@BuiltValue()
abstract class TTEXTOSRESPUESTA
    implements Built<TTEXTOSRESPUESTA, TTEXTOSRESPUESTABuilder> {
  @BuiltValueField(wireName: r'item')
  BuiltList<ZCSSTFAQ>? get item;

  TTEXTOSRESPUESTA._();

  factory TTEXTOSRESPUESTA([void updates(TTEXTOSRESPUESTABuilder b)]) =
      _$TTEXTOSRESPUESTA;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TTEXTOSRESPUESTABuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TTEXTOSRESPUESTA> get serializer =>
      _$TTEXTOSRESPUESTASerializer();
}

class _$TTEXTOSRESPUESTASerializer
    implements PrimitiveSerializer<TTEXTOSRESPUESTA> {
  @override
  final Iterable<Type> types = const [TTEXTOSRESPUESTA, _$TTEXTOSRESPUESTA];

  @override
  final String wireName = r'TTEXTOSRESPUESTA';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TTEXTOSRESPUESTA object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.item != null) {
      yield r'item';
      yield serializers.serialize(
        object.item,
        specifiedType: const FullType(BuiltList, [FullType(ZCSSTFAQ)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    TTEXTOSRESPUESTA object, {
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
    required TTEXTOSRESPUESTABuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'item':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ZCSSTFAQ)]),
          ) as BuiltList<ZCSSTFAQ>;
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
  TTEXTOSRESPUESTA deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TTEXTOSRESPUESTABuilder();
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
