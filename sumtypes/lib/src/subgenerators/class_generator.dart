import 'package:analyzer/dart/element/element.dart';
import 'package:sumtypes/src/subgenerators/class_body_generator.dart';
import 'package:sumtypes/src/variant.dart';

import '../variant_generator.dart';

class ClassGenerator implements VariantGenerator {
  final Iterable<VariantGenerator> generators;

  const ClassGenerator(this.generators);

  @override
  String generate(
    ClassElement sumtype,
    Variant variant,
  ) {
    final typeParameters = sumtype.typeParameters.isEmpty
        ? ''
        : '<${sumtype.typeParameters.join(', ')}>';

    final bodyGenerator = ClassBodyGenerator(generators);

    return '''    
    class ${variant.name}$typeParameters extends ${sumtype.name}$typeParameters {
      ${bodyGenerator.generate(sumtype, variant)}
    }
    ''';
  }
}
