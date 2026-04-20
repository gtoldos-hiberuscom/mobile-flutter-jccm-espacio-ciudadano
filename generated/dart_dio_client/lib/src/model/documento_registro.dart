//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'documento_registro.g.dart';

/// DocumentoRegistro
///
/// Properties:
/// * [algoritmo]
/// * [fileSize]
/// * [hash]
/// * [nombre]
@BuiltValue()
abstract class DocumentoRegistro
    implements Built<DocumentoRegistro, DocumentoRegistroBuilder> {
  @BuiltValueField(wireName: r'algoritmo')
  String? get algoritmo;

  @BuiltValueField(wireName: r'fileSize')
  String? get fileSize;

  @BuiltValueField(wireName: r'hash')
  String? get hash;

  @BuiltValueField(wireName: r'nombre')
  String? get nombre;

  DocumentoRegistro._();

  factory DocumentoRegistro([void updates(DocumentoRegistroBuilder b)]) =
      _$DocumentoRegistro;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DocumentoRegistroBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DocumentoRegistro> get serializer =>
      _$DocumentoRegistroSerializer();
}

class _$DocumentoRegistroSerializer
    implements PrimitiveSerializer<DocumentoRegistro> {
  @override
  final Iterable<Type> types = const [DocumentoRegistro, _$DocumentoRegistro];

  @override
  final String wireName = r'DocumentoRegistro';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DocumentoRegistro object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.algoritmo != null) {
      yield r'algoritmo';
      yield serializers.serialize(
        object.algoritmo,
        specifiedType: const FullType(String),
      );
    }
    if (object.fileSize != null) {
      yield r'fileSize';
      yield serializers.serialize(
        object.fileSize,
        specifiedType: const FullType(String),
      );
    }
    if (object.hash != null) {
      yield r'hash';
      yield serializers.serialize(
        object.hash,
        specifiedType: const FullType(String),
      );
    }
    if (object.nombre != null) {
      yield r'nombre';
      yield serializers.serialize(
        object.nombre,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    DocumentoRegistro object, {
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
    required DocumentoRegistroBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'algoritmo':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.algoritmo = valueDes;
          break;
        case r'fileSize':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.fileSize = valueDes;
          break;
        case r'hash':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.hash = valueDes;
          break;
        case r'nombre':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.nombre = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DocumentoRegistro deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DocumentoRegistroBuilder();
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
