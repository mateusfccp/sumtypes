import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:dartz/dartz.dart';

class Variant {
  final String name;
  final Iterable<String> typeArguments;
  final int index;

  Variant(
    this.name,
    this.typeArguments,
    this.index,
  );

  static Option<Variant> fromObject(
    ClassElement sumtype,
    DartObject object,
    int index,
  ) {
    try {
      final variant = Variant(
        object.getField('(super)').getField('name').toStringValue(),
        object.type.typeArguments.map((type) => type.getDisplayString()).map(
          (type) {
            final match = RegExp(r'R(\d+)').firstMatch(type);

            return match == null
                ? type
                : type.replaceAll(
                    match.group(0),
                    sumtype.typeParameters[int.parse(match.group(1))].name,
                  );
          },
        ),
        index,
      );

      return Some(variant);
    } catch (_) {
      return const None();
    }
  }
}
