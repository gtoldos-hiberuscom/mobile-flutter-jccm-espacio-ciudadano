//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'dtquery.g.dart';

/// DTQUERY
///
/// Properties:
/// * [query] 
@BuiltValue()
abstract class DTQUERY implements Built<DTQUERY, DTQUERYBuilder> {
  @BuiltValueField(wireName: r'query')
  String get query;

  DTQUERY._();

  factory DTQUERY([void updates(DTQUERYBuilder b)]) = _$DTQUERY;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DTQUERYBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DTQUERY> get serializer => _$DTQUERYSerializer();
}

class _$DTQUERYSerializer implements PrimitiveSerializer<DTQUERY> {
  @override
  final Iterable<Type> types = const [DTQUERY, _$DTQUERY];

  @override
  final String wireName = r'DTQUERY';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DTQUERY object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'query';
    yield serializers.serialize(
      object.query,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DTQUERY object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DTQUERYBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'query':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.query = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DTQUERY deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DTQUERYBuilder();
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

