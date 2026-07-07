//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'datos_representante.g.dart';

/// DatosRepresentante
///
/// Properties:
/// * [apellido1] 
/// * [apellido2] 
/// * [nifcif] 
/// * [nombre] 
/// * [tipodoc] 
@BuiltValue()
abstract class DatosRepresentante implements Built<DatosRepresentante, DatosRepresentanteBuilder> {
  @BuiltValueField(wireName: r'apellido1')
  String? get apellido1;

  @BuiltValueField(wireName: r'apellido2')
  String? get apellido2;

  @BuiltValueField(wireName: r'nifcif')
  String? get nifcif;

  @BuiltValueField(wireName: r'nombre')
  String? get nombre;

  @BuiltValueField(wireName: r'tipodoc')
  String? get tipodoc;

  DatosRepresentante._();

  factory DatosRepresentante([void updates(DatosRepresentanteBuilder b)]) = _$DatosRepresentante;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DatosRepresentanteBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DatosRepresentante> get serializer => _$DatosRepresentanteSerializer();
}

class _$DatosRepresentanteSerializer implements PrimitiveSerializer<DatosRepresentante> {
  @override
  final Iterable<Type> types = const [DatosRepresentante, _$DatosRepresentante];

  @override
  final String wireName = r'DatosRepresentante';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DatosRepresentante object, {
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
    if (object.nifcif != null) {
      yield r'nifcif';
      yield serializers.serialize(
        object.nifcif,
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
    DatosRepresentante object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DatosRepresentanteBuilder result,
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
        case r'nifcif':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.nifcif = valueDes;
          break;
        case r'nombre':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.nombre = valueDes;
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
  DatosRepresentante deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DatosRepresentanteBuilder();
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

