//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:espacio_ciudadano_api/src/model/informacion_adicional_dto.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'documento_dto.g.dart';

/// DocumentoDto
///
/// Properties:
/// * [aplicacion]
/// * [id]
/// * [identificador]
/// * [informacionAdicional]
/// * [tipoEntidad]
@BuiltValue()
abstract class DocumentoDto
    implements Built<DocumentoDto, DocumentoDtoBuilder> {
  @BuiltValueField(wireName: r'aplicacion')
  String? get aplicacion;

  @BuiltValueField(wireName: r'id')
  int? get id;

  @BuiltValueField(wireName: r'identificador')
  String? get identificador;

  @BuiltValueField(wireName: r'informacionAdicional')
  BuiltList<InformacionAdicionalDto>? get informacionAdicional;

  @BuiltValueField(wireName: r'tipoEntidad')
  String? get tipoEntidad;

  DocumentoDto._();

  factory DocumentoDto([void updates(DocumentoDtoBuilder b)]) = _$DocumentoDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DocumentoDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DocumentoDto> get serializer => _$DocumentoDtoSerializer();
}

class _$DocumentoDtoSerializer implements PrimitiveSerializer<DocumentoDto> {
  @override
  final Iterable<Type> types = const [DocumentoDto, _$DocumentoDto];

  @override
  final String wireName = r'DocumentoDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DocumentoDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.aplicacion != null) {
      yield r'aplicacion';
      yield serializers.serialize(
        object.aplicacion,
        specifiedType: const FullType(String),
      );
    }
    if (object.id != null) {
      yield r'id';
      yield serializers.serialize(
        object.id,
        specifiedType: const FullType(int),
      );
    }
    if (object.identificador != null) {
      yield r'identificador';
      yield serializers.serialize(
        object.identificador,
        specifiedType: const FullType(String),
      );
    }
    if (object.informacionAdicional != null) {
      yield r'informacionAdicional';
      yield serializers.serialize(
        object.informacionAdicional,
        specifiedType:
            const FullType(BuiltList, [FullType(InformacionAdicionalDto)]),
      );
    }
    if (object.tipoEntidad != null) {
      yield r'tipoEntidad';
      yield serializers.serialize(
        object.tipoEntidad,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    DocumentoDto object, {
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
    required DocumentoDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'aplicacion':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.aplicacion = valueDes;
          break;
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.id = valueDes;
          break;
        case r'identificador':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.identificador = valueDes;
          break;
        case r'informacionAdicional':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType(BuiltList, [FullType(InformacionAdicionalDto)]),
          ) as BuiltList<InformacionAdicionalDto>;
          result.informacionAdicional.replace(valueDes);
          break;
        case r'tipoEntidad':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.tipoEntidad = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DocumentoDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DocumentoDtoBuilder();
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
