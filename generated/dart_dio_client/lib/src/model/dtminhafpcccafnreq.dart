//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'dtminhafpcccafnreq.g.dart';

/// DTMINHAFPCCCAFNREQ
///
/// Properties:
/// * [apellido1] 
/// * [apellido2] 
/// * [comaut] 
/// * [docu] 
/// * [documentofuncionario] 
/// * [fechacon] 
/// * [fechanac] 
/// * [idaut] 
/// * [nombre] 
/// * [nombrefuncionario] 
/// * [numexp] 
/// * [nutitulo] 
/// * [proc] 
/// * [tipdoc] 
/// * [tipo] 
@BuiltValue()
abstract class DTMINHAFPCCCAFNREQ implements Built<DTMINHAFPCCCAFNREQ, DTMINHAFPCCCAFNREQBuilder> {
  @BuiltValueField(wireName: r'apellido1')
  String? get apellido1;

  @BuiltValueField(wireName: r'apellido2')
  String? get apellido2;

  @BuiltValueField(wireName: r'comaut')
  String? get comaut;

  @BuiltValueField(wireName: r'docu')
  String? get docu;

  @BuiltValueField(wireName: r'documentofuncionario')
  String? get documentofuncionario;

  @BuiltValueField(wireName: r'fechacon')
  String? get fechacon;

  @BuiltValueField(wireName: r'fechanac')
  String? get fechanac;

  @BuiltValueField(wireName: r'idaut')
  String? get idaut;

  @BuiltValueField(wireName: r'nombre')
  String? get nombre;

  @BuiltValueField(wireName: r'nombrefuncionario')
  String? get nombrefuncionario;

  @BuiltValueField(wireName: r'numexp')
  String? get numexp;

  @BuiltValueField(wireName: r'nutitulo')
  String? get nutitulo;

  @BuiltValueField(wireName: r'proc')
  String? get proc;

  @BuiltValueField(wireName: r'tipdoc')
  String? get tipdoc;

  @BuiltValueField(wireName: r'tipo')
  String? get tipo;

  DTMINHAFPCCCAFNREQ._();

  factory DTMINHAFPCCCAFNREQ([void updates(DTMINHAFPCCCAFNREQBuilder b)]) = _$DTMINHAFPCCCAFNREQ;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DTMINHAFPCCCAFNREQBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DTMINHAFPCCCAFNREQ> get serializer => _$DTMINHAFPCCCAFNREQSerializer();
}

class _$DTMINHAFPCCCAFNREQSerializer implements PrimitiveSerializer<DTMINHAFPCCCAFNREQ> {
  @override
  final Iterable<Type> types = const [DTMINHAFPCCCAFNREQ, _$DTMINHAFPCCCAFNREQ];

  @override
  final String wireName = r'DTMINHAFPCCCAFNREQ';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DTMINHAFPCCCAFNREQ object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.apellido1 != null) {
      yield r'apellido1';
      yield serializers.serialize(
        object.apellido1,
        specifiedType: const FullType(String),
      );
    }
    if (object.apellido2 != null) {
      yield r'apellido2';
      yield serializers.serialize(
        object.apellido2,
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
    if (object.docu != null) {
      yield r'docu';
      yield serializers.serialize(
        object.docu,
        specifiedType: const FullType(String),
      );
    }
    if (object.documentofuncionario != null) {
      yield r'documentofuncionario';
      yield serializers.serialize(
        object.documentofuncionario,
        specifiedType: const FullType(String),
      );
    }
    if (object.fechacon != null) {
      yield r'fechacon';
      yield serializers.serialize(
        object.fechacon,
        specifiedType: const FullType(String),
      );
    }
    if (object.fechanac != null) {
      yield r'fechanac';
      yield serializers.serialize(
        object.fechanac,
        specifiedType: const FullType(String),
      );
    }
    if (object.idaut != null) {
      yield r'idaut';
      yield serializers.serialize(
        object.idaut,
        specifiedType: const FullType(String),
      );
    }
    if (object.nombre != null) {
      yield r'nombre';
      yield serializers.serialize(
        object.nombre,
        specifiedType: const FullType(String),
      );
    }
    if (object.nombrefuncionario != null) {
      yield r'nombrefuncionario';
      yield serializers.serialize(
        object.nombrefuncionario,
        specifiedType: const FullType(String),
      );
    }
    if (object.numexp != null) {
      yield r'numexp';
      yield serializers.serialize(
        object.numexp,
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
    if (object.proc != null) {
      yield r'proc';
      yield serializers.serialize(
        object.proc,
        specifiedType: const FullType(String),
      );
    }
    if (object.tipdoc != null) {
      yield r'tipdoc';
      yield serializers.serialize(
        object.tipdoc,
        specifiedType: const FullType(String),
      );
    }
    if (object.tipo != null) {
      yield r'tipo';
      yield serializers.serialize(
        object.tipo,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    DTMINHAFPCCCAFNREQ object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DTMINHAFPCCCAFNREQBuilder result,
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
        case r'comaut':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.comaut = valueDes;
          break;
        case r'docu':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.docu = valueDes;
          break;
        case r'documentofuncionario':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.documentofuncionario = valueDes;
          break;
        case r'fechacon':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.fechacon = valueDes;
          break;
        case r'fechanac':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.fechanac = valueDes;
          break;
        case r'idaut':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.idaut = valueDes;
          break;
        case r'nombre':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.nombre = valueDes;
          break;
        case r'nombrefuncionario':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.nombrefuncionario = valueDes;
          break;
        case r'numexp':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.numexp = valueDes;
          break;
        case r'nutitulo':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.nutitulo = valueDes;
          break;
        case r'proc':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.proc = valueDes;
          break;
        case r'tipdoc':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.tipdoc = valueDes;
          break;
        case r'tipo':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.tipo = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DTMINHAFPCCCAFNREQ deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DTMINHAFPCCCAFNREQBuilder();
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

