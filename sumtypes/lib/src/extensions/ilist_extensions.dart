import 'package:dartz/dartz.dart';

extension JoinIListExtension on IList<String> {
  Option<String> join([String joiner = '']) => headOption
      .bind((head) => tailOption.map((tail) => Tuple2(head, tail)))
      .map(
        (headTail) => headTail.value2.foldLeft(
          headTail.value1,
          (previous, current) => '$previous$joiner$current',
        ),
      );
}
