//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:espacio_ciudadano_api/src/model/datosregistro.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'resultadoprocedimiento.g.dart';

/// RESULTADOPROCEDIMIENTO
///
/// Properties:
/// * [datosregistro] 
/// * [estado] 
/// * [idregistro] 
/// * [idunico] 
/// * [mensaje] 
@BuiltValue()
abstract class RESULTADOPROCEDIMIENTO implements Built<RESULTADOPROCEDIMIENTO, RESULTADOPROCEDIMIENTOBuilder> {
  @BuiltValueField(wireName: r'datosregistro')
  DATOSREGISTRO get datosregistro;

  @BuiltValueField(wireName: r'estado')
  String get estado;

  @BuiltValueField(wireName: r'idregistro')
  String get idregistro;

  @BuiltValueField(wireName: r'idunico')
  String get idunico;

  @BuiltValueField(wireName: r'mensaje')
  String get mensaje;

  RESULTADOPROCEDIMIENTO._();

  factory RESULTADOPROCEDIMIENTO([void updates(RESULTADOPROCEDIMIENTOBuilder b)]) = _$RESULTADOPROCEDIMIENTO;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RESULTADOPROCEDIMIENTOBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RESULTADOPROCEDIMIENTO> get serializer => _$RESULTADOPROCEDIMIENTOSerializer();
}

class _$RESULTADOPROCEDIMIENTOSerializer implements PrimitiveSerializer<RESULTADOPROCEDIMIENTO> {
  @override
  final Iterable<Type> types = const [RESULTADOPROCEDIMIENTO, _$RESULTADOPROCEDIMIENTO];

  @override
  final String wireName = r'RESULTADOPROCEDIMIENTO';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RESULTADOPROCEDIMIENTO object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'datosregistro';
    yield serializers.serialize(
      object.datosregistro,
      specifiedType: const FullType(DATOSREGISTRO),
    );
    yield r'estado';
    yield serializers.serialize(
      object.estado,
      specifiedType: const FullType(String),
    );
    yield r'idregistro';
    yield serializers.serialize(
      object.idregistro,
      specifiedType: const FullType(String),
    );
    yield r'idunico';
    yield serializers.serialize(
      object.idunico,
      specifiedType: const FullType(String),
    );
    yield r'mensaje';
    yield serializers.serialize(
      object.mensaje,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    RESULTADOPROCEDIMIENTO object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required RESULTADOPROCEDIMIENTOBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'datosregistro':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DATOSREGISTRO),
          ) as DATOSREGISTRO;
          result.datosregistro.replace(valueDes);
          break;
        case r'estado':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.estado = valueDes;
          break;
        case r'idregistro':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.idregistro = valueDes;
          break;
        case r'idunico':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.idunico = valueDes;
          break;
        case r'mensaje':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.mensaje = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  RESULTADOPROCEDIMIENTO deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RESULTADOPROCEDIMIENTOBuilder();
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

