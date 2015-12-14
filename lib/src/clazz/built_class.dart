library dart_builder.src.clazz.built_class;

import 'package:collection/equality.dart';
import 'package:dart_builder/src/method/built_method.dart';
import 'package:dart_builder/src/type/built_type.dart';
import 'package:dart_builder/src/variable/built_variable.dart';
import 'package:quiver/core.dart';

/// Immutable class declaration, useful for code generation.
///
/// See [ClassBuilder] for a mutable builder.
class BuiltClass {
  static final Expando<int> _hashCodes = new Expando<int>('hashCodes');
  static const _listEquals = const ListEquality();

  /// Whether this class should be marked `abstract`.
  final bool isAbstract;

  /// Whether this class should be marked `external`.
  final bool isExternal;

  /// The name of the class.
  final String name;

  /// Class-level member fields.
  final List<BuiltVariable> fields;

  /// Class-level member methods.
  ///
  /// To implement constructors, use the [name] of the class as the method name
  /// or with the `.name` syntax for named constructors, i.e.:
  ///     const BuiltClass(
  ///         'Foo',
  ///         methods: const [const BuiltMethod(name: 'Foo.fromBar')])
  ///
  /// TODO: Consider a seperate collection for constructors and add missing
  /// parts like `const` for a constructor.
  final List<BuiltMethod> methods;

  /// Generic types the class supports.
  ///
  /// Example use to create `class Foo<T>`:
  ///     const BuiltClass(
  ///         'Foo',
  ///         generics: const [const BuiltType('T')]);
  final List<BuiltType> generics;

  /// Which class to extend, if any.
  final BuiltType extend;

  /// Which classes to implement, if any.
  final List<BuiltType> implement;

  /// Which classes to mixin, if any.
  final List<BuiltType> mixin;

  const BuiltClass(this.name,
      {this.isAbstract: false,
      this.isExternal: false,
      this.fields: const [],
      this.methods: const [],
      this.generics: const [],
      this.extend,
      this.implement: const [],
      this.mixin: const []});

  @override
  int get hashCode {
    int hashCode = _hashCodes[this];
    if (hashCode == null) {
      hashCode = hashObjects([
        name,
        isAbstract,
        isExternal,
        hashObjects(fields),
        hashObjects(methods),
        hashObjects(generics),
        extend,
        hashObjects(implement),
        hashObjects(mixin)
      ]);
      _hashCodes[this] = hashCode;
    }
    return hashCode;
  }

  @override
  bool operator ==(Object o) {
    if (o is BuiltClass) {
      // Avoid a more expensive comparison if the hash codes are different.
      if (o.hashCode != hashCode) return false;
      return o.name == name &&
          o.isAbstract == isAbstract &&
          o.isExternal == isExternal &&
          _listEquals(o.fields, fields) &&
          _listEquals(o.methods, methods) &&
          _listEquals(o.generics, generics) &&
          o.extend == extend &&
          _listEquals(o.implement, implement) &&
          _listEquals(o.mixin, mixin);
    }
    return false;
  }
}
