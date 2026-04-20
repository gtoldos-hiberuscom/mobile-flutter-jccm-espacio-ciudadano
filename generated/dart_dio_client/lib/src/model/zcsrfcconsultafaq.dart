//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:espacio_ciudadano_api/src/model/tfaq.dart';
import 'package:espacio_ciudadano_api/src/model/zcssportal.dart';
import 'package:espacio_ciudadano_api/src/model/returns.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'zcsrfcconsultafaq.g.dart';

/// ZCSRFCCONSULTAFAQ
///
/// Properties:
/// * [idatos] 
/// * [returns] 
/// * [tfaq] 
@BuiltValue()
abstract class ZCSRFCCONSULTAFAQ implements Built<ZCSRFCCONSULTAFAQ, ZCSRFCCONSULTAFAQBuilder> {
  @BuiltValueField(wireName: r'idatos')
  ZCSSPORTAL get idatos;

  @BuiltValueField(wireName: r'returns')
  RETURNS get returns;

  @BuiltValueField(wireName: r'tfaq')
  TFAQ get tfaq;

  ZCSRFCCONSULTAFAQ._();

  factory ZCSRFCCONSULTAFAQ([void updates(ZCSRFCCONSULTAFAQBuilder b)]) = _$ZCSRFCCONSULTAFAQ;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ZCSRFCCONSULTAFAQBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ZCSRFCCONSULTAFAQ> get serializer => _$ZCSRFCCONSULTAFAQSerializer();
}

class _$ZCSRFCCONSULTAFAQSerializer implements PrimitiveSerializer<ZCSRFCCONSULTAFAQ> {
  @override
  final Iterable<Type> types = const [ZCSRFCCONSULTAFAQ, _$ZCSRFCCONSULTAFAQ];

  @override
  final String wireName = r'ZCSRFCCONSULTAFAQ';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ZCSRFCCONSULTAFAQ object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'idatos';
    yield serializers.serialize(
      object.idatos,
      specifiedType: const FullType(ZCSSPORTAL),
    );
    yield r'returns';
    yield serializers.serialize(
      object.returns,
      specifiedType: const FullType(RETURNS),
    );
    yield r'tfaq';
    yield serializers.serialize(
      object.tfaq,
      specifiedType: const FullType(TFAQ),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ZCSRFCCONSULTAFAQ object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ZCSRFCCONSULTAFAQBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'idatos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ZCSSPORTAL),
          ) as ZCSSPORTAL;
          result.idatos.replace(valueDes);
          break;
        case r'returns':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(RETURNS),
          ) as RETURNS;
          result.returns.replace(valueDes);
          break;
        case r'tfaq':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(TFAQ),
          ) as TFAQ;
          result.tfaq.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ZCSRFCCONSULTAFAQ deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ZCSRFCCONSULTAFAQBuilder();
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

