//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:espacio_ciudadano_api/src/model/datos_beneficiarios_familia_numerosa.dart';
import 'package:espacio_ciudadano_api/src/model/datos_titulo_familia_numerosa.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'datos_especificos_familia_numerosa.g.dart';

/// DatosEspecificosFamiliaNumerosa
///
/// Properties:
/// * [beneficiarios]
/// * [datosTitulo]
@BuiltValue()
abstract class DatosEspecificosFamiliaNumerosa
    implements
        Built<DatosEspecificosFamiliaNumerosa,
            DatosEspecificosFamiliaNumerosaBuilder> {
  @BuiltValueField(wireName: r'beneficiarios')
  DatosBeneficiariosFamiliaNumerosa? get beneficiarios;

  @BuiltValueField(wireName: r'datos_titulo')
  DatosTituloFamiliaNumerosa? get datosTitulo;

  DatosEspecificosFamiliaNumerosa._();

  factory DatosEspecificosFamiliaNumerosa(
          [void updates(DatosEspecificosFamiliaNumerosaBuilder b)]) =
      _$DatosEspecificosFamiliaNumerosa;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DatosEspecificosFamiliaNumerosaBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DatosEspecificosFamiliaNumerosa> get serializer =>
      _$DatosEspecificosFamiliaNumerosaSerializer();
}

class _$DatosEspecificosFamiliaNumerosaSerializer
    implements PrimitiveSerializer<DatosEspecificosFamiliaNumerosa> {
  @override
  final Iterable<Type> types = const [
    DatosEspecificosFamiliaNumerosa,
    _$DatosEspecificosFamiliaNumerosa
  ];

  @override
  final String wireName = r'DatosEspecificosFamiliaNumerosa';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DatosEspecificosFamiliaNumerosa object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.beneficiarios != null) {
      yield r'beneficiarios';
      yield serializers.serialize(
        object.beneficiarios,
        specifiedType: const FullType(DatosBeneficiariosFamiliaNumerosa),
      );
    }
    if (object.datosTitulo != null) {
      yield r'datos_titulo';
      yield serializers.serialize(
        object.datosTitulo,
        specifiedType: const FullType(DatosTituloFamiliaNumerosa),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    DatosEspecificosFamiliaNumerosa object, {
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
    required DatosEspecificosFamiliaNumerosaBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'beneficiarios':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DatosBeneficiariosFamiliaNumerosa),
          ) as DatosBeneficiariosFamiliaNumerosa;
          result.beneficiarios.replace(valueDes);
          break;
        case r'datos_titulo':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DatosTituloFamiliaNumerosa),
          ) as DatosTituloFamiliaNumerosa;
          result.datosTitulo.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DatosEspecificosFamiliaNumerosa deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DatosEspecificosFamiliaNumerosaBuilder();
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
