//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:espacio_ciudadano_api/src/model/listavehiculos.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'dtdgtlistadovehiculosres.g.dart';

/// DTDGTLISTADOVEHICULOSRES
///
/// Properties:
/// * [idepeticion] 
/// * [listavehiculos] 
/// * [mensaje] 
/// * [resul] 
@BuiltValue()
abstract class DTDGTLISTADOVEHICULOSRES implements Built<DTDGTLISTADOVEHICULOSRES, DTDGTLISTADOVEHICULOSRESBuilder> {
  @BuiltValueField(wireName: r'idepeticion')
  String? get idepeticion;

  @BuiltValueField(wireName: r'listavehiculos')
  LISTAVEHICULOS? get listavehiculos;

  @BuiltValueField(wireName: r'mensaje')
  String? get mensaje;

  @BuiltValueField(wireName: r'resul')
  String? get resul;

  DTDGTLISTADOVEHICULOSRES._();

  factory DTDGTLISTADOVEHICULOSRES([void updates(DTDGTLISTADOVEHICULOSRESBuilder b)]) = _$DTDGTLISTADOVEHICULOSRES;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DTDGTLISTADOVEHICULOSRESBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DTDGTLISTADOVEHICULOSRES> get serializer => _$DTDGTLISTADOVEHICULOSRESSerializer();
}

class _$DTDGTLISTADOVEHICULOSRESSerializer implements PrimitiveSerializer<DTDGTLISTADOVEHICULOSRES> {
  @override
  final Iterable<Type> types = const [DTDGTLISTADOVEHICULOSRES, _$DTDGTLISTADOVEHICULOSRES];

  @override
  final String wireName = r'DTDGTLISTADOVEHICULOSRES';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DTDGTLISTADOVEHICULOSRES object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.idepeticion != null) {
      yield r'idepeticion';
      yield serializers.serialize(
        object.idepeticion,
        specifiedType: const FullType(String),
      );
    }
    if (object.listavehiculos != null) {
      yield r'listavehiculos';
      yield serializers.serialize(
        object.listavehiculos,
        specifiedType: const FullType(LISTAVEHICULOS),
      );
    }
    if (object.mensaje != null) {
      yield r'mensaje';
      yield serializers.serialize(
        object.mensaje,
        specifiedType: const FullType(String),
      );
    }
    if (object.resul != null) {
      yield r'resul';
      yield serializers.serialize(
        object.resul,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    DTDGTLISTADOVEHICULOSRES object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DTDGTLISTADOVEHICULOSRESBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'idepeticion':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.idepeticion = valueDes;
          break;
        case r'listavehiculos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(LISTAVEHICULOS),
          ) as LISTAVEHICULOS;
          result.listavehiculos.replace(valueDes);
          break;
        case r'mensaje':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.mensaje = valueDes;
          break;
        case r'resul':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.resul = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DTDGTLISTADOVEHICULOSRES deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DTDGTLISTADOVEHICULOSRESBuilder();
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

