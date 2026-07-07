//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:espacio_ciudadano_api/src/model/dt_identificacion_rep.dart';
import 'package:espacio_ciudadano_api/src/model/adjuntos.dart';
import 'package:espacio_ciudadano_api/src/model/dt_identificacion.dart';
import 'package:espacio_ciudadano_api/src/model/datossolicitante.dart';
import 'package:espacio_ciudadano_api/src/model/registro.dart';
import 'package:espacio_ciudadano_api/src/model/datospago.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'dt_procedimiento.g.dart';

/// DTProcedimiento
///
/// Properties:
/// * [adjuntos] 
/// * [asudescripcion] 
/// * [asunto] 
/// * [consejeria] 
/// * [datospago] 
/// * [datosprocedimiento] 
/// * [datossolicitante] 
/// * [firma] 
/// * [identificacion] 
/// * [identificacionrep] 
/// * [idunico] 
/// * [noexpediente] 
/// * [provincia] 
/// * [registro] 
/// * [source_] 
/// * [tipoprocedimiento] 
/// * [unidadorganica] 
@BuiltValue()
abstract class DTProcedimiento implements Built<DTProcedimiento, DTProcedimientoBuilder> {
  @BuiltValueField(wireName: r'adjuntos')
  ADJUNTOS get adjuntos;

  @BuiltValueField(wireName: r'asudescripcion')
  String? get asudescripcion;

  @BuiltValueField(wireName: r'asunto')
  String get asunto;

  @BuiltValueField(wireName: r'consejeria')
  String get consejeria;

  @BuiltValueField(wireName: r'datospago')
  DATOSPAGO? get datospago;

  @BuiltValueField(wireName: r'datosprocedimiento')
  JsonObject get datosprocedimiento;

  @BuiltValueField(wireName: r'datossolicitante')
  DATOSSOLICITANTE get datossolicitante;

  @BuiltValueField(wireName: r'firma')
  String? get firma;

  @BuiltValueField(wireName: r'identificacion')
  DTIdentificacion get identificacion;

  @BuiltValueField(wireName: r'identificacionrep')
  DTIdentificacionRep get identificacionrep;

  @BuiltValueField(wireName: r'idunico')
  String get idunico;

  @BuiltValueField(wireName: r'noexpediente')
  String get noexpediente;

  @BuiltValueField(wireName: r'provincia')
  String get provincia;

  @BuiltValueField(wireName: r'registro')
  REGISTRO get registro;

  @BuiltValueField(wireName: r'source')
  String? get source_;

  @BuiltValueField(wireName: r'tipoprocedimiento')
  String get tipoprocedimiento;

  @BuiltValueField(wireName: r'unidadorganica')
  String get unidadorganica;

  DTProcedimiento._();

  factory DTProcedimiento([void updates(DTProcedimientoBuilder b)]) = _$DTProcedimiento;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DTProcedimientoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DTProcedimiento> get serializer => _$DTProcedimientoSerializer();
}

class _$DTProcedimientoSerializer implements PrimitiveSerializer<DTProcedimiento> {
  @override
  final Iterable<Type> types = const [DTProcedimiento, _$DTProcedimiento];

  @override
  final String wireName = r'DTProcedimiento';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DTProcedimiento object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'adjuntos';
    yield serializers.serialize(
      object.adjuntos,
      specifiedType: const FullType(ADJUNTOS),
    );
    if (object.asudescripcion != null) {
      yield r'asudescripcion';
      yield serializers.serialize(
        object.asudescripcion,
        specifiedType: const FullType(String),
      );
    }
    yield r'asunto';
    yield serializers.serialize(
      object.asunto,
      specifiedType: const FullType(String),
    );
    yield r'consejeria';
    yield serializers.serialize(
      object.consejeria,
      specifiedType: const FullType(String),
    );
    if (object.datospago != null) {
      yield r'datospago';
      yield serializers.serialize(
        object.datospago,
        specifiedType: const FullType(DATOSPAGO),
      );
    }
    yield r'datosprocedimiento';
    yield serializers.serialize(
      object.datosprocedimiento,
      specifiedType: const FullType(JsonObject),
    );
    yield r'datossolicitante';
    yield serializers.serialize(
      object.datossolicitante,
      specifiedType: const FullType(DATOSSOLICITANTE),
    );
    if (object.firma != null) {
      yield r'firma';
      yield serializers.serialize(
        object.firma,
        specifiedType: const FullType(String),
      );
    }
    yield r'identificacion';
    yield serializers.serialize(
      object.identificacion,
      specifiedType: const FullType(DTIdentificacion),
    );
    yield r'identificacionrep';
    yield serializers.serialize(
      object.identificacionrep,
      specifiedType: const FullType(DTIdentificacionRep),
    );
    yield r'idunico';
    yield serializers.serialize(
      object.idunico,
      specifiedType: const FullType(String),
    );
    yield r'noexpediente';
    yield serializers.serialize(
      object.noexpediente,
      specifiedType: const FullType(String),
    );
    yield r'provincia';
    yield serializers.serialize(
      object.provincia,
      specifiedType: const FullType(String),
    );
    yield r'registro';
    yield serializers.serialize(
      object.registro,
      specifiedType: const FullType(REGISTRO),
    );
    if (object.source_ != null) {
      yield r'source';
      yield serializers.serialize(
        object.source_,
        specifiedType: const FullType(String),
      );
    }
    yield r'tipoprocedimiento';
    yield serializers.serialize(
      object.tipoprocedimiento,
      specifiedType: const FullType(String),
    );
    yield r'unidadorganica';
    yield serializers.serialize(
      object.unidadorganica,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DTProcedimiento object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DTProcedimientoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'adjuntos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ADJUNTOS),
          ) as ADJUNTOS;
          result.adjuntos.replace(valueDes);
          break;
        case r'asudescripcion':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.asudescripcion = valueDes;
          break;
        case r'asunto':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.asunto = valueDes;
          break;
        case r'consejeria':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.consejeria = valueDes;
          break;
        case r'datospago':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DATOSPAGO),
          ) as DATOSPAGO;
          result.datospago.replace(valueDes);
          break;
        case r'datosprocedimiento':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(JsonObject),
          ) as JsonObject;
          result.datosprocedimiento = valueDes;
          break;
        case r'datossolicitante':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DATOSSOLICITANTE),
          ) as DATOSSOLICITANTE;
          result.datossolicitante.replace(valueDes);
          break;
        case r'firma':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.firma = valueDes;
          break;
        case r'identificacion':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DTIdentificacion),
          ) as DTIdentificacion;
          result.identificacion.replace(valueDes);
          break;
        case r'identificacionrep':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DTIdentificacionRep),
          ) as DTIdentificacionRep;
          result.identificacionrep.replace(valueDes);
          break;
        case r'idunico':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.idunico = valueDes;
          break;
        case r'noexpediente':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.noexpediente = valueDes;
          break;
        case r'provincia':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.provincia = valueDes;
          break;
        case r'registro':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(REGISTRO),
          ) as REGISTRO;
          result.registro.replace(valueDes);
          break;
        case r'source':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.source_ = valueDes;
          break;
        case r'tipoprocedimiento':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.tipoprocedimiento = valueDes;
          break;
        case r'unidadorganica':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.unidadorganica = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DTProcedimiento deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DTProcedimientoBuilder();
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

