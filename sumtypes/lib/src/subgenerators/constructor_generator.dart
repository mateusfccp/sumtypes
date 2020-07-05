import 'package:analyzer/dart/element/element.dart';

import '../variant.dart';
import '../variant_generator.dart';

class _ConstructorGenerator implements VariantGenerator {
  const _ConstructorGenerator();

  @override
  String generate(
    ClassElement element,
    Variant variant,
  ) {
    final isConst = element.constructors[0].isConst;
    final prefix = isConst ? 'const' : '';
    final constructorParameters = List<String>.generate(
      variant.typeArguments.length,
      (i) => 'this.item${i + 1}',
    ).join(', ');

    return '$prefix ${variant.name}($constructorParameters);';
  }
}

const _ConstructorGenerator Constructor = _ConstructorGenerator();
