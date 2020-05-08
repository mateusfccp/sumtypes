import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:build/src/builder/build_step.dart';
import 'package:source_gen/source_gen.dart';

import '../annotations.dart';

class AlgebraicGenerator extends GeneratorForAnnotation<Algebraic> {
  @override
  String generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    final objects = annotation.read("type").listValue;

    return objects
        .map((object) => _generateClass(element as ClassElement, object))
        .join("\n");
  }

  String _generateClass(
    ClassElement element,
    DartObject object,
  ) {
    final String className =
        object.getField('(super)').getField('name').toStringValue();
    final typeParameters = element.typeParameters.isNotEmpty
        ? "<${element.typeParameters.join(", ")}>"
        : "";

    return '''class $className$typeParameters extends ${element.name}$typeParameters {
        ${_generateBody(element, className, object)}
      }
      ''';
  }

  String _generateBody(
    ClassElement element,
    String className,
    DartObject object,
  ) {
    // Get type argumets from main type
    final List<String> types = object.type.typeArguments
        .map((type) => type.getDisplayString())
        .toList();

    // Generate type declarations
    final String declarations = types
        .map((type) {
          final RegExpMatch match = RegExp(r'R(\d+)').firstMatch(type);

          return match == null
              ? type
              : type.replaceAll(
                  match.group(0),
                  element.typeParameters[int.parse(match.group(1))].name,
                );
        })
        .toList()
        .asMap()
        .map((index, type) =>
            MapEntry<int, String>(index, "final $type item${index + 1};"))
        .values
        .join("\n");

    // Generate constructor
    final bool isConst = element.constructors[0].isConst;
    final String prefix = isConst ? "const" : "";
    final String constructorParameters =
        List<String>.generate(types.length, (i) => "this.item${i + 1}")
            .join(", ");
    final String constructor = "$prefix $className($constructorParameters);";

    // Generate operator == override
    final String fieldsComparison = List<String>.generate(
            types.length, (i) => "&& this.item${i + 1} == other.item${i + 1}")
        .join(" ");
    final String equalOperator =
        "operator ==(Object other) => other is $className $fieldsComparison;";

    return '''
    $declarations

    $constructor

    $equalOperator
    ''';
  }
}
