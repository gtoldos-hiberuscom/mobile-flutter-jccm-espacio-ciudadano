//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:espacio_ciudadano_api/src/model/datos_titulo_familia_numerosa_list.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'datos_titulo_familia_numerosa.g.dart';

/// DatosTituloFamiliaNumerosa
///
/// Properties:
/// * [row]
@BuiltValue()
abstract class DatosTituloFamiliaNumerosa
    implements
        Built<DatosTituloFamiliaNumerosa, DatosTituloFamiliaNumerosaBuilder> {
  @BuiltValueField(wireName: r'row')
  BuiltList<DatosTituloFamiliaNumerosaList>? get row;

  DatosTituloFamiliaNumerosa._();

  factory DatosTituloFamiliaNumerosa(
          [void updates(DatosTituloFamiliaNumerosaBuilder b)]) =
      _$DatosTituloFamiliaNumerosa;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DatosTituloFamiliaNumerosaBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DatosTituloFamiliaNumerosa> get serializer =>
      _$DatosTituloFamiliaNumerosaSerializer();
}

class _$DatosTituloFamiliaNumerosaSerializer
    implements PrimitiveSerializer<DatosTituloFamiliaNumerosa> {
  @override
  final Iterable<Type> types = const [
    DatosTituloFamiliaNumerosa,
    _$DatosTituloFamiliaNumerosa
  ];

  @override
  final String wireName = r'DatosTituloFamiliaNumerosa';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DatosTituloFamiliaNumerosa object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.row != null) {
      yield r'row';
      yield serializers.serialize(
        object.row,
        specifiedType: const FullType(
            BuiltList, [FullType(DatosTituloFamiliaNumerosaList)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    DatosTituloFamiliaNumerosa object, {
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
    required DatosTituloFamiliaNumerosaBuilder result,
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
                BuiltList, [FullType(DatosTituloFamiliaNumerosaList)]),
          ) as BuiltList<DatosTituloFamiliaNumerosaList>;
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
  DatosTituloFamiliaNumerosa deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DatosTituloFamiliaNumerosaBuilder();
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
