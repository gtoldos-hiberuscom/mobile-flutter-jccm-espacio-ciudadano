//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'xml_registro.g.dart';

/// XMLRegistro
///
/// Properties:
/// * [xmlClave]
@BuiltValue()
abstract class XMLRegistro implements Built<XMLRegistro, XMLRegistroBuilder> {
  @BuiltValueField(wireName: r'xmlClave')
  String? get xmlClave;

  XMLRegistro._();

  factory XMLRegistro([void updates(XMLRegistroBuilder b)]) = _$XMLRegistro;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(XMLRegistroBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<XMLRegistro> get serializer => _$XMLRegistroSerializer();
}

class _$XMLRegistroSerializer implements PrimitiveSerializer<XMLRegistro> {
  @override
  final Iterable<Type> types = const [XMLRegistro, _$XMLRegistro];

  @override
  final String wireName = r'XMLRegistro';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    XMLRegistro object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.xmlClave != null) {
      yield r'xmlClave';
      yield serializers.serialize(
        object.xmlClave,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    XMLRegistro object, {
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
    required XMLRegistroBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'xmlClave':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.xmlClave = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  XMLRegistro deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = XMLRegistroBuilder();
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
