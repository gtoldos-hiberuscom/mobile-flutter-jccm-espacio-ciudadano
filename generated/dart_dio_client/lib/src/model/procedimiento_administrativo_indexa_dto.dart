//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'procedimiento_administrativo_indexa_dto.g.dart';

/// ProcedimientoAdministrativoIndexaDto
///
/// Properties:
/// * [denominacion]
/// * [idFicha]
@BuiltValue()
abstract class ProcedimientoAdministrativoIndexaDto
    implements
        Built<ProcedimientoAdministrativoIndexaDto,
            ProcedimientoAdministrativoIndexaDtoBuilder> {
  @BuiltValueField(wireName: r'denominacion')
  String? get denominacion;

  @BuiltValueField(wireName: r'idFicha')
  String? get idFicha;

  ProcedimientoAdministrativoIndexaDto._();

  factory ProcedimientoAdministrativoIndexaDto(
          [void updates(ProcedimientoAdministrativoIndexaDtoBuilder b)]) =
      _$ProcedimientoAdministrativoIndexaDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProcedimientoAdministrativoIndexaDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProcedimientoAdministrativoIndexaDto> get serializer =>
      _$ProcedimientoAdministrativoIndexaDtoSerializer();
}

class _$ProcedimientoAdministrativoIndexaDtoSerializer
    implements PrimitiveSerializer<ProcedimientoAdministrativoIndexaDto> {
  @override
  final Iterable<Type> types = const [
    ProcedimientoAdministrativoIndexaDto,
    _$ProcedimientoAdministrativoIndexaDto
  ];

  @override
  final String wireName = r'ProcedimientoAdministrativoIndexaDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProcedimientoAdministrativoIndexaDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.denominacion != null) {
      yield r'denominacion';
      yield serializers.serialize(
        object.denominacion,
        specifiedType: const FullType(String),
      );
    }
    if (object.idFicha != null) {
      yield r'idFicha';
      yield serializers.serialize(
        object.idFicha,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ProcedimientoAdministrativoIndexaDto object, {
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
    required ProcedimientoAdministrativoIndexaDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'denominacion':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.denominacion = valueDes;
          break;
        case r'idFicha':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.idFicha = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ProcedimientoAdministrativoIndexaDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProcedimientoAdministrativoIndexaDtoBuilder();
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
