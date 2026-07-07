//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'dtselectbynifreq.g.dart';

/// DTSELECTBYNIFREQ
///
/// Properties:
/// * [numerodocumento] 
/// * [tipodoc] 
@BuiltValue()
abstract class DTSELECTBYNIFREQ implements Built<DTSELECTBYNIFREQ, DTSELECTBYNIFREQBuilder> {
  @BuiltValueField(wireName: r'numerodocumento')
  String? get numerodocumento;

  @BuiltValueField(wireName: r'tipodoc')
  String? get tipodoc;

  DTSELECTBYNIFREQ._();

  factory DTSELECTBYNIFREQ([void updates(DTSELECTBYNIFREQBuilder b)]) = _$DTSELECTBYNIFREQ;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DTSELECTBYNIFREQBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DTSELECTBYNIFREQ> get serializer => _$DTSELECTBYNIFREQSerializer();
}

class _$DTSELECTBYNIFREQSerializer implements PrimitiveSerializer<DTSELECTBYNIFREQ> {
  @override
  final Iterable<Type> types = const [DTSELECTBYNIFREQ, _$DTSELECTBYNIFREQ];

  @override
  final String wireName = r'DTSELECTBYNIFREQ';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DTSELECTBYNIFREQ object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.numerodocumento != null) {
      yield r'numerodocumento';
      yield serializers.serialize(
        object.numerodocumento,
        specifiedType: const FullType(String),
      );
    }
    if (object.tipodoc != null) {
      yield r'tipodoc';
      yield serializers.serialize(
        object.tipodoc,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    DTSELECTBYNIFREQ object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DTSELECTBYNIFREQBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'numerodocumento':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.numerodocumento = valueDes;
          break;
        case r'tipodoc':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.tipodoc = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DTSELECTBYNIFREQ deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DTSELECTBYNIFREQBuilder();
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

