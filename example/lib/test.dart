import 'package:quiver/core.dart';
import 'package:sumtypes_annotation/sumtypes_annotation.dart';

part 'test.g.dart';

@Sumtype([
  T0('Nil'),
  T2<R0, IList<R0>>('Cons'),
], generators: [
  Extension.Eq
])
abstract class IList<T> {
  const IList();

  T head() => this is Cons ? ((this as Cons).item1 as T) : null;
  IList<T> tail() =>
      this is Cons ? ((this as Cons).item2 as IList<T>) : const Nil();

  IList<U> fmap<U>(U Function(T) f) {
    final list = this;

    if (list is Cons<T>) {
      return Cons<U>(f(list.item1), list.tail().fmap(f));
    } else {
      return Nil();
    }
  }

  @override
  String toString() {
    final t = this;

    if (t is Cons<T>) {
      return '{t.head().toString()} ' + t.tail().toString();
    } else {
      return '';
    }
  }
}

void main() {
  final IList<int> list = Cons(0, Cons(1, Cons(2, Nil())));
  print(list);

  final doubleList = list.fmap((a) => a * 2);
  print(doubleList);

  final repeatedList = list.fmap((a) => a.toString() * 5);
  print(repeatedList);
}
