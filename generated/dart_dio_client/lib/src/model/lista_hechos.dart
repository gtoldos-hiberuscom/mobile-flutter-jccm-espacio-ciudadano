//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:espacio_ciudadano_api/src/model/hecho.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'lista_hechos.g.dart';

/// ListaHechos
///
/// Properties:
/// * [listaHechos]
@BuiltValue()
abstract class ListaHechos implements Built<ListaHechos, ListaHechosBuilder> {
  @BuiltValueField(wireName: r'listaHechos')
  BuiltList<Hecho>? get listaHechos;

  ListaHechos._();

  factory ListaHechos([void updates(ListaHechosBuilder b)]) = _$ListaHechos;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ListaHechosBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ListaHechos> get serializer => _$ListaHechosSerializer();
}

class _$ListaHechosSerializer implements PrimitiveSerializer<ListaHechos> {
  @override
  final Iterable<Type> types = const [ListaHechos, _$ListaHechos];

  @override
  final String wireName = r'ListaHechos';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ListaHechos object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.listaHechos != null) {
      yield r'listaHechos';
      yield serializers.serialize(
        object.listaHechos,
        specifiedType: const FullType(BuiltList, [FullType(Hecho)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ListaHechos object, {
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
    required ListaHechosBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'listaHechos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(Hecho)]),
          ) as BuiltList<Hecho>;
          result.listaHechos.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ListaHechos deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ListaHechosBuilder();
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
