import 'package:analyzer/dart/element/element.dart';
import 'package:sumtypes_annotation/sumtypes_annotation.dart';

import 'subgenerators/extensions/eq_generator.dart';
import 'variant.dart';

abstract class VariantGenerator {
  const VariantGenerator();

  String generate(
    ClassElement sumtype,
    Variant variant,
  );

  static VariantGenerator from(Extension option) {
    const map = {
      Extension.Eq: EqGenerator,
    };

    return map[option];
  }
}
