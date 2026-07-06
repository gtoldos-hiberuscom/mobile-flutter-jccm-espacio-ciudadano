//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'email_aviso_dto.g.dart';

/// EmailAvisoDto
///
/// Properties:
/// * [email]
@BuiltValue()
abstract class EmailAvisoDto
    implements Built<EmailAvisoDto, EmailAvisoDtoBuilder> {
  @BuiltValueField(wireName: r'email')
  String? get email;

  EmailAvisoDto._();

  factory EmailAvisoDto([void updates(EmailAvisoDtoBuilder b)]) =
      _$EmailAvisoDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(EmailAvisoDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<EmailAvisoDto> get serializer =>
      _$EmailAvisoDtoSerializer();
}

class _$EmailAvisoDtoSerializer implements PrimitiveSerializer<EmailAvisoDto> {
  @override
  final Iterable<Type> types = const [EmailAvisoDto, _$EmailAvisoDto];

  @override
  final String wireName = r'EmailAvisoDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    EmailAvisoDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.email != null) {
      yield r'email';
      yield serializers.serialize(
        object.email,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    EmailAvisoDto object, {
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
    required EmailAvisoDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'email':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.email = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  EmailAvisoDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = EmailAvisoDtoBuilder();
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
