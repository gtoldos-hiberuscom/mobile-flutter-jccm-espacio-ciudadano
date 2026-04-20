//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'zcstbtdocfirma.g.dart';

/// ZCSTBTDOCFIRMA
///
/// Properties:
/// * [codtdf] 
/// * [dentdf] 
@BuiltValue()
abstract class ZCSTBTDOCFIRMA implements Built<ZCSTBTDOCFIRMA, ZCSTBTDOCFIRMABuilder> {
  @BuiltValueField(wireName: r'codtdf')
  String? get codtdf;

  @BuiltValueField(wireName: r'dentdf')
  String? get dentdf;

  ZCSTBTDOCFIRMA._();

  factory ZCSTBTDOCFIRMA([void updates(ZCSTBTDOCFIRMABuilder b)]) = _$ZCSTBTDOCFIRMA;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ZCSTBTDOCFIRMABuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ZCSTBTDOCFIRMA> get serializer => _$ZCSTBTDOCFIRMASerializer();
}

class _$ZCSTBTDOCFIRMASerializer implements PrimitiveSerializer<ZCSTBTDOCFIRMA> {
  @override
  final Iterable<Type> types = const [ZCSTBTDOCFIRMA, _$ZCSTBTDOCFIRMA];

  @override
  final String wireName = r'ZCSTBTDOCFIRMA';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ZCSTBTDOCFIRMA object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.codtdf != null) {
      yield r'codtdf';
      yield serializers.serialize(
        object.codtdf,
        specifiedType: const FullType(String),
      );
    }
    if (object.dentdf != null) {
      yield r'dentdf';
      yield serializers.serialize(
        object.dentdf,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ZCSTBTDOCFIRMA object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ZCSTBTDOCFIRMABuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'codtdf':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.codtdf = valueDes;
          break;
        case r'dentdf':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.dentdf = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ZCSTBTDOCFIRMA deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ZCSTBTDOCFIRMABuilder();
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

