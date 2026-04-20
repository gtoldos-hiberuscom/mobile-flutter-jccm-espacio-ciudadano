//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:espacio_ciudadano_api/src/model/datos_especificos_familia_numerosa.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'response_familia_numerosa_intermediacion.g.dart';

/// ResponseFamiliaNumerosaIntermediacion
///
/// Properties:
/// * [codestado]
/// * [datosespecificos]
/// * [docu]
/// * [idpeticion]
/// * [mensaje]
/// * [tipodoc]
@BuiltValue()
abstract class ResponseFamiliaNumerosaIntermediacion
    implements
        Built<ResponseFamiliaNumerosaIntermediacion,
            ResponseFamiliaNumerosaIntermediacionBuilder> {
  @BuiltValueField(wireName: r'codestado')
  String? get codestado;

  @BuiltValueField(wireName: r'datosespecificos')
  DatosEspecificosFamiliaNumerosa? get datosespecificos;

  @BuiltValueField(wireName: r'docu')
  String? get docu;

  @BuiltValueField(wireName: r'idpeticion')
  String? get idpeticion;

  @BuiltValueField(wireName: r'mensaje')
  String? get mensaje;

  @BuiltValueField(wireName: r'tipodoc')
  String? get tipodoc;

  ResponseFamiliaNumerosaIntermediacion._();

  factory ResponseFamiliaNumerosaIntermediacion(
          [void updates(ResponseFamiliaNumerosaIntermediacionBuilder b)]) =
      _$ResponseFamiliaNumerosaIntermediacion;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ResponseFamiliaNumerosaIntermediacionBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ResponseFamiliaNumerosaIntermediacion> get serializer =>
      _$ResponseFamiliaNumerosaIntermediacionSerializer();
}

class _$ResponseFamiliaNumerosaIntermediacionSerializer
    implements PrimitiveSerializer<ResponseFamiliaNumerosaIntermediacion> {
  @override
  final Iterable<Type> types = const [
    ResponseFamiliaNumerosaIntermediacion,
    _$ResponseFamiliaNumerosaIntermediacion
  ];

  @override
  final String wireName = r'ResponseFamiliaNumerosaIntermediacion';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ResponseFamiliaNumerosaIntermediacion object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.codestado != null) {
      yield r'codestado';
      yield serializers.serialize(
        object.codestado,
        specifiedType: const FullType(String),
      );
    }
    if (object.datosespecificos != null) {
      yield r'datosespecificos';
      yield serializers.serialize(
        object.datosespecificos,
        specifiedType: const FullType(DatosEspecificosFamiliaNumerosa),
      );
    }
    if (object.docu != null) {
      yield r'docu';
      yield serializers.serialize(
        object.docu,
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
    if (object.tipodoc != null) {
      yield r'tipodoc';
      yield serializers.serialize(
        object.tipodoc,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ResponseFamiliaNumerosaIntermediacion object, {
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
    required ResponseFamiliaNumerosaIntermediacionBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'codestado':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.codestado = valueDes;
          break;
        case r'datosespecificos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DatosEspecificosFamiliaNumerosa),
          ) as DatosEspecificosFamiliaNumerosa;
          result.datosespecificos.replace(valueDes);
          break;
        case r'docu':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.docu = valueDes;
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
        case r'tipodoc':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.tipodoc = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ResponseFamiliaNumerosaIntermediacion deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ResponseFamiliaNumerosaIntermediacionBuilder();
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
