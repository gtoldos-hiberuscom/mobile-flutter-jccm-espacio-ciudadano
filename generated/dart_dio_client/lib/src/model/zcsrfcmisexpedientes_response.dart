//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:espacio_ciudadano_api/src/model/expedientes.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'zcsrfcmisexpedientes_response.g.dart';

/// ZCSRFCMISEXPEDIENTESResponse
///
/// Properties:
/// * [error]
/// * [expedientes]
/// * [subrc]
@BuiltValue()
abstract class ZCSRFCMISEXPEDIENTESResponse
    implements
        Built<ZCSRFCMISEXPEDIENTESResponse,
            ZCSRFCMISEXPEDIENTESResponseBuilder> {
  @BuiltValueField(wireName: r'error')
  String? get error;

  @BuiltValueField(wireName: r'expedientes')
  EXPEDIENTES? get expedientes;

  @BuiltValueField(wireName: r'subrc')
  int? get subrc;

  ZCSRFCMISEXPEDIENTESResponse._();

  factory ZCSRFCMISEXPEDIENTESResponse(
          [void updates(ZCSRFCMISEXPEDIENTESResponseBuilder b)]) =
      _$ZCSRFCMISEXPEDIENTESResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ZCSRFCMISEXPEDIENTESResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ZCSRFCMISEXPEDIENTESResponse> get serializer =>
      _$ZCSRFCMISEXPEDIENTESResponseSerializer();
}

class _$ZCSRFCMISEXPEDIENTESResponseSerializer
    implements PrimitiveSerializer<ZCSRFCMISEXPEDIENTESResponse> {
  @override
  final Iterable<Type> types = const [
    ZCSRFCMISEXPEDIENTESResponse,
    _$ZCSRFCMISEXPEDIENTESResponse
  ];

  @override
  final String wireName = r'ZCSRFCMISEXPEDIENTESResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ZCSRFCMISEXPEDIENTESResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.error != null) {
      yield r'error';
      yield serializers.serialize(
        object.error,
        specifiedType: const FullType(String),
      );
    }
    if (object.expedientes != null) {
      yield r'expedientes';
      yield serializers.serialize(
        object.expedientes,
        specifiedType: const FullType(EXPEDIENTES),
      );
    }
    if (object.subrc != null) {
      yield r'subrc';
      yield serializers.serialize(
        object.subrc,
        specifiedType: const FullType(int),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ZCSRFCMISEXPEDIENTESResponse object, {
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
    required ZCSRFCMISEXPEDIENTESResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'error':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.error = valueDes;
          break;
        case r'expedientes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(EXPEDIENTES),
          ) as EXPEDIENTES;
          result.expedientes.replace(valueDes);
          break;
        case r'subrc':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.subrc = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ZCSRFCMISEXPEDIENTESResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ZCSRFCMISEXPEDIENTESResponseBuilder();
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
