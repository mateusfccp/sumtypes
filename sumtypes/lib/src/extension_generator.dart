import 'package:analyzer/dart/element/element.dart';
import 'package:dartz/dartz.dart' hide Option;
import 'package:sumtypes_annotation/sumtypes_annotation.dart';

import 'subgenerators/extensions/order_generator.dart';
import 'variant.dart';

abstract class ExtensionGenerator {
  const ExtensionGenerator();

  String generate(ClassElement sumtype, IList<Variant> variants);

  static ExtensionGenerator from(Extension option) {
    const map = {
      Extension.Ord: OrdExtensionGenerator,
    };

    return map[option];
  }
}
