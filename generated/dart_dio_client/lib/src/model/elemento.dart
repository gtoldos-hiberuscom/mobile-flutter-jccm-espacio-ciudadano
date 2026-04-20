//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'elemento.g.dart';

/// ELEMENTO
///
/// Properties:
/// * [centro]
/// * [codcen]
/// * [codpaisexpedicion]
/// * [codtipotitulo]
/// * [codtitulacion]
/// * [fecexp]
/// * [fecfin]
/// * [ley]
/// * [nivel]
/// * [nordlib]
/// * [nregaut]
/// * [nregmec]
/// * [nregnac]
/// * [numfol]
/// * [numlib]
/// * [paisexpedicion]
/// * [provtit]
/// * [tipoest]
/// * [tipotit]
/// * [titulacion]
@BuiltValue()
abstract class ELEMENTO implements Built<ELEMENTO, ELEMENTOBuilder> {
  @BuiltValueField(wireName: r'centro')
  String? get centro;

  @BuiltValueField(wireName: r'codcen')
  String? get codcen;

  @BuiltValueField(wireName: r'codpaisexpedicion')
  String? get codpaisexpedicion;

  @BuiltValueField(wireName: r'codtipotitulo')
  String? get codtipotitulo;

  @BuiltValueField(wireName: r'codtitulacion')
  String? get codtitulacion;

  @BuiltValueField(wireName: r'fecexp')
  String? get fecexp;

  @BuiltValueField(wireName: r'fecfin')
  String? get fecfin;

  @BuiltValueField(wireName: r'ley')
  String? get ley;

  @BuiltValueField(wireName: r'nivel')
  String? get nivel;

  @BuiltValueField(wireName: r'nordlib')
  String? get nordlib;

  @BuiltValueField(wireName: r'nregaut')
  String? get nregaut;

  @BuiltValueField(wireName: r'nregmec')
  String? get nregmec;

  @BuiltValueField(wireName: r'nregnac')
  String? get nregnac;

  @BuiltValueField(wireName: r'numfol')
  String? get numfol;

  @BuiltValueField(wireName: r'numlib')
  String? get numlib;

  @BuiltValueField(wireName: r'paisexpedicion')
  String? get paisexpedicion;

  @BuiltValueField(wireName: r'provtit')
  String? get provtit;

  @BuiltValueField(wireName: r'tipoest')
  String? get tipoest;

  @BuiltValueField(wireName: r'tipotit')
  String? get tipotit;

  @BuiltValueField(wireName: r'titulacion')
  String? get titulacion;

  ELEMENTO._();

  factory ELEMENTO([void updates(ELEMENTOBuilder b)]) = _$ELEMENTO;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ELEMENTOBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ELEMENTO> get serializer => _$ELEMENTOSerializer();
}

class _$ELEMENTOSerializer implements PrimitiveSerializer<ELEMENTO> {
  @override
  final Iterable<Type> types = const [ELEMENTO, _$ELEMENTO];

