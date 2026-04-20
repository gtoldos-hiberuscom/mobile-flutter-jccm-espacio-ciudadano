//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'datos_beneficiarios_familia_numerosa_list.g.dart';

/// DatosBeneficiariosFamiliaNumerosaList
///
/// Properties:
/// * [apellido1]
/// * [apellido2]
/// * [documentacion]
/// * [fechaNacimiento]
/// * [nombre]
/// * [tipoDocumentacion]
/// * [titular]
@BuiltValue()
abstract class DatosBeneficiariosFamiliaNumerosaList
    implements
        Built<DatosBeneficiariosFamiliaNumerosaList,
            DatosBeneficiariosFamiliaNumerosaListBuilder> {
  @BuiltValueField(wireName: r'apellido1')
  String? get apellido1;

  @BuiltValueField(wireName: r'apellido2')
  String? get apellido2;

  @BuiltValueField(wireName: r'documentacion')
  String? get documentacion;

  @BuiltValueField(wireName: r'fecha_nacimiento')
  String? get fechaNacimiento;

  @BuiltValueField(wireName: r'nombre')
  String? get nombre;

  @BuiltValueField(wireName: r'tipo_documentacion')
  String? get tipoDocumentacion;

  @BuiltValueField(wireName: r'titular')
  String? get titular;

  DatosBeneficiariosFamiliaNumerosaList._();

  factory DatosBeneficiariosFamiliaNumerosaList(
          [void updates(DatosBeneficiariosFamiliaNumerosaListBuilder b)]) =
      _$DatosBeneficiariosFamiliaNumerosaList;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DatosBeneficiariosFamiliaNumerosaListBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DatosBeneficiariosFamiliaNumerosaList> get serializer =>
      _$DatosBeneficiariosFamiliaNumerosaListSerializer();
}

class _$DatosBeneficiariosFamiliaNumerosaListSerializer
    implements PrimitiveSerializer<DatosBeneficiariosFamiliaNumerosaList> {
  @override
  final Iterable<Type> types = const [
    DatosBeneficiariosFamiliaNumerosaList,
    _$DatosBeneficiariosFamiliaNumerosaList
  ];

  @override
  final String wireName = r'DatosBeneficiariosFamiliaNumerosaList';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DatosBeneficiariosFamiliaNumerosaList object, {
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
    if (object.documentacion != null) {
      yield r'documentacion';
      yield serializers.serialize(
        object.documentacion,
        specifiedType: const FullType(String),
      );
    }
    if (object.fechaNacimiento != null) {
      yield r'fecha_nacimiento';
      yield serializers.serialize(
        object.fechaNacimiento,
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
    if (object.tipoDocumentacion != null) {
      yield r'tipo_documentacion';
      yield serializers.serialize(
        object.tipoDocumentacion,
        specifiedType: const FullType(String),
      );
    }
    if (object.titular != null) {
      yield r'titular';
      yield serializers.serialize(
        object.titular,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    DatosBeneficiariosFamiliaNumerosaList object, {
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
    required DatosBeneficiariosFamiliaNumerosaListBuilder result,
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
        case r'documentacion':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.documentacion = valueDes;
          break;
        case r'fecha_nacimiento':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.fechaNacimiento = valueDes;
          break;
        case r'nombre':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.nombre = valueDes;
          break;
        case r'tipo_documentacion':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.tipoDocumentacion = valueDes;
          break;
        case r'titular':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.titular = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DatosBeneficiariosFamiliaNumerosaList deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DatosBeneficiariosFamiliaNumerosaListBuilder();
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
