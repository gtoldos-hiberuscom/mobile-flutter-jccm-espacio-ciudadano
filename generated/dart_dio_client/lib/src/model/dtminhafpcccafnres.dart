//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:espacio_ciudadano_api/src/model/beneficiarios.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'dtminhafpcccafnres.g.dart';

/// DTMINHAFPCCCAFNRES
///
/// Properties:
/// * [beneficiarios] 
/// * [categoria] 
/// * [comaut] 
/// * [feccaduci] 
/// * [fecexpedi] 
/// * [idpeticion] 
/// * [mensaje] 
/// * [numhij] 
/// * [nutitulo] 
/// * [resul] 
/// * [vigente] 
@BuiltValue()
abstract class DTMINHAFPCCCAFNRES implements Built<DTMINHAFPCCCAFNRES, DTMINHAFPCCCAFNRESBuilder> {
  @BuiltValueField(wireName: r'beneficiarios')
  BuiltList<BENEFICIARIOS>? get beneficiarios;

  @BuiltValueField(wireName: r'categoria')
  String? get categoria;

  @BuiltValueField(wireName: r'comaut')
  String? get comaut;

  @BuiltValueField(wireName: r'feccaduci')
  String? get feccaduci;

  @BuiltValueField(wireName: r'fecexpedi')
  String? get fecexpedi;

  @BuiltValueField(wireName: r'idpeticion')
  String? get idpeticion;

  @BuiltValueField(wireName: r'mensaje')
  String? get mensaje;

  @BuiltValueField(wireName: r'numhij')
  String? get numhij;

  @BuiltValueField(wireName: r'nutitulo')
  String? get nutitulo;

  @BuiltValueField(wireName: r'resul')
  String? get resul;

  @BuiltValueField(wireName: r'vigente')
  String? get vigente;

  DTMINHAFPCCCAFNRES._();

  factory DTMINHAFPCCCAFNRES([void updates(DTMINHAFPCCCAFNRESBuilder b)]) = _$DTMINHAFPCCCAFNRES;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DTMINHAFPCCCAFNRESBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DTMINHAFPCCCAFNRES> get serializer => _$DTMINHAFPCCCAFNRESSerializer();
}

class _$DTMINHAFPCCCAFNRESSerializer implements PrimitiveSerializer<DTMINHAFPCCCAFNRES> {
  @override
  final Iterable<Type> types = const [DTMINHAFPCCCAFNRES, _$DTMINHAFPCCCAFNRES];

  @override
  final String wireName = r'DTMINHAFPCCCAFNRES';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DTMINHAFPCCCAFNRES object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.beneficiarios != null) {
      yield r'beneficiarios';
      yield serializers.serialize(
        object.beneficiarios,
        specifiedType: const FullType(BuiltList, [FullType(BENEFICIARIOS)]),
      );
    }
    if (object.categoria != null) {
      yield r'categoria';
      yield serializers.serialize(
        object.categoria,
        specifiedType: const FullType(String),
      );
    }
    if (object.comaut != null) {
      yield r'comaut';
      yield serializers.serialize(
        object.comaut,
        specifiedType: const FullType(String),
      );
    }
    if (object.feccaduci != null) {
      yield r'feccaduci';
      yield serializers.serialize(
        object.feccaduci,
        specifiedType: const FullType(String),
      );
    }
    if (object.fecexpedi != null) {
      yield r'fecexpedi';
      yield serializers.serialize(
        object.fecexpedi,
        specifiedType: const FullType(String),
      );
    }
    if (object.idpeticion != null) {
      yield r'idpeticion';
      yield serializers.serialize(
        object.idpeticion,
        specifiedType: const FullType(String),
      );
    }
    if (object.mensaje != null) {
      yield r'mensaje';
      yield serializers.serialize(
        object.mensaje,
        specifiedType: const FullType(String),
      );
    }
    if (object.numhij != null) {
      yield r'numhij';
      yield serializers.serialize(
        object.numhij,
        specifiedType: const FullType(String),
      );
    }
    if (object.nutitulo != null) {
      yield r'nutitulo';
      yield serializers.serialize(
        object.nutitulo,
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
    if (object.vigente != null) {
      yield r'vigente';
      yield serializers.serialize(
        object.vigente,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    DTMINHAFPCCCAFNRES object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DTMINHAFPCCCAFNRESBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'beneficiarios':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(BENEFICIARIOS)]),
          ) as BuiltList<BENEFICIARIOS>;
          result.beneficiarios.replace(valueDes);
          break;
        case r'categoria':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.categoria = valueDes;
          break;
        case r'comaut':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.comaut = valueDes;
          break;
        case r'feccaduci':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.feccaduci = valueDes;
          break;
        case r'fecexpedi':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.fecexpedi = valueDes;
          break;
        case r'idpeticion':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.idpeticion = valueDes;
          break;
        case r'mensaje':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.mensaje = valueDes;
          break;
        case r'numhij':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.numhij = valueDes;
          break;
        case r'nutitulo':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.nutitulo = valueDes;
          break;
        case r'resul':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.resul = valueDes;
          break;
        case r'vigente':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.vigente = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DTMINHAFPCCCAFNRES deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DTMINHAFPCCCAFNRESBuilder();
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

