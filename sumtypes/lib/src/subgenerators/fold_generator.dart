import 'package:analyzer/dart/element/element.dart';
import 'package:dartz/dartz.dart';
import 'package:recase/recase.dart';

import '../extension_generator.dart';
import '../extensions/ilist_extensions.dart';
import '../variant.dart';

const FoldGenerator = _FoldGenerator();

class _FoldGenerator extends ExtensionGenerator {
  const _FoldGenerator();

  @override
  String generate(ClassElement sumtype, IList<Variant> variants) {
    // If there is only one variant, fold shouldn't be generated
    if (variants.length() == 1) {
      return '';
    }

    final typeParameters = sumtype.typeParameters.isEmpty
        ? ''
        : '<${sumtype.typeParameters.join(', ')}>';

    // I'm going to save this because currently .length is expensive on IList

    final lastVariant = variants.reverse().headOption;

    // Fold functions
    final foldFunction = _FoldPartGenerator(typeParameters, lastVariant);

    // TODO: Fix foldElse
    // final foldElseFunction = _FoldOrElsePartGenerator(typeParameters);

    return '''
    extension Fold${sumtype.name}Extension$typeParameters on ${sumtype.name}$typeParameters {
      ${_partGenerator(foldFunction, variants)}
    }
    ''';
  }

  static String _partGenerator(
      _PartGenerator partGenerator, IList<Variant> variants) {
    final arguments = variants.map(partGenerator.argument);
    final statements = partGenerator.statements(variants);

    return partGenerator.function(arguments, statements);
  }

  static String _argumentStatement(
    Variant variant,
    String typeParameters,
    int argumentIndex,
  ) {
    final arguments = List.generate(
      variant.typeArguments.length,
      (index) => '_this.item${index + 1}',
    ).join(', ');

    final statement = argumentIndex == 0 ? 'if' : 'else if';

    return '''
    $statement (_this is ${variant.name}$typeParameters) {
      return ${variant.name.camelCase}($arguments);
    }
    ''';
  }
}

abstract class _PartGenerator {
  String get typeParameters;
  Option<Variant> get lastVariant;

  String argument(Variant variant);
  String function(IList<String> arguments, IList<String> statements);
  IList<String> statements(IList<Variant> variants);
}

class _FoldPartGenerator implements _PartGenerator {
  @override
  final String typeParameters;

  @override
  final Option<Variant> lastVariant;

  _FoldPartGenerator(this.typeParameters, this.lastVariant);

  @override
  String argument(Variant variant) {
    final signature = 'FoldT Function(${variant.typeArguments.join(', ')})';
    final name = '${variant.name.camelCase}';

    return '$signature $name';
  }

  @override
  String function(IList<String> arguments, IList<String> statements) {
    final data = lastVariant.fold(
      () => Tuple2(
        '',
        IList<String>.from([]),
      ),
      (lastVariant) {
        final _name = lastVariant.name;
        final _arguments = IList.generate(
          lastVariant.typeArguments.length,
          (index) => 'variant.item${index + 1}',
        );

        return Tuple2(_name, _arguments);
      },
    );

    final variantVariable = data.value2.isEmpty
        ? ''
        : 'final variant = (this as ${data.value1}$typeParameters);';

    return '''
    FoldT fold<FoldT>(${arguments.join(', ') | ''}) {
      final _this = this;
      ${statements.join() | ''}
      else {
        $variantVariable
        return ${data.value1.camelCase}(${data.value2.join(', ') | ''});
      }
    }
    ''';
  }

  @override
  IList<String> statements(IList<Variant> variants) {
    final length = variants.length();
    return variants.mapWithIndex(
      (index, variant) => index == length - 1
          ? ''
          : _FoldGenerator._argumentStatement(variant, typeParameters, index),
    );
  }
}

class _FoldOrElsePartGenerator implements _PartGenerator {
  @override
  final String typeParameters;

  @override
  Option<Variant> get lastVariant => const None();

  _FoldOrElsePartGenerator(this.typeParameters);

  @override
  String argument(Variant variant) {
    final signature =
        'Option<FoldT Function(${variant.typeArguments.join(', ')})>';
    final name = '${variant.name.camelCase}';

    return '$signature $name = const None()';
  }

  @override
  String function(IList<String> arguments, IList<String> statements) {
    return '''
    FoldT foldElse<FoldT>({${arguments.join(', ') | ''}, required FoldT Function() orElse,}) {
      final _this = this;
      ${statements.join() | ''}
      else {
        return orElse();
      }
    }
    ''';
  }

  @override
  IList<String> statements(IList<Variant> variants) => variants.mapWithIndex(
        (index, variant) =>
            _FoldGenerator._argumentStatement(variant, typeParameters, index),
      );
}
