//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'contacto_registro_poblacional_request_dto.g.dart';

/// ContactoRegistroPoblacionalRequestDto
///
/// Properties:
/// * [correo] 
/// * [telefono] 
@BuiltValue()
abstract class ContactoRegistroPoblacionalRequestDto implements Built<ContactoRegistroPoblacionalRequestDto, ContactoRegistroPoblacionalRequestDtoBuilder> {
  @BuiltValueField(wireName: r'correo')
  String? get correo;

  @BuiltValueField(wireName: r'telefono')
  String? get telefono;

  ContactoRegistroPoblacionalRequestDto._();

  factory ContactoRegistroPoblacionalRequestDto([void updates(ContactoRegistroPoblacionalRequestDtoBuilder b)]) = _$ContactoRegistroPoblacionalRequestDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ContactoRegistroPoblacionalRequestDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ContactoRegistroPoblacionalRequestDto> get serializer => _$ContactoRegistroPoblacionalRequestDtoSerializer();
}

class _$ContactoRegistroPoblacionalRequestDtoSerializer implements PrimitiveSerializer<ContactoRegistroPoblacionalRequestDto> {
  @override
  final Iterable<Type> types = const [ContactoRegistroPoblacionalRequestDto, _$ContactoRegistroPoblacionalRequestDto];

  @override
  final String wireName = r'ContactoRegistroPoblacionalRequestDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ContactoRegistroPoblacionalRequestDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.correo != null) {
      yield r'correo';
      yield serializers.serialize(
        object.correo,
        specifiedType: const FullType(String),
      );
    }
    if (object.telefono != null) {
      yield r'telefono';
      yield serializers.serialize(
        object.telefono,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ContactoRegistroPoblacionalRequestDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ContactoRegistroPoblacionalRequestDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'correo':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.correo = valueDes;
          break;
        case r'telefono':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.telefono = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ContactoRegistroPoblacionalRequestDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ContactoRegistroPoblacionalRequestDtoBuilder();
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

