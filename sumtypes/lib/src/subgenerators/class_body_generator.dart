import 'package:analyzer/dart/element/element.dart';
import 'package:sumtypes/src/variant.dart';

import '../variant_generator.dart';

class ClassBodyGenerator implements VariantGenerator {
  final Iterable<VariantGenerator> generators;

  const ClassBodyGenerator(this.generators);

  @override
  String generate(
    ClassElement sumtype,
    Variant variant,
  ) =>
      generators
          .where((generator) => generator.generate != null)
          .map((generator) => generator.generate(sumtype, variant))
          .join('\n');
}
