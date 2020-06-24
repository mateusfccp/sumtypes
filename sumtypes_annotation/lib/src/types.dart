abstract class Type {
  final String name;

  const Type(this.name);
}

class T0 extends Type {
  const T0(String name) : super(name);
}

class T1<Type1> extends Type {
  const T1(String name) : super(name);
}

class T2<Type1, Type2> extends Type {
  const T2(String name) : super(name);
}

class T3<Type1, Type2, Type3, Type4, Type5> extends Type {
  const T3(String name) : super(name);
}

class T4<Type1, Type2> extends Type {
  const T4(String name) : super(name);
}

class T5<Type1, Type2> extends Type {
  const T5(String name) : super(name);
}
