library dart_builder.src.elements.base;

import 'package:dart_builder/src/elements/source.dart';

/// A marker interface for elements that can be top-level within a class.
abstract class ClassLevelElement {}

/// A named [Source] element.
abstract class NamedSourceElement extends Source {
  /// The name.
  final String name;

  const NamedSourceElement(this.name);
}

/// A marker for elements that can be top-level in a file.
abstract class TopLevelElement implements Source {}
