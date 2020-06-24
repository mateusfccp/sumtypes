import 'package:analyzer/dart/element/element.dart';

import '../sumtype_subgenerator.dart';

class _ConstructorGenerator extends SumtypeSubgenerator {
  const _ConstructorGenerator();

  @override
  String Function(
    ClassElement,
    String,
    Iterable<String>,
  ) get generate => (element, className, types) {
        final isConst = element.constructors[0].isConst;
        final prefix = isConst ? 'const' : '';
        final constructorParameters =
            List<String>.generate(types.length, (i) => 'this.item${i + 1}')
                .join(', ');
        return '$prefix $className($constructorParameters);';
      };
}

const _ConstructorGenerator Constructor = _ConstructorGenerator();
