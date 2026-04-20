//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'datossolicitante.g.dart';

/// DATOSSOLICITANTE
///
/// Properties:
/// * [apellido1] 
/// * [apellido2] 
/// * [codigopostal] 
/// * [domicilio] 
/// * [entidad] 
/// * [nombre] 
/// * [numero] 
/// * [poblacion] 
/// * [provincia] 
@BuiltValue()
abstract class DATOSSOLICITANTE implements Built<DATOSSOLICITANTE, DATOSSOLICITANTEBuilder> {
  @BuiltValueField(wireName: r'apellido1')
  String get apellido1;

  @BuiltValueField(wireName: r'apellido2')
  String get apellido2;

  @BuiltValueField(wireName: r'codigopostal')
  String get codigopostal;

  @BuiltValueField(wireName: r'domicilio')
  String get domicilio;

  @BuiltValueField(wireName: r'entidad')
  String get entidad;

  @BuiltValueField(wireName: r'nombre')
  String get nombre;

  @BuiltValueField(wireName: r'numero')
  String get numero;

  @BuiltValueField(wireName: r'poblacion')
  String get poblacion;

  @BuiltValueField(wireName: r'provincia')
  String get provincia;

  DATOSSOLICITANTE._();

  factory DATOSSOLICITANTE([void updates(DATOSSOLICITANTEBuilder b)]) = _$DATOSSOLICITANTE;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DATOSSOLICITANTEBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DATOSSOLICITANTE> get serializer => _$DATOSSOLICITANTESerializer();
}

class _$DATOSSOLICITANTESerializer implements PrimitiveSerializer<DATOSSOLICITANTE> {
  @override
  final Iterable<Type> types = const [DATOSSOLICITANTE, _$DATOSSOLICITANTE];

  @override
  final String wireName = r'DATOSSOLICITANTE';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DATOSSOLICITANTE object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'apellido1';
    yield serializers.serialize(
      object.apellido1,
      specifiedType: const FullType(String),
    );
    yield r'apellido2';
    yield serializers.serialize(
      object.apellido2,
      specifiedType: const FullType(String),
    );
    yield r'codigopostal';
    yield serializers.serialize(
      object.codigopostal,
      specifiedType: const FullType(String),
    );
    yield r'domicilio';
    yield serializers.serialize(
      object.domicilio,
      specifiedType: const FullType(String),
    );
    yield r'entidad';
    yield serializers.serialize(
      object.entidad,
      specifiedType: const FullType(String),
    );
    yield r'nombre';
    yield serializers.serialize(
      object.nombre,
      specifiedType: const FullType(String),
    );
    yield r'numero';
    yield serializers.serialize(
      object.numero,
      specifiedType: const FullType(String),
    );
    yield r'poblacion';
    yield serializers.serialize(
      object.poblacion,
      specifiedType: const FullType(String),
    );
    yield r'provincia';
    yield serializers.serialize(
      object.provincia,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DATOSSOLICITANTE object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DATOSSOLICITANTEBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'apellido1':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.apellido1 = valueDes;
          break;
        case r'apellido2':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.apellido2 = valueDes;
          break;
        case r'codigopostal':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.codigopostal = valueDes;
          break;
        case r'domicilio':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.domicilio = valueDes;
          break;
        case r'entidad':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.entidad = valueDes;
          break;
        case r'nombre':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.nombre = valueDes;
          break;
        case r'numero':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.numero = valueDes;
          break;
        case r'poblacion':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.poblacion = valueDes;
          break;
        case r'provincia':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.provincia = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DATOSSOLICITANTE deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DATOSSOLICITANTEBuilder();
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

