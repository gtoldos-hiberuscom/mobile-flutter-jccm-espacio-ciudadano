//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:espacio_ciudadano_api/src/model/tramite.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'tramites_por_hecho.g.dart';

/// TramitesPorHecho
///
/// Properties:
/// * [idHecho]
/// * [nombreHecho]
/// * [tramites]
@BuiltValue()
abstract class TramitesPorHecho
    implements Built<TramitesPorHecho, TramitesPorHechoBuilder> {
  @BuiltValueField(wireName: r'idHecho')
  int? get idHecho;

  @BuiltValueField(wireName: r'nombreHecho')
  String? get nombreHecho;

  @BuiltValueField(wireName: r'tramites')
  BuiltList<Tramite>? get tramites;

  TramitesPorHecho._();

  factory TramitesPorHecho([void updates(TramitesPorHechoBuilder b)]) =
      _$TramitesPorHecho;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TramitesPorHechoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TramitesPorHecho> get serializer =>
      _$TramitesPorHechoSerializer();
}

class _$TramitesPorHechoSerializer
    implements PrimitiveSerializer<TramitesPorHecho> {
  @override
  final Iterable<Type> types = const [TramitesPorHecho, _$TramitesPorHecho];

  @override
  final String wireName = r'TramitesPorHecho';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TramitesPorHecho object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.idHecho != null) {
      yield r'idHecho';
      yield serializers.serialize(
        object.idHecho,
        specifiedType: const FullType(int),
      );
    }
    if (object.nombreHecho != null) {
      yield r'nombreHecho';
      yield serializers.serialize(
        object.nombreHecho,
        specifiedType: const FullType(String),
      );
    }
    if (object.tramites != null) {
      yield r'tramites';
      yield serializers.serialize(
        object.tramites,
        specifiedType: const FullType(BuiltList, [FullType(Tramite)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    TramitesPorHecho object, {
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
    required TramitesPorHechoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'idHecho':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.idHecho = valueDes;
          break;
        case r'nombreHecho':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.nombreHecho = valueDes;
          break;
        case r'tramites':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(Tramite)]),
          ) as BuiltList<Tramite>;
          result.tramites.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  TramitesPorHecho deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TramitesPorHechoBuilder();
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
