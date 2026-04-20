//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:espacio_ciudadano_api/src/model/info_error.dart';
import 'package:espacio_ciudadano_api/src/model/respuesta_fachada_familia_numerosa_interm.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'respuesta_respuesta_fachada_familia_numerosa_interm.g.dart';

/// Respuesta de la operación
///
/// Properties:
/// * [body] 
/// * [codigoRespuesta] - Código asociado a la respuesta obtenida
/// * [infoError] 
/// * [mensajeRespuesta] - Mensaje informativo de la respuesta obtenida
/// * [timestamp] - Momento en que se registró la respuesta
@BuiltValue()
abstract class RespuestaRespuestaFachadaFamiliaNumerosaInterm implements Built<RespuestaRespuestaFachadaFamiliaNumerosaInterm, RespuestaRespuestaFachadaFamiliaNumerosaIntermBuilder> {
  @BuiltValueField(wireName: r'body')
  RespuestaFachadaFamiliaNumerosaInterm? get body;

  /// Código asociado a la respuesta obtenida
  @BuiltValueField(wireName: r'codigo-respuesta')
  String? get codigoRespuesta;

  @BuiltValueField(wireName: r'info-error')
  InfoError? get infoError;

  /// Mensaje informativo de la respuesta obtenida
  @BuiltValueField(wireName: r'mensaje-respuesta')
  String? get mensajeRespuesta;

  /// Momento en que se registró la respuesta
  @BuiltValueField(wireName: r'timestamp')
  DateTime? get timestamp;

  RespuestaRespuestaFachadaFamiliaNumerosaInterm._();

  factory RespuestaRespuestaFachadaFamiliaNumerosaInterm([void updates(RespuestaRespuestaFachadaFamiliaNumerosaIntermBuilder b)]) = _$RespuestaRespuestaFachadaFamiliaNumerosaInterm;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RespuestaRespuestaFachadaFamiliaNumerosaIntermBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RespuestaRespuestaFachadaFamiliaNumerosaInterm> get serializer => _$RespuestaRespuestaFachadaFamiliaNumerosaIntermSerializer();
}

class _$RespuestaRespuestaFachadaFamiliaNumerosaIntermSerializer implements PrimitiveSerializer<RespuestaRespuestaFachadaFamiliaNumerosaInterm> {
  @override
  final Iterable<Type> types = const [RespuestaRespuestaFachadaFamiliaNumerosaInterm, _$RespuestaRespuestaFachadaFamiliaNumerosaInterm];

  @override
  final String wireName = r'RespuestaRespuestaFachadaFamiliaNumerosaInterm';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RespuestaRespuestaFachadaFamiliaNumerosaInterm object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.body != null) {
      yield r'body';
      yield serializers.serialize(
        object.body,
        specifiedType: const FullType(RespuestaFachadaFamiliaNumerosaInterm),
      );
    }
    if (object.codigoRespuesta != null) {
      yield r'codigo-respuesta';
      yield serializers.serialize(
        object.codigoRespuesta,
        specifiedType: const FullType(String),
      );
    }
    if (object.infoError != null) {
      yield r'info-error';
      yield serializers.serialize(
        object.infoError,
        specifiedType: const FullType(InfoError),
      );
    }
    if (object.mensajeRespuesta != null) {
      yield r'mensaje-respuesta';
      yield serializers.serialize(
        object.mensajeRespuesta,
        specifiedType: const FullType(String),
      );
    }
    if (object.timestamp != null) {
      yield r'timestamp';
      yield serializers.serialize(
        object.timestamp,
        specifiedType: const FullType(DateTime),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    RespuestaRespuestaFachadaFamiliaNumerosaInterm object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required RespuestaRespuestaFachadaFamiliaNumerosaIntermBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'body':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(RespuestaFachadaFamiliaNumerosaInterm),
          ) as RespuestaFachadaFamiliaNumerosaInterm;
          result.body.replace(valueDes);
          break;
        case r'codigo-respuesta':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.codigoRespuesta = valueDes;
          break;
        case r'info-error':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(InfoError),
          ) as InfoError;
          result.infoError.replace(valueDes);
          break;
        case r'mensaje-respuesta':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.mensajeRespuesta = valueDes;
          break;
        case r'timestamp':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.timestamp = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  RespuestaRespuestaFachadaFamiliaNumerosaInterm deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RespuestaRespuestaFachadaFamiliaNumerosaIntermBuilder();
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

