//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:espacio_ciudadano_api/src/model/zcslistadodocsexpte.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'etlistdocs.g.dart';

/// ETLISTDOCS
///
/// Properties:
/// * [item] 
@BuiltValue()
abstract class ETLISTDOCS implements Built<ETLISTDOCS, ETLISTDOCSBuilder> {
  @BuiltValueField(wireName: r'item')
  BuiltList<ZCSLISTADODOCSEXPTE>? get item;

  ETLISTDOCS._();

  factory ETLISTDOCS([void updates(ETLISTDOCSBuilder b)]) = _$ETLISTDOCS;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ETLISTDOCSBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ETLISTDOCS> get serializer => _$ETLISTDOCSSerializer();
}

class _$ETLISTDOCSSerializer implements PrimitiveSerializer<ETLISTDOCS> {
  @override
  final Iterable<Type> types = const [ETLISTDOCS, _$ETLISTDOCS];

  @override
  final String wireName = r'ETLISTDOCS';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ETLISTDOCS object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.item != null) {
      yield r'item';
      yield serializers.serialize(
        object.item,
        specifiedType: const FullType(BuiltList, [FullType(ZCSLISTADODOCSEXPTE)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ETLISTDOCS object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ETLISTDOCSBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'item':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ZCSLISTADODOCSEXPTE)]),
          ) as BuiltList<ZCSLISTADODOCSEXPTE>;
          result.item.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ETLISTDOCS deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ETLISTDOCSBuilder();
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

