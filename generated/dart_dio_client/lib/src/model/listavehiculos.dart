//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:espacio_ciudadano_api/src/model/vehiculo.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'listavehiculos.g.dart';

/// LISTAVEHICULOS
///
/// Properties:
/// * [vehiculo] 
@BuiltValue()
abstract class LISTAVEHICULOS implements Built<LISTAVEHICULOS, LISTAVEHICULOSBuilder> {
  @BuiltValueField(wireName: r'vehiculo')
  BuiltList<VEHICULO>? get vehiculo;

  LISTAVEHICULOS._();

  factory LISTAVEHICULOS([void updates(LISTAVEHICULOSBuilder b)]) = _$LISTAVEHICULOS;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(LISTAVEHICULOSBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<LISTAVEHICULOS> get serializer => _$LISTAVEHICULOSSerializer();
}

class _$LISTAVEHICULOSSerializer implements PrimitiveSerializer<LISTAVEHICULOS> {
  @override
  final Iterable<Type> types = const [LISTAVEHICULOS, _$LISTAVEHICULOS];

  @override
  final String wireName = r'LISTAVEHICULOS';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    LISTAVEHICULOS object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.vehiculo != null) {
      yield r'vehiculo';
      yield serializers.serialize(
        object.vehiculo,
        specifiedType: const FullType(BuiltList, [FullType(VEHICULO)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    LISTAVEHICULOS object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required LISTAVEHICULOSBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'vehiculo':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(VEHICULO)]),
          ) as BuiltList<VEHICULO>;
          result.vehiculo.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  LISTAVEHICULOS deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = LISTAVEHICULOSBuilder();
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

