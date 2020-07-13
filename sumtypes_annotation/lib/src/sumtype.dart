import 'extension.dart';
import 'types.dart';

class Sumtype {
  final List<Type> type;
  final List<Extension> generators;

  const Sumtype(
    this.type, {
    this.generators = const [],
  });
}
