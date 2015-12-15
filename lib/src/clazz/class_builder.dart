library dart_builder.src.clazz.class_builder;

import 'package:dart_builder/src/base.dart';
import 'package:dart_builder/src/clazz/built_class.dart';
import 'package:dart_builder/src/clazz/built_constructor.dart';
import 'package:dart_builder/src/clazz/constructor_builder.dart';
import 'package:dart_builder/src/method/built_method.dart';
import 'package:dart_builder/src/method/built_method_body.dart';

/// A mutable helper for creating a [BuiltClass] incrementally.
class ClassBuilder implements Builder<BuiltClass> {
  final List<ConstructorBuilder> _constructors;

  /// The name of the class.
  final String name;

  /// Creates a builder for a class named [name].
  factory ClassBuilder(String name) => new ClassBuilder._(name, []);

  ClassBuilder._(this.name, this._constructors);

  /// Returns a [ConstructorBuilder] that is added to the class.
  ConstructorBuilder addConstructor() {
    var builder = new ConstructorBuilder();
    _constructors.add(builder);
    return builder;
  }

  /// Returns an immutable [BuiltClass] as a result.
  @override
  BuiltClass build() {
    return new BuiltClass(name,
        constructors: Builder.buildHelper(_constructors));
  }

  /// Clones the state of the build and returns as a new [ClassBuilder].
  ///
  /// Optionally can [rename].
  @override
  ClassBuilder clone({String rename}) {
    return new ClassBuilder._(
        rename ?? name, Builder.cloneHelper(_constructors));
  }
}
