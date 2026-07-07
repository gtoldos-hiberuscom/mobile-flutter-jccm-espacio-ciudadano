//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'registro.g.dart';

/// REGISTRO
///
/// Properties:
/// * [fecha] 
/// * [noregistro] 
@BuiltValue()
abstract class REGISTRO implements Built<REGISTRO, REGISTROBuilder> {
  @BuiltValueField(wireName: r'fecha')
  String get fecha;

  @BuiltValueField(wireName: r'noregistro')
  String get noregistro;

  REGISTRO._();

  factory REGISTRO([void updates(REGISTROBuilder b)]) = _$REGISTRO;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(REGISTROBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<REGISTRO> get serializer => _$REGISTROSerializer();
}

class _$REGISTROSerializer implements PrimitiveSerializer<REGISTRO> {
  @override
  final Iterable<Type> types = const [REGISTRO, _$REGISTRO];

  @override
  final String wireName = r'REGISTRO';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    REGISTRO object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'fecha';
    yield serializers.serialize(
      object.fecha,
      specifiedType: const FullType(String),
    );
    yield r'noregistro';
    yield serializers.serialize(
      object.noregistro,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    REGISTRO object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required REGISTROBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'fecha':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.fecha = valueDes;
          break;
        case r'noregistro':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.noregistro = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  REGISTRO deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = REGISTROBuilder();
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

