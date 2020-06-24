import 'package:analyzer/dart/element/element.dart';

import '../../sumtype_subgenerator.dart';

/// Generator for equality
const _EqGenerator QuiverEqGenerator = _EqGenerator();

class _EqGenerator extends SumtypeSubgenerator {
  const _EqGenerator();

  @override
  Set<String> get imports => const {'package:quiver/quiver.dart'};

  @override
  String Function(ClassElement, String, Iterable<String>) get generate =>
      (_, className, types) {
        // operator == override
        final fieldsComparison = List.generate(
          types.length,
          (i) => '&& item${i + 1} == other.item${i + 1}',
        ).join(' ');

        final operator = '''
      @override
      bool operator ==(Object other) => other is $className $fieldsComparison;
    ''';

        // hashCode override
        final fieldsToHash = [
          "'mateusfccp/sumtypes'",
          "'$className'",
          ...List.generate(
            types.length,
            (i) => 'item${i + 1}',
          ),
        ];

        final hashCode = '''
    @override
    int get hashCode => hashObjects([${fieldsToHash.join(', ')}]);
    ''';

        // Final generated string
        return '''
    $operator
    $hashCode
    ''';
      };

  @override
  bool operator ==(Object a) => false;

  @override
  int get hashCode => super.hashCode;
}
