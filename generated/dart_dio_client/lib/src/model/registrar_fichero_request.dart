//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:espacio_ciudadano_api/src/model/documento_registro.dart';
import 'package:espacio_ciudadano_api/src/model/xml_registro.dart';
import 'package:built_collection/built_collection.dart';
import 'package:espacio_ciudadano_api/src/model/datos_representante.dart';
import 'package:espacio_ciudadano_api/src/model/confirmarprocedimiento.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'registrar_fichero_request.g.dart';

/// RegistrarFicheroRequest
///
/// Properties:
/// * [confirmarProcedimiento]
/// * [consejeriaTramitadora]
/// * [datosRepresentante]
/// * [documentos]
/// * [esPorContraste]
/// * [estadoTramitacion]
/// * [fechaCierreTramitacion]
/// * [fechaInicioTramitacion]
/// * [oficinaTramitadora]
/// * [procedimiento]
/// * [xmlRegistro]
@BuiltValue()
abstract class RegistrarFicheroRequest
    implements Built<RegistrarFicheroRequest, RegistrarFicheroRequestBuilder> {
  @BuiltValueField(wireName: r'confirmarProcedimiento')
  CONFIRMARPROCEDIMIENTO? get confirmarProcedimiento;

  @BuiltValueField(wireName: r'consejeriaTramitadora')
  String? get consejeriaTramitadora;

  @BuiltValueField(wireName: r'datosRepresentante')
  DatosRepresentante? get datosRepresentante;

  @BuiltValueField(wireName: r'documentos')
  BuiltList<DocumentoRegistro>? get documentos;

  @BuiltValueField(wireName: r'esPorContraste')
  bool? get esPorContraste;

  @BuiltValueField(wireName: r'estadoTramitacion')
  String? get estadoTramitacion;

  @BuiltValueField(wireName: r'fechaCierreTramitacion')
  String? get fechaCierreTramitacion;

  @BuiltValueField(wireName: r'fechaInicioTramitacion')
  String? get fechaInicioTramitacion;

  @BuiltValueField(wireName: r'oficinaTramitadora')
  String? get oficinaTramitadora;

  @BuiltValueField(wireName: r'procedimiento')
  String? get procedimiento;

  @BuiltValueField(wireName: r'xmlRegistro')
  XMLRegistro? get xmlRegistro;

  RegistrarFicheroRequest._();

  factory RegistrarFicheroRequest(
          [void updates(RegistrarFicheroRequestBuilder b)]) =
      _$RegistrarFicheroRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RegistrarFicheroRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RegistrarFicheroRequest> get serializer =>
      _$RegistrarFicheroRequestSerializer();
}

class _$RegistrarFicheroRequestSerializer
    implements PrimitiveSerializer<RegistrarFicheroRequest> {
  @override
  final Iterable<Type> types = const [
    RegistrarFicheroRequest,
    _$RegistrarFicheroRequest
  ];

  @override
  final String wireName = r'RegistrarFicheroRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RegistrarFicheroRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.confirmarProcedimiento != null) {
      yield r'confirmarProcedimiento';
      yield serializers.serialize(
        object.confirmarProcedimiento,
        specifiedType: const FullType(CONFIRMARPROCEDIMIENTO),
      );
    }
    if (object.consejeriaTramitadora != null) {
      yield r'consejeriaTramitadora';
      yield serializers.serialize(
        object.consejeriaTramitadora,
        specifiedType: const FullType(String),
      );
    }
    if (object.datosRepresentante != null) {
      yield r'datosRepresentante';
      yield serializers.serialize(
        object.datosRepresentante,
        specifiedType: const FullType(DatosRepresentante),
      );
    }
    if (object.documentos != null) {
      yield r'documentos';
      yield serializers.serialize(
        object.documentos,
        specifiedType: const FullType(BuiltList, [FullType(DocumentoRegistro)]),
      );
    }
    if (object.esPorContraste != null) {
      yield r'esPorContraste';
      yield serializers.serialize(
        object.esPorContraste,
        specifiedType: const FullType(bool),
      );
    }
    if (object.estadoTramitacion != null) {
      yield r'estadoTramitacion';
      yield serializers.serialize(
        object.estadoTramitacion,
        specifiedType: const FullType(String),
      );
    }
    if (object.fechaCierreTramitacion != null) {
      yield r'fechaCierreTramitacion';
      yield serializers.serialize(
        object.fechaCierreTramitacion,
        specifiedType: const FullType(String),
      );
    }
    if (object.fechaInicioTramitacion != null) {
      yield r'fechaInicioTramitacion';
      yield serializers.serialize(
        object.fechaInicioTramitacion,
        specifiedType: const FullType(String),
      );
    }
    if (object.oficinaTramitadora != null) {
      yield r'oficinaTramitadora';
      yield serializers.serialize(
        object.oficinaTramitadora,
        specifiedType: const FullType(String),
      );
    }
    if (object.procedimiento != null) {
      yield r'procedimiento';
      yield serializers.serialize(
        object.procedimiento,
        specifiedType: const FullType(String),
      );
    }
    if (object.xmlRegistro != null) {
      yield r'xmlRegistro';
      yield serializers.serialize(
        object.xmlRegistro,
        specifiedType: const FullType(XMLRegistro),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    RegistrarFicheroRequest object, {
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
    required RegistrarFicheroRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'confirmarProcedimiento':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CONFIRMARPROCEDIMIENTO),
          ) as CONFIRMARPROCEDIMIENTO;
          result.confirmarProcedimiento.replace(valueDes);
          break;
        case r'consejeriaTramitadora':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.consejeriaTramitadora = valueDes;
          break;
        case r'datosRepresentante':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DatosRepresentante),
          ) as DatosRepresentante;
          result.datosRepresentante.replace(valueDes);
          break;
        case r'documentos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType(BuiltList, [FullType(DocumentoRegistro)]),
          ) as BuiltList<DocumentoRegistro>;
          result.documentos.replace(valueDes);
          break;
        case r'esPorContraste':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.esPorContraste = valueDes;
          break;
        case r'estadoTramitacion':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.estadoTramitacion = valueDes;
          break;
        case r'fechaCierreTramitacion':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.fechaCierreTramitacion = valueDes;
          break;
        case r'fechaInicioTramitacion':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.fechaInicioTramitacion = valueDes;
          break;
        case r'oficinaTramitadora':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.oficinaTramitadora = valueDes;
          break;
        case r'procedimiento':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.procedimiento = valueDes;
          break;
        case r'xmlRegistro':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(XMLRegistro),
          ) as XMLRegistro;
          result.xmlRegistro.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  RegistrarFicheroRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RegistrarFicheroRequestBuilder();
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
