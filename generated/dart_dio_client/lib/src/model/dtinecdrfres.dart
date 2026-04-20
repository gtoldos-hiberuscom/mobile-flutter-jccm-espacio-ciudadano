//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'dtinecdrfres.g.dart';

/// DTINECDRFRES
///
/// Properties:
/// * [blores] 
/// * [codencol] 
/// * [codensin] 
/// * [codmun] 
/// * [codnuc] 
/// * [codpos] 
/// * [codpro] 
/// * [codunip] 
/// * [codvar] 
/// * [codvia] 
/// * [denencol] 
/// * [denensin] 
/// * [denmun] 
/// * [dennuc] 
/// * [denpro] 
/// * [descvar] 
/// * [docu] 
/// * [escres] 
/// * [fecvar] 
/// * [hecres] 
/// * [idpeticion] 
/// * [kimres] 
/// * [mensaje] 
/// * [nomvia] 
/// * [numres] 
/// * [numsup] 
/// * [plares] 
/// * [portes] 
/// * [pueres] 
/// * [resul] 
/// * [tipodoc] 
/// * [tipvia] 
@BuiltValue()
abstract class DTINECDRFRES implements Built<DTINECDRFRES, DTINECDRFRESBuilder> {
  @BuiltValueField(wireName: r'blores')
  String? get blores;

  @BuiltValueField(wireName: r'codencol')
  String? get codencol;

  @BuiltValueField(wireName: r'codensin')
  String? get codensin;

  @BuiltValueField(wireName: r'codmun')
  String? get codmun;

  @BuiltValueField(wireName: r'codnuc')
  String? get codnuc;

  @BuiltValueField(wireName: r'codpos')
  String? get codpos;

  @BuiltValueField(wireName: r'codpro')
  String? get codpro;

  @BuiltValueField(wireName: r'codunip')
  String? get codunip;

  @BuiltValueField(wireName: r'codvar')
  String? get codvar;

  @BuiltValueField(wireName: r'codvia')
  String? get codvia;

  @BuiltValueField(wireName: r'denencol')
  String? get denencol;

  @BuiltValueField(wireName: r'denensin')
  String? get denensin;

  @BuiltValueField(wireName: r'denmun')
  String? get denmun;

  @BuiltValueField(wireName: r'dennuc')
  String? get dennuc;

  @BuiltValueField(wireName: r'denpro')
  String? get denpro;

  @BuiltValueField(wireName: r'descvar')
  String? get descvar;

  @BuiltValueField(wireName: r'docu')
  String? get docu;

  @BuiltValueField(wireName: r'escres')
  String? get escres;

  @BuiltValueField(wireName: r'fecvar')
  String? get fecvar;

  @BuiltValueField(wireName: r'hecres')
  String? get hecres;

  @BuiltValueField(wireName: r'idpeticion')
  String? get idpeticion;

  @BuiltValueField(wireName: r'kimres')
  String? get kimres;

  @BuiltValueField(wireName: r'mensaje')
  String? get mensaje;

  @BuiltValueField(wireName: r'nomvia')
  String? get nomvia;

  @BuiltValueField(wireName: r'numres')
  String? get numres;

  @BuiltValueField(wireName: r'numsup')
  String? get numsup;

  @BuiltValueField(wireName: r'plares')
  String? get plares;

  @BuiltValueField(wireName: r'portes')
  String? get portes;

  @BuiltValueField(wireName: r'pueres')
  String? get pueres;

  @BuiltValueField(wireName: r'resul')
  String? get resul;

  @BuiltValueField(wireName: r'tipodoc')
  String? get tipodoc;

  @BuiltValueField(wireName: r'tipvia')
  String? get tipvia;

  DTINECDRFRES._();

  factory DTINECDRFRES([void updates(DTINECDRFRESBuilder b)]) = _$DTINECDRFRES;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DTINECDRFRESBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DTINECDRFRES> get serializer => _$DTINECDRFRESSerializer();
}

class _$DTINECDRFRESSerializer implements PrimitiveSerializer<DTINECDRFRES> {
  @override
  final Iterable<Type> types = const [DTINECDRFRES, _$DTINECDRFRES];

