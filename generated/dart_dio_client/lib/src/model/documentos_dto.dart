//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:espacio_ciudadano_api/src/model/documento_dto.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'documentos_dto.g.dart';

/// DocumentosDto
///
/// Properties:
/// * [documento]
/// * [identificadorReferencia]
/// * [orden]
@BuiltValue()
abstract class DocumentosDto
    implements Built<DocumentosDto, DocumentosDtoBuilder> {
  @BuiltValueField(wireName: r'documento')
  DocumentoDto? get documento;

  @BuiltValueField(wireName: r'identificadorReferencia')
  String? get identificadorReferencia;

  @BuiltValueField(wireName: r'orden')
  int? get orden;

  DocumentosDto._();

  factory DocumentosDto([void updates(DocumentosDtoBuilder b)]) =
      _$DocumentosDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DocumentosDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DocumentosDto> get serializer =>
      _$DocumentosDtoSerializer();
}

class _$DocumentosDtoSerializer implements PrimitiveSerializer<DocumentosDto> {
  @override
  final Iterable<Type> types = const [DocumentosDto, _$DocumentosDto];

  @override
  final String wireName = r'DocumentosDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DocumentosDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.documento != null) {
      yield r'documento';
      yield serializers.serialize(
        object.documento,
        specifiedType: const FullType(DocumentoDto),
      );
    }
    if (object.identificadorReferencia != null) {
      yield r'identificadorReferencia';
      yield serializers.serialize(
        object.identificadorReferencia,
        specifiedType: const FullType(String),
      );
    }
    if (object.orden != null) {
      yield r'orden';
      yield serializers.serialize(
        object.orden,
        specifiedType: const FullType(int),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    DocumentosDto object, {
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
    required DocumentosDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'documento':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DocumentoDto),
          ) as DocumentoDto;
          result.documento.replace(valueDes);
          break;
        case r'identificadorReferencia':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.identificadorReferencia = valueDes;
          break;
        case r'orden':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.orden = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DocumentosDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DocumentosDtoBuilder();
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
