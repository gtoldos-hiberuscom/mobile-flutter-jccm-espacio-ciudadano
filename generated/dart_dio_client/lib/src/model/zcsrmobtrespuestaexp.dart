//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:espacio_ciudadano_api/src/model/ttextosrespuesta.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'zcsrmobtrespuestaexp.g.dart';

/// ZCSRMOBTRESPUESTAEXP
///
/// Properties:
/// * [irefdoc] 
/// * [ttextosrespuesta] 
@BuiltValue()
abstract class ZCSRMOBTRESPUESTAEXP implements Built<ZCSRMOBTRESPUESTAEXP, ZCSRMOBTRESPUESTAEXPBuilder> {
  @BuiltValueField(wireName: r'irefdoc')
  String get irefdoc;

  @BuiltValueField(wireName: r'ttextosrespuesta')
  TTEXTOSRESPUESTA get ttextosrespuesta;

  ZCSRMOBTRESPUESTAEXP._();

  factory ZCSRMOBTRESPUESTAEXP([void updates(ZCSRMOBTRESPUESTAEXPBuilder b)]) = _$ZCSRMOBTRESPUESTAEXP;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ZCSRMOBTRESPUESTAEXPBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ZCSRMOBTRESPUESTAEXP> get serializer => _$ZCSRMOBTRESPUESTAEXPSerializer();
}

class _$ZCSRMOBTRESPUESTAEXPSerializer implements PrimitiveSerializer<ZCSRMOBTRESPUESTAEXP> {
  @override
  final Iterable<Type> types = const [ZCSRMOBTRESPUESTAEXP, _$ZCSRMOBTRESPUESTAEXP];

  @override
  final String wireName = r'ZCSRMOBTRESPUESTAEXP';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ZCSRMOBTRESPUESTAEXP object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'irefdoc';
    yield serializers.serialize(
      object.irefdoc,
      specifiedType: const FullType(String),
    );
    yield r'ttextosrespuesta';
    yield serializers.serialize(
      object.ttextosrespuesta,
      specifiedType: const FullType(TTEXTOSRESPUESTA),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ZCSRMOBTRESPUESTAEXP object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ZCSRMOBTRESPUESTAEXPBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'irefdoc':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.irefdoc = valueDes;
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
  ZCSRMOBTRESPUESTAEXP deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ZCSRMOBTRESPUESTAEXPBuilder();
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

