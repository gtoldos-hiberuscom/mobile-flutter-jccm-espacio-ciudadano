//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'clausulas.g.dart';

/// Clausulas
///
/// Properties:
/// * [idClausula]
/// * [seleccionado]
/// * [version]
@BuiltValue()
abstract class Clausulas implements Built<Clausulas, ClausulasBuilder> {
  @BuiltValueField(wireName: r'idClausula')
  int? get idClausula;

  @BuiltValueField(wireName: r'seleccionado')
  bool? get seleccionado;

  @BuiltValueField(wireName: r'version')
  String? get version;

  Clausulas._();

  factory Clausulas([void updates(ClausulasBuilder b)]) = _$Clausulas;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ClausulasBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<Clausulas> get serializer => _$ClausulasSerializer();
}

class _$ClausulasSerializer implements PrimitiveSerializer<Clausulas> {
  @override
  final Iterable<Type> types = const [Clausulas, _$Clausulas];

  @override
  final String wireName = r'Clausulas';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    Clausulas object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.idClausula != null) {
      yield r'idClausula';
      yield serializers.serialize(
        object.idClausula,
        specifiedType: const FullType(int),
      );
    }
    if (object.seleccionado != null) {
      yield r'seleccionado';
      yield serializers.serialize(
        object.seleccionado,
        specifiedType: const FullType(bool),
      );
    }
    if (object.version != null) {
      yield r'version';
      yield serializers.serialize(
        object.version,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    Clausulas object, {
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
    required ClausulasBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'idClausula':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.idClausula = valueDes;
          break;
        case r'seleccionado':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.seleccionado = valueDes;
          break;
        case r'version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.version = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  Clausulas deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ClausulasBuilder();
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
