//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:espacio_ciudadano_api/src/model/informacion_adicional_dto.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'unidad_organica_dto.g.dart';

/// UnidadOrganicaDto
///
/// Properties:
/// * [informacionAdicional]
/// * [sistema]
@BuiltValue()
abstract class UnidadOrganicaDto
    implements Built<UnidadOrganicaDto, UnidadOrganicaDtoBuilder> {
  @BuiltValueField(wireName: r'informacionAdicional')
  BuiltList<InformacionAdicionalDto>? get informacionAdicional;

  @BuiltValueField(wireName: r'sistema')
  String? get sistema;

  UnidadOrganicaDto._();

  factory UnidadOrganicaDto([void updates(UnidadOrganicaDtoBuilder b)]) =
      _$UnidadOrganicaDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UnidadOrganicaDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UnidadOrganicaDto> get serializer =>
      _$UnidadOrganicaDtoSerializer();
}

class _$UnidadOrganicaDtoSerializer
    implements PrimitiveSerializer<UnidadOrganicaDto> {
  @override
  final Iterable<Type> types = const [UnidadOrganicaDto, _$UnidadOrganicaDto];

  @override
  final String wireName = r'UnidadOrganicaDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UnidadOrganicaDto object, {
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
    if (object.sistema != null) {
      yield r'sistema';
      yield serializers.serialize(
        object.sistema,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    UnidadOrganicaDto object, {
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
    required UnidadOrganicaDtoBuilder result,
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
        case r'sistema':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.sistema = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  UnidadOrganicaDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UnidadOrganicaDtoBuilder();
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
