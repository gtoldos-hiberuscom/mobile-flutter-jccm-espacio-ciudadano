//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:espacio_ciudadano_api/src/model/api_error.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'info_error.g.dart';

/// Información de error asociada a la respuesta
///
/// Properties:
/// * [errores] - Listado de errores reportados por la operación
/// * [idError] - Identificador único del error ocurrido
@BuiltValue()
abstract class InfoError implements Built<InfoError, InfoErrorBuilder> {
  /// Listado de errores reportados por la operación
  @BuiltValueField(wireName: r'errores')
  BuiltList<ApiError>? get errores;

  /// Identificador único del error ocurrido
  @BuiltValueField(wireName: r'id-error')
  String? get idError;

  InfoError._();

  factory InfoError([void updates(InfoErrorBuilder b)]) = _$InfoError;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(InfoErrorBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<InfoError> get serializer => _$InfoErrorSerializer();
}

class _$InfoErrorSerializer implements PrimitiveSerializer<InfoError> {
  @override
  final Iterable<Type> types = const [InfoError, _$InfoError];

  @override
  final String wireName = r'InfoError';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    InfoError object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.errores != null) {
      yield r'errores';
      yield serializers.serialize(
        object.errores,
        specifiedType: const FullType(BuiltList, [FullType(ApiError)]),
      );
    }
    if (object.idError != null) {
      yield r'id-error';
      yield serializers.serialize(
        object.idError,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    InfoError object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required InfoErrorBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'errores':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ApiError)]),
          ) as BuiltList<ApiError>;
          result.errores.replace(valueDes);
          break;
        case r'id-error':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.idError = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  InfoError deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = InfoErrorBuilder();
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

