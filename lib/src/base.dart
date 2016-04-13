library dart_builder.src.base;

/// A class that can return a type [T] as a result of [build].
abstract class Builder<T> {
  /// Returns an immutable list of the built results from [builders].
  static List buildHelper(Iterable<Builder> builders) {
    return new List.unmodifiable(builders.map((b) => b.build()));
  }

  /// Returns a new list of cloned [builders].
  static List<Builder> cloneHelper(Iterable<Builder> builders) {
    return builders.map((b) => b.clone()).toList();
  }

  /// Create a [T] from the internal state of the builder.
  T build();

  /// Return a defensive copy of the current builder state.
  Builder clone();
}

/// An interface for something that can be a named definition.
abstract class BuiltNamedDefinition {
  String get name;
}
