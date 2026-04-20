//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'zcsvec_response.g.dart';

/// ZCSVECResponse
///
/// Properties:
/// * [certificado] 
/// * [denerror] 
/// * [idtrans] 
/// * [resul] 
/// * [subject] 
/// * [uriformava] 
/// * [uritipofirma] 
@BuiltValue()
abstract class ZCSVECResponse implements Built<ZCSVECResponse, ZCSVECResponseBuilder> {
  @BuiltValueField(wireName: r'certificado')
  String? get certificado;

  @BuiltValueField(wireName: r'denerror')
  String? get denerror;

  @BuiltValueField(wireName: r'idtrans')
  String? get idtrans;

  @BuiltValueField(wireName: r'resul')
  String? get resul;

  @BuiltValueField(wireName: r'subject')
  String? get subject;

  @BuiltValueField(wireName: r'uriformava')
  String? get uriformava;

  @BuiltValueField(wireName: r'uritipofirma')
  String? get uritipofirma;

  ZCSVECResponse._();

  factory ZCSVECResponse([void updates(ZCSVECResponseBuilder b)]) = _$ZCSVECResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ZCSVECResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ZCSVECResponse> get serializer => _$ZCSVECResponseSerializer();
}

class _$ZCSVECResponseSerializer implements PrimitiveSerializer<ZCSVECResponse> {
  @override
  final Iterable<Type> types = const [ZCSVECResponse, _$ZCSVECResponse];

  @override
  final String wireName = r'ZCSVECResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ZCSVECResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.certificado != null) {
      yield r'certificado';
      yield serializers.serialize(
        object.certificado,
        specifiedType: const FullType(String),
      );
    }
    if (object.denerror != null) {
      yield r'denerror';
      yield serializers.serialize(
        object.denerror,
        specifiedType: const FullType(String),
      );
    }
    if (object.idtrans != null) {
      yield r'idtrans';
      yield serializers.serialize(
        object.idtrans,
        specifiedType: const FullType(String),
      );
    }
    if (object.resul != null) {
      yield r'resul';
      yield serializers.serialize(
        object.resul,
        specifiedType: const FullType(String),
      );
    }
    if (object.subject != null) {
      yield r'subject';
      yield serializers.serialize(
        object.subject,
        specifiedType: const FullType(String),
      );
    }
    if (object.uriformava != null) {
      yield r'uriformava';
      yield serializers.serialize(
        object.uriformava,
        specifiedType: const FullType(String),
      );
    }
    if (object.uritipofirma != null) {
      yield r'uritipofirma';
      yield serializers.serialize(
        object.uritipofirma,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ZCSVECResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ZCSVECResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'certificado':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.certificado = valueDes;
          break;
        case r'denerror':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.denerror = valueDes;
          break;
        case r'idtrans':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.idtrans = valueDes;
          break;
        case r'resul':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.resul = valueDes;
          break;
        case r'subject':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.subject = valueDes;
          break;
        case r'uriformava':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.uriformava = valueDes;
          break;
        case r'uritipofirma':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.uritipofirma = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ZCSVECResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ZCSVECResponseBuilder();
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

