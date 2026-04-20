//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'bapiret2.g.dart';

/// BAPIRET2
///
/// Properties:
/// * [field]
/// * [id]
/// * [logmsgno]
/// * [logno]
/// * [message]
/// * [messagev1]
/// * [messagev2]
/// * [messagev3]
/// * [messagev4]
/// * [number]
/// * [parameter]
/// * [row]
/// * [system]
/// * [type]
@BuiltValue()
abstract class BAPIRET2 implements Built<BAPIRET2, BAPIRET2Builder> {
  @BuiltValueField(wireName: r'field')
  String? get field;

  @BuiltValueField(wireName: r'id')
  String? get id;

  @BuiltValueField(wireName: r'logmsgno')
  String? get logmsgno;

  @BuiltValueField(wireName: r'logno')
  String? get logno;

  @BuiltValueField(wireName: r'message')
  String? get message;

  @BuiltValueField(wireName: r'messagev1')
  String? get messagev1;

  @BuiltValueField(wireName: r'messagev2')
  String? get messagev2;

  @BuiltValueField(wireName: r'messagev3')
  String? get messagev3;

  @BuiltValueField(wireName: r'messagev4')
  String? get messagev4;

  @BuiltValueField(wireName: r'number')
  String? get number;

  @BuiltValueField(wireName: r'parameter')
  String? get parameter;

  @BuiltValueField(wireName: r'row')
  int? get row;

  @BuiltValueField(wireName: r'system')
  String? get system;

  @BuiltValueField(wireName: r'type')
  String? get type;

  BAPIRET2._();

  factory BAPIRET2([void updates(BAPIRET2Builder b)]) = _$BAPIRET2;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(BAPIRET2Builder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<BAPIRET2> get serializer => _$BAPIRET2Serializer();
}

class _$BAPIRET2Serializer implements PrimitiveSerializer<BAPIRET2> {
  @override
  final Iterable<Type> types = const [BAPIRET2, _$BAPIRET2];

  @override
  final String wireName = r'BAPIRET2';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    BAPIRET2 object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.field != null) {
      yield r'field';
      yield serializers.serialize(
        object.field,
        specifiedType: const FullType(String),
      );
    }
    if (object.id != null) {
      yield r'id';
      yield serializers.serialize(
        object.id,
        specifiedType: const FullType(String),
      );
    }
    if (object.logmsgno != null) {
      yield r'logmsgno';
      yield serializers.serialize(
        object.logmsgno,
        specifiedType: const FullType(String),
      );
    }
    if (object.logno != null) {
      yield r'logno';
      yield serializers.serialize(
        object.logno,
        specifiedType: const FullType(String),
      );
    }
    if (object.message != null) {
      yield r'message';
      yield serializers.serialize(
        object.message,
        specifiedType: const FullType(String),
      );
    }
    if (object.messagev1 != null) {
      yield r'messagev1';
      yield serializers.serialize(
        object.messagev1,
        specifiedType: const FullType(String),
      );
    }
    if (object.messagev2 != null) {
      yield r'messagev2';
      yield serializers.serialize(
        object.messagev2,
        specifiedType: const FullType(String),
      );
    }
    if (object.messagev3 != null) {
      yield r'messagev3';
      yield serializers.serialize(
        object.messagev3,
        specifiedType: const FullType(String),
      );
    }
    if (object.messagev4 != null) {
      yield r'messagev4';
      yield serializers.serialize(
        object.messagev4,
        specifiedType: const FullType(String),
      );
    }
    if (object.number != null) {
      yield r'number';
      yield serializers.serialize(
        object.number,
        specifiedType: const FullType(String),
      );
    }
    if (object.parameter != null) {
      yield r'parameter';
      yield serializers.serialize(
        object.parameter,
        specifiedType: const FullType(String),
      );
    }
    if (object.row != null) {
      yield r'row';
      yield serializers.serialize(
        object.row,
        specifiedType: const FullType(int),
      );
    }
    if (object.system != null) {
      yield r'system';
      yield serializers.serialize(
        object.system,
        specifiedType: const FullType(String),
      );
    }
    if (object.type != null) {
      yield r'type';
      yield serializers.serialize(
        object.type,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    BAPIRET2 object, {
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
    required BAPIRET2Builder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'field':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.field = valueDes;
          break;
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'logmsgno':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.logmsgno = valueDes;
          break;
        case r'logno':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.logno = valueDes;
          break;
        case r'message':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.message = valueDes;
          break;
        case r'messagev1':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.messagev1 = valueDes;
          break;
        case r'messagev2':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.messagev2 = valueDes;
          break;
        case r'messagev3':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.messagev3 = valueDes;
          break;
        case r'messagev4':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.messagev4 = valueDes;
          break;
        case r'number':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.number = valueDes;
          break;
        case r'parameter':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.parameter = valueDes;
          break;
        case r'row':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.row = valueDes;
          break;
        case r'system':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.system = valueDes;
          break;
        case r'type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.type = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  BAPIRET2 deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = BAPIRET2Builder();
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
