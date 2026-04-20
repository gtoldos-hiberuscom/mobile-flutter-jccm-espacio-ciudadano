//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:espacio_ciudadano_api/src/model/hecho.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'lista_hechos_agente.g.dart';

/// ListaHechosAgente
///
/// Properties:
/// * [idAgente]
/// * [listaHechos]
@BuiltValue()
abstract class ListaHechosAgente
    implements Built<ListaHechosAgente, ListaHechosAgenteBuilder> {
  @BuiltValueField(wireName: r'idAgente')
  String? get idAgente;

  @BuiltValueField(wireName: r'listaHechos')
  BuiltList<Hecho>? get listaHechos;

  ListaHechosAgente._();

  factory ListaHechosAgente([void updates(ListaHechosAgenteBuilder b)]) =
      _$ListaHechosAgente;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ListaHechosAgenteBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ListaHechosAgente> get serializer =>
      _$ListaHechosAgenteSerializer();
}

class _$ListaHechosAgenteSerializer
    implements PrimitiveSerializer<ListaHechosAgente> {
  @override
  final Iterable<Type> types = const [ListaHechosAgente, _$ListaHechosAgente];

  @override
  final String wireName = r'ListaHechosAgente';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ListaHechosAgente object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.idAgente != null) {
      yield r'idAgente';
      yield serializers.serialize(
        object.idAgente,
        specifiedType: const FullType(String),
      );
    }
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
    ListaHechosAgente object, {
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
    required ListaHechosAgenteBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'idAgente':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.idAgente = valueDes;
          break;
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
  ListaHechosAgente deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ListaHechosAgenteBuilder();
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
