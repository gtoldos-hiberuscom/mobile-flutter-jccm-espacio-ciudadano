//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'informacion_adicional_dto.g.dart';

/// InformacionAdicionalDto
///
/// Properties:
/// * [clave]
/// * [valor]
@BuiltValue()
abstract class InformacionAdicionalDto
    implements Built<InformacionAdicionalDto, InformacionAdicionalDtoBuilder> {
  @BuiltValueField(wireName: r'clave')
  String? get clave;

  @BuiltValueField(wireName: r'valor')
  String? get valor;

  InformacionAdicionalDto._();

  factory InformacionAdicionalDto(
          [void updates(InformacionAdicionalDtoBuilder b)]) =
      _$InformacionAdicionalDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(InformacionAdicionalDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<InformacionAdicionalDto> get serializer =>
      _$InformacionAdicionalDtoSerializer();
}

class _$InformacionAdicionalDtoSerializer
    implements PrimitiveSerializer<InformacionAdicionalDto> {
  @override
  final Iterable<Type> types = const [
    InformacionAdicionalDto,
    _$InformacionAdicionalDto
  ];

  @override
  final String wireName = r'InformacionAdicionalDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    InformacionAdicionalDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.clave != null) {
      yield r'clave';
      yield serializers.serialize(
        object.clave,
        specifiedType: const FullType(String),
      );
    }
    if (object.valor != null) {
      yield r'valor';
      yield serializers.serialize(
        object.valor,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    InformacionAdicionalDto object, {
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
    required InformacionAdicionalDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'clave':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.clave = valueDes;
          break;
        case r'valor':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.valor = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  InformacionAdicionalDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = InformacionAdicionalDtoBuilder();
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
