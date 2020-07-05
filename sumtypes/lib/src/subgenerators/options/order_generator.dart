import 'package:analyzer/dart/element/element.dart';
import 'package:dartz/dartz.dart';
import 'package:recase/recase.dart';

import '../../extension_generator.dart';
import '../../variant.dart';
import '../../variant_generator.dart';

const OrdVariantGenerator = _OrdVariantGenerator();

class _OrdVariantGenerator implements VariantGenerator {
  const _OrdVariantGenerator();

  @override
  String generate(ClassElement sumtype, Variant variant) {
    return '''
      final _index = ${variant.index};
    ''';
  }
}

const OrdExtensionGenerator = _OrdExtensionGenerator();

class _OrdExtensionGenerator implements ExtensionGenerator {
  const _OrdExtensionGenerator();

  @override
  String generate(ClassElement sumtype, IList<Variant> variants) {
    final name = sumtype.name.pascalCase;

    return '''
      final ${name}Order = _${name}Order();

      class _${name}Order extends Order<${name}> {
        @override
        Ordering order(${name} a1, ${name} a2) => Ordering.values[
            (((a1 as dynamic)._index as int) - ((a2 as dynamic)._index as int))
                    .clamp(-1, 1)
                    .toInt() +
                1];
      }
    ''';
  }
}
