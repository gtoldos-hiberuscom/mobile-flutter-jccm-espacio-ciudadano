//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:espacio_ciudadano_api/src/model/pregistro.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'datosregistro.g.dart';

/// DATOSREGISTRO
///
/// Properties:
/// * [pregistro] 
@BuiltValue()
abstract class DATOSREGISTRO implements Built<DATOSREGISTRO, DATOSREGISTROBuilder> {
  @BuiltValueField(wireName: r'pregistro')
  PREGISTRO? get pregistro;

  DATOSREGISTRO._();

  factory DATOSREGISTRO([void updates(DATOSREGISTROBuilder b)]) = _$DATOSREGISTRO;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DATOSREGISTROBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DATOSREGISTRO> get serializer => _$DATOSREGISTROSerializer();
}

class _$DATOSREGISTROSerializer implements PrimitiveSerializer<DATOSREGISTRO> {
  @override
  final Iterable<Type> types = const [DATOSREGISTRO, _$DATOSREGISTRO];

  @override
  final String wireName = r'DATOSREGISTRO';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DATOSREGISTRO object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.pregistro != null) {
      yield r'pregistro';
      yield serializers.serialize(
        object.pregistro,
        specifiedType: const FullType(PREGISTRO),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    DATOSREGISTRO object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DATOSREGISTROBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'pregistro':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PREGISTRO),
          ) as PREGISTRO;
          result.pregistro.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DATOSREGISTRO deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DATOSREGISTROBuilder();
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

