//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'zcsrfcpubliselectbynumreg.g.dart';

/// ZCSRFCPUBLISELECTBYNUMREG
///
/// Properties:
/// * [pnumdoc] 
/// * [pregistro] 
/// * [ptipodoc] 
@BuiltValue()
abstract class ZCSRFCPUBLISELECTBYNUMREG implements Built<ZCSRFCPUBLISELECTBYNUMREG, ZCSRFCPUBLISELECTBYNUMREGBuilder> {
  @BuiltValueField(wireName: r'pnumdoc')
  String get pnumdoc;

  @BuiltValueField(wireName: r'pregistro')
  String get pregistro;

  @BuiltValueField(wireName: r'ptipodoc')
  String get ptipodoc;

  ZCSRFCPUBLISELECTBYNUMREG._();

  factory ZCSRFCPUBLISELECTBYNUMREG([void updates(ZCSRFCPUBLISELECTBYNUMREGBuilder b)]) = _$ZCSRFCPUBLISELECTBYNUMREG;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ZCSRFCPUBLISELECTBYNUMREGBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ZCSRFCPUBLISELECTBYNUMREG> get serializer => _$ZCSRFCPUBLISELECTBYNUMREGSerializer();
}

class _$ZCSRFCPUBLISELECTBYNUMREGSerializer implements PrimitiveSerializer<ZCSRFCPUBLISELECTBYNUMREG> {
  @override
  final Iterable<Type> types = const [ZCSRFCPUBLISELECTBYNUMREG, _$ZCSRFCPUBLISELECTBYNUMREG];

  @override
  final String wireName = r'ZCSRFCPUBLISELECTBYNUMREG';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ZCSRFCPUBLISELECTBYNUMREG object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'pnumdoc';
    yield serializers.serialize(
      object.pnumdoc,
      specifiedType: const FullType(String),
    );
    yield r'pregistro';
    yield serializers.serialize(
      object.pregistro,
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
    ZCSRFCPUBLISELECTBYNUMREG object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ZCSRFCPUBLISELECTBYNUMREGBuilder result,
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
        case r'pregistro':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.pregistro = valueDes;
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
  ZCSRFCPUBLISELECTBYNUMREG deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ZCSRFCPUBLISELECTBYNUMREGBuilder();
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

