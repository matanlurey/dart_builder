library dart_builder.src.file;

import 'package:dart_builder/src/elements/base.dart';
import 'package:dart_builder/src/elements/directive.dart';
import 'package:dart_builder/src/elements/source.dart';
import 'package:dart_style/dart_style.dart';

/// A collection of Dart language constructs that form a file.
///
/// Unlike other [Source] implementations, [toSource] automatically runs the
/// dart_style formatter by default.
class SourceFile extends Source {
  static final _formatter = new DartFormatter();

  final Directive libraryOrPart;
  final List<ImportDirective> imports;
  final List<TopLevelElement> topLevelElements;

  /// Creates a new file representing a library with [libraryName].
  ///
  /// Includes [imports] and other [topLevelElements] like class definitions.
  factory SourceFile.library(
      String libraryName, {
      Iterable<ImportDirective> imports: const [],
      Iterable<TopLevelElement> topLevelElements: const []}) {
    return new SourceFile._(
        new LibraryDirective(libraryName),
        imports.toList(growable: false),
        topLevelElements.toList(growable: false));
  }

  /// Creates a new file representing a part of an existing [libraryName].
  ///
  /// Includes [topLevelElements] like class definitions.
  factory SourceFile.part(
      String libraryName, {
      Iterable<TopLevelElement> topLevelElements: const []}) {
    return new SourceFile._(
        new PartOfDirective(libraryName),
        const [],
        topLevelElements.toList(growable: false));
  }

  SourceFile._(this.libraryOrPart, this.imports, this.topLevelElements);

  /// Whether this is a part file.
  bool get isPart => libraryOrPart is PartDirective;

  /// Whether this is a library.
  bool get isLibrary => libraryOrPart is LibraryDirective;

  @override
  void write(StringSink out) {
    libraryOrPart.write(out);
    out.writeln();
    if (imports.isNotEmpty) {
      for (final directive in imports) {
        directive.write(out);
        out.writeln();
      }
      out.writeln();
    }
    for (final element in topLevelElements) {
      element.write(out);
      out.writeln();
    }
  }

  @override
  String toSource({bool format: true}) {
    var source = super.toSource();
    if (format) {
      source = _formatter.format(source);
    }
    return source;
  }
}
