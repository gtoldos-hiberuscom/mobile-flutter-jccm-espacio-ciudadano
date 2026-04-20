//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'dtselectbynifv2_req.g.dart';

/// DTSELECTBYNIFV2REQ
///
/// Properties:
/// * [numerodocumento]
/// * [tipodocumento]
/// * [tipoprocedimiento]
@BuiltValue()
abstract class DTSELECTBYNIFV2REQ
    implements Built<DTSELECTBYNIFV2REQ, DTSELECTBYNIFV2REQBuilder> {
  @BuiltValueField(wireName: r'numerodocumento')
  String? get numerodocumento;

  @BuiltValueField(wireName: r'tipodocumento')
  String? get tipodocumento;

  @BuiltValueField(wireName: r'tipoprocedimiento')
  String? get tipoprocedimiento;

  DTSELECTBYNIFV2REQ._();

  factory DTSELECTBYNIFV2REQ([void updates(DTSELECTBYNIFV2REQBuilder b)]) =
      _$DTSELECTBYNIFV2REQ;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DTSELECTBYNIFV2REQBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DTSELECTBYNIFV2REQ> get serializer =>
      _$DTSELECTBYNIFV2REQSerializer();
}

class _$DTSELECTBYNIFV2REQSerializer
    implements PrimitiveSerializer<DTSELECTBYNIFV2REQ> {
  @override
  final Iterable<Type> types = const [DTSELECTBYNIFV2REQ, _$DTSELECTBYNIFV2REQ];

  @override
  final String wireName = r'DTSELECTBYNIFV2REQ';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DTSELECTBYNIFV2REQ object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.numerodocumento != null) {
      yield r'numerodocumento';
      yield serializers.serialize(
        object.numerodocumento,
        specifiedType: const FullType(String),
      );
    }
    if (object.tipodocumento != null) {
      yield r'tipodocumento';
      yield serializers.serialize(
        object.tipodocumento,
        specifiedType: const FullType(String),
      );
    }
    if (object.tipoprocedimiento != null) {
      yield r'tipoprocedimiento';
      yield serializers.serialize(
        object.tipoprocedimiento,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    DTSELECTBYNIFV2REQ object, {
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
    required DTSELECTBYNIFV2REQBuilder result,
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
        case r'tipodocumento':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.tipodocumento = valueDes;
          break;
        case r'tipoprocedimiento':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.tipoprocedimiento = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DTSELECTBYNIFV2REQ deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DTSELECTBYNIFV2REQBuilder();
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
