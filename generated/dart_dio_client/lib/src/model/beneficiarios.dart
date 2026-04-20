//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'beneficiarios.g.dart';

/// BENEFICIARIOS
///
/// Properties:
/// * [apellido1]
/// * [apellido2]
/// * [fecnac]
/// * [nombre]
/// * [numdoc]
/// * [tipdoc]
/// * [titular]
@BuiltValue()
abstract class BENEFICIARIOS
    implements Built<BENEFICIARIOS, BENEFICIARIOSBuilder> {
  @BuiltValueField(wireName: r'apellido1')
  String? get apellido1;

  @BuiltValueField(wireName: r'apellido2')
  String? get apellido2;

  @BuiltValueField(wireName: r'fecnac')
  String? get fecnac;

  @BuiltValueField(wireName: r'nombre')
  String? get nombre;

  @BuiltValueField(wireName: r'numdoc')
  String? get numdoc;

  @BuiltValueField(wireName: r'tipdoc')
  String? get tipdoc;

  @BuiltValueField(wireName: r'titular')
  String? get titular;

  BENEFICIARIOS._();

  factory BENEFICIARIOS([void updates(BENEFICIARIOSBuilder b)]) =
      _$BENEFICIARIOS;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(BENEFICIARIOSBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<BENEFICIARIOS> get serializer =>
      _$BENEFICIARIOSSerializer();
}

class _$BENEFICIARIOSSerializer implements PrimitiveSerializer<BENEFICIARIOS> {
  @override
  final Iterable<Type> types = const [BENEFICIARIOS, _$BENEFICIARIOS];

  @override
  final String wireName = r'BENEFICIARIOS';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    BENEFICIARIOS object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.apellido1 != null) {
      yield r'apellido1';
      yield serializers.serialize(
        object.apellido1,
        specifiedType: const FullType(String),
      );
    }
    if (object.apellido2 != null) {
      yield r'apellido2';
      yield serializers.serialize(
        object.apellido2,
        specifiedType: const FullType(String),
      );
    }
    if (object.fecnac != null) {
      yield r'fecnac';
      yield serializers.serialize(
        object.fecnac,
        specifiedType: const FullType(String),
      );
    }
    if (object.nombre != null) {
      yield r'nombre';
      yield serializers.serialize(
        object.nombre,
        specifiedType: const FullType(String),
      );
    }
    if (object.numdoc != null) {
      yield r'numdoc';
      yield serializers.serialize(
        object.numdoc,
        specifiedType: const FullType(String),
      );
    }
    if (object.tipdoc != null) {
      yield r'tipdoc';
      yield serializers.serialize(
        object.tipdoc,
        specifiedType: const FullType(String),
      );
    }
    if (object.titular != null) {
      yield r'titular';
      yield serializers.serialize(
        object.titular,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    BENEFICIARIOS object, {
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
    required BENEFICIARIOSBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'apellido1':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.apellido1 = valueDes;
          break;
        case r'apellido2':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.apellido2 = valueDes;
          break;
        case r'fecnac':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.fecnac = valueDes;
          break;
        case r'nombre':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.nombre = valueDes;
          break;
        case r'numdoc':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.numdoc = valueDes;
          break;
        case r'tipdoc':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.tipdoc = valueDes;
          break;
        case r'titular':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.titular = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  BENEFICIARIOS deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = BENEFICIARIOSBuilder();
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
