//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'dt_identificacion.g.dart';

/// DTIdentificacion
///
/// Properties:
/// * [category]
/// * [nifcif]
@BuiltValue()
abstract class DTIdentificacion
    implements Built<DTIdentificacion, DTIdentificacionBuilder> {
  @BuiltValueField(wireName: r'category')
  String get category;

  @BuiltValueField(wireName: r'nifcif')
  String get nifcif;

  DTIdentificacion._();

  factory DTIdentificacion([void updates(DTIdentificacionBuilder b)]) =
      _$DTIdentificacion;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DTIdentificacionBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DTIdentificacion> get serializer =>
      _$DTIdentificacionSerializer();
}

class _$DTIdentificacionSerializer
    implements PrimitiveSerializer<DTIdentificacion> {
  @override
  final Iterable<Type> types = const [DTIdentificacion, _$DTIdentificacion];

  @override
  final String wireName = r'DTIdentificacion';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DTIdentificacion object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'category';
    yield serializers.serialize(
      object.category,
      specifiedType: const FullType(String),
    );
    yield r'nifcif';
    yield serializers.serialize(
      object.nifcif,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DTIdentificacion object, {
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
    required DTIdentificacionBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'category':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.category = valueDes;
          break;
        case r'nifcif':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.nifcif = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DTIdentificacion deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DTIdentificacionBuilder();
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
