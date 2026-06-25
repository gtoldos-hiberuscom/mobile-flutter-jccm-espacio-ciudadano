//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:espacio_ciudadano_api/src/model/interesado_notifica_dto.dart';
import 'package:built_collection/built_collection.dart';
import 'package:espacio_ciudadano_api/src/model/procedimiento_administrativo_dto.dart';
import 'package:espacio_ciudadano_api/src/model/unidad_organica_dto.dart';
import 'package:espacio_ciudadano_api/src/model/documentos_dto.dart';
import 'package:espacio_ciudadano_api/src/model/expediente_dto.dart';
import 'package:espacio_ciudadano_api/src/model/historico_estado_dto.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'notificacion_dto.g.dart';

/// NotificacionDto
///
/// Properties:
/// * [concepto]
/// * [descripcion]
/// * [documentos]
/// * [estado]
/// * [expediente]
/// * [fecAlta]
/// * [fecCaducidad]
/// * [historicoEstados]
/// * [id]
/// * [interesados]
/// * [procedimientoAdministrativo]
/// * [tipoEnvio]
/// * [unidadOrganica]
@BuiltValue()
abstract class NotificacionDto
    implements Built<NotificacionDto, NotificacionDtoBuilder> {
  @BuiltValueField(wireName: r'concepto')
  String? get concepto;

  @BuiltValueField(wireName: r'descripcion')
  String? get descripcion;

  @BuiltValueField(wireName: r'documentos')
  BuiltList<DocumentosDto>? get documentos;

  @BuiltValueField(wireName: r'estado')
  String? get estado;

  @BuiltValueField(wireName: r'expediente')
  ExpedienteDto? get expediente;

  @BuiltValueField(wireName: r'fecAlta')
  DateTime? get fecAlta;

  @BuiltValueField(wireName: r'fecCaducidad')
  DateTime? get fecCaducidad;

  @BuiltValueField(wireName: r'historicoEstados')
  BuiltList<HistoricoEstadoDto>? get historicoEstados;

  @BuiltValueField(wireName: r'id')
  int? get id;

  @BuiltValueField(wireName: r'interesados')
  BuiltList<InteresadoNotificaDto>? get interesados;

  @BuiltValueField(wireName: r'procedimientoAdministrativo')
  ProcedimientoAdministrativoDto? get procedimientoAdministrativo;

  @BuiltValueField(wireName: r'tipoEnvio')
  String? get tipoEnvio;

  @BuiltValueField(wireName: r'unidadOrganica')
  UnidadOrganicaDto? get unidadOrganica;

  NotificacionDto._();

  factory NotificacionDto([void updates(NotificacionDtoBuilder b)]) =
      _$NotificacionDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(NotificacionDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<NotificacionDto> get serializer =>
      _$NotificacionDtoSerializer();
}

class _$NotificacionDtoSerializer
    implements PrimitiveSerializer<NotificacionDto> {
  @override
  final Iterable<Type> types = const [NotificacionDto, _$NotificacionDto];

  @override
  final String wireName = r'NotificacionDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    NotificacionDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.concepto != null) {
      yield r'concepto';
      yield serializers.serialize(
        object.concepto,
        specifiedType: const FullType(String),
      );
    }
    if (object.descripcion != null) {
      yield r'descripcion';
      yield serializers.serialize(
        object.descripcion,
        specifiedType: const FullType(String),
      );
    }
    if (object.documentos != null) {
      yield r'documentos';
      yield serializers.serialize(
        object.documentos,
        specifiedType: const FullType(BuiltList, [FullType(DocumentosDto)]),
      );
    }
    if (object.estado != null) {
      yield r'estado';
      yield serializers.serialize(
        object.estado,
        specifiedType: const FullType(String),
      );
    }
    if (object.expediente != null) {
      yield r'expediente';
      yield serializers.serialize(
        object.expediente,
        specifiedType: const FullType(ExpedienteDto),
      );
    }
    if (object.fecAlta != null) {
      yield r'fecAlta';
      yield serializers.serialize(
        object.fecAlta,
        specifiedType: const FullType(DateTime),
      );
    }
    if (object.fecCaducidad != null) {
      yield r'fecCaducidad';
      yield serializers.serialize(
        object.fecCaducidad,
        specifiedType: const FullType(DateTime),
      );
    }
    if (object.historicoEstados != null) {
      yield r'historicoEstados';
      yield serializers.serialize(
        object.historicoEstados,
        specifiedType:
            const FullType(BuiltList, [FullType(HistoricoEstadoDto)]),
      );
    }
    if (object.id != null) {
      yield r'id';
      yield serializers.serialize(
        object.id,
        specifiedType: const FullType(int),
      );
    }
    if (object.interesados != null) {
      yield r'interesados';
      yield serializers.serialize(
        object.interesados,
        specifiedType:
            const FullType(BuiltList, [FullType(InteresadoNotificaDto)]),
      );
    }
    if (object.procedimientoAdministrativo != null) {
      yield r'procedimientoAdministrativo';
      yield serializers.serialize(
        object.procedimientoAdministrativo,
        specifiedType: const FullType(ProcedimientoAdministrativoDto),
      );
    }
    if (object.tipoEnvio != null) {
      yield r'tipoEnvio';
      yield serializers.serialize(
        object.tipoEnvio,
        specifiedType: const FullType(String),
      );
    }
    if (object.unidadOrganica != null) {
      yield r'unidadOrganica';
      yield serializers.serialize(
        object.unidadOrganica,
        specifiedType: const FullType(UnidadOrganicaDto),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    NotificacionDto object, {
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
    required NotificacionDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'concepto':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.concepto = valueDes;
          break;
        case r'descripcion':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.descripcion = valueDes;
          break;
        case r'documentos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(DocumentosDto)]),
          ) as BuiltList<DocumentosDto>;
          result.documentos.replace(valueDes);
          break;
        case r'estado':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.estado = valueDes;
          break;
        case r'expediente':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ExpedienteDto),
          ) as ExpedienteDto;
          result.expediente.replace(valueDes);
          break;
        case r'fecAlta':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.fecAlta = valueDes;
          break;
        case r'fecCaducidad':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.fecCaducidad = valueDes;
          break;
        case r'historicoEstados':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType(BuiltList, [FullType(HistoricoEstadoDto)]),
          ) as BuiltList<HistoricoEstadoDto>;
          result.historicoEstados.replace(valueDes);
          break;
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.id = valueDes;
          break;
        case r'interesados':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType(BuiltList, [FullType(InteresadoNotificaDto)]),
          ) as BuiltList<InteresadoNotificaDto>;
          result.interesados.replace(valueDes);
          break;
        case r'procedimientoAdministrativo':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ProcedimientoAdministrativoDto),
          ) as ProcedimientoAdministrativoDto;
          result.procedimientoAdministrativo.replace(valueDes);
          break;
        case r'tipoEnvio':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.tipoEnvio = valueDes;
          break;
        case r'unidadOrganica':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(UnidadOrganicaDto),
          ) as UnidadOrganicaDto;
          result.unidadOrganica.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  NotificacionDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = NotificacionDtoBuilder();
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
