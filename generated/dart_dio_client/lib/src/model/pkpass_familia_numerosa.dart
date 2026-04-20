//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'pkpass_familia_numerosa.g.dart';

/// PkpassFamiliaNumerosa
///
/// Properties:
/// * [codError]
/// * [datos]
/// * [descError]
/// * [pkpass]
@BuiltValue()
abstract class PkpassFamiliaNumerosa
    implements Built<PkpassFamiliaNumerosa, PkpassFamiliaNumerosaBuilder> {
  @BuiltValueField(wireName: r'codError')
  String? get codError;

  @BuiltValueField(wireName: r'datos')
  String? get datos;

  @BuiltValueField(wireName: r'descError')
  String? get descError;

  @BuiltValueField(wireName: r'pkpass')
  String? get pkpass;

  PkpassFamiliaNumerosa._();

  factory PkpassFamiliaNumerosa(
      [void updates(PkpassFamiliaNumerosaBuilder b)]) = _$PkpassFamiliaNumerosa;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PkpassFamiliaNumerosaBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PkpassFamiliaNumerosa> get serializer =>
      _$PkpassFamiliaNumerosaSerializer();
}

class _$PkpassFamiliaNumerosaSerializer
    implements PrimitiveSerializer<PkpassFamiliaNumerosa> {
  @override
  final Iterable<Type> types = const [
    PkpassFamiliaNumerosa,
    _$PkpassFamiliaNumerosa
  ];

  @override
  final String wireName = r'PkpassFamiliaNumerosa';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PkpassFamiliaNumerosa object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.codError != null) {
      yield r'codError';
      yield serializers.serialize(
        object.codError,
        specifiedType: const FullType(String),
      );
    }
    if (object.datos != null) {
      yield r'datos';
      yield serializers.serialize(
        object.datos,
        specifiedType: const FullType(String),
      );
    }
    if (object.descError != null) {
      yield r'descError';
      yield serializers.serialize(
        object.descError,
        specifiedType: const FullType(String),
      );
    }
    if (object.pkpass != null) {
      yield r'pkpass';
      yield serializers.serialize(
        object.pkpass,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    PkpassFamiliaNumerosa object, {
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
    required PkpassFamiliaNumerosaBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'codError':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.codError = valueDes;
          break;
        case r'datos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.datos = valueDes;
          break;
        case r'descError':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.descError = valueDes;
          break;
        case r'pkpass':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.pkpass = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PkpassFamiliaNumerosa deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PkpassFamiliaNumerosaBuilder();
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
