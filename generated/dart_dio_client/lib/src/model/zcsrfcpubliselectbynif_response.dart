//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:espacio_ciudadano_api/src/model/publicacionportal.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'zcsrfcpubliselectbynif_response.g.dart';

/// ZCSRFCPUBLISELECTBYNIFResponse
///
/// Properties:
/// * [isubrc] 
/// * [publicacionportal] 
/// * [resultado] 
@BuiltValue()
abstract class ZCSRFCPUBLISELECTBYNIFResponse implements Built<ZCSRFCPUBLISELECTBYNIFResponse, ZCSRFCPUBLISELECTBYNIFResponseBuilder> {
  @BuiltValueField(wireName: r'isubrc')
  int? get isubrc;

  @BuiltValueField(wireName: r'publicacionportal')
  PUBLICACIONPORTAL? get publicacionportal;

  @BuiltValueField(wireName: r'resultado')
  String? get resultado;

  ZCSRFCPUBLISELECTBYNIFResponse._();

  factory ZCSRFCPUBLISELECTBYNIFResponse([void updates(ZCSRFCPUBLISELECTBYNIFResponseBuilder b)]) = _$ZCSRFCPUBLISELECTBYNIFResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ZCSRFCPUBLISELECTBYNIFResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ZCSRFCPUBLISELECTBYNIFResponse> get serializer => _$ZCSRFCPUBLISELECTBYNIFResponseSerializer();
}

class _$ZCSRFCPUBLISELECTBYNIFResponseSerializer implements PrimitiveSerializer<ZCSRFCPUBLISELECTBYNIFResponse> {
  @override
  final Iterable<Type> types = const [ZCSRFCPUBLISELECTBYNIFResponse, _$ZCSRFCPUBLISELECTBYNIFResponse];

  @override
  final String wireName = r'ZCSRFCPUBLISELECTBYNIFResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ZCSRFCPUBLISELECTBYNIFResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
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
        specifiedType: const FullType(PUBLICACIONPORTAL),
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
    ZCSRFCPUBLISELECTBYNIFResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ZCSRFCPUBLISELECTBYNIFResponseBuilder result,
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
        case r'publicacionportal':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PUBLICACIONPORTAL),
          ) as PUBLICACIONPORTAL;
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
  ZCSRFCPUBLISELECTBYNIFResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ZCSRFCPUBLISELECTBYNIFResponseBuilder();
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

