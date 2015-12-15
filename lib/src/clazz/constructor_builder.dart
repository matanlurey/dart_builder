library dart_builder.src.clazz.constructor_builder;

class ConstructorBuilder {
  /// The (optional) name of the constructor, such as 'internal'.
  String name;

  ParameterListBuilder _parameterBuilder;

  /// The parameters of this constructor.
  ParameterListBuilder get parameters {
    return _parameterBuilder ??= new ParameterListBuilder();
  }

  /// Remove (null out) [name].
  void removeName() {
    name = null;
  }
}
