//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:espacio_ciudadano_api/src/model/ttextosrespuesta.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'zcsrmobtrespuestaexp_response.g.dart';

/// ZCSRMOBTRESPUESTAEXPResponse
///
/// Properties:
/// * [esubrc]
/// * [return_]
/// * [ttextosrespuesta]
@BuiltValue()
abstract class ZCSRMOBTRESPUESTAEXPResponse
    implements
        Built<ZCSRMOBTRESPUESTAEXPResponse,
            ZCSRMOBTRESPUESTAEXPResponseBuilder> {
  @BuiltValueField(wireName: r'esubrc')
  int? get esubrc;

  @BuiltValueField(wireName: r'return')
  String? get return_;

  @BuiltValueField(wireName: r'ttextosrespuesta')
  TTEXTOSRESPUESTA get ttextosrespuesta;

  ZCSRMOBTRESPUESTAEXPResponse._();

  factory ZCSRMOBTRESPUESTAEXPResponse(
          [void updates(ZCSRMOBTRESPUESTAEXPResponseBuilder b)]) =
      _$ZCSRMOBTRESPUESTAEXPResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ZCSRMOBTRESPUESTAEXPResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ZCSRMOBTRESPUESTAEXPResponse> get serializer =>
      _$ZCSRMOBTRESPUESTAEXPResponseSerializer();
}

class _$ZCSRMOBTRESPUESTAEXPResponseSerializer
    implements PrimitiveSerializer<ZCSRMOBTRESPUESTAEXPResponse> {
  @override
  final Iterable<Type> types = const [
    ZCSRMOBTRESPUESTAEXPResponse,
    _$ZCSRMOBTRESPUESTAEXPResponse
  ];

  @override
  final String wireName = r'ZCSRMOBTRESPUESTAEXPResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ZCSRMOBTRESPUESTAEXPResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.esubrc != null) {
      yield r'esubrc';
      yield serializers.serialize(
        object.esubrc,
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
    yield r'ttextosrespuesta';
    yield serializers.serialize(
      object.ttextosrespuesta,
      specifiedType: const FullType(TTEXTOSRESPUESTA),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ZCSRMOBTRESPUESTAEXPResponse object, {
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
    required ZCSRMOBTRESPUESTAEXPResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'esubrc':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.esubrc = valueDes;
          break;
        case r'return':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.return_ = valueDes;
          break;
        case r'ttextosrespuesta':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(TTEXTOSRESPUESTA),
          ) as TTEXTOSRESPUESTA;
          result.ttextosrespuesta.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ZCSRMOBTRESPUESTAEXPResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ZCSRMOBTRESPUESTAEXPResponseBuilder();
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
