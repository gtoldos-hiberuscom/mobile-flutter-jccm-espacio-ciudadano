//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'expediente_dto.g.dart';

/// ExpedienteDto
///
/// Properties:
/// * [identificador]
@BuiltValue()
abstract class ExpedienteDto
    implements Built<ExpedienteDto, ExpedienteDtoBuilder> {
  @BuiltValueField(wireName: r'identificador')
  String? get identificador;

  ExpedienteDto._();

  factory ExpedienteDto([void updates(ExpedienteDtoBuilder b)]) =
      _$ExpedienteDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ExpedienteDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ExpedienteDto> get serializer =>
      _$ExpedienteDtoSerializer();
}

class _$ExpedienteDtoSerializer implements PrimitiveSerializer<ExpedienteDto> {
  @override
  final Iterable<Type> types = const [ExpedienteDto, _$ExpedienteDto];

  @override
  final String wireName = r'ExpedienteDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ExpedienteDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.identificador != null) {
      yield r'identificador';
      yield serializers.serialize(
        object.identificador,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ExpedienteDto object, {
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
    required ExpedienteDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'identificador':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.identificador = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ExpedienteDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ExpedienteDtoBuilder();
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
