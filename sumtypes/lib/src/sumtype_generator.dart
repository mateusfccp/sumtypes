import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/src/builder/build_step.dart';
import 'package:source_gen/source_gen.dart';
import 'package:sumtypes_annotation/sumtypes_annotation.dart';

import 'subgenerators/constructor_generator.dart';
import 'subgenerators/declarations_generator.dart';
import 'sumtype_subgenerator.dart';

class SumtypeGenerator extends GeneratorForAnnotation<Sumtype> {
  @override
  String generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep _,
  ) {
    // Prevent @Sumtype to be used on non-classes
    if (element is! ClassElement) {
      final friendlyName = element.displayName;
      throw InvalidGenerationSourceError(
        'Generator cannot target `$friendlyName`. '
        '`@Sumyupe` can only be applied to an abstract class.',
        todo: 'Remove the `@Sumtype` annotation from `$friendlyName`.',
        element: element,
      );
    }

    // Prevent @Sumtype to be used on non-abstract classes
    if (element is ClassElement && !element.isAbstract) {
      final friendlyName = element.displayName;
      throw InvalidGenerationSourceError(
        'Generator cannot target `$friendlyName`. '
        '`@Sumyupe` can only be applied to an abstract class.',
        todo: 'Make `$friendlyName` an abstract class.',
        element: element,
      );
    }

    final objects = annotation.read('type').listValue;

    final options =
        annotation.read('generators').listValue.map(_optionfromDartObject);

    final generators = [
      Declarations,
      Constructor,
      ...options.map(SumtypeSubgenerator.from),
    ];

    final classes = objects
        .map((object) =>
            _generateClass(element as ClassElement, object, generators))
        .join('\n');

    return '''
    $classes
''';
  }

  String _generateClass(
    ClassElement element,
    DartObject object,
    Iterable<SumtypeSubgenerator> generators,
  ) {
    final className =
        object.getField('(super)').getField('name').toStringValue();
    final typeParameters = element.typeParameters.isEmpty
        ? ''
        : '<${element.typeParameters.join(', ')}>';

    return '''    
    class $className$typeParameters extends ${element.name}$typeParameters {
      ${_generateBody(element, className, object, generators)}
    }
    ''';
  }

  String _generateBody(
    ClassElement element,
    String className,
    DartObject object,
    Iterable<SumtypeSubgenerator> generators,
  ) {
    // Get type argumets from main type
    final types = object.type.typeArguments
        .map((type) => type.getDisplayString())
        .toList();

    return generators
        .where((generator) => generator.generate != null)
        .map((generator) => generator.generate(element, className, types))
        .join('\n');
  }

  Option _optionfromDartObject(DartObject object) {
    assert(object != null);

    // Find all the enum constants in Option
    final objectType = (object.type as InterfaceType);
    final enumFields = objectType.element.fields
        .where((field) => field.isEnumConstant)
        .toList()
        .asMap()
        .entries;

    // Match with current object to get the index
    final index = enumFields
        .singleWhere(
          (element) => element.value.computeConstantValue() == object,
        )
        .key;

    // Return the correspondent Option
    return Option.values[index];
  }
}
