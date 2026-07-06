//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'historico_estado_dto.g.dart';

/// HistoricoEstadoDto
///
/// Properties:
/// * [estado]
/// * [fechaCambio]
@BuiltValue()
abstract class HistoricoEstadoDto
    implements Built<HistoricoEstadoDto, HistoricoEstadoDtoBuilder> {
  @BuiltValueField(wireName: r'estado')
  String? get estado;

  @BuiltValueField(wireName: r'fecha-cambio')
  DateTime? get fechaCambio;

  HistoricoEstadoDto._();

  factory HistoricoEstadoDto([void updates(HistoricoEstadoDtoBuilder b)]) =
      _$HistoricoEstadoDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(HistoricoEstadoDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<HistoricoEstadoDto> get serializer =>
      _$HistoricoEstadoDtoSerializer();
}

class _$HistoricoEstadoDtoSerializer
    implements PrimitiveSerializer<HistoricoEstadoDto> {
  @override
  final Iterable<Type> types = const [HistoricoEstadoDto, _$HistoricoEstadoDto];

  @override
  final String wireName = r'HistoricoEstadoDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    HistoricoEstadoDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.estado != null) {
      yield r'estado';
      yield serializers.serialize(
        object.estado,
        specifiedType: const FullType(String),
      );
    }
    if (object.fechaCambio != null) {
      yield r'fecha-cambio';
      yield serializers.serialize(
        object.fechaCambio,
        specifiedType: const FullType(DateTime),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    HistoricoEstadoDto object, {
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
    required HistoricoEstadoDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'estado':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.estado = valueDes;
          break;
        case r'fecha-cambio':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.fechaCambio = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  HistoricoEstadoDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = HistoricoEstadoDtoBuilder();
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
