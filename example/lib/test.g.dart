// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'test.dart';

// **************************************************************************
// AlgebraicGenerator
// **************************************************************************

class JsonNull extends JsonValue {
  const JsonNull();

  operator ==(Object other) => other is JsonNull;
}

class JsonBool extends JsonValue {
  final bool item1;

  const JsonBool(this.item1);

  operator ==(Object other) => other is JsonBool && this.item1 == other.item1;
}

class JsonNumber extends JsonValue {
  final num item1;

  const JsonNumber(this.item1);

  operator ==(Object other) => other is JsonNumber && this.item1 == other.item1;
}

class JsonString extends JsonValue {
  final String item1;

  const JsonString(this.item1);

  operator ==(Object other) => other is JsonString && this.item1 == other.item1;
}

class JsonArray extends JsonValue {
  final List<JsonValue> item1;

  const JsonArray(this.item1);

  operator ==(Object other) => other is JsonArray && this.item1 == other.item1;
}

class JsonObject extends JsonValue {
  final Map<String, JsonValue> item1;

  const JsonObject(this.item1);

  operator ==(Object other) => other is JsonObject && this.item1 == other.item1;
}

class Nil<T> extends IList<T> {
  const Nil();

  operator ==(Object other) => other is Nil;
}

class Cons<T> extends IList<T> {
  final T item1;
  final IList<T> item2;

  const Cons(this.item1, this.item2);

  operator ==(Object other) =>
      other is Cons && this.item1 == other.item1 && this.item2 == other.item2;
}
