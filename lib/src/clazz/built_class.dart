library dart_builder.src.clazz.built_class;

import 'package:collection/equality.dart';
import 'package:dart_builder/src/base.dart';
import 'package:dart_builder/src/clazz/built_constructor.dart';
import 'package:dart_builder/src/method/built_method.dart';
import 'package:dart_builder/src/type/built_type.dart';
import 'package:dart_builder/src/variable/built_variable.dart';
import 'package:quiver/core.dart';

/// Immutable class declaration, useful for code generation.
///
/// See [ClassBuilder] for a mutable builder.
class BuiltClass implements BuiltNamedDefinition {
  static final Expando<int> _hashCodes = new Expando<int>('hashCodes');
  static const ListEquality _listEquals = const ListEquality();

  /// Whether this class should be marked `abstract`.
  final bool isAbstract;

  /// Whether this class should be marked `external`.
  final bool isExternal;

  /// The name of the class.
  @override
  final String name;

  /// Class-level member fields.
  final List<BuiltVariable> fields;

  /// Constructors.
  final List<BuiltConstructor> constructors;

  /// Class-level member methods.
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
      this.constructors: const [],
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
        hashObjects(constructors),
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
          o.constructors == constructors &&
          _listEquals.equals(o.fields, fields) &&
          _listEquals.equals(o.methods, methods) &&
          _listEquals.equals(o.generics, generics) &&
          o.extend == extend &&
          _listEquals.equals(o.implement, implement) &&
          _listEquals.equals(o.mixin, mixin);
    }
    return false;
  }

  @override
  String toString() => 'BuiltClass' + {
    'name': name,
    'isAbstract': isAbstract,
    'isExternal': isExternal,
    'constructors': constructors,
    'fields': fields,
    'methods': methods,
    'generics': generics,
    'extend': extend,
    'implement': implement,
    'mixin': mixin
  }.toString();
}
