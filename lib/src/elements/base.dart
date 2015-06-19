library dart_builder.src.elements.base;

import 'package:dart_builder/src/elements/source.dart';

abstract class NamedSourceElement extends Source {
  final String name;

  NamedSourceElement(this.name);
}

/// A marker for elements that can be top-level in a file.
abstract class TopLevelElement implements Source {}
