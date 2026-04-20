//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:espacio_ciudadano_api/src/model/tfaq.dart';
import 'package:espacio_ciudadano_api/src/model/returns.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'zcsrfcconsultafaq_response.g.dart';

/// ZCSRFCCONSULTAFAQResponse
///
/// Properties:
/// * [isubrc] 
/// * [return_] 
/// * [returns] 
/// * [tfaq] 
@BuiltValue()
abstract class ZCSRFCCONSULTAFAQResponse implements Built<ZCSRFCCONSULTAFAQResponse, ZCSRFCCONSULTAFAQResponseBuilder> {
  @BuiltValueField(wireName: r'isubrc')
  int? get isubrc;

  @BuiltValueField(wireName: r'return')
  String? get return_;

  @BuiltValueField(wireName: r'returns')
  RETURNS get returns;

  @BuiltValueField(wireName: r'tfaq')
  TFAQ get tfaq;

  ZCSRFCCONSULTAFAQResponse._();

  factory ZCSRFCCONSULTAFAQResponse([void updates(ZCSRFCCONSULTAFAQResponseBuilder b)]) = _$ZCSRFCCONSULTAFAQResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ZCSRFCCONSULTAFAQResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ZCSRFCCONSULTAFAQResponse> get serializer => _$ZCSRFCCONSULTAFAQResponseSerializer();
}

class _$ZCSRFCCONSULTAFAQResponseSerializer implements PrimitiveSerializer<ZCSRFCCONSULTAFAQResponse> {
  @override
  final Iterable<Type> types = const [ZCSRFCCONSULTAFAQResponse, _$ZCSRFCCONSULTAFAQResponse];

  @override
  final String wireName = r'ZCSRFCCONSULTAFAQResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ZCSRFCCONSULTAFAQResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.isubrc != null) {
      yield r'isubrc';
      yield serializers.serialize(
        object.isubrc,
        specifiedType: const FullType(int),
      );
    }
    if (object.return_ != null) {
      yield r'return';
      yield serializers.serialize(
        object.return_,
        specifiedType: const FullType(String),
      );
    }
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
    ZCSRFCCONSULTAFAQResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ZCSRFCCONSULTAFAQResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'isubrc':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.isubrc = valueDes;
          break;
        case r'return':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.return_ = valueDes;
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
  ZCSRFCCONSULTAFAQResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ZCSRFCCONSULTAFAQResponseBuilder();
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

