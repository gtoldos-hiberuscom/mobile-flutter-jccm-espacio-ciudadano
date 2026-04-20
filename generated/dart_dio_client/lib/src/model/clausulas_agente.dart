//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:espacio_ciudadano_api/src/model/clausulas.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'clausulas_agente.g.dart';

/// ClausulasAgente
///
/// Properties:
/// * [clausulas]
/// * [idAgente]
@BuiltValue()
abstract class ClausulasAgente
    implements Built<ClausulasAgente, ClausulasAgenteBuilder> {
  @BuiltValueField(wireName: r'clausulas')
  BuiltList<Clausulas>? get clausulas;

  @BuiltValueField(wireName: r'idAgente')
  String? get idAgente;

  ClausulasAgente._();

  factory ClausulasAgente([void updates(ClausulasAgenteBuilder b)]) =
      _$ClausulasAgente;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ClausulasAgenteBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ClausulasAgente> get serializer =>
      _$ClausulasAgenteSerializer();
}

class _$ClausulasAgenteSerializer
    implements PrimitiveSerializer<ClausulasAgente> {
  @override
  final Iterable<Type> types = const [ClausulasAgente, _$ClausulasAgente];

  @override
  final String wireName = r'ClausulasAgente';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ClausulasAgente object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.clausulas != null) {
      yield r'clausulas';
      yield serializers.serialize(
        object.clausulas,
        specifiedType: const FullType(BuiltList, [FullType(Clausulas)]),
      );
    }
    if (object.idAgente != null) {
      yield r'idAgente';
      yield serializers.serialize(
        object.idAgente,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ClausulasAgente object, {
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
    required ClausulasAgenteBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'clausulas':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(Clausulas)]),
          ) as BuiltList<Clausulas>;
          result.clausulas.replace(valueDes);
          break;
        case r'idAgente':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.idAgente = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ClausulasAgente deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ClausulasAgenteBuilder();
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
