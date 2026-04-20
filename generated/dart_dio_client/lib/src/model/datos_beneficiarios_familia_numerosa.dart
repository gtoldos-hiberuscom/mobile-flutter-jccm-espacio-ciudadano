//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:espacio_ciudadano_api/src/model/datos_beneficiarios_familia_numerosa_list.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'datos_beneficiarios_familia_numerosa.g.dart';

/// DatosBeneficiariosFamiliaNumerosa
///
/// Properties:
/// * [row]
@BuiltValue()
abstract class DatosBeneficiariosFamiliaNumerosa
    implements
        Built<DatosBeneficiariosFamiliaNumerosa,
            DatosBeneficiariosFamiliaNumerosaBuilder> {
  @BuiltValueField(wireName: r'row')
  BuiltList<DatosBeneficiariosFamiliaNumerosaList>? get row;

  DatosBeneficiariosFamiliaNumerosa._();

  factory DatosBeneficiariosFamiliaNumerosa(
          [void updates(DatosBeneficiariosFamiliaNumerosaBuilder b)]) =
      _$DatosBeneficiariosFamiliaNumerosa;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DatosBeneficiariosFamiliaNumerosaBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DatosBeneficiariosFamiliaNumerosa> get serializer =>
      _$DatosBeneficiariosFamiliaNumerosaSerializer();
}

class _$DatosBeneficiariosFamiliaNumerosaSerializer
    implements PrimitiveSerializer<DatosBeneficiariosFamiliaNumerosa> {
  @override
  final Iterable<Type> types = const [
    DatosBeneficiariosFamiliaNumerosa,
    _$DatosBeneficiariosFamiliaNumerosa
  ];

  @override
  final String wireName = r'DatosBeneficiariosFamiliaNumerosa';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DatosBeneficiariosFamiliaNumerosa object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.row != null) {
      yield r'row';
      yield serializers.serialize(
        object.row,
        specifiedType: const FullType(
            BuiltList, [FullType(DatosBeneficiariosFamiliaNumerosaList)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    DatosBeneficiariosFamiliaNumerosa object, {
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
    required DatosBeneficiariosFamiliaNumerosaBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'row':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(
                BuiltList, [FullType(DatosBeneficiariosFamiliaNumerosaList)]),
          ) as BuiltList<DatosBeneficiariosFamiliaNumerosaList>;
          result.row.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DatosBeneficiariosFamiliaNumerosa deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DatosBeneficiariosFamiliaNumerosaBuilder();
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
