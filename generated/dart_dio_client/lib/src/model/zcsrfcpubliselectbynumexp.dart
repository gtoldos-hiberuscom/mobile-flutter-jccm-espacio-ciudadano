//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'zcsrfcpubliselectbynumexp.g.dart';

/// ZCSRFCPUBLISELECTBYNUMEXP
///
/// Properties:
/// * [pnumdoc]
/// * [pnumexp]
/// * [ptipodoc]
@BuiltValue()
abstract class ZCSRFCPUBLISELECTBYNUMEXP
    implements
        Built<ZCSRFCPUBLISELECTBYNUMEXP, ZCSRFCPUBLISELECTBYNUMEXPBuilder> {
  @BuiltValueField(wireName: r'pnumdoc')
  String get pnumdoc;

  @BuiltValueField(wireName: r'pnumexp')
  String get pnumexp;

  @BuiltValueField(wireName: r'ptipodoc')
  String get ptipodoc;

  ZCSRFCPUBLISELECTBYNUMEXP._();

  factory ZCSRFCPUBLISELECTBYNUMEXP(
          [void updates(ZCSRFCPUBLISELECTBYNUMEXPBuilder b)]) =
      _$ZCSRFCPUBLISELECTBYNUMEXP;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ZCSRFCPUBLISELECTBYNUMEXPBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ZCSRFCPUBLISELECTBYNUMEXP> get serializer =>
      _$ZCSRFCPUBLISELECTBYNUMEXPSerializer();
}

class _$ZCSRFCPUBLISELECTBYNUMEXPSerializer
    implements PrimitiveSerializer<ZCSRFCPUBLISELECTBYNUMEXP> {
  @override
  final Iterable<Type> types = const [
    ZCSRFCPUBLISELECTBYNUMEXP,
    _$ZCSRFCPUBLISELECTBYNUMEXP
  ];

  @override
  final String wireName = r'ZCSRFCPUBLISELECTBYNUMEXP';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ZCSRFCPUBLISELECTBYNUMEXP object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'pnumdoc';
    yield serializers.serialize(
      object.pnumdoc,
      specifiedType: const FullType(String),
    );
    yield r'pnumexp';
    yield serializers.serialize(
      object.pnumexp,
      specifiedType: const FullType(String),
    );
    yield r'ptipodoc';
    yield serializers.serialize(
      object.ptipodoc,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ZCSRFCPUBLISELECTBYNUMEXP object, {
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
    required ZCSRFCPUBLISELECTBYNUMEXPBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'pnumdoc':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.pnumdoc = valueDes;
          break;
        case r'pnumexp':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.pnumexp = valueDes;
          break;
        case r'ptipodoc':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.ptipodoc = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ZCSRFCPUBLISELECTBYNUMEXP deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ZCSRFCPUBLISELECTBYNUMEXPBuilder();
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
