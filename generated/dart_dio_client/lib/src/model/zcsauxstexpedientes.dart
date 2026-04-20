//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'zcsauxstexpedientes.g.dart';

/// ZCSAUXSTEXPEDIENTES
///
/// Properties:
/// * [adjuntar]
/// * [certific]
/// * [consej]
/// * [desconsej]
/// * [descrip]
/// * [desfam]
/// * [desproc]
/// * [ejeexp]
/// * [estado]
/// * [estadosede]
/// * [familia]
/// * [fechafin]
/// * [fechareg]
/// * [numexp]
/// * [registro]
/// * [tipoproc]
/// * [titulo]
@BuiltValue()
abstract class ZCSAUXSTEXPEDIENTES
    implements Built<ZCSAUXSTEXPEDIENTES, ZCSAUXSTEXPEDIENTESBuilder> {
  @BuiltValueField(wireName: r'adjuntar')
  String? get adjuntar;

  @BuiltValueField(wireName: r'certific')
  String? get certific;

  @BuiltValueField(wireName: r'consej')
  String? get consej;

  @BuiltValueField(wireName: r'desconsej')
  String? get desconsej;

  @BuiltValueField(wireName: r'descrip')
  String? get descrip;

  @BuiltValueField(wireName: r'desfam')
  String? get desfam;

  @BuiltValueField(wireName: r'desproc')
  String? get desproc;

  @BuiltValueField(wireName: r'ejeexp')
  String? get ejeexp;

  @BuiltValueField(wireName: r'estado')
  String? get estado;

  @BuiltValueField(wireName: r'estadosede')
  String? get estadosede;

  @BuiltValueField(wireName: r'familia')
  String? get familia;

  @BuiltValueField(wireName: r'fechafin')
  String? get fechafin;

  @BuiltValueField(wireName: r'fechareg')
  String? get fechareg;

  @BuiltValueField(wireName: r'numexp')
  String? get numexp;

  @BuiltValueField(wireName: r'registro')
  String? get registro;

  @BuiltValueField(wireName: r'tipoproc')
  String? get tipoproc;

  @BuiltValueField(wireName: r'titulo')
  String? get titulo;

  ZCSAUXSTEXPEDIENTES._();

  factory ZCSAUXSTEXPEDIENTES([void updates(ZCSAUXSTEXPEDIENTESBuilder b)]) =
      _$ZCSAUXSTEXPEDIENTES;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ZCSAUXSTEXPEDIENTESBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ZCSAUXSTEXPEDIENTES> get serializer =>
      _$ZCSAUXSTEXPEDIENTESSerializer();
}

class _$ZCSAUXSTEXPEDIENTESSerializer
    implements PrimitiveSerializer<ZCSAUXSTEXPEDIENTES> {
  @override
  final Iterable<Type> types = const [
    ZCSAUXSTEXPEDIENTES,
    _$ZCSAUXSTEXPEDIENTES
  ];

  @override
  final String wireName = r'ZCSAUXSTEXPEDIENTES';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ZCSAUXSTEXPEDIENTES object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.adjuntar != null) {
      yield r'adjuntar';
      yield serializers.serialize(
        object.adjuntar,
        specifiedType: const FullType(String),
      );
    }
    if (object.certific != null) {
      yield r'certific';
      yield serializers.serialize(
        object.certific,
        specifiedType: const FullType(String),
      );
    }
    if (object.consej != null) {
      yield r'consej';
      yield serializers.serialize(
        object.consej,
        specifiedType: const FullType(String),
      );
    }
    if (object.desconsej != null) {
      yield r'desconsej';
      yield serializers.serialize(
        object.desconsej,
        specifiedType: const FullType(String),
      );
    }
    if (object.descrip != null) {
      yield r'descrip';
      yield serializers.serialize(
        object.descrip,
        specifiedType: const FullType(String),
      );
    }
    if (object.desfam != null) {
      yield r'desfam';
      yield serializers.serialize(
        object.desfam,
        specifiedType: const FullType(String),
      );
    }
    if (object.desproc != null) {
      yield r'desproc';
      yield serializers.serialize(
        object.desproc,
        specifiedType: const FullType(String),
      );
    }
    if (object.ejeexp != null) {
      yield r'ejeexp';
      yield serializers.serialize(
        object.ejeexp,
        specifiedType: const FullType(String),
      );
    }
    if (object.estado != null) {
      yield r'estado';
      yield serializers.serialize(
        object.estado,
        specifiedType: const FullType(String),
      );
    }
    if (object.estadosede != null) {
      yield r'estadosede';
      yield serializers.serialize(
        object.estadosede,
        specifiedType: const FullType(String),
      );
    }
    if (object.familia != null) {
      yield r'familia';
      yield serializers.serialize(
        object.familia,
        specifiedType: const FullType(String),
      );
    }
    if (object.fechafin != null) {
      yield r'fechafin';
      yield serializers.serialize(
        object.fechafin,
        specifiedType: const FullType(String),
      );
    }
    if (object.fechareg != null) {
      yield r'fechareg';
      yield serializers.serialize(
        object.fechareg,
        specifiedType: const FullType(String),
      );
    }
    if (object.numexp != null) {
      yield r'numexp';
      yield serializers.serialize(
        object.numexp,
        specifiedType: const FullType(String),
      );
    }
    if (object.registro != null) {
      yield r'registro';
      yield serializers.serialize(
        object.registro,
        specifiedType: const FullType(String),
      );
    }
    if (object.tipoproc != null) {
      yield r'tipoproc';
      yield serializers.serialize(
        object.tipoproc,
        specifiedType: const FullType(String),
      );
    }
    if (object.titulo != null) {
      yield r'titulo';
      yield serializers.serialize(
        object.titulo,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ZCSAUXSTEXPEDIENTES object, {
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
    required ZCSAUXSTEXPEDIENTESBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'adjuntar':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.adjuntar = valueDes;
          break;
        case r'certific':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.certific = valueDes;
          break;
        case r'consej':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.consej = valueDes;
          break;
        case r'desconsej':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.desconsej = valueDes;
          break;
        case r'descrip':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.descrip = valueDes;
          break;
        case r'desfam':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.desfam = valueDes;
          break;
        case r'desproc':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.desproc = valueDes;
          break;
        case r'ejeexp':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.ejeexp = valueDes;
          break;
        case r'estado':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.estado = valueDes;
          break;
        case r'estadosede':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.estadosede = valueDes;
          break;
        case r'familia':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.familia = valueDes;
          break;
        case r'fechafin':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.fechafin = valueDes;
          break;
        case r'fechareg':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.fechareg = valueDes;
          break;
        case r'numexp':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.numexp = valueDes;
          break;
        case r'registro':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.registro = valueDes;
          break;
        case r'tipoproc':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.tipoproc = valueDes;
          break;
        case r'titulo':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.titulo = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ZCSAUXSTEXPEDIENTES deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ZCSAUXSTEXPEDIENTESBuilder();
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
