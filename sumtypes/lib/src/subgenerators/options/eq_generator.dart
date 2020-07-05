import 'package:analyzer/dart/element/element.dart';
import 'package:sumtypes/src/variant.dart';

import '../../variant_generator.dart';

/// Generator for equality
const _EqGenerator EqGenerator = _EqGenerator();

class _EqGenerator implements VariantGenerator {
  const _EqGenerator();

  @override
  String generate(
    ClassElement sumtype,
    Variant variant,
  ) {
    // operator == override
    final fieldsComparison = List.generate(
      variant.typeArguments.length,
      (i) => '&& item${i + 1} == other.item${i + 1}',
    ).join(' ');

    final operator = '''
      @override
      bool operator ==(Object other) => other is ${variant.name} $fieldsComparison;
    ''';

    // hashCode override
    final fieldsToHash = [
      '#${sumtype.name}',
      '#${variant.name}',
      ...List.generate(
        variant.typeArguments.length,
        (i) => 'item${i + 1}',
      ),
    ];

    final hashCode = '''
    @override
    int get hashCode => hashObjects(<Object>[${fieldsToHash.join(', ')}]);
    ''';

    // Final generated string
    return '''
    $operator
    $hashCode
    ''';
  }

  @override
  bool operator ==(Object a) => false;

  @override
  int get hashCode => super.hashCode;
}
