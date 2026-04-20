//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'pdatos.g.dart';

/// PDATOS
///
/// Properties:
/// * [apellido1]
/// * [apellido2]
/// * [asuid]
/// * [descrip]
/// * [idunico]
/// * [nombre]
/// * [numdoc]
/// * [uniorg]
@BuiltValue()
abstract class PDATOS implements Built<PDATOS, PDATOSBuilder> {
  @BuiltValueField(wireName: r'apellido1')
  String get apellido1;

  @BuiltValueField(wireName: r'apellido2')
  String get apellido2;

  @BuiltValueField(wireName: r'asuid')
  String get asuid;

  @BuiltValueField(wireName: r'descrip')
  String get descrip;

  @BuiltValueField(wireName: r'idunico')
  String get idunico;

  @BuiltValueField(wireName: r'nombre')
  String get nombre;

  @BuiltValueField(wireName: r'numdoc')
  String get numdoc;

  @BuiltValueField(wireName: r'uniorg')
  String get uniorg;

  PDATOS._();

  factory PDATOS([void updates(PDATOSBuilder b)]) = _$PDATOS;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PDATOSBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PDATOS> get serializer => _$PDATOSSerializer();
}

class _$PDATOSSerializer implements PrimitiveSerializer<PDATOS> {
  @override
  final Iterable<Type> types = const [PDATOS, _$PDATOS];

  @override
  final String wireName = r'PDATOS';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PDATOS object, {
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
    yield r'asuid';
    yield serializers.serialize(
      object.asuid,
      specifiedType: const FullType(String),
    );
    yield r'descrip';
    yield serializers.serialize(
      object.descrip,
      specifiedType: const FullType(String),
    );
    yield r'idunico';
    yield serializers.serialize(
      object.idunico,
      specifiedType: const FullType(String),
    );
    yield r'nombre';
    yield serializers.serialize(
      object.nombre,
      specifiedType: const FullType(String),
    );
    yield r'numdoc';
    yield serializers.serialize(
      object.numdoc,
      specifiedType: const FullType(String),
    );
    yield r'uniorg';
    yield serializers.serialize(
      object.uniorg,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PDATOS object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object,
            specifiedType: specifiedType)
        .toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PDATOSBuilder result,
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
        case r'asuid':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.asuid = valueDes;
          break;
        case r'descrip':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.descrip = valueDes;
          break;
        case r'idunico':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.idunico = valueDes;
          break;
        case r'nombre':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.nombre = valueDes;
          break;
        case r'numdoc':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.numdoc = valueDes;
          break;
        case r'uniorg':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.uniorg = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PDATOS deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PDATOSBuilder();
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
