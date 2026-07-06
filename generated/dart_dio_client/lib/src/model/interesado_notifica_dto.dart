//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:espacio_ciudadano_api/src/model/documento_dto.dart';
import 'package:espacio_ciudadano_api/src/model/medios_aviso_adicionales_dto.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'interesado_notifica_dto.g.dart';

/// InteresadoNotificaDto
///
/// Properties:
/// * [interesado]
/// * [mediosAvisoAdicionales]
/// * [tipoIdentificador]
/// * [valorIdentificador]
@BuiltValue()
abstract class InteresadoNotificaDto
    implements Built<InteresadoNotificaDto, InteresadoNotificaDtoBuilder> {
  @BuiltValueField(wireName: r'interesado')
  DocumentoDto? get interesado;

  @BuiltValueField(wireName: r'mediosAvisoAdicionales')
  MediosAvisoAdicionalesDto? get mediosAvisoAdicionales;

  @BuiltValueField(wireName: r'tipoIdentificador')
  String? get tipoIdentificador;

  @BuiltValueField(wireName: r'valorIdentificador')
  String? get valorIdentificador;

  InteresadoNotificaDto._();

  factory InteresadoNotificaDto(
      [void updates(InteresadoNotificaDtoBuilder b)]) = _$InteresadoNotificaDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(InteresadoNotificaDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<InteresadoNotificaDto> get serializer =>
      _$InteresadoNotificaDtoSerializer();
}

class _$InteresadoNotificaDtoSerializer
    implements PrimitiveSerializer<InteresadoNotificaDto> {
  @override
  final Iterable<Type> types = const [
    InteresadoNotificaDto,
    _$InteresadoNotificaDto
  ];

  @override
  final String wireName = r'InteresadoNotificaDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    InteresadoNotificaDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.interesado != null) {
      yield r'interesado';
      yield serializers.serialize(
        object.interesado,
        specifiedType: const FullType(DocumentoDto),
      );
    }
    if (object.mediosAvisoAdicionales != null) {
      yield r'mediosAvisoAdicionales';
      yield serializers.serialize(
        object.mediosAvisoAdicionales,
        specifiedType: const FullType(MediosAvisoAdicionalesDto),
      );
    }
    if (object.tipoIdentificador != null) {
      yield r'tipoIdentificador';
      yield serializers.serialize(
        object.tipoIdentificador,
        specifiedType: const FullType(String),
      );
    }
    if (object.valorIdentificador != null) {
      yield r'valorIdentificador';
      yield serializers.serialize(
        object.valorIdentificador,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    InteresadoNotificaDto object, {
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
    required InteresadoNotificaDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'interesado':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DocumentoDto),
          ) as DocumentoDto;
          result.interesado.replace(valueDes);
          break;
        case r'mediosAvisoAdicionales':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(MediosAvisoAdicionalesDto),
          ) as MediosAvisoAdicionalesDto;
          result.mediosAvisoAdicionales.replace(valueDes);
          break;
        case r'tipoIdentificador':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.tipoIdentificador = valueDes;
          break;
        case r'valorIdentificador':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.valorIdentificador = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  InteresadoNotificaDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = InteresadoNotificaDtoBuilder();
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
