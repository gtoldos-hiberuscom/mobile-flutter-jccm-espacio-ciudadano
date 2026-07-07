//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:espacio_ciudadano_api/src/model/unidad_organica_indexa_dto.dart';
import 'package:espacio_ciudadano_api/src/model/procedimiento_administrativo_indexa_dto.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'notificacion_indexa_dto.g.dart';

/// Resumen de una notificación electrónica indexada para listados
///
/// Properties:
/// * [concepto] - Concepto o asunto de la notificación
/// * [fechaCaducidad] - Fecha límite para acceder a la notificación antes de que expire
/// * [idNotificacion] - Identificador único de la notificación
/// * [procedimientoAdministrativo] 
/// * [sistemaOrigen] - Código del sistema origen que generó la notificación
/// * [unidadOrganica] 
@BuiltValue()
abstract class NotificacionIndexaDto implements Built<NotificacionIndexaDto, NotificacionIndexaDtoBuilder> {
  /// Concepto o asunto de la notificación
  @BuiltValueField(wireName: r'concepto')
  String? get concepto;

  /// Fecha límite para acceder a la notificación antes de que expire
  @BuiltValueField(wireName: r'fechaCaducidad')
  DateTime? get fechaCaducidad;

  /// Identificador único de la notificación
  @BuiltValueField(wireName: r'idNotificacion')
  int? get idNotificacion;

  @BuiltValueField(wireName: r'procedimientoAdministrativo')
  ProcedimientoAdministrativoIndexaDto? get procedimientoAdministrativo;

  /// Código del sistema origen que generó la notificación
  @BuiltValueField(wireName: r'sistemaOrigen')
  String? get sistemaOrigen;

  @BuiltValueField(wireName: r'unidadOrganica')
  UnidadOrganicaIndexaDto? get unidadOrganica;

  NotificacionIndexaDto._();

  factory NotificacionIndexaDto([void updates(NotificacionIndexaDtoBuilder b)]) = _$NotificacionIndexaDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(NotificacionIndexaDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<NotificacionIndexaDto> get serializer => _$NotificacionIndexaDtoSerializer();
}

class _$NotificacionIndexaDtoSerializer implements PrimitiveSerializer<NotificacionIndexaDto> {
  @override
  final Iterable<Type> types = const [NotificacionIndexaDto, _$NotificacionIndexaDto];

  @override
  final String wireName = r'NotificacionIndexaDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    NotificacionIndexaDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.concepto != null) {
      yield r'concepto';
      yield serializers.serialize(
        object.concepto,
        specifiedType: const FullType(String),
      );
    }
    if (object.fechaCaducidad != null) {
      yield r'fechaCaducidad';
      yield serializers.serialize(
        object.fechaCaducidad,
        specifiedType: const FullType(DateTime),
      );
    }
    if (object.idNotificacion != null) {
      yield r'idNotificacion';
      yield serializers.serialize(
        object.idNotificacion,
        specifiedType: const FullType(int),
      );
    }
    if (object.procedimientoAdministrativo != null) {
      yield r'procedimientoAdministrativo';
      yield serializers.serialize(
        object.procedimientoAdministrativo,
        specifiedType: const FullType(ProcedimientoAdministrativoIndexaDto),
      );
    }
    if (object.sistemaOrigen != null) {
      yield r'sistemaOrigen';
      yield serializers.serialize(
        object.sistemaOrigen,
        specifiedType: const FullType(String),
      );
    }
    if (object.unidadOrganica != null) {
      yield r'unidadOrganica';
      yield serializers.serialize(
        object.unidadOrganica,
        specifiedType: const FullType(UnidadOrganicaIndexaDto),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    NotificacionIndexaDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required NotificacionIndexaDtoBuilder result,
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
        case r'fechaCaducidad':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.fechaCaducidad = valueDes;
          break;
        case r'idNotificacion':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.idNotificacion = valueDes;
          break;
        case r'procedimientoAdministrativo':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ProcedimientoAdministrativoIndexaDto),
          ) as ProcedimientoAdministrativoIndexaDto;
          result.procedimientoAdministrativo.replace(valueDes);
          break;
        case r'sistemaOrigen':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.sistemaOrigen = valueDes;
          break;
        case r'unidadOrganica':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(UnidadOrganicaIndexaDto),
          ) as UnidadOrganicaIndexaDto;
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
  NotificacionIndexaDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = NotificacionIndexaDtoBuilder();
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

