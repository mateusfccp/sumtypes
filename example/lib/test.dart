import 'package:adt/annotations.dart';

part 'test.g.dart';

@Algebraic([
  T0('JsonNull'),
  T1<bool>('JsonBool'),
  T1<num>('JsonNumber'),
  T1<String>('JsonString'),
  T1<List<JsonValue>>('JsonArray'),
  T1<Map<String, JsonValue>>('JsonObject'),
])
abstract class JsonValue {
  const JsonValue();
}

@Algebraic([
  T0('Nil'),
  T2<R0, IList<R0>>('Cons'),
])
abstract class IList<T> {
  const IList();

  T head() => this is Cons ? ((this as Cons).item1 as T) : null;
  IList<T> tail() =>
      this is Cons ? ((this as Cons).item2 as IList<T>) : const Nil();
  
  IList<U> fmap<U>(U Function(T) f) {
    IList<T> list = this;

    if (list is Cons<T>) {
      return Cons<U>(f(list.item1), list.tail().fmap(f));
    } else {
      return Nil();
    }
  }

  @override
  String toString() {
    IList<T> t = this;

    if (t is Cons<T>) {
      return "${t.head().toString()} " + t.tail().toString();
    } else {
      return "";
    }
  }
}

void main() {
  IList<int> list = Cons(0, Cons(1, Cons(2, Nil())));
  print(list);

  IList<int> doubleList = list.fmap((a) => a * 2);
  print(doubleList);

  IList<String> repeatedList = list.fmap((a) => a.toString() * 5);
  print(repeatedList);
}
