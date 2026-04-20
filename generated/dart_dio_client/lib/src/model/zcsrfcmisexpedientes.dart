//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'zcsrfcmisexpedientes.g.dart';

/// ZCSRFCMISEXPEDIENTES
///
/// Properties:
/// * [pdescproc] 
/// * [pestado] 
/// * [pfechadesde] 
/// * [pfechahasta] 
/// * [pnumdoc] 
@BuiltValue()
abstract class ZCSRFCMISEXPEDIENTES implements Built<ZCSRFCMISEXPEDIENTES, ZCSRFCMISEXPEDIENTESBuilder> {
  @BuiltValueField(wireName: r'pdescproc')
  String? get pdescproc;

  @BuiltValueField(wireName: r'pestado')
  String? get pestado;

  @BuiltValueField(wireName: r'pfechadesde')
  String? get pfechadesde;

  @BuiltValueField(wireName: r'pfechahasta')
  String? get pfechahasta;

  @BuiltValueField(wireName: r'pnumdoc')
  String get pnumdoc;

  ZCSRFCMISEXPEDIENTES._();

  factory ZCSRFCMISEXPEDIENTES([void updates(ZCSRFCMISEXPEDIENTESBuilder b)]) = _$ZCSRFCMISEXPEDIENTES;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ZCSRFCMISEXPEDIENTESBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ZCSRFCMISEXPEDIENTES> get serializer => _$ZCSRFCMISEXPEDIENTESSerializer();
}

class _$ZCSRFCMISEXPEDIENTESSerializer implements PrimitiveSerializer<ZCSRFCMISEXPEDIENTES> {
  @override
  final Iterable<Type> types = const [ZCSRFCMISEXPEDIENTES, _$ZCSRFCMISEXPEDIENTES];

  @override
  final String wireName = r'ZCSRFCMISEXPEDIENTES';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ZCSRFCMISEXPEDIENTES object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.pdescproc != null) {
      yield r'pdescproc';
      yield serializers.serialize(
        object.pdescproc,
        specifiedType: const FullType(String),
      );
    }
    if (object.pestado != null) {
      yield r'pestado';
      yield serializers.serialize(
        object.pestado,
        specifiedType: const FullType(String),
      );
    }
    if (object.pfechadesde != null) {
      yield r'pfechadesde';
      yield serializers.serialize(
        object.pfechadesde,
        specifiedType: const FullType(String),
      );
    }
    if (object.pfechahasta != null) {
      yield r'pfechahasta';
      yield serializers.serialize(
        object.pfechahasta,
        specifiedType: const FullType(String),
      );
    }
    yield r'pnumdoc';
    yield serializers.serialize(
      object.pnumdoc,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ZCSRFCMISEXPEDIENTES object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ZCSRFCMISEXPEDIENTESBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'pdescproc':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.pdescproc = valueDes;
          break;
        case r'pestado':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.pestado = valueDes;
          break;
        case r'pfechadesde':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.pfechadesde = valueDes;
          break;
        case r'pfechahasta':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.pfechahasta = valueDes;
          break;
        case r'pnumdoc':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.pnumdoc = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ZCSRFCMISEXPEDIENTES deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ZCSRFCMISEXPEDIENTESBuilder();
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

