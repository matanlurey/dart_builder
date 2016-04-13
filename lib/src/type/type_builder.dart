library dart_builder.src.type.type_builder;

import 'package:dart_builder/src/base.dart';
import 'package:dart_builder/src/type/built_type.dart';

/// A mutable helper for creating a [BuiltType] incrementally.
class TypeBuilder implements Builder<BuiltType> {
  final String name;
  final String prefix;

  final List<TypeBuilder> _generics;

  /// Create a new type named [name].
  factory TypeBuilder(String name, {String prefix}) {
    return new TypeBuilder._(name, prefix, []);
  }

  TypeBuilder._(this.name, this.prefix, this._generics);

  /// Adds a generic parameter of [name].
  TypeBuilder addGeneric(String name, {String prefix}) {
    var typeBuilder = new TypeBuilder(name, prefix: prefix);
    _generics.add(typeBuilder);
    return typeBuilder;
  }

  /// Adds a generic parameter using an existing [typeBuilder].
  TypeBuilder addExistingGeneric(TypeBuilder typeBuilder) {
    var typeBuilderClone = typeBuilder.clone();
    _generics.add(typeBuilderClone);
    return typeBuilderClone;
  }

  @override
  TypeBuilder clone({String rename, String newPrefix}) {
    throw new UnimplementedError();
  }

  @override
  BuiltType build() {
    throw new UnimplementedError();
  }
}
