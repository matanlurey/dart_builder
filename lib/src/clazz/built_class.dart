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

  final bool isAbstract;
  final bool isExternal;
  final String name;

  final List<BuiltVariable> fields;
  final List<BuiltMethod> methods;

  final List<BuiltType> generics;
  final BuiltType extend;
  final List<BuiltType> implement;
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
