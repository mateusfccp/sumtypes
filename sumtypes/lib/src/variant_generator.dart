import 'package:analyzer/dart/element/element.dart';
import 'package:sumtypes_annotation/sumtypes_annotation.dart';

import 'subgenerators/options/eq_generator.dart';
import 'subgenerators/options/order_generator.dart';
import 'variant.dart';

abstract class VariantGenerator {
  const VariantGenerator();

  String generate(
    ClassElement sumtype,
    Variant variant,
  );

  static VariantGenerator from(Option option) {
    const map = {
      Option.Eq: EqGenerator,
      Option.Ord: OrdVariantGenerator,
    };

    return map[option];
  }
}
