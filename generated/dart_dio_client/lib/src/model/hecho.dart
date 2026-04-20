//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'hecho.g.dart';

/// Hecho
///
/// Properties:
/// * [idHecho]
/// * [nombreHecho]
/// * [seleccionado]
@BuiltValue()
abstract class Hecho implements Built<Hecho, HechoBuilder> {
  @BuiltValueField(wireName: r'idHecho')
  int? get idHecho;

  @BuiltValueField(wireName: r'nombreHecho')
  String? get nombreHecho;

  @BuiltValueField(wireName: r'seleccionado')
  bool? get seleccionado;

  Hecho._();

  factory Hecho([void updates(HechoBuilder b)]) = _$Hecho;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(HechoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<Hecho> get serializer => _$HechoSerializer();
}

class _$HechoSerializer implements PrimitiveSerializer<Hecho> {
  @override
  final Iterable<Type> types = const [Hecho, _$Hecho];

  @override
  final String wireName = r'Hecho';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    Hecho object, {
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
    if (object.seleccionado != null) {
      yield r'seleccionado';
      yield serializers.serialize(
        object.seleccionado,
        specifiedType: const FullType(bool),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    Hecho object, {
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
    required HechoBuilder result,
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
        case r'seleccionado':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.seleccionado = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  Hecho deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = HechoBuilder();
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
