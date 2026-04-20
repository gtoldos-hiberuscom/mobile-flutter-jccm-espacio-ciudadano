//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'dtdgtlistadovehiculosreq.g.dart';

/// DTDGTLISTADOVEHICULOSREQ
///
/// Properties:
/// * [docu]
/// * [documentofuncionario]
/// * [idaut]
/// * [nombrefuncionario]
/// * [proc]
/// * [tipo]
/// * [tipodoc]
@BuiltValue()
abstract class DTDGTLISTADOVEHICULOSREQ
    implements
        Built<DTDGTLISTADOVEHICULOSREQ, DTDGTLISTADOVEHICULOSREQBuilder> {
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

  @BuiltValueField(wireName: r'tipo')
  String? get tipo;

  @BuiltValueField(wireName: r'tipodoc')
  String? get tipodoc;

  DTDGTLISTADOVEHICULOSREQ._();

  factory DTDGTLISTADOVEHICULOSREQ(
          [void updates(DTDGTLISTADOVEHICULOSREQBuilder b)]) =
      _$DTDGTLISTADOVEHICULOSREQ;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DTDGTLISTADOVEHICULOSREQBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DTDGTLISTADOVEHICULOSREQ> get serializer =>
      _$DTDGTLISTADOVEHICULOSREQSerializer();
}

class _$DTDGTLISTADOVEHICULOSREQSerializer
    implements PrimitiveSerializer<DTDGTLISTADOVEHICULOSREQ> {
  @override
  final Iterable<Type> types = const [
    DTDGTLISTADOVEHICULOSREQ,
    _$DTDGTLISTADOVEHICULOSREQ
  ];

  @override
  final String wireName = r'DTDGTLISTADOVEHICULOSREQ';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DTDGTLISTADOVEHICULOSREQ object, {
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
    DTDGTLISTADOVEHICULOSREQ object, {
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
    required DTDGTLISTADOVEHICULOSREQBuilder result,
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
  DTDGTLISTADOVEHICULOSREQ deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DTDGTLISTADOVEHICULOSREQBuilder();
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
