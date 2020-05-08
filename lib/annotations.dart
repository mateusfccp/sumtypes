class Algebraic {
  final List<AlgebraicType> type;

  const Algebraic(this.type);
}

abstract class AlgebraicType {
  final String name;

  const AlgebraicType(this.name);
}

class T0 extends AlgebraicType {
  const T0(name) : super(name);
}

class T1<Type1> extends AlgebraicType {
  const T1(name) : super(name);
}

class T2<Type1, Type2> extends AlgebraicType {
  const T2(name) : super(name);
}

abstract class R0 { }

abstract class R1 { }

abstract class R2 { }
