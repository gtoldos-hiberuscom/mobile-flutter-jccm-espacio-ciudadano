//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:espacio_ciudadano_api/src/model/publicacionportal.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'zcsrfcpubliselectbynumreg_response.g.dart';

/// ZCSRFCPUBLISELECTBYNUMREGResponse
///
/// Properties:
/// * [adjuntar]
/// * [isubrc]
/// * [publicacionportal]
/// * [resultado]
@BuiltValue()
abstract class ZCSRFCPUBLISELECTBYNUMREGResponse
    implements
        Built<ZCSRFCPUBLISELECTBYNUMREGResponse,
            ZCSRFCPUBLISELECTBYNUMREGResponseBuilder> {
  @BuiltValueField(wireName: r'adjuntar')
  String? get adjuntar;

  @BuiltValueField(wireName: r'isubrc')
  int? get isubrc;

  @BuiltValueField(wireName: r'publicacionportal')
  PUBLICACIONPORTAL? get publicacionportal;

  @BuiltValueField(wireName: r'resultado')
  String? get resultado;

  ZCSRFCPUBLISELECTBYNUMREGResponse._();

  factory ZCSRFCPUBLISELECTBYNUMREGResponse(
          [void updates(ZCSRFCPUBLISELECTBYNUMREGResponseBuilder b)]) =
      _$ZCSRFCPUBLISELECTBYNUMREGResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ZCSRFCPUBLISELECTBYNUMREGResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ZCSRFCPUBLISELECTBYNUMREGResponse> get serializer =>
      _$ZCSRFCPUBLISELECTBYNUMREGResponseSerializer();
}

class _$ZCSRFCPUBLISELECTBYNUMREGResponseSerializer
    implements PrimitiveSerializer<ZCSRFCPUBLISELECTBYNUMREGResponse> {
  @override
  final Iterable<Type> types = const [
    ZCSRFCPUBLISELECTBYNUMREGResponse,
    _$ZCSRFCPUBLISELECTBYNUMREGResponse
  ];

  @override
  final String wireName = r'ZCSRFCPUBLISELECTBYNUMREGResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ZCSRFCPUBLISELECTBYNUMREGResponse object, {
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
    ZCSRFCPUBLISELECTBYNUMREGResponse object, {
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
    required ZCSRFCPUBLISELECTBYNUMREGResponseBuilder result,
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
  ZCSRFCPUBLISELECTBYNUMREGResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ZCSRFCPUBLISELECTBYNUMREGResponseBuilder();
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
