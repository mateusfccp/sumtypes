import 'options.dart';
import 'types.dart';

class Sumtype {
  final List<Type> type;
  final List<Option> generators;

  const Sumtype(
    this.type, {
    this.generators = const [],
  });
}
