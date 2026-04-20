//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'zcsvec.g.dart';

/// ZCSVEC
///
/// Properties:
/// * [codtdf] 
/// * [coduo] 
/// * [datfirma] 
/// * [desdoc] 
/// * [firma] 
/// * [idaplic] 
/// * [idprop] 
/// * [origen] 
/// * [tipo] 
/// * [tipodoc] 
@BuiltValue()
abstract class ZCSVEC implements Built<ZCSVEC, ZCSVECBuilder> {
  @BuiltValueField(wireName: r'codtdf')
  String get codtdf;

  @BuiltValueField(wireName: r'coduo')
  String get coduo;

  @BuiltValueField(wireName: r'datfirma')
  String get datfirma;

  @BuiltValueField(wireName: r'desdoc')
  String get desdoc;

  @BuiltValueField(wireName: r'firma')
  String get firma;

  @BuiltValueField(wireName: r'idaplic')
  String get idaplic;

  @BuiltValueField(wireName: r'idprop')
  String get idprop;

  @BuiltValueField(wireName: r'origen')
  String get origen;

  @BuiltValueField(wireName: r'tipo')
  String get tipo;

  @BuiltValueField(wireName: r'tipodoc')
  String get tipodoc;

  ZCSVEC._();

  factory ZCSVEC([void updates(ZCSVECBuilder b)]) = _$ZCSVEC;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ZCSVECBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ZCSVEC> get serializer => _$ZCSVECSerializer();
}

class _$ZCSVECSerializer implements PrimitiveSerializer<ZCSVEC> {
  @override
  final Iterable<Type> types = const [ZCSVEC, _$ZCSVEC];

  @override
  final String wireName = r'ZCSVEC';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ZCSVEC object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'codtdf';
    yield serializers.serialize(
      object.codtdf,
      specifiedType: const FullType(String),
    );
    yield r'coduo';
    yield serializers.serialize(
      object.coduo,
      specifiedType: const FullType(String),
    );
    yield r'datfirma';
    yield serializers.serialize(
      object.datfirma,
      specifiedType: const FullType(String),
    );
    yield r'desdoc';
    yield serializers.serialize(
      object.desdoc,
      specifiedType: const FullType(String),
    );
    yield r'firma';
    yield serializers.serialize(
      object.firma,
      specifiedType: const FullType(String),
    );
    yield r'idaplic';
    yield serializers.serialize(
      object.idaplic,
      specifiedType: const FullType(String),
    );
    yield r'idprop';
    yield serializers.serialize(
      object.idprop,
      specifiedType: const FullType(String),
    );
    yield r'origen';
    yield serializers.serialize(
      object.origen,
      specifiedType: const FullType(String),
    );
    yield r'tipo';
    yield serializers.serialize(
      object.tipo,
      specifiedType: const FullType(String),
    );
    yield r'tipodoc';
    yield serializers.serialize(
      object.tipodoc,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ZCSVEC object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ZCSVECBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'codtdf':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.codtdf = valueDes;
          break;
        case r'coduo':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.coduo = valueDes;
          break;
        case r'datfirma':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.datfirma = valueDes;
          break;
        case r'desdoc':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.desdoc = valueDes;
          break;
        case r'firma':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.firma = valueDes;
          break;
        case r'idaplic':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.idaplic = valueDes;
          break;
        case r'idprop':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.idprop = valueDes;
          break;
        case r'origen':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.origen = valueDes;
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
  ZCSVEC deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ZCSVECBuilder();
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

