library dart_builder.src.elements.definition;

import 'package:dart_builder/src/keywords.dart';
import 'package:dart_builder/src/elements/base.dart';
import 'package:dart_builder/src/elements/source.dart';
import 'package:dart_builder/src/elements/type.dart';

part 'definition/class.dart';
part 'definition/field.dart';
part 'definition/method.dart';
part 'definition/parameter.dart';

/// A definition element.
abstract class Definition extends NamedSourceElement {
  const Definition(String name) : super(name);
}
