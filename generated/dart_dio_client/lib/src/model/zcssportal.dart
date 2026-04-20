//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'zcssportal.g.dart';

/// ZCSSPORTAL
///
/// Properties:
/// * [ejeexp] 
/// * [numexp] 
/// * [subfam] 
@BuiltValue()
abstract class ZCSSPORTAL implements Built<ZCSSPORTAL, ZCSSPORTALBuilder> {
  @BuiltValueField(wireName: r'ejeexp')
  String? get ejeexp;

  @BuiltValueField(wireName: r'numexp')
  String? get numexp;

  @BuiltValueField(wireName: r'subfam')
  String? get subfam;

  ZCSSPORTAL._();

  factory ZCSSPORTAL([void updates(ZCSSPORTALBuilder b)]) = _$ZCSSPORTAL;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ZCSSPORTALBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ZCSSPORTAL> get serializer => _$ZCSSPORTALSerializer();
}

class _$ZCSSPORTALSerializer implements PrimitiveSerializer<ZCSSPORTAL> {
  @override
  final Iterable<Type> types = const [ZCSSPORTAL, _$ZCSSPORTAL];

  @override
  final String wireName = r'ZCSSPORTAL';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ZCSSPORTAL object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.ejeexp != null) {
      yield r'ejeexp';
      yield serializers.serialize(
        object.ejeexp,
        specifiedType: const FullType(String),
      );
    }
    if (object.numexp != null) {
      yield r'numexp';
      yield serializers.serialize(
        object.numexp,
        specifiedType: const FullType(String),
      );
    }
    if (object.subfam != null) {
      yield r'subfam';
      yield serializers.serialize(
        object.subfam,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ZCSSPORTAL object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ZCSSPORTALBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'ejeexp':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.ejeexp = valueDes;
          break;
        case r'numexp':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.numexp = valueDes;
          break;
        case r'subfam':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.subfam = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ZCSSPORTAL deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ZCSSPORTALBuilder();
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

