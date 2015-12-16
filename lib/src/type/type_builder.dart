library dart_builder.src.type.type_builder;

import 'package:dart_builder/src/base.dart';
import 'package:dart_builder/src/type/built_type.dart';

/// A mutable helper for creating a [BuiltType] incrementally.
class TypeBuilder implements Builder<BuiltType> {
  /// A builder that always returns [BuiltType.coreBool];
  static const TypeBuilder coreBool =
      const _PresetTypeBuilder(BuiltType.coreBool);

  /// A builder that always returns [BuiltType.coreDynamic];
  static const TypeBuilder coreDynamic =
      const _PresetTypeBuilder(BuiltType.coreDynamic);

  /// A builder that always returns [BuiltType.coreInt];
  static const TypeBuilder coreInt =
      const _PresetTypeBuilder(BuiltType.coreInt);

  /// A builder that always returns [BuiltType.coreObject];
  static const TypeBuilder coreObject =
      const _PresetTypeBuilder(BuiltType.coreObject);

  /// A builder that always returns [BuiltType.coreString];
  static const TypeBuilder coreString =
      const _PresetTypeBuilder(BuiltType.coreString);

  /// A builder that always returns [BuiltType.coreVoid];
  static const TypeBuilder coreVoid =
      const _PresetTypeBuilder(BuiltType.coreVoid);

  final String name;
  final String prefix;

  final List<TypeBuilder> _generics;

  /// Create a new type named [name].
  factory TypeBuilder(String name, {String prefix}) {
    return new TypeBuilder._(name, prefix, []);
  }

  factory TypeBuilder.coreIterable() {
    return new TypeBuilder('Iterable', null);
  }

  factory TypeBuilder.coreList() {
    return new TypeBuilder('List', null);
  }

  factory TypeBuilder.coreMap() {
    return new TypeBuilder('Map', null);
  }

  factory TypeBuilder.coreSet() {
    return new TypeBuilder('Set', null);
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
    return new TypeBuilder._(rename ?? name,
        prefix: newPrefix ?? prefix, generics: Builder.cloneHelper(_generics));
  }

  @override
  BuiltType build() {
    return new BuiltType(name,
        generics: Builder.buildHelper(_generics), prefix: prefix);
  }
}

class _PresetTypeBuilder implements TypeBuilder {
  final BuiltType _builtType;

  const _PresetTypeBuilder(this._builtType);

  @override
  BuiltType build() => _builtType;

  @override
  TypeBuilder clone({String rename, String newPrefix}) {
    if (rename != null || newPrefix != null) {
      throw new ArgumentError('Cannot modify a preset type.');
    }
    return this;
  }

  @override
  TypeBuilder addGeneric(String name, {String prefix}) {
    throw new StateError('Cannot modify a preset type.');
  }

  @override
  String get name => _builtType.name;

  @override
  String get prefix => _builtType.prefix;
}
