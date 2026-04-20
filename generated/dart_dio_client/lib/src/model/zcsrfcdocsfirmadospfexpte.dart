//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:espacio_ciudadano_api/src/model/etreturn.dart';
import 'package:espacio_ciudadano_api/src/model/etlistdocs.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'zcsrfcdocsfirmadospfexpte.g.dart';

/// ZCSRFCDOCSFIRMADOSPFEXPTE
///
/// Properties:
/// * [etlistdocs]
/// * [etreturn]
/// * [ipclase]
/// * [ipejeexp]
/// * [ipnumexp]
/// * [iprefdoc]
@BuiltValue()
abstract class ZCSRFCDOCSFIRMADOSPFEXPTE
    implements
        Built<ZCSRFCDOCSFIRMADOSPFEXPTE, ZCSRFCDOCSFIRMADOSPFEXPTEBuilder> {
  @BuiltValueField(wireName: r'etlistdocs')
  ETLISTDOCS? get etlistdocs;

  @BuiltValueField(wireName: r'etreturn')
  ETRETURN? get etreturn;

  @BuiltValueField(wireName: r'ipclase')
  String? get ipclase;

  @BuiltValueField(wireName: r'ipejeexp')
  String? get ipejeexp;

  @BuiltValueField(wireName: r'ipnumexp')
  String? get ipnumexp;

  @BuiltValueField(wireName: r'iprefdoc')
  String? get iprefdoc;

  ZCSRFCDOCSFIRMADOSPFEXPTE._();

  factory ZCSRFCDOCSFIRMADOSPFEXPTE(
          [void updates(ZCSRFCDOCSFIRMADOSPFEXPTEBuilder b)]) =
      _$ZCSRFCDOCSFIRMADOSPFEXPTE;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ZCSRFCDOCSFIRMADOSPFEXPTEBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ZCSRFCDOCSFIRMADOSPFEXPTE> get serializer =>
      _$ZCSRFCDOCSFIRMADOSPFEXPTESerializer();
}

class _$ZCSRFCDOCSFIRMADOSPFEXPTESerializer
    implements PrimitiveSerializer<ZCSRFCDOCSFIRMADOSPFEXPTE> {
  @override
  final Iterable<Type> types = const [
    ZCSRFCDOCSFIRMADOSPFEXPTE,
    _$ZCSRFCDOCSFIRMADOSPFEXPTE
  ];

  @override
  final String wireName = r'ZCSRFCDOCSFIRMADOSPFEXPTE';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ZCSRFCDOCSFIRMADOSPFEXPTE object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.etlistdocs != null) {
      yield r'etlistdocs';
      yield serializers.serialize(
        object.etlistdocs,
        specifiedType: const FullType(ETLISTDOCS),
      );
    }
    if (object.etreturn != null) {
      yield r'etreturn';
      yield serializers.serialize(
        object.etreturn,
        specifiedType: const FullType(ETRETURN),
      );
    }
    if (object.ipclase != null) {
      yield r'ipclase';
      yield serializers.serialize(
        object.ipclase,
        specifiedType: const FullType(String),
      );
    }
    if (object.ipejeexp != null) {
      yield r'ipejeexp';
      yield serializers.serialize(
        object.ipejeexp,
        specifiedType: const FullType(String),
      );
    }
    if (object.ipnumexp != null) {
      yield r'ipnumexp';
      yield serializers.serialize(
        object.ipnumexp,
        specifiedType: const FullType(String),
      );
    }
    if (object.iprefdoc != null) {
      yield r'iprefdoc';
      yield serializers.serialize(
        object.iprefdoc,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ZCSRFCDOCSFIRMADOSPFEXPTE object, {
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
    required ZCSRFCDOCSFIRMADOSPFEXPTEBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'etlistdocs':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ETLISTDOCS),
          ) as ETLISTDOCS;
          result.etlistdocs.replace(valueDes);
          break;
        case r'etreturn':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ETRETURN),
          ) as ETRETURN;
          result.etreturn.replace(valueDes);
          break;
        case r'ipclase':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.ipclase = valueDes;
          break;
        case r'ipejeexp':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.ipejeexp = valueDes;
          break;
        case r'ipnumexp':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.ipnumexp = valueDes;
          break;
        case r'iprefdoc':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.iprefdoc = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ZCSRFCDOCSFIRMADOSPFEXPTE deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ZCSRFCDOCSFIRMADOSPFEXPTEBuilder();
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
