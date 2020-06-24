import 'package:analyzer/dart/element/element.dart';

import '../../sumtype_subgenerator.dart';

/// Generator for equality
const _EqGenerator EqGenerator = _EqGenerator();

class _EqGenerator extends SumtypeSubgenerator {
  const _EqGenerator();

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
    int get hashCode {
      const gen = 0x1fffffff;
      const c1 = 0x0007ffff;
      const f1 = 0x03ffffff;
      const f2 = 0x00003fff;

      int _combine(int hash, int value) {
        hash = gen & (hash + value);
        hash = gen & (hash + ((c1 & hash) << 10));
        return hash ^ (hash >> 6);
      }

      int _finish(int hash) {
        hash = gen & (hash + ((f1 & hash) << 3));
        hash = hash ^ (hash >> 11);
        return gen & (hash + ((f2 & hash) << 15));
      }

      final objects = [${fieldsToHash.join(', ')}];
      return _finish(objects.fold(0, (h, i) => _combine(h, i.hashCode)));
    }
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
