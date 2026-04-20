//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'dt_identificacion_rep.g.dart';

/// DTIdentificacionRep
///
/// Properties:
/// * [categoryrep]
/// * [nifcifrep]
@BuiltValue()
abstract class DTIdentificacionRep
    implements Built<DTIdentificacionRep, DTIdentificacionRepBuilder> {
  @BuiltValueField(wireName: r'categoryrep')
  String get categoryrep;

  @BuiltValueField(wireName: r'nifcifrep')
  String get nifcifrep;

  DTIdentificacionRep._();

  factory DTIdentificacionRep([void updates(DTIdentificacionRepBuilder b)]) =
      _$DTIdentificacionRep;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DTIdentificacionRepBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DTIdentificacionRep> get serializer =>
      _$DTIdentificacionRepSerializer();
}

class _$DTIdentificacionRepSerializer
    implements PrimitiveSerializer<DTIdentificacionRep> {
  @override
  final Iterable<Type> types = const [
    DTIdentificacionRep,
    _$DTIdentificacionRep
  ];

  @override
  final String wireName = r'DTIdentificacionRep';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DTIdentificacionRep object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'categoryrep';
    yield serializers.serialize(
      object.categoryrep,
      specifiedType: const FullType(String),
    );
    yield r'nifcifrep';
    yield serializers.serialize(
      object.nifcifrep,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DTIdentificacionRep object, {
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
    required DTIdentificacionRepBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'categoryrep':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.categoryrep = valueDes;
          break;
        case r'nifcifrep':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.nifcifrep = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DTIdentificacionRep deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DTIdentificacionRepBuilder();
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
