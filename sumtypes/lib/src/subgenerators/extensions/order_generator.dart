import 'package:analyzer/dart/element/element.dart';
import 'package:dartz/dartz.dart';
import 'package:recase/recase.dart';

import '../../extension_generator.dart';
import '../../extensions/ilist_extensions.dart';
import '../../variant.dart';

const OrdExtensionGenerator = _OrdExtensionGenerator();

class _OrdExtensionGenerator implements ExtensionGenerator {
  const _OrdExtensionGenerator();

  @override
  String generate(ClassElement sumtype, IList<Variant> variants) {
    final name = sumtype.name.pascalCase;
    final variantNames = variants.map((variant) => variant.name);

    return '''
      final _${name}Set = IVector<Rank>.from([${variantNames.map((name) => '$name()').join(', ') | ''}]);
    
      final ${name}Order = _${name}Order();

      class _${name}Order extends Order<${name}> {
        Option<int> indexOf(${name} element) => _${name}Set.indexOf(element);

        @override
        Ordering order(${name} a1, ${name} a2) =>
            indexOf(a1)
                .bind(
                  (a1) => indexOf(a2).map(
                    (a2) => Tuple2(a1, a2),
                  ),
                )
                .map((elements) => elements.value1 - elements.value2)
                .map((result) => result.clamp(-1, 1).toInt() + 1)
                .map((result) => Ordering.values[result]) |
            Ordering.EQ;

        Option<${name}> next(${name} element) =>
          indexOf(element).bind((index) => _${name}Set[index + 1]);

        Option<${name}> previous(${name} element) =>
          indexOf(element).bind((index) => _${name}Set[index - 1]);
      }

    ''';
  }
}
