//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'tercero_n2_dto.g.dart';

/// TerceroN2Dto
///
/// Properties:
/// * [dni]
/// * [email]
/// * [idTercero]
/// * [telefono]
@BuiltValue()
abstract class TerceroN2Dto
    implements Built<TerceroN2Dto, TerceroN2DtoBuilder> {
  @BuiltValueField(wireName: r'dni')
  String? get dni;

  @BuiltValueField(wireName: r'email')
  String? get email;

  @BuiltValueField(wireName: r'idTercero')
  int? get idTercero;

  @BuiltValueField(wireName: r'telefono')
  int? get telefono;

  TerceroN2Dto._();

  factory TerceroN2Dto([void updates(TerceroN2DtoBuilder b)]) = _$TerceroN2Dto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TerceroN2DtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TerceroN2Dto> get serializer => _$TerceroN2DtoSerializer();
}

class _$TerceroN2DtoSerializer implements PrimitiveSerializer<TerceroN2Dto> {
  @override
  final Iterable<Type> types = const [TerceroN2Dto, _$TerceroN2Dto];

  @override
  final String wireName = r'TerceroN2Dto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TerceroN2Dto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.dni != null) {
      yield r'dni';
      yield serializers.serialize(
        object.dni,
        specifiedType: const FullType(String),
      );
    }
    if (object.email != null) {
      yield r'email';
      yield serializers.serialize(
        object.email,
        specifiedType: const FullType(String),
      );
    }
    if (object.idTercero != null) {
      yield r'idTercero';
      yield serializers.serialize(
        object.idTercero,
        specifiedType: const FullType(int),
      );
    }
    if (object.telefono != null) {
      yield r'telefono';
      yield serializers.serialize(
        object.telefono,
        specifiedType: const FullType(int),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    TerceroN2Dto object, {
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
    required TerceroN2DtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'dni':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.dni = valueDes;
          break;
        case r'email':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.email = valueDes;
          break;
        case r'idTercero':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.idTercero = valueDes;
          break;
        case r'telefono':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
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
  TerceroN2Dto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TerceroN2DtoBuilder();
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
