//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:espacio_ciudadano_api/src/model/telefono_aviso_dto.dart';
import 'package:built_collection/built_collection.dart';
import 'package:espacio_ciudadano_api/src/model/email_aviso_dto.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'medios_aviso_adicionales_dto.g.dart';

/// MediosAvisoAdicionalesDto
///
/// Properties:
/// * [emailsAviso]
/// * [telefonosAviso]
@BuiltValue()
abstract class MediosAvisoAdicionalesDto
    implements
        Built<MediosAvisoAdicionalesDto, MediosAvisoAdicionalesDtoBuilder> {
  @BuiltValueField(wireName: r'emailsAviso')
  BuiltList<EmailAvisoDto>? get emailsAviso;

  @BuiltValueField(wireName: r'telefonosAviso')
  BuiltList<TelefonoAvisoDto>? get telefonosAviso;

  MediosAvisoAdicionalesDto._();

  factory MediosAvisoAdicionalesDto(
          [void updates(MediosAvisoAdicionalesDtoBuilder b)]) =
      _$MediosAvisoAdicionalesDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MediosAvisoAdicionalesDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MediosAvisoAdicionalesDto> get serializer =>
      _$MediosAvisoAdicionalesDtoSerializer();
}

class _$MediosAvisoAdicionalesDtoSerializer
    implements PrimitiveSerializer<MediosAvisoAdicionalesDto> {
  @override
  final Iterable<Type> types = const [
    MediosAvisoAdicionalesDto,
    _$MediosAvisoAdicionalesDto
  ];

  @override
  final String wireName = r'MediosAvisoAdicionalesDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MediosAvisoAdicionalesDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.emailsAviso != null) {
      yield r'emailsAviso';
      yield serializers.serialize(
        object.emailsAviso,
        specifiedType: const FullType(BuiltList, [FullType(EmailAvisoDto)]),
      );
    }
    if (object.telefonosAviso != null) {
      yield r'telefonosAviso';
      yield serializers.serialize(
        object.telefonosAviso,
        specifiedType: const FullType(BuiltList, [FullType(TelefonoAvisoDto)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    MediosAvisoAdicionalesDto object, {
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
    required MediosAvisoAdicionalesDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'emailsAviso':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(EmailAvisoDto)]),
          ) as BuiltList<EmailAvisoDto>;
          result.emailsAviso.replace(valueDes);
          break;
        case r'telefonosAviso':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType(BuiltList, [FullType(TelefonoAvisoDto)]),
          ) as BuiltList<TelefonoAvisoDto>;
          result.telefonosAviso.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MediosAvisoAdicionalesDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MediosAvisoAdicionalesDtoBuilder();
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
