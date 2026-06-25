//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'respuesta_fachada_interm.g.dart';

/// RespuestaFachadaInterm
///
/// Properties:
/// * [respuesta]
@BuiltValue()
abstract class RespuestaFachadaInterm
    implements Built<RespuestaFachadaInterm, RespuestaFachadaIntermBuilder> {
  @BuiltValueField(wireName: r'respuesta')
  JsonObject? get respuesta;

  RespuestaFachadaInterm._();

  factory RespuestaFachadaInterm(
          [void updates(RespuestaFachadaIntermBuilder b)]) =
      _$RespuestaFachadaInterm;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RespuestaFachadaIntermBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RespuestaFachadaInterm> get serializer =>
      _$RespuestaFachadaIntermSerializer();
}

class _$RespuestaFachadaIntermSerializer
    implements PrimitiveSerializer<RespuestaFachadaInterm> {
  @override
  final Iterable<Type> types = const [
    RespuestaFachadaInterm,
    _$RespuestaFachadaInterm
  ];

  @override
  final String wireName = r'RespuestaFachadaInterm';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RespuestaFachadaInterm object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.respuesta != null) {
      yield r'respuesta';
      yield serializers.serialize(
        object.respuesta,
        specifiedType: const FullType(JsonObject),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    RespuestaFachadaInterm object, {
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
    required RespuestaFachadaIntermBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'respuesta':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(JsonObject),
          ) as JsonObject;
          result.respuesta = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  RespuestaFachadaInterm deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RespuestaFachadaIntermBuilder();
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
