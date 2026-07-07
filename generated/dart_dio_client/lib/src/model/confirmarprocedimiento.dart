//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:espacio_ciudadano_api/src/model/pdatos.dart';
import 'package:espacio_ciudadano_api/src/model/dt_procedimiento.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'confirmarprocedimiento.g.dart';

/// CONFIRMARPROCEDIMIENTO
///
/// Properties:
/// * [pdatos] 
/// * [procedimiento] 
@BuiltValue()
abstract class CONFIRMARPROCEDIMIENTO implements Built<CONFIRMARPROCEDIMIENTO, CONFIRMARPROCEDIMIENTOBuilder> {
  @BuiltValueField(wireName: r'pdatos')
  PDATOS get pdatos;

  @BuiltValueField(wireName: r'procedimiento')
  DTProcedimiento get procedimiento;

  CONFIRMARPROCEDIMIENTO._();

  factory CONFIRMARPROCEDIMIENTO([void updates(CONFIRMARPROCEDIMIENTOBuilder b)]) = _$CONFIRMARPROCEDIMIENTO;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CONFIRMARPROCEDIMIENTOBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CONFIRMARPROCEDIMIENTO> get serializer => _$CONFIRMARPROCEDIMIENTOSerializer();
}

class _$CONFIRMARPROCEDIMIENTOSerializer implements PrimitiveSerializer<CONFIRMARPROCEDIMIENTO> {
  @override
  final Iterable<Type> types = const [CONFIRMARPROCEDIMIENTO, _$CONFIRMARPROCEDIMIENTO];

  @override
  final String wireName = r'CONFIRMARPROCEDIMIENTO';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CONFIRMARPROCEDIMIENTO object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'pdatos';
    yield serializers.serialize(
      object.pdatos,
      specifiedType: const FullType(PDATOS),
    );
    yield r'procedimiento';
    yield serializers.serialize(
      object.procedimiento,
      specifiedType: const FullType(DTProcedimiento),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CONFIRMARPROCEDIMIENTO object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CONFIRMARPROCEDIMIENTOBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'pdatos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PDATOS),
          ) as PDATOS;
          result.pdatos.replace(valueDes);
          break;
        case r'procedimiento':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DTProcedimiento),
          ) as DTProcedimiento;
          result.procedimiento.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CONFIRMARPROCEDIMIENTO deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CONFIRMARPROCEDIMIENTOBuilder();
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

