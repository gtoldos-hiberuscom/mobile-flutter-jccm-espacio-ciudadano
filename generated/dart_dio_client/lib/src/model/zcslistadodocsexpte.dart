//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'zcslistadodocsexpte.g.dart';

/// ZCSLISTADODOCSEXPTE
///
/// Properties:
/// * [clase] 
/// * [codmod] 
/// * [datarege] 
/// * [descrip] 
/// * [ejeexp] 
/// * [fechadoc] 
/// * [horarege] 
/// * [idtransaccion] 
/// * [numdoc] 
/// * [numexp] 
/// * [numrege] 
@BuiltValue()
abstract class ZCSLISTADODOCSEXPTE implements Built<ZCSLISTADODOCSEXPTE, ZCSLISTADODOCSEXPTEBuilder> {
  @BuiltValueField(wireName: r'clase')
  String? get clase;

  @BuiltValueField(wireName: r'codmod')
  String? get codmod;

  @BuiltValueField(wireName: r'datarege')
  String? get datarege;

  @BuiltValueField(wireName: r'descrip')
  String? get descrip;

  @BuiltValueField(wireName: r'ejeexp')
  String? get ejeexp;

  @BuiltValueField(wireName: r'fechadoc')
  String? get fechadoc;

  @BuiltValueField(wireName: r'horarege')
  String? get horarege;

  @BuiltValueField(wireName: r'idtransaccion')
  String? get idtransaccion;

  @BuiltValueField(wireName: r'numdoc')
  String? get numdoc;

  @BuiltValueField(wireName: r'numexp')
  String? get numexp;

  @BuiltValueField(wireName: r'numrege')
  String? get numrege;

  ZCSLISTADODOCSEXPTE._();

  factory ZCSLISTADODOCSEXPTE([void updates(ZCSLISTADODOCSEXPTEBuilder b)]) = _$ZCSLISTADODOCSEXPTE;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ZCSLISTADODOCSEXPTEBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ZCSLISTADODOCSEXPTE> get serializer => _$ZCSLISTADODOCSEXPTESerializer();
}

class _$ZCSLISTADODOCSEXPTESerializer implements PrimitiveSerializer<ZCSLISTADODOCSEXPTE> {
  @override
  final Iterable<Type> types = const [ZCSLISTADODOCSEXPTE, _$ZCSLISTADODOCSEXPTE];

  @override
  final String wireName = r'ZCSLISTADODOCSEXPTE';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ZCSLISTADODOCSEXPTE object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.clase != null) {
      yield r'clase';
      yield serializers.serialize(
        object.clase,
        specifiedType: const FullType(String),
      );
    }
    if (object.codmod != null) {
      yield r'codmod';
      yield serializers.serialize(
        object.codmod,
        specifiedType: const FullType(String),
      );
    }
    if (object.datarege != null) {
      yield r'datarege';
      yield serializers.serialize(
        object.datarege,
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
    if (object.ejeexp != null) {
      yield r'ejeexp';
      yield serializers.serialize(
        object.ejeexp,
        specifiedType: const FullType(String),
      );
    }
    if (object.fechadoc != null) {
      yield r'fechadoc';
      yield serializers.serialize(
        object.fechadoc,
        specifiedType: const FullType(String),
      );
    }
    if (object.horarege != null) {
      yield r'horarege';
      yield serializers.serialize(
        object.horarege,
        specifiedType: const FullType(String),
      );
    }
    if (object.idtransaccion != null) {
      yield r'idtransaccion';
      yield serializers.serialize(
        object.idtransaccion,
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
    if (object.numexp != null) {
      yield r'numexp';
      yield serializers.serialize(
        object.numexp,
        specifiedType: const FullType(String),
      );
    }
    if (object.numrege != null) {
      yield r'numrege';
      yield serializers.serialize(
        object.numrege,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ZCSLISTADODOCSEXPTE object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ZCSLISTADODOCSEXPTEBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'clase':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.clase = valueDes;
          break;
        case r'codmod':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.codmod = valueDes;
          break;
        case r'datarege':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.datarege = valueDes;
          break;
        case r'descrip':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.descrip = valueDes;
          break;
        case r'ejeexp':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.ejeexp = valueDes;
          break;
        case r'fechadoc':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.fechadoc = valueDes;
          break;
        case r'horarege':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.horarege = valueDes;
          break;
        case r'idtransaccion':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.idtransaccion = valueDes;
          break;
        case r'numdoc':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.numdoc = valueDes;
          break;
        case r'numexp':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.numexp = valueDes;
          break;
        case r'numrege':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.numrege = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ZCSLISTADODOCSEXPTE deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ZCSLISTADODOCSEXPTEBuilder();
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