  @override
  final String wireName = r'DTINECDRFRES';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DTINECDRFRES object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.blores != null) {
      yield r'blores';
      yield serializers.serialize(
        object.blores,
        specifiedType: const FullType(String),
      );
    }
    if (object.codencol != null) {
      yield r'codencol';
      yield serializers.serialize(
        object.codencol,
        specifiedType: const FullType(String),
      );
    }
    if (object.codensin != null) {
      yield r'codensin';
      yield serializers.serialize(
        object.codensin,
        specifiedType: const FullType(String),
      );
    }
    if (object.codmun != null) {
      yield r'codmun';
      yield serializers.serialize(
        object.codmun,
        specifiedType: const FullType(String),
      );
    }
    if (object.codnuc != null) {
      yield r'codnuc';
      yield serializers.serialize(
        object.codnuc,
        specifiedType: const FullType(String),
      );
    }
    if (object.codpos != null) {
      yield r'codpos';
      yield serializers.serialize(
        object.codpos,
        specifiedType: const FullType(String),
      );
    }
    if (object.codpro != null) {
      yield r'codpro';
      yield serializers.serialize(
        object.codpro,
        specifiedType: const FullType(String),
      );
    }
    if (object.codunip != null) {
      yield r'codunip';
      yield serializers.serialize(
        object.codunip,
        specifiedType: const FullType(String),
      );
    }
    if (object.codvar != null) {
      yield r'codvar';
      yield serializers.serialize(
        object.codvar,
        specifiedType: const FullType(String),
      );
    }
    if (object.codvia != null) {
      yield r'codvia';
      yield serializers.serialize(
        object.codvia,
        specifiedType: const FullType(String),
      );
    }
    if (object.denencol != null) {
      yield r'denencol';
      yield serializers.serialize(
        object.denencol,
        specifiedType: const FullType(String),
      );
    }
    if (object.denensin != null) {
      yield r'denensin';
      yield serializers.serialize(
        object.denensin,
        specifiedType: const FullType(String),
      );
    }
    if (object.denmun != null) {
      yield r'denmun';
      yield serializers.serialize(
        object.denmun,
        specifiedType: const FullType(String),
      );
    }
    if (object.dennuc != null) {
      yield r'dennuc';
      yield serializers.serialize(
        object.dennuc,
        specifiedType: const FullType(String),
      );
    }
    if (object.denpro != null) {
      yield r'denpro';
      yield serializers.serialize(
        object.denpro,
        specifiedType: const FullType(String),
      );
    }
    if (object.descvar != null) {
      yield r'descvar';
      yield serializers.serialize(
        object.descvar,
        specifiedType: const FullType(String),
      );
    }
    if (object.docu != null) {
      yield r'docu';
      yield serializers.serialize(
        object.docu,
        specifiedType: const FullType(String),
      );
    }
    if (object.escres != null) {
      yield r'escres';
      yield serializers.serialize(
        object.escres,
        specifiedType: const FullType(String),
      );
    }
    if (object.fecvar != null) {
      yield r'fecvar';
      yield serializers.serialize(
        object.fecvar,
        specifiedType: const FullType(String),
      );
    }
    if (object.hecres != null) {
      yield r'hecres';
      yield serializers.serialize(
        object.hecres,
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
    if (object.kimres != null) {
      yield r'kimres';
      yield serializers.serialize(
        object.kimres,
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
    if (object.nomvia != null) {
      yield r'nomvia';
      yield serializers.serialize(
        object.nomvia,
        specifiedType: const FullType(String),
      );
    }
    if (object.numres != null) {
      yield r'numres';
      yield serializers.serialize(
        object.numres,
        specifiedType: const FullType(String),
      );
    }
    if (object.numsup != null) {
      yield r'numsup';
      yield serializers.serialize(
        object.numsup,
        specifiedType: const FullType(String),
      );
    }
    if (object.plares != null) {
      yield r'plares';
      yield serializers.serialize(
        object.plares,
        specifiedType: const FullType(String),
      );
    }
    if (object.portes != null) {
      yield r'portes';
      yield serializers.serialize(
        object.portes,
        specifiedType: const FullType(String),
      );
    }
    if (object.pueres != null) {
      yield r'pueres';
      yield serializers.serialize(
        object.pueres,
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
    if (object.tipodoc != null) {
      yield r'tipodoc';
      yield serializers.serialize(
        object.tipodoc,
        specifiedType: const FullType(String),
      );
    }
    if (object.tipvia != null) {
      yield r'tipvia';
      yield serializers.serialize(
        object.tipvia,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    DTINECDRFRES object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DTINECDRFRESBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'blores':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.blores = valueDes;
          break;
        case r'codencol':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.codencol = valueDes;
          break;
        case r'codensin':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.codensin = valueDes;
          break;
        case r'codmun':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.codmun = valueDes;
          break;
        case r'codnuc':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.codnuc = valueDes;
          break;
        case r'codpos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.codpos = valueDes;
          break;
        case r'codpro':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.codpro = valueDes;
          break;
        case r'codunip':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.codunip = valueDes;
          break;
        case r'codvar':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.codvar = valueDes;
          break;
        case r'codvia':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.codvia = valueDes;
          break;
        case r'denencol':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.denencol = valueDes;
          break;
        case r'denensin':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.denensin = valueDes;
          break;
        case r'denmun':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.denmun = valueDes;
          break;
        case r'dennuc':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.dennuc = valueDes;
          break;
        case r'denpro':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.denpro = valueDes;
          break;
        case r'descvar':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.descvar = valueDes;
          break;
        case r'docu':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.docu = valueDes;
          break;
        case r'escres':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.escres = valueDes;
          break;
        case r'fecvar':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.fecvar = valueDes;
          break;
        case r'hecres':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.hecres = valueDes;
          break;
        case r'idpeticion':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.idpeticion = valueDes;
          break;
        case r'kimres':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.kimres = valueDes;
          break;
        case r'mensaje':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.mensaje = valueDes;
          break;
        case r'nomvia':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.nomvia = valueDes;
          break;
        case r'numres':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.numres = valueDes;
          break;
        case r'numsup':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.numsup = valueDes;
          break;
        case r'plares':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.plares = valueDes;
          break;
        case r'portes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.portes = valueDes;
          break;
        case r'pueres':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.pueres = valueDes;
          break;
        case r'resul':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.resul = valueDes;
          break;
        case r'tipodoc':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.tipodoc = valueDes;
          break;
        case r'tipvia':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.tipvia = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DTINECDRFRES deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DTINECDRFRESBuilder();
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

