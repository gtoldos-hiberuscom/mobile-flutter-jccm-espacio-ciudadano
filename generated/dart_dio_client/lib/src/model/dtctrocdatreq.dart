//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'dtctrocdatreq.g.dart';

/// DTCTROCDATREQ
///
/// Properties:
/// * [docu] 
/// * [documentofuncionario] 
/// * [idaut] 
/// * [nombrefuncionario] 
/// * [proc] 
/// * [tipdoc] 
/// * [tipo] 
@BuiltValue()
abstract class DTCTROCDATREQ implements Built<DTCTROCDATREQ, DTCTROCDATREQBuilder> {
  @BuiltValueField(wireName: r'docu')
  String? get docu;

  @BuiltValueField(wireName: r'documentofuncionario')
  String? get documentofuncionario;

  @BuiltValueField(wireName: r'idaut')
  String? get idaut;

  @BuiltValueField(wireName: r'nombrefuncionario')
  String? get nombrefuncionario;

  @BuiltValueField(wireName: r'proc')
  String? get proc;

  @BuiltValueField(wireName: r'tipdoc')
  String? get tipdoc;

  @BuiltValueField(wireName: r'tipo')
  String? get tipo;

  DTCTROCDATREQ._();

  factory DTCTROCDATREQ([void updates(DTCTROCDATREQBuilder b)]) = _$DTCTROCDATREQ;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DTCTROCDATREQBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DTCTROCDATREQ> get serializer => _$DTCTROCDATREQSerializer();
}

class _$DTCTROCDATREQSerializer implements PrimitiveSerializer<DTCTROCDATREQ> {
  @override
  final Iterable<Type> types = const [DTCTROCDATREQ, _$DTCTROCDATREQ];

  @override
  final String wireName = r'DTCTROCDATREQ';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DTCTROCDATREQ object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.docu != null) {
      yield r'docu';
      yield serializers.serialize(
        object.docu,
        specifiedType: const FullType(String),
      );
    }
    if (object.documentofuncionario != null) {
      yield r'documentofuncionario';
      yield serializers.serialize(
        object.documentofuncionario,
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
    if (object.nombrefuncionario != null) {
      yield r'nombrefuncionario';
      yield serializers.serialize(
        object.nombrefuncionario,
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
    if (object.tipdoc != null) {
      yield r'tipdoc';
      yield serializers.serialize(
        object.tipdoc,
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
  }

  @override
  Object serialize(
    Serializers serializers,
    DTCTROCDATREQ object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DTCTROCDATREQBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'docu':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.docu = valueDes;
          break;
        case r'documentofuncionario':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.documentofuncionario = valueDes;
          break;
        case r'idaut':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.idaut = valueDes;
          break;
        case r'nombrefuncionario':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.nombrefuncionario = valueDes;
          break;
        case r'proc':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.proc = valueDes;
          break;
        case r'tipdoc':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.tipdoc = valueDes;
          break;
        case r'tipo':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.tipo = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DTCTROCDATREQ deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DTCTROCDATREQBuilder();
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

