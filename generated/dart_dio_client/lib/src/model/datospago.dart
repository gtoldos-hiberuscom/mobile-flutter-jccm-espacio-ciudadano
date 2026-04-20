//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'datospago.g.dart';

/// DATOSPAGO
///
/// Properties:
/// * [imprec]
/// * [refdocrecur]
@BuiltValue()
abstract class DATOSPAGO implements Built<DATOSPAGO, DATOSPAGOBuilder> {
  @BuiltValueField(wireName: r'imprec')
  String get imprec;

  @BuiltValueField(wireName: r'refdocrecur')
  String get refdocrecur;

  DATOSPAGO._();

  factory DATOSPAGO([void updates(DATOSPAGOBuilder b)]) = _$DATOSPAGO;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DATOSPAGOBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DATOSPAGO> get serializer => _$DATOSPAGOSerializer();
}

class _$DATOSPAGOSerializer implements PrimitiveSerializer<DATOSPAGO> {
  @override
  final Iterable<Type> types = const [DATOSPAGO, _$DATOSPAGO];

  @override
  final String wireName = r'DATOSPAGO';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DATOSPAGO object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'imprec';
    yield serializers.serialize(
      object.imprec,
      specifiedType: const FullType(String),
    );
    yield r'refdocrecur';
    yield serializers.serialize(
      object.refdocrecur,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DATOSPAGO object, {
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
    required DATOSPAGOBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'imprec':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.imprec = valueDes;
          break;
        case r'refdocrecur':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.refdocrecur = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DATOSPAGO deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DATOSPAGOBuilder();
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