  @override
  final String wireName = r'ELEMENTO';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ELEMENTO object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.centro != null) {
      yield r'centro';
      yield serializers.serialize(
        object.centro,
        specifiedType: const FullType(String),
      );
    }
    if (object.codcen != null) {
      yield r'codcen';
      yield serializers.serialize(
        object.codcen,
        specifiedType: const FullType(String),
      );
    }
    if (object.codpaisexpedicion != null) {
      yield r'codpaisexpedicion';
      yield serializers.serialize(
        object.codpaisexpedicion,
        specifiedType: const FullType(String),
      );
    }
    if (object.codtipotitulo != null) {
      yield r'codtipotitulo';
      yield serializers.serialize(
        object.codtipotitulo,
        specifiedType: const FullType(String),
      );
    }
    if (object.codtitulacion != null) {
      yield r'codtitulacion';
      yield serializers.serialize(
        object.codtitulacion,
        specifiedType: const FullType(String),
      );
    }
    if (object.fecexp != null) {
      yield r'fecexp';
      yield serializers.serialize(
        object.fecexp,
        specifiedType: const FullType(String),
      );
    }
    if (object.fecfin != null) {
      yield r'fecfin';
      yield serializers.serialize(
        object.fecfin,
        specifiedType: const FullType(String),
      );
    }
    if (object.ley != null) {
      yield r'ley';
      yield serializers.serialize(
        object.ley,
        specifiedType: const FullType(String),
      );
    }
    if (object.nivel != null) {
      yield r'nivel';
      yield serializers.serialize(
        object.nivel,
        specifiedType: const FullType(String),
      );
    }
    if (object.nordlib != null) {
      yield r'nordlib';
      yield serializers.serialize(
        object.nordlib,
        specifiedType: const FullType(String),
      );
    }
    if (object.nregaut != null) {
      yield r'nregaut';
      yield serializers.serialize(
        object.nregaut,
        specifiedType: const FullType(String),
      );
    }
    if (object.nregmec != null) {
      yield r'nregmec';
      yield serializers.serialize(
        object.nregmec,
        specifiedType: const FullType(String),
      );
    }
    if (object.nregnac != null) {
      yield r'nregnac';
      yield serializers.serialize(
        object.nregnac,
        specifiedType: const FullType(String),
      );
    }
    if (object.numfol != null) {
      yield r'numfol';
      yield serializers.serialize(
        object.numfol,
        specifiedType: const FullType(String),
      );
    }
    if (object.numlib != null) {
      yield r'numlib';
      yield serializers.serialize(
        object.numlib,
        specifiedType: const FullType(String),
      );
    }
    if (object.paisexpedicion != null) {
      yield r'paisexpedicion';
      yield serializers.serialize(
        object.paisexpedicion,
        specifiedType: const FullType(String),
      );
    }
    if (object.provtit != null) {
      yield r'provtit';
      yield serializers.serialize(
        object.provtit,
        specifiedType: const FullType(String),
      );
    }
    if (object.tipoest != null) {
      yield r'tipoest';
      yield serializers.serialize(
        object.tipoest,
        specifiedType: const FullType(String),
      );
    }
    if (object.tipotit != null) {
      yield r'tipotit';
      yield serializers.serialize(
        object.tipotit,
        specifiedType: const FullType(String),
      );
    }
    if (object.titulacion != null) {
      yield r'titulacion';
      yield serializers.serialize(
        object.titulacion,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ELEMENTO object, {
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
    required ELEMENTOBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'centro':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.centro = valueDes;
          break;
        case r'codcen':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.codcen = valueDes;
          break;
        case r'codpaisexpedicion':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.codpaisexpedicion = valueDes;
          break;
        case r'codtipotitulo':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.codtipotitulo = valueDes;
          break;
        case r'codtitulacion':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.codtitulacion = valueDes;
          break;
        case r'fecexp':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.fecexp = valueDes;
          break;
        case r'fecfin':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.fecfin = valueDes;
          break;
        case r'ley':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.ley = valueDes;
          break;
        case r'nivel':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.nivel = valueDes;
          break;
        case r'nordlib':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.nordlib = valueDes;
          break;
        case r'nregaut':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.nregaut = valueDes;
          break;
        case r'nregmec':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.nregmec = valueDes;
          break;
        case r'nregnac':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.nregnac = valueDes;
          break;
        case r'numfol':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.numfol = valueDes;
          break;
        case r'numlib':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.numlib = valueDes;
          break;
        case r'paisexpedicion':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.paisexpedicion = valueDes;
          break;
        case r'provtit':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.provtit = valueDes;
          break;
        case r'tipoest':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.tipoest = valueDes;
          break;
        case r'tipotit':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.tipotit = valueDes;
          break;
        case r'titulacion':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.titulacion = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ELEMENTO deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ELEMENTOBuilder();
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
