//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:espacio_ciudadano_api/src/model/elemento.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'dtedutuores.g.dart';

/// DTEDUTUORES
///
/// Properties:
/// * [docu]
/// * [elemento]
/// * [fecnac]
/// * [idpeticion]
/// * [mensaje]
/// * [resul]
@BuiltValue()
abstract class DTEDUTUORES implements Built<DTEDUTUORES, DTEDUTUORESBuilder> {
  @BuiltValueField(wireName: r'docu')
  String? get docu;

  @BuiltValueField(wireName: r'elemento')
  BuiltList<ELEMENTO>? get elemento;

  @BuiltValueField(wireName: r'fecnac')
  String? get fecnac;

  @BuiltValueField(wireName: r'idpeticion')
  String? get idpeticion;

  @BuiltValueField(wireName: r'mensaje')
  String? get mensaje;

  @BuiltValueField(wireName: r'resul')
  String? get resul;

  DTEDUTUORES._();

  factory DTEDUTUORES([void updates(DTEDUTUORESBuilder b)]) = _$DTEDUTUORES;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DTEDUTUORESBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DTEDUTUORES> get serializer => _$DTEDUTUORESSerializer();
}

class _$DTEDUTUORESSerializer implements PrimitiveSerializer<DTEDUTUORES> {
  @override
  final Iterable<Type> types = const [DTEDUTUORES, _$DTEDUTUORES];

  @override
  final String wireName = r'DTEDUTUORES';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DTEDUTUORES object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.docu != null) {
      yield r'docu';
      yield serializers.serialize(
        object.docu,
        specifiedType: const FullType(String),
      );
    }
    if (object.elemento != null) {
      yield r'elemento';
      yield serializers.serialize(
        object.elemento,
        specifiedType: const FullType(BuiltList, [FullType(ELEMENTO)]),
      );
    }
    if (object.fecnac != null) {
      yield r'fecnac';
      yield serializers.serialize(
        object.fecnac,
        specifiedType: const FullType(String),
      );
    }
    if (object.idpeticion != null) {
      yield r'idpeticion';
      yield serializers.serialize(
        object.idpeticion,
        specifiedType: const FullType(String),
      );
    }
    if (object.mensaje != null) {
      yield r'mensaje';
      yield serializers.serialize(
        object.mensaje,
        specifiedType: const FullType(String),
      );
    }
    if (object.resul != null) {
      yield r'resul';
      yield serializers.serialize(
        object.resul,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    DTEDUTUORES object, {
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
    required DTEDUTUORESBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'docu':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.docu = valueDes;
          break;
        case r'elemento':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ELEMENTO)]),
          ) as BuiltList<ELEMENTO>;
          result.elemento.replace(valueDes);
          break;
        case r'fecnac':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.fecnac = valueDes;
          break;
        case r'idpeticion':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.idpeticion = valueDes;
          break;
        case r'mensaje':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.mensaje = valueDes;
          break;
        case r'resul':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.resul = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DTEDUTUORES deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DTEDUTUORESBuilder();
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
