//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:espacio_ciudadano_api/src/model/zcsstpubportal.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'zcsrfcpubliselectbynumexp_response.g.dart';

/// ZCSRFCPUBLISELECTBYNUMEXPResponse
///
/// Properties:
/// * [adjuntar] 
/// * [isubrc] 
/// * [publicacionportal] 
/// * [resultado] 
@BuiltValue()
abstract class ZCSRFCPUBLISELECTBYNUMEXPResponse implements Built<ZCSRFCPUBLISELECTBYNUMEXPResponse, ZCSRFCPUBLISELECTBYNUMEXPResponseBuilder> {
  @BuiltValueField(wireName: r'adjuntar')
  String? get adjuntar;

  @BuiltValueField(wireName: r'isubrc')
  int? get isubrc;

  @BuiltValueField(wireName: r'publicacionportal')
  ZCSSTPUBPORTAL? get publicacionportal;

  @BuiltValueField(wireName: r'resultado')
  String? get resultado;

  ZCSRFCPUBLISELECTBYNUMEXPResponse._();

  factory ZCSRFCPUBLISELECTBYNUMEXPResponse([void updates(ZCSRFCPUBLISELECTBYNUMEXPResponseBuilder b)]) = _$ZCSRFCPUBLISELECTBYNUMEXPResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ZCSRFCPUBLISELECTBYNUMEXPResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ZCSRFCPUBLISELECTBYNUMEXPResponse> get serializer => _$ZCSRFCPUBLISELECTBYNUMEXPResponseSerializer();
}

class _$ZCSRFCPUBLISELECTBYNUMEXPResponseSerializer implements PrimitiveSerializer<ZCSRFCPUBLISELECTBYNUMEXPResponse> {
  @override
  final Iterable<Type> types = const [ZCSRFCPUBLISELECTBYNUMEXPResponse, _$ZCSRFCPUBLISELECTBYNUMEXPResponse];

  @override
  final String wireName = r'ZCSRFCPUBLISELECTBYNUMEXPResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ZCSRFCPUBLISELECTBYNUMEXPResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.adjuntar != null) {
      yield r'adjuntar';
      yield serializers.serialize(
        object.adjuntar,
        specifiedType: const FullType(String),
      );
    }
    if (object.isubrc != null) {
      yield r'isubrc';
      yield serializers.serialize(
        object.isubrc,
        specifiedType: const FullType(int),
      );
    }
    if (object.publicacionportal != null) {
      yield r'publicacionportal';
      yield serializers.serialize(
        object.publicacionportal,
        specifiedType: const FullType(ZCSSTPUBPORTAL),
      );
    }
    if (object.resultado != null) {
      yield r'resultado';
      yield serializers.serialize(
        object.resultado,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ZCSRFCPUBLISELECTBYNUMEXPResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ZCSRFCPUBLISELECTBYNUMEXPResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'adjuntar':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.adjuntar = valueDes;
          break;
        case r'isubrc':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.isubrc = valueDes;
          break;
        case r'publicacionportal':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ZCSSTPUBPORTAL),
          ) as ZCSSTPUBPORTAL;
          result.publicacionportal.replace(valueDes);
          break;
        case r'resultado':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.resultado = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ZCSRFCPUBLISELECTBYNUMEXPResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ZCSRFCPUBLISELECTBYNUMEXPResponseBuilder();
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

