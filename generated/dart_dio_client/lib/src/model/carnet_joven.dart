//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'carnet_joven.g.dart';

/// CarnetJoven
///
/// Properties:
/// * [fechaFinValidez] 
/// * [fechaNacimiento] 
/// * [numero] 
/// * [titular] 
/// * [enTramitacion] 
@BuiltValue()
abstract class CarnetJoven implements Built<CarnetJoven, CarnetJovenBuilder> {
  @BuiltValueField(wireName: r'FechaFinValidez')
  String? get fechaFinValidez;

  @BuiltValueField(wireName: r'FechaNacimiento')
  String? get fechaNacimiento;

  @BuiltValueField(wireName: r'Numero')
  String? get numero;

  @BuiltValueField(wireName: r'Titular')
  String? get titular;

  @BuiltValueField(wireName: r'enTramitacion')
  String? get enTramitacion;

  CarnetJoven._();

  factory CarnetJoven([void updates(CarnetJovenBuilder b)]) = _$CarnetJoven;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CarnetJovenBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CarnetJoven> get serializer => _$CarnetJovenSerializer();
}

class _$CarnetJovenSerializer implements PrimitiveSerializer<CarnetJoven> {
  @override
  final Iterable<Type> types = const [CarnetJoven, _$CarnetJoven];

  @override
  final String wireName = r'CarnetJoven';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CarnetJoven object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.fechaFinValidez != null) {
      yield r'FechaFinValidez';
      yield serializers.serialize(
        object.fechaFinValidez,
        specifiedType: const FullType(String),
      );
    }
    if (object.fechaNacimiento != null) {
      yield r'FechaNacimiento';
      yield serializers.serialize(
        object.fechaNacimiento,
        specifiedType: const FullType(String),
      );
    }
    if (object.numero != null) {
      yield r'Numero';
      yield serializers.serialize(
        object.numero,
        specifiedType: const FullType(String),
      );
    }
    if (object.titular != null) {
      yield r'Titular';
      yield serializers.serialize(
        object.titular,
        specifiedType: const FullType(String),
      );
    }
    if (object.enTramitacion != null) {
      yield r'enTramitacion';
      yield serializers.serialize(
        object.enTramitacion,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    CarnetJoven object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CarnetJovenBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'FechaFinValidez':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.fechaFinValidez = valueDes;
          break;
        case r'FechaNacimiento':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.fechaNacimiento = valueDes;
          break;
        case r'Numero':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.numero = valueDes;
          break;
        case r'Titular':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.titular = valueDes;
          break;
        case r'enTramitacion':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.enTramitacion = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CarnetJoven deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CarnetJovenBuilder();
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

