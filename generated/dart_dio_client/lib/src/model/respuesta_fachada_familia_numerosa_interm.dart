//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:espacio_ciudadano_api/src/model/response_familia_numerosa_intermediacion.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'respuesta_fachada_familia_numerosa_interm.g.dart';

/// Objeto devuelto en el payload
///
/// Properties:
/// * [respuesta] 
@BuiltValue()
abstract class RespuestaFachadaFamiliaNumerosaInterm implements Built<RespuestaFachadaFamiliaNumerosaInterm, RespuestaFachadaFamiliaNumerosaIntermBuilder> {
  @BuiltValueField(wireName: r'respuesta')
  ResponseFamiliaNumerosaIntermediacion? get respuesta;

  RespuestaFachadaFamiliaNumerosaInterm._();

  factory RespuestaFachadaFamiliaNumerosaInterm([void updates(RespuestaFachadaFamiliaNumerosaIntermBuilder b)]) = _$RespuestaFachadaFamiliaNumerosaInterm;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RespuestaFachadaFamiliaNumerosaIntermBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RespuestaFachadaFamiliaNumerosaInterm> get serializer => _$RespuestaFachadaFamiliaNumerosaIntermSerializer();
}

class _$RespuestaFachadaFamiliaNumerosaIntermSerializer implements PrimitiveSerializer<RespuestaFachadaFamiliaNumerosaInterm> {
  @override
  final Iterable<Type> types = const [RespuestaFachadaFamiliaNumerosaInterm, _$RespuestaFachadaFamiliaNumerosaInterm];

  @override
  final String wireName = r'RespuestaFachadaFamiliaNumerosaInterm';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RespuestaFachadaFamiliaNumerosaInterm object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.respuesta != null) {
      yield r'respuesta';
      yield serializers.serialize(
        object.respuesta,
        specifiedType: const FullType(ResponseFamiliaNumerosaIntermediacion),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    RespuestaFachadaFamiliaNumerosaInterm object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required RespuestaFachadaFamiliaNumerosaIntermBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'respuesta':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ResponseFamiliaNumerosaIntermediacion),
          ) as ResponseFamiliaNumerosaIntermediacion;
          result.respuesta.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  RespuestaFachadaFamiliaNumerosaInterm deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RespuestaFachadaFamiliaNumerosaIntermBuilder();
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

