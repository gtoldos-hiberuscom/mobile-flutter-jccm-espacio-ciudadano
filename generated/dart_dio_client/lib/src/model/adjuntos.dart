//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'adjuntos.g.dart';

/// ADJUNTOS
///
/// Properties:
/// * [adjunto] 
@BuiltValue()
abstract class ADJUNTOS implements Built<ADJUNTOS, ADJUNTOSBuilder> {
  @BuiltValueField(wireName: r'adjunto')
  BuiltList<String> get adjunto;

  ADJUNTOS._();

  factory ADJUNTOS([void updates(ADJUNTOSBuilder b)]) = _$ADJUNTOS;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ADJUNTOSBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ADJUNTOS> get serializer => _$ADJUNTOSSerializer();
}

class _$ADJUNTOSSerializer implements PrimitiveSerializer<ADJUNTOS> {
  @override
  final Iterable<Type> types = const [ADJUNTOS, _$ADJUNTOS];

  @override
  final String wireName = r'ADJUNTOS';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ADJUNTOS object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'adjunto';
    yield serializers.serialize(
      object.adjunto,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ADJUNTOS object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ADJUNTOSBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'adjunto':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.adjunto.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ADJUNTOS deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ADJUNTOSBuilder();
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

