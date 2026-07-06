//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'telefono_aviso_dto.g.dart';

/// TelefonoAvisoDto
///
/// Properties:
/// * [telefono]
@BuiltValue()
abstract class TelefonoAvisoDto
    implements Built<TelefonoAvisoDto, TelefonoAvisoDtoBuilder> {
  @BuiltValueField(wireName: r'telefono')
  String? get telefono;

  TelefonoAvisoDto._();

  factory TelefonoAvisoDto([void updates(TelefonoAvisoDtoBuilder b)]) =
      _$TelefonoAvisoDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TelefonoAvisoDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TelefonoAvisoDto> get serializer =>
      _$TelefonoAvisoDtoSerializer();
}

class _$TelefonoAvisoDtoSerializer
    implements PrimitiveSerializer<TelefonoAvisoDto> {
  @override
  final Iterable<Type> types = const [TelefonoAvisoDto, _$TelefonoAvisoDto];

  @override
  final String wireName = r'TelefonoAvisoDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TelefonoAvisoDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
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
    TelefonoAvisoDto object, {
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
    required TelefonoAvisoDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
  TelefonoAvisoDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TelefonoAvisoDtoBuilder();
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
