import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/src/builder/build_step.dart';
import 'package:dartz/dartz.dart' hide Option;
import 'package:source_gen/source_gen.dart';
import 'package:sumtypes/src/extension_generator.dart';
import 'package:sumtypes_annotation/sumtypes_annotation.dart';

import 'extensions/ilist_extensions.dart';
import 'subgenerators/class_generator.dart';
import 'subgenerators/constructor_generator.dart';
import 'subgenerators/declarations_generator.dart';
import 'subgenerators/fold_generator.dart';
import 'variant.dart';
import 'variant_generator.dart';

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

    final sumtype = element as ClassElement;

    final variants = IList.sequenceOption<Variant>(
      IList.from(annotation.read('type').listValue).mapWithIndex(
        (index, object) => Variant.fromObject(sumtype, object, index),
      ),
    );

    final options =
        annotation.read('generators').listValue.map(_optionfromDartObject);

    final variantsGenerators = [
      Declarations,
      Constructor,
      ...options
          .map(VariantGenerator.from)
          .where((generator) => generator != null),
    ];

    // Generate each individual class
    final generatedVariants = variants.fold(
      () => IList<String>.from([]),
      (v) => v.map(
        (variant) =>
            ClassGenerator(variantsGenerators).generate(sumtype, variant),
      ),
    );

    final extensionsGenerators = [
      FoldGenerator,
      ...options
          .map(ExtensionGenerator.from)
          .where((generator) => generator != null),
    ];

    final generatedExtensions = variants.fold(
      () => const <String>[],
      (v) => extensionsGenerators.map(
        (generator) => generator.generate(sumtype, v),
      ),
    );

    return '''
    ${generatedVariants.join() | ''}
    ${generatedExtensions.join()}
    ''';
  }

  static Option _optionfromDartObject(DartObject object) {
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
