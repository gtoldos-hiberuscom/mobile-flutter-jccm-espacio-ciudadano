//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'request_fachada_familia_numerosa_interm.g.dart';

/// RequestFachadaFamiliaNumerosaInterm
///
/// Properties:
/// * [docFuncionario]
/// * [docu]
/// * [idaut]
/// * [nombreFuncionario]
/// * [proc]
/// * [tipo]
/// * [tipodoc]
@BuiltValue()
abstract class RequestFachadaFamiliaNumerosaInterm
    implements
        Built<RequestFachadaFamiliaNumerosaInterm,
            RequestFachadaFamiliaNumerosaIntermBuilder> {
  @BuiltValueField(wireName: r'doc_funcionario')
  String? get docFuncionario;

  @BuiltValueField(wireName: r'docu')
  String? get docu;

  @BuiltValueField(wireName: r'idaut')
  String? get idaut;

  @BuiltValueField(wireName: r'nombre_funcionario')
  String? get nombreFuncionario;

  @BuiltValueField(wireName: r'proc')
  String? get proc;

  @BuiltValueField(wireName: r'tipo')
  String? get tipo;

  @BuiltValueField(wireName: r'tipodoc')
  String? get tipodoc;

  RequestFachadaFamiliaNumerosaInterm._();

  factory RequestFachadaFamiliaNumerosaInterm(
          [void updates(RequestFachadaFamiliaNumerosaIntermBuilder b)]) =
      _$RequestFachadaFamiliaNumerosaInterm;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RequestFachadaFamiliaNumerosaIntermBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RequestFachadaFamiliaNumerosaInterm> get serializer =>
      _$RequestFachadaFamiliaNumerosaIntermSerializer();
}

class _$RequestFachadaFamiliaNumerosaIntermSerializer
    implements PrimitiveSerializer<RequestFachadaFamiliaNumerosaInterm> {
  @override
  final Iterable<Type> types = const [
    RequestFachadaFamiliaNumerosaInterm,
    _$RequestFachadaFamiliaNumerosaInterm
  ];

  @override
  final String wireName = r'RequestFachadaFamiliaNumerosaInterm';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RequestFachadaFamiliaNumerosaInterm object, {
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
    if (object.idaut != null) {
      yield r'idaut';
      yield serializers.serialize(
        object.idaut,
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
    if (object.proc != null) {
      yield r'proc';
      yield serializers.serialize(
        object.proc,
        specifiedType: const FullType(String),
      );
    }
    if (object.tipo != null) {
      yield r'tipo';
      yield serializers.serialize(
        object.tipo,
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
    RequestFachadaFamiliaNumerosaInterm object, {
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
    required RequestFachadaFamiliaNumerosaIntermBuilder result,
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
        case r'idaut':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.idaut = valueDes;
          break;
        case r'nombre_funcionario':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.nombreFuncionario = valueDes;
          break;
        case r'proc':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.proc = valueDes;
          break;
        case r'tipo':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.tipo = valueDes;
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
  RequestFachadaFamiliaNumerosaInterm deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RequestFachadaFamiliaNumerosaIntermBuilder();
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
