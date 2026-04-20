//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'carnet_qr.g.dart';

/// CarnetQr
///
/// Properties:
/// * [qr] 
@BuiltValue()
abstract class CarnetQr implements Built<CarnetQr, CarnetQrBuilder> {
  @BuiltValueField(wireName: r'qr')
  String? get qr;

  CarnetQr._();

  factory CarnetQr([void updates(CarnetQrBuilder b)]) = _$CarnetQr;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CarnetQrBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CarnetQr> get serializer => _$CarnetQrSerializer();
}

class _$CarnetQrSerializer implements PrimitiveSerializer<CarnetQr> {
  @override
  final Iterable<Type> types = const [CarnetQr, _$CarnetQr];

  @override
  final String wireName = r'CarnetQr';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CarnetQr object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.qr != null) {
      yield r'qr';
      yield serializers.serialize(
        object.qr,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    CarnetQr object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CarnetQrBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'qr':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.qr = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CarnetQr deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CarnetQrBuilder();
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

