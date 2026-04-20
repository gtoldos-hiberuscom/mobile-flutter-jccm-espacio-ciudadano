//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:espacio_ciudadano_api/src/model/tramites_por_hecho.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'lista_tramites_por_hechos.g.dart';

/// ListaTramitesPorHechos
///
/// Properties:
/// * [listaTramitesPorHechos] 
@BuiltValue()
abstract class ListaTramitesPorHechos implements Built<ListaTramitesPorHechos, ListaTramitesPorHechosBuilder> {
  @BuiltValueField(wireName: r'listaTramitesPorHechos')
  BuiltList<TramitesPorHecho>? get listaTramitesPorHechos;

  ListaTramitesPorHechos._();

  factory ListaTramitesPorHechos([void updates(ListaTramitesPorHechosBuilder b)]) = _$ListaTramitesPorHechos;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ListaTramitesPorHechosBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ListaTramitesPorHechos> get serializer => _$ListaTramitesPorHechosSerializer();
}

class _$ListaTramitesPorHechosSerializer implements PrimitiveSerializer<ListaTramitesPorHechos> {
  @override
  final Iterable<Type> types = const [ListaTramitesPorHechos, _$ListaTramitesPorHechos];

  @override
  final String wireName = r'ListaTramitesPorHechos';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ListaTramitesPorHechos object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.listaTramitesPorHechos != null) {
      yield r'listaTramitesPorHechos';
      yield serializers.serialize(
        object.listaTramitesPorHechos,
        specifiedType: const FullType(BuiltList, [FullType(TramitesPorHecho)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ListaTramitesPorHechos object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ListaTramitesPorHechosBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'listaTramitesPorHechos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(TramitesPorHecho)]),
          ) as BuiltList<TramitesPorHecho>;
          result.listaTramitesPorHechos.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ListaTramitesPorHechos deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ListaTramitesPorHechosBuilder();
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

