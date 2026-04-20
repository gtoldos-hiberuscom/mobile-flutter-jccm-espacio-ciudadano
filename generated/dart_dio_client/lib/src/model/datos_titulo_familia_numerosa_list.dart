//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'datos_titulo_familia_numerosa_list.g.dart';

/// DatosTituloFamiliaNumerosaList
///
/// Properties:
/// * [categoria] 
/// * [codigoComunidadAutoma] 
/// * [fechaCaducidad] 
/// * [fechaEfecto] 
/// * [numeroHijos] 
/// * [numeroTitulo] 
/// * [tituloVigente] 
@BuiltValue()
abstract class DatosTituloFamiliaNumerosaList implements Built<DatosTituloFamiliaNumerosaList, DatosTituloFamiliaNumerosaListBuilder> {
  @BuiltValueField(wireName: r'categoria')
  String? get categoria;

  @BuiltValueField(wireName: r'codigo_comunidad_automa')
  String? get codigoComunidadAutoma;

  @BuiltValueField(wireName: r'fecha_caducidad')
  String? get fechaCaducidad;

  @BuiltValueField(wireName: r'fecha_efecto')
  String? get fechaEfecto;

  @BuiltValueField(wireName: r'numero_hijos')
  int? get numeroHijos;

  @BuiltValueField(wireName: r'numero_titulo')
  String? get numeroTitulo;

  @BuiltValueField(wireName: r'titulo_vigente')
  String? get tituloVigente;

  DatosTituloFamiliaNumerosaList._();

  factory DatosTituloFamiliaNumerosaList([void updates(DatosTituloFamiliaNumerosaListBuilder b)]) = _$DatosTituloFamiliaNumerosaList;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DatosTituloFamiliaNumerosaListBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DatosTituloFamiliaNumerosaList> get serializer => _$DatosTituloFamiliaNumerosaListSerializer();
}

class _$DatosTituloFamiliaNumerosaListSerializer implements PrimitiveSerializer<DatosTituloFamiliaNumerosaList> {
  @override
  final Iterable<Type> types = const [DatosTituloFamiliaNumerosaList, _$DatosTituloFamiliaNumerosaList];

  @override
  final String wireName = r'DatosTituloFamiliaNumerosaList';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DatosTituloFamiliaNumerosaList object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.categoria != null) {
      yield r'categoria';
      yield serializers.serialize(
        object.categoria,
        specifiedType: const FullType(String),
      );
    }
    if (object.codigoComunidadAutoma != null) {
      yield r'codigo_comunidad_automa';
      yield serializers.serialize(
        object.codigoComunidadAutoma,
        specifiedType: const FullType(String),
      );
    }
    if (object.fechaCaducidad != null) {
      yield r'fecha_caducidad';
      yield serializers.serialize(
        object.fechaCaducidad,
        specifiedType: const FullType(String),
      );
    }
    if (object.fechaEfecto != null) {
      yield r'fecha_efecto';
      yield serializers.serialize(
        object.fechaEfecto,
        specifiedType: const FullType(String),
      );
    }
    if (object.numeroHijos != null) {
      yield r'numero_hijos';
      yield serializers.serialize(
        object.numeroHijos,
        specifiedType: const FullType(int),
      );
    }
    if (object.numeroTitulo != null) {
      yield r'numero_titulo';
      yield serializers.serialize(
        object.numeroTitulo,
        specifiedType: const FullType(String),
      );
    }
    if (object.tituloVigente != null) {
      yield r'titulo_vigente';
      yield serializers.serialize(
        object.tituloVigente,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    DatosTituloFamiliaNumerosaList object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DatosTituloFamiliaNumerosaListBuilder result,
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
        case r'codigo_comunidad_automa':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.codigoComunidadAutoma = valueDes;
          break;
        case r'fecha_caducidad':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.fechaCaducidad = valueDes;
          break;
        case r'fecha_efecto':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.fechaEfecto = valueDes;
          break;
        case r'numero_hijos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.numeroHijos = valueDes;
          break;
        case r'numero_titulo':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.numeroTitulo = valueDes;
          break;
        case r'titulo_vigente':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.tituloVigente = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DatosTituloFamiliaNumerosaList deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DatosTituloFamiliaNumerosaListBuilder();
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

