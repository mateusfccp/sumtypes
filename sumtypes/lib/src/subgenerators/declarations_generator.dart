import 'package:analyzer/dart/element/element.dart';

import '../variant.dart';
import '../variant_generator.dart';

class _DeclarationsGenerator implements VariantGenerator {
  const _DeclarationsGenerator();

  @override
  String generate(ClassElement sumtype, Variant variant) {
    final argumentsList = variant.typeArguments.toList();

    return List.generate(
      argumentsList.length,
      (index) => 'final ${argumentsList[index]} item${index + 1};',
    ).join('\n');
  }
}

const _DeclarationsGenerator Declarations = _DeclarationsGenerator();
