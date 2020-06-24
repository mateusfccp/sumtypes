import 'package:analyzer/dart/element/element.dart';

import '../sumtype_subgenerator.dart';

class _DeclarationsGenerator extends SumtypeSubgenerator {
  const _DeclarationsGenerator();

  @override
  String Function(ClassElement, String, Iterable<String>) get generate =>
      (element, _, types) => types
          .map(
            (type) {
              final match = RegExp(r'R(\d+)').firstMatch(type);

              return match == null
                  ? type
                  : type.replaceAll(
                      match.group(0),
                      element.typeParameters[int.parse(match.group(1))].name,
                    );
            },
          )
          .toList()
          .asMap()
          .map(
            (index, type) => MapEntry<int, String>(
              index,
              'final $type item${index + 1};',
            ),
          )
          .values
          .join('\n');
}

const _DeclarationsGenerator Declarations = _DeclarationsGenerator();
