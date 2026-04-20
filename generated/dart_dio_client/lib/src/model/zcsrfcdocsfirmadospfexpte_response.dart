//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:espacio_ciudadano_api/src/model/etreturn.dart';
import 'package:espacio_ciudadano_api/src/model/etlistdocs.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'zcsrfcdocsfirmadospfexpte_response.g.dart';

/// ZCSRFCDOCSFIRMADOSPFEXPTEResponse
///
/// Properties:
/// * [etlistdocs] 
/// * [etreturn] 
@BuiltValue()
abstract class ZCSRFCDOCSFIRMADOSPFEXPTEResponse implements Built<ZCSRFCDOCSFIRMADOSPFEXPTEResponse, ZCSRFCDOCSFIRMADOSPFEXPTEResponseBuilder> {
  @BuiltValueField(wireName: r'etlistdocs')
  ETLISTDOCS? get etlistdocs;

  @BuiltValueField(wireName: r'etreturn')
  ETRETURN? get etreturn;

  ZCSRFCDOCSFIRMADOSPFEXPTEResponse._();

  factory ZCSRFCDOCSFIRMADOSPFEXPTEResponse([void updates(ZCSRFCDOCSFIRMADOSPFEXPTEResponseBuilder b)]) = _$ZCSRFCDOCSFIRMADOSPFEXPTEResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ZCSRFCDOCSFIRMADOSPFEXPTEResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ZCSRFCDOCSFIRMADOSPFEXPTEResponse> get serializer => _$ZCSRFCDOCSFIRMADOSPFEXPTEResponseSerializer();
}

class _$ZCSRFCDOCSFIRMADOSPFEXPTEResponseSerializer implements PrimitiveSerializer<ZCSRFCDOCSFIRMADOSPFEXPTEResponse> {
  @override
  final Iterable<Type> types = const [ZCSRFCDOCSFIRMADOSPFEXPTEResponse, _$ZCSRFCDOCSFIRMADOSPFEXPTEResponse];

  @override
  final String wireName = r'ZCSRFCDOCSFIRMADOSPFEXPTEResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ZCSRFCDOCSFIRMADOSPFEXPTEResponse object, {
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
  }

  @override
  Object serialize(
    Serializers serializers,
    ZCSRFCDOCSFIRMADOSPFEXPTEResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ZCSRFCDOCSFIRMADOSPFEXPTEResponseBuilder result,
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ZCSRFCDOCSFIRMADOSPFEXPTEResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ZCSRFCDOCSFIRMADOSPFEXPTEResponseBuilder();
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

