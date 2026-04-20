//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'dtsepesvdidefares.g.dart';

/// DTSEPESVDIDEFARES
///
/// Properties:
/// * [idpeticion] 
/// * [inscrito] 
/// * [mensaje] 
/// * [resul] 
/// * [ultimainscrip] 
@BuiltValue()
abstract class DTSEPESVDIDEFARES implements Built<DTSEPESVDIDEFARES, DTSEPESVDIDEFARESBuilder> {
  @BuiltValueField(wireName: r'idpeticion')
  String? get idpeticion;

  @BuiltValueField(wireName: r'inscrito')
  String? get inscrito;

  @BuiltValueField(wireName: r'mensaje')
  String? get mensaje;

  @BuiltValueField(wireName: r'resul')
  String? get resul;

  @BuiltValueField(wireName: r'ultimainscrip')
  String? get ultimainscrip;

  DTSEPESVDIDEFARES._();

  factory DTSEPESVDIDEFARES([void updates(DTSEPESVDIDEFARESBuilder b)]) = _$DTSEPESVDIDEFARES;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DTSEPESVDIDEFARESBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DTSEPESVDIDEFARES> get serializer => _$DTSEPESVDIDEFARESSerializer();
}

class _$DTSEPESVDIDEFARESSerializer implements PrimitiveSerializer<DTSEPESVDIDEFARES> {
  @override
  final Iterable<Type> types = const [DTSEPESVDIDEFARES, _$DTSEPESVDIDEFARES];

  @override
  final String wireName = r'DTSEPESVDIDEFARES';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DTSEPESVDIDEFARES object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.idpeticion != null) {
      yield r'idpeticion';
      yield serializers.serialize(
        object.idpeticion,
        specifiedType: const FullType(String),
      );
    }
    if (object.inscrito != null) {
      yield r'inscrito';
      yield serializers.serialize(
        object.inscrito,
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
    if (object.resul != null) {
      yield r'resul';
      yield serializers.serialize(
        object.resul,
        specifiedType: const FullType(String),
      );
    }
    if (object.ultimainscrip != null) {
      yield r'ultimainscrip';
      yield serializers.serialize(
        object.ultimainscrip,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    DTSEPESVDIDEFARES object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DTSEPESVDIDEFARESBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'idpeticion':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.idpeticion = valueDes;
          break;
        case r'inscrito':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.inscrito = valueDes;
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
        case r'ultimainscrip':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.ultimainscrip = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DTSEPESVDIDEFARES deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DTSEPESVDIDEFARESBuilder();
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

