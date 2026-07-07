//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'adjunto.g.dart';

/// ADJUNTO
///
/// Properties:
/// * [categoria] 
/// * [data] 
/// * [hash] 
/// * [idaplic] 
/// * [idprop] 
/// * [idtrans] 
/// * [idunico] 
/// * [metadatos] 
/// * [nifcif] 
/// * [nombre] 
/// * [observaciones1] 
/// * [observaciones2] 
/// * [observaciones3] 
/// * [origen] 
/// * [subject] 
/// * [tdoc] 
/// * [tipodoc] 
/// * [tipoprocedimiento] 
@BuiltValue()
abstract class ADJUNTO implements Built<ADJUNTO, ADJUNTOBuilder> {
  @BuiltValueField(wireName: r'categoria')
  String? get categoria;

  @BuiltValueField(wireName: r'data')
  String? get data;

  @BuiltValueField(wireName: r'hash')
  String? get hash;

  @BuiltValueField(wireName: r'idaplic')
  String? get idaplic;

  @BuiltValueField(wireName: r'idprop')
  String? get idprop;

  @BuiltValueField(wireName: r'idtrans')
  String? get idtrans;

  @BuiltValueField(wireName: r'idunico')
  String get idunico;

  @BuiltValueField(wireName: r'metadatos')
  String? get metadatos;

  @BuiltValueField(wireName: r'nifcif')
  String get nifcif;

  @BuiltValueField(wireName: r'nombre')
  String get nombre;

  @BuiltValueField(wireName: r'observaciones1')
  String? get observaciones1;

  @BuiltValueField(wireName: r'observaciones2')
  String? get observaciones2;

  @BuiltValueField(wireName: r'observaciones3')
  String? get observaciones3;

  @BuiltValueField(wireName: r'origen')
  String? get origen;

  @BuiltValueField(wireName: r'subject')
  String? get subject;

  @BuiltValueField(wireName: r'tdoc')
  String? get tdoc;

  @BuiltValueField(wireName: r'tipodoc')
  String? get tipodoc;

  @BuiltValueField(wireName: r'tipoprocedimiento')
  String get tipoprocedimiento;

  ADJUNTO._();

  factory ADJUNTO([void updates(ADJUNTOBuilder b)]) = _$ADJUNTO;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ADJUNTOBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ADJUNTO> get serializer => _$ADJUNTOSerializer();
}

class _$ADJUNTOSerializer implements PrimitiveSerializer<ADJUNTO> {
  @override
  final Iterable<Type> types = const [ADJUNTO, _$ADJUNTO];

  @override
  final String wireName = r'ADJUNTO';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ADJUNTO object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.categoria != null) {
      yield r'categoria';
      yield serializers.serialize(
        object.categoria,
        specifiedType: const FullType(String),
      );
    }
    if (object.data != null) {
      yield r'data';
      yield serializers.serialize(
        object.data,
        specifiedType: const FullType(String),
      );
    }
    if (object.hash != null) {
      yield r'hash';
      yield serializers.serialize(
        object.hash,
        specifiedType: const FullType(String),
      );
    }
    if (object.idaplic != null) {
      yield r'idaplic';
      yield serializers.serialize(
        object.idaplic,
        specifiedType: const FullType(String),
      );
    }
    if (object.idprop != null) {
      yield r'idprop';
      yield serializers.serialize(
        object.idprop,
        specifiedType: const FullType(String),
      );
    }
    if (object.idtrans != null) {
      yield r'idtrans';
      yield serializers.serialize(
        object.idtrans,
        specifiedType: const FullType(String),
      );
    }
    yield r'idunico';
    yield serializers.serialize(
      object.idunico,
      specifiedType: const FullType(String),
    );
    if (object.metadatos != null) {
      yield r'metadatos';
      yield serializers.serialize(
        object.metadatos,
        specifiedType: const FullType(String),
      );
    }
    yield r'nifcif';
    yield serializers.serialize(
      object.nifcif,
      specifiedType: const FullType(String),
    );
    yield r'nombre';
    yield serializers.serialize(
      object.nombre,
      specifiedType: const FullType(String),
    );
    if (object.observaciones1 != null) {
      yield r'observaciones1';
      yield serializers.serialize(
        object.observaciones1,
        specifiedType: const FullType(String),
      );
    }
    if (object.observaciones2 != null) {
      yield r'observaciones2';
      yield serializers.serialize(
        object.observaciones2,
        specifiedType: const FullType(String),
      );
    }
    if (object.observaciones3 != null) {
      yield r'observaciones3';
      yield serializers.serialize(
        object.observaciones3,
        specifiedType: const FullType(String),
      );
    }
    if (object.origen != null) {
      yield r'origen';
      yield serializers.serialize(
        object.origen,
        specifiedType: const FullType(String),
      );
    }
    if (object.subject != null) {
      yield r'subject';
      yield serializers.serialize(
        object.subject,
        specifiedType: const FullType(String),
      );
    }
    if (object.tdoc != null) {
      yield r'tdoc';
      yield serializers.serialize(
        object.tdoc,
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
    yield r'tipoprocedimiento';
    yield serializers.serialize(
      object.tipoprocedimiento,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ADJUNTO object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ADJUNTOBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'categoria':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.categoria = valueDes;
          break;
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.data = valueDes;
          break;
        case r'hash':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.hash = valueDes;
          break;
        case r'idaplic':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.idaplic = valueDes;
          break;
        case r'idprop':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.idprop = valueDes;
          break;
        case r'idtrans':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.idtrans = valueDes;
          break;
        case r'idunico':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.idunico = valueDes;
          break;
        case r'metadatos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.metadatos = valueDes;
          break;
        case r'nifcif':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.nifcif = valueDes;
          break;
        case r'nombre':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.nombre = valueDes;
          break;
        case r'observaciones1':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.observaciones1 = valueDes;
          break;
        case r'observaciones2':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.observaciones2 = valueDes;
          break;
        case r'observaciones3':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.observaciones3 = valueDes;
          break;
        case r'origen':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.origen = valueDes;
          break;
        case r'subject':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.subject = valueDes;
          break;
        case r'tdoc':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.tdoc = valueDes;
          break;
        case r'tipodoc':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.tipodoc = valueDes;
          break;
        case r'tipoprocedimiento':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.tipoprocedimiento = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ADJUNTO deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ADJUNTOBuilder();
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

