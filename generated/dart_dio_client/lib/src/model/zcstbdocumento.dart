//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'zcstbdocumento.g.dart';

/// ZCSTBDOCUMENTO
///
/// Properties:
/// * [ejeexp]
/// * [iddoc]
/// * [numexp]
/// * [tipoproc]
@BuiltValue()
abstract class ZCSTBDOCUMENTO
    implements Built<ZCSTBDOCUMENTO, ZCSTBDOCUMENTOBuilder> {
  @BuiltValueField(wireName: r'ejeexp')
  String? get ejeexp;

  @BuiltValueField(wireName: r'iddoc')
  String? get iddoc;

  @BuiltValueField(wireName: r'numexp')
  String? get numexp;

  @BuiltValueField(wireName: r'tipoproc')
  String? get tipoproc;

  ZCSTBDOCUMENTO._();

  factory ZCSTBDOCUMENTO([void updates(ZCSTBDOCUMENTOBuilder b)]) =
      _$ZCSTBDOCUMENTO;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ZCSTBDOCUMENTOBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ZCSTBDOCUMENTO> get serializer =>
      _$ZCSTBDOCUMENTOSerializer();
}

class _$ZCSTBDOCUMENTOSerializer
    implements PrimitiveSerializer<ZCSTBDOCUMENTO> {
  @override
  final Iterable<Type> types = const [ZCSTBDOCUMENTO, _$ZCSTBDOCUMENTO];

  @override
  final String wireName = r'ZCSTBDOCUMENTO';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ZCSTBDOCUMENTO object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.ejeexp != null) {
      yield r'ejeexp';
      yield serializers.serialize(
        object.ejeexp,
        specifiedType: const FullType(String),
      );
    }
    if (object.iddoc != null) {
      yield r'iddoc';
      yield serializers.serialize(
        object.iddoc,
        specifiedType: const FullType(String),
      );
    }
    if (object.numexp != null) {
      yield r'numexp';
      yield serializers.serialize(
        object.numexp,
        specifiedType: const FullType(String),
      );
    }
    if (object.tipoproc != null) {
      yield r'tipoproc';
      yield serializers.serialize(
        object.tipoproc,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ZCSTBDOCUMENTO object, {
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
    required ZCSTBDOCUMENTOBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'ejeexp':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.ejeexp = valueDes;
          break;
        case r'iddoc':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.iddoc = valueDes;
          break;
        case r'numexp':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.numexp = valueDes;
          break;
        case r'tipoproc':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.tipoproc = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ZCSTBDOCUMENTO deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ZCSTBDOCUMENTOBuilder();
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
