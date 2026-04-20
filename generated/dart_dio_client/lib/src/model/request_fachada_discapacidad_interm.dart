//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'request_fachada_discapacidad_interm.g.dart';

/// RequestFachadaDiscapacidadInterm
///
/// Properties:
/// * [docFuncionario] 
/// * [docu] 
/// * [nombreFuncionario] 
/// * [tipodoc] 
@BuiltValue()
abstract class RequestFachadaDiscapacidadInterm implements Built<RequestFachadaDiscapacidadInterm, RequestFachadaDiscapacidadIntermBuilder> {
  @BuiltValueField(wireName: r'doc_funcionario')
  String? get docFuncionario;

  @BuiltValueField(wireName: r'docu')
  String? get docu;

  @BuiltValueField(wireName: r'nombre_funcionario')
  String? get nombreFuncionario;

  @BuiltValueField(wireName: r'tipodoc')
  String? get tipodoc;

  RequestFachadaDiscapacidadInterm._();

  factory RequestFachadaDiscapacidadInterm([void updates(RequestFachadaDiscapacidadIntermBuilder b)]) = _$RequestFachadaDiscapacidadInterm;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RequestFachadaDiscapacidadIntermBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RequestFachadaDiscapacidadInterm> get serializer => _$RequestFachadaDiscapacidadIntermSerializer();
}

class _$RequestFachadaDiscapacidadIntermSerializer implements PrimitiveSerializer<RequestFachadaDiscapacidadInterm> {
  @override
  final Iterable<Type> types = const [RequestFachadaDiscapacidadInterm, _$RequestFachadaDiscapacidadInterm];

  @override
  final String wireName = r'RequestFachadaDiscapacidadInterm';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RequestFachadaDiscapacidadInterm object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.docFuncionario != null) {
      yield r'doc_funcionario';
      yield serializers.serialize(
        object.docFuncionario,
        specifiedType: const FullType(String),
      );
    }
    if (object.docu != null) {
      yield r'docu';
      yield serializers.serialize(
        object.docu,
        specifiedType: const FullType(String),
      );
    }
    if (object.nombreFuncionario != null) {
      yield r'nombre_funcionario';
      yield serializers.serialize(
        object.nombreFuncionario,
        specifiedType: const FullType(String),
      );
    }
    if (object.tipodoc != null) {
      yield r'tipodoc';
      yield serializers.serialize(
        object.tipodoc,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    RequestFachadaDiscapacidadInterm object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required RequestFachadaDiscapacidadIntermBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'doc_funcionario':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.docFuncionario = valueDes;
          break;
        case r'docu':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.docu = valueDes;
          break;
        case r'nombre_funcionario':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.nombreFuncionario = valueDes;
          break;
        case r'tipodoc':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.tipodoc = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  RequestFachadaDiscapacidadInterm deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RequestFachadaDiscapacidadIntermBuilder();
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

