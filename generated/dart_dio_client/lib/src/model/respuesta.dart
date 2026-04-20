//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:espacio_ciudadano_api/src/model/info_error.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'respuesta.g.dart';

/// Respuesta de la operación
///
/// Properties:
/// * [body] - Objeto devuelto en el payload
/// * [codigoRespuesta] - Código asociado a la respuesta obtenida
/// * [infoError] 
/// * [mensajeRespuesta] - Mensaje informativo de la respuesta obtenida
/// * [timestamp] - Momento en que se registró la respuesta
@BuiltValue()
abstract class Respuesta implements Built<Respuesta, RespuestaBuilder> {
  /// Objeto devuelto en el payload
  @BuiltValueField(wireName: r'body')
  JsonObject? get body;

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

  Respuesta._();

  factory Respuesta([void updates(RespuestaBuilder b)]) = _$Respuesta;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RespuestaBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<Respuesta> get serializer => _$RespuestaSerializer();
}

class _$RespuestaSerializer implements PrimitiveSerializer<Respuesta> {
  @override
  final Iterable<Type> types = const [Respuesta, _$Respuesta];

  @override
  final String wireName = r'Respuesta';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    Respuesta object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.body != null) {
      yield r'body';
      yield serializers.serialize(
        object.body,
        specifiedType: const FullType(JsonObject),
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
    Respuesta object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required RespuestaBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'body':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(JsonObject),
          ) as JsonObject;
          result.body = valueDes;
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
  Respuesta deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RespuestaBuilder();
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

