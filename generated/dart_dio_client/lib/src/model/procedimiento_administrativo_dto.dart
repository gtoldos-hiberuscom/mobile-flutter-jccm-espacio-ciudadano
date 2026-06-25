//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:espacio_ciudadano_api/src/model/informacion_adicional_dto.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'procedimiento_administrativo_dto.g.dart';

/// ProcedimientoAdministrativoDto
///
/// Properties:
/// * [informacionAdicional]
@BuiltValue()
abstract class ProcedimientoAdministrativoDto
    implements
        Built<ProcedimientoAdministrativoDto,
            ProcedimientoAdministrativoDtoBuilder> {
  @BuiltValueField(wireName: r'informacionAdicional')
  BuiltList<InformacionAdicionalDto>? get informacionAdicional;

  ProcedimientoAdministrativoDto._();

  factory ProcedimientoAdministrativoDto(
          [void updates(ProcedimientoAdministrativoDtoBuilder b)]) =
      _$ProcedimientoAdministrativoDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProcedimientoAdministrativoDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProcedimientoAdministrativoDto> get serializer =>
      _$ProcedimientoAdministrativoDtoSerializer();
}

class _$ProcedimientoAdministrativoDtoSerializer
    implements PrimitiveSerializer<ProcedimientoAdministrativoDto> {
  @override
  final Iterable<Type> types = const [
    ProcedimientoAdministrativoDto,
    _$ProcedimientoAdministrativoDto
  ];

  @override
  final String wireName = r'ProcedimientoAdministrativoDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProcedimientoAdministrativoDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.informacionAdicional != null) {
      yield r'informacionAdicional';
      yield serializers.serialize(
        object.informacionAdicional,
        specifiedType:
            const FullType(BuiltList, [FullType(InformacionAdicionalDto)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ProcedimientoAdministrativoDto object, {
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
    required ProcedimientoAdministrativoDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'informacionAdicional':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType(BuiltList, [FullType(InformacionAdicionalDto)]),
          ) as BuiltList<InformacionAdicionalDto>;
          result.informacionAdicional.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ProcedimientoAdministrativoDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProcedimientoAdministrativoDtoBuilder();
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
