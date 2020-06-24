import 'package:analyzer/dart/element/element.dart';
import 'package:sumtypes_annotation/sumtypes_annotation.dart';

import 'subgenerators/options/eq_generator.dart';
import 'subgenerators/options/quiver_eq_generator.dart';

abstract class SumtypeSubgenerator {
  const SumtypeSubgenerator();

  String Function(
    ClassElement element,
    String className,
    Iterable<String> types,
  ) get generate => null;

  static SumtypeSubgenerator from(Option option) {
    const map = {
      Option.Eq: QuiverEqGenerator,
      Option.EqFallback: EqGenerator,
      //Option.Ord: OrdGenerator,
    };

    return map[option];
  }
}
