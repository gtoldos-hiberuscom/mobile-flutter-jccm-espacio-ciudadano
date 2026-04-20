//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'tramite.g.dart';

/// Tramite
///
/// Properties:
/// * [fechaPresentacionFin]
/// * [fechaPresentacionIni]
/// * [idTramite]
/// * [idUnidadResponsable]
/// * [nombreTramite]
/// * [nombreUnidadResponsable]
@BuiltValue()
abstract class Tramite implements Built<Tramite, TramiteBuilder> {
  @BuiltValueField(wireName: r'fechaPresentacionFin')
  String? get fechaPresentacionFin;

  @BuiltValueField(wireName: r'fechaPresentacionIni')
  String? get fechaPresentacionIni;

  @BuiltValueField(wireName: r'idTramite')
  int? get idTramite;

  @BuiltValueField(wireName: r'idUnidadResponsable')
  int? get idUnidadResponsable;

  @BuiltValueField(wireName: r'nombreTramite')
  String? get nombreTramite;

  @BuiltValueField(wireName: r'nombreUnidadResponsable')
  String? get nombreUnidadResponsable;

  Tramite._();

  factory Tramite([void updates(TramiteBuilder b)]) = _$Tramite;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TramiteBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<Tramite> get serializer => _$TramiteSerializer();
}

class _$TramiteSerializer implements PrimitiveSerializer<Tramite> {
  @override
  final Iterable<Type> types = const [Tramite, _$Tramite];

  @override
  final String wireName = r'Tramite';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    Tramite object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.fechaPresentacionFin != null) {
      yield r'fechaPresentacionFin';
      yield serializers.serialize(
        object.fechaPresentacionFin,
        specifiedType: const FullType(String),
      );
    }
    if (object.fechaPresentacionIni != null) {
      yield r'fechaPresentacionIni';
      yield serializers.serialize(
        object.fechaPresentacionIni,
        specifiedType: const FullType(String),
      );
    }
    if (object.idTramite != null) {
      yield r'idTramite';
      yield serializers.serialize(
        object.idTramite,
        specifiedType: const FullType(int),
      );
    }
    if (object.idUnidadResponsable != null) {
      yield r'idUnidadResponsable';
      yield serializers.serialize(
        object.idUnidadResponsable,
        specifiedType: const FullType(int),
      );
    }
    if (object.nombreTramite != null) {
      yield r'nombreTramite';
      yield serializers.serialize(
        object.nombreTramite,
        specifiedType: const FullType(String),
      );
    }
    if (object.nombreUnidadResponsable != null) {
      yield r'nombreUnidadResponsable';
      yield serializers.serialize(
        object.nombreUnidadResponsable,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    Tramite object, {
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
    required TramiteBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'fechaPresentacionFin':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.fechaPresentacionFin = valueDes;
          break;
        case r'fechaPresentacionIni':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.fechaPresentacionIni = valueDes;
          break;
        case r'idTramite':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.idTramite = valueDes;
          break;
        case r'idUnidadResponsable':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.idUnidadResponsable = valueDes;
          break;
        case r'nombreTramite':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.nombreTramite = valueDes;
          break;
        case r'nombreUnidadResponsable':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.nombreUnidadResponsable = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  Tramite deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TramiteBuilder();
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
