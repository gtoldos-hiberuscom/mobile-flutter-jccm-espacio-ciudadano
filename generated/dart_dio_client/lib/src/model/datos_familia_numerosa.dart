//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'datos_familia_numerosa.g.dart';

/// DatosFamiliaNumerosa
///
/// Properties:
/// * [codError] 
/// * [datos] 
/// * [descError] 
/// * [fechaValidezDesde] 
/// * [fechaValidezHasta] 
/// * [numeroTitulo] 
@BuiltValue()
abstract class DatosFamiliaNumerosa implements Built<DatosFamiliaNumerosa, DatosFamiliaNumerosaBuilder> {
  @BuiltValueField(wireName: r'codError')
  String? get codError;

  @BuiltValueField(wireName: r'datos')
  String? get datos;

  @BuiltValueField(wireName: r'descError')
  String? get descError;

  @BuiltValueField(wireName: r'fechaValidezDesde')
  String? get fechaValidezDesde;

  @BuiltValueField(wireName: r'fechaValidezHasta')
  String? get fechaValidezHasta;

  @BuiltValueField(wireName: r'numeroTitulo')
  String? get numeroTitulo;

  DatosFamiliaNumerosa._();

  factory DatosFamiliaNumerosa([void updates(DatosFamiliaNumerosaBuilder b)]) = _$DatosFamiliaNumerosa;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DatosFamiliaNumerosaBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DatosFamiliaNumerosa> get serializer => _$DatosFamiliaNumerosaSerializer();
}

class _$DatosFamiliaNumerosaSerializer implements PrimitiveSerializer<DatosFamiliaNumerosa> {
  @override
  final Iterable<Type> types = const [DatosFamiliaNumerosa, _$DatosFamiliaNumerosa];

  @override
  final String wireName = r'DatosFamiliaNumerosa';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DatosFamiliaNumerosa object, {
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
    if (object.fechaValidezDesde != null) {
      yield r'fechaValidezDesde';
      yield serializers.serialize(
        object.fechaValidezDesde,
        specifiedType: const FullType(String),
      );
    }
    if (object.fechaValidezHasta != null) {
      yield r'fechaValidezHasta';
      yield serializers.serialize(
        object.fechaValidezHasta,
        specifiedType: const FullType(String),
      );
    }
    if (object.numeroTitulo != null) {
      yield r'numeroTitulo';
      yield serializers.serialize(
        object.numeroTitulo,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    DatosFamiliaNumerosa object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DatosFamiliaNumerosaBuilder result,
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
        case r'fechaValidezDesde':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.fechaValidezDesde = valueDes;
          break;
        case r'fechaValidezHasta':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.fechaValidezHasta = valueDes;
          break;
        case r'numeroTitulo':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.numeroTitulo = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DatosFamiliaNumerosa deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DatosFamiliaNumerosaBuilder();
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

