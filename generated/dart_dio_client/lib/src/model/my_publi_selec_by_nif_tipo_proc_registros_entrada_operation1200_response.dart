//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element, unused_element_parameter
import 'package:espacio_ciudadano_api/src/model/respuesta_zcsrfcpubliselectbynifv2_response.dart';
import 'package:espacio_ciudadano_api/src/model/respuesta.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:one_of/one_of.dart';

part 'my_publi_selec_by_nif_tipo_proc_registros_entrada_operation1200_response.g.dart';

/// MyPubliSelecByNifTipoProcRegistrosEntradaOperation1200Response
///
/// Properties:
/// * [body] - Objeto devuelto en el payload
/// * [codigoRespuesta] - Código asociado a la respuesta obtenida
/// * [infoError] 
/// * [mensajeRespuesta] - Mensaje informativo de la respuesta obtenida
/// * [timestamp] - Momento en que se registró la respuesta
@BuiltValue()
abstract class MyPubliSelecByNifTipoProcRegistrosEntradaOperation1200Response implements Built<MyPubliSelecByNifTipoProcRegistrosEntradaOperation1200Response, MyPubliSelecByNifTipoProcRegistrosEntradaOperation1200ResponseBuilder> {
  /// One Of [Respuesta], [RespuestaZCSRFCPUBLISELECTBYNIFV2Response]
  OneOf get oneOf;

  MyPubliSelecByNifTipoProcRegistrosEntradaOperation1200Response._();

  factory MyPubliSelecByNifTipoProcRegistrosEntradaOperation1200Response([void updates(MyPubliSelecByNifTipoProcRegistrosEntradaOperation1200ResponseBuilder b)]) = _$MyPubliSelecByNifTipoProcRegistrosEntradaOperation1200Response;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MyPubliSelecByNifTipoProcRegistrosEntradaOperation1200ResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MyPubliSelecByNifTipoProcRegistrosEntradaOperation1200Response> get serializer => _$MyPubliSelecByNifTipoProcRegistrosEntradaOperation1200ResponseSerializer();
}

class _$MyPubliSelecByNifTipoProcRegistrosEntradaOperation1200ResponseSerializer implements PrimitiveSerializer<MyPubliSelecByNifTipoProcRegistrosEntradaOperation1200Response> {
  @override
  final Iterable<Type> types = const [MyPubliSelecByNifTipoProcRegistrosEntradaOperation1200Response, _$MyPubliSelecByNifTipoProcRegistrosEntradaOperation1200Response];

  @override
  final String wireName = r'MyPubliSelecByNifTipoProcRegistrosEntradaOperation1200Response';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MyPubliSelecByNifTipoProcRegistrosEntradaOperation1200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
  }

  @override
  Object serialize(
    Serializers serializers,
    MyPubliSelecByNifTipoProcRegistrosEntradaOperation1200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final oneOf = object.oneOf;
    return serializers.serialize(oneOf.value, specifiedType: FullType(oneOf.valueType))!;
  }

  @override
  MyPubliSelecByNifTipoProcRegistrosEntradaOperation1200Response deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MyPubliSelecByNifTipoProcRegistrosEntradaOperation1200ResponseBuilder();
    Object? oneOfDataSrc;
    final targetType = const FullType(OneOf, [FullType(RespuestaZCSRFCPUBLISELECTBYNIFV2Response), FullType(Respuesta), ]);
    oneOfDataSrc = serialized;
    result.oneOf = serializers.deserialize(oneOfDataSrc, specifiedType: targetType) as OneOf;
    return result.build();
  }
}

