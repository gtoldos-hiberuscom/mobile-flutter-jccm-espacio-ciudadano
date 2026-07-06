//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'unidad_organica_indexa_dto.g.dart';

/// UnidadOrganicaIndexaDto
///
/// Properties:
/// * [nombre]
@BuiltValue()
abstract class UnidadOrganicaIndexaDto
    implements Built<UnidadOrganicaIndexaDto, UnidadOrganicaIndexaDtoBuilder> {
  @BuiltValueField(wireName: r'nombre')
  String? get nombre;

  UnidadOrganicaIndexaDto._();

  factory UnidadOrganicaIndexaDto(
          [void updates(UnidadOrganicaIndexaDtoBuilder b)]) =
      _$UnidadOrganicaIndexaDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UnidadOrganicaIndexaDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UnidadOrganicaIndexaDto> get serializer =>
      _$UnidadOrganicaIndexaDtoSerializer();
}

class _$UnidadOrganicaIndexaDtoSerializer
    implements PrimitiveSerializer<UnidadOrganicaIndexaDto> {
  @override
  final Iterable<Type> types = const [
    UnidadOrganicaIndexaDto,
    _$UnidadOrganicaIndexaDto
  ];

  @override
  final String wireName = r'UnidadOrganicaIndexaDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UnidadOrganicaIndexaDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.nombre != null) {
      yield r'nombre';
      yield serializers.serialize(
        object.nombre,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    UnidadOrganicaIndexaDto object, {
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
    required UnidadOrganicaIndexaDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'nombre':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.nombre = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  UnidadOrganicaIndexaDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UnidadOrganicaIndexaDtoBuilder();
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
