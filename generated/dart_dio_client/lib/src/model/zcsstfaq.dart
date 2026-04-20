//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'zcsstfaq.g.dart';

/// ZCSSTFAQ
///
/// Properties:
/// * [numseq] 
/// * [textarea] 
/// * [textlinea] 
@BuiltValue()
abstract class ZCSSTFAQ implements Built<ZCSSTFAQ, ZCSSTFAQBuilder> {
  @BuiltValueField(wireName: r'numseq')
  String? get numseq;

  @BuiltValueField(wireName: r'textarea')
  String? get textarea;

  @BuiltValueField(wireName: r'textlinea')
  String? get textlinea;

  ZCSSTFAQ._();

  factory ZCSSTFAQ([void updates(ZCSSTFAQBuilder b)]) = _$ZCSSTFAQ;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ZCSSTFAQBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ZCSSTFAQ> get serializer => _$ZCSSTFAQSerializer();
}

class _$ZCSSTFAQSerializer implements PrimitiveSerializer<ZCSSTFAQ> {
  @override
  final Iterable<Type> types = const [ZCSSTFAQ, _$ZCSSTFAQ];

  @override
  final String wireName = r'ZCSSTFAQ';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ZCSSTFAQ object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.numseq != null) {
      yield r'numseq';
      yield serializers.serialize(
        object.numseq,
        specifiedType: const FullType(String),
      );
    }
    if (object.textarea != null) {
      yield r'textarea';
      yield serializers.serialize(
        object.textarea,
        specifiedType: const FullType(String),
      );
    }
    if (object.textlinea != null) {
      yield r'textlinea';
      yield serializers.serialize(
        object.textlinea,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ZCSSTFAQ object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ZCSSTFAQBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'numseq':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.numseq = valueDes;
          break;
        case r'textarea':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.textarea = valueDes;
          break;
        case r'textlinea':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.textlinea = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ZCSSTFAQ deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ZCSSTFAQBuilder();
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

