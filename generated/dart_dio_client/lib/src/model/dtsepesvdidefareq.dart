//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'dtsepesvdidefareq.g.dart';

/// DTSEPESVDIDEFAREQ
///
/// Properties:
/// * [apellido1TITULAR] 
/// * [apellido2TITULAR] 
/// * [docu] 
/// * [documentofuncionario] 
/// * [idaut] 
/// * [nombrefuncionario] 
/// * [nombretitular] 
/// * [proc] 
/// * [tipo] 
/// * [tipodoc] 
@BuiltValue()
abstract class DTSEPESVDIDEFAREQ implements Built<DTSEPESVDIDEFAREQ, DTSEPESVDIDEFAREQBuilder> {
  @BuiltValueField(wireName: r'apellido1TITULAR')
  String? get apellido1TITULAR;

  @BuiltValueField(wireName: r'apellido2TITULAR')
  String? get apellido2TITULAR;

  @BuiltValueField(wireName: r'docu')
  String? get docu;

  @BuiltValueField(wireName: r'documentofuncionario')
  String? get documentofuncionario;

  @BuiltValueField(wireName: r'idaut')
  String? get idaut;

  @BuiltValueField(wireName: r'nombrefuncionario')
  String? get nombrefuncionario;

  @BuiltValueField(wireName: r'nombretitular')
  String? get nombretitular;

  @BuiltValueField(wireName: r'proc')
  String? get proc;

  @BuiltValueField(wireName: r'tipo')
  String? get tipo;

  @BuiltValueField(wireName: r'tipodoc')
  String? get tipodoc;

  DTSEPESVDIDEFAREQ._();

  factory DTSEPESVDIDEFAREQ([void updates(DTSEPESVDIDEFAREQBuilder b)]) = _$DTSEPESVDIDEFAREQ;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DTSEPESVDIDEFAREQBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DTSEPESVDIDEFAREQ> get serializer => _$DTSEPESVDIDEFAREQSerializer();
}

class _$DTSEPESVDIDEFAREQSerializer implements PrimitiveSerializer<DTSEPESVDIDEFAREQ> {
  @override
  final Iterable<Type> types = const [DTSEPESVDIDEFAREQ, _$DTSEPESVDIDEFAREQ];

  @override
  final String wireName = r'DTSEPESVDIDEFAREQ';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DTSEPESVDIDEFAREQ object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.apellido1TITULAR != null) {
      yield r'apellido1TITULAR';
      yield serializers.serialize(
        object.apellido1TITULAR,
        specifiedType: const FullType(String),
      );
    }
    if (object.apellido2TITULAR != null) {
      yield r'apellido2TITULAR';
      yield serializers.serialize(
        object.apellido2TITULAR,
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
    if (object.idaut != null) {
      yield r'idaut';
      yield serializers.serialize(
        object.idaut,
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
    if (object.nombretitular != null) {
      yield r'nombretitular';
      yield serializers.serialize(
        object.nombretitular,
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
    if (object.tipo != null) {
      yield r'tipo';
      yield serializers.serialize(
        object.tipo,
        specifiedType: const FullType(String),
      );
    }
    if (object.tipodoc != null) {
      yield r'tipodoc';
      yield serializers.serialize(
        object.tipodoc,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    DTSEPESVDIDEFAREQ object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DTSEPESVDIDEFAREQBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'apellido1TITULAR':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.apellido1TITULAR = valueDes;
          break;
        case r'apellido2TITULAR':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.apellido2TITULAR = valueDes;
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
        case r'idaut':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.idaut = valueDes;
          break;
        case r'nombrefuncionario':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.nombrefuncionario = valueDes;
          break;
        case r'nombretitular':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.nombretitular = valueDes;
          break;
        case r'proc':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.proc = valueDes;
          break;
        case r'tipo':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.tipo = valueDes;
          break;
        case r'tipodoc':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.tipodoc = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DTSEPESVDIDEFAREQ deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DTSEPESVDIDEFAREQBuilder();
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

