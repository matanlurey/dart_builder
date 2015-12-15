library dart_builder.src.file.built_file;

import 'package:collection/equality.dart';
import 'package:dart_builder/src/base.dart';
import 'package:dart_builder/src/file/built_directive.dart';
import 'package:quiver/core.dart';

/// An output file of [libraryName].
///
/// - May import, export, or include [directives].
/// - Usually has many [definitions].
class BuiltFile {
  static final Expando<int> _hashCodes = new Expando<int>();
  static const ListEquality _listEquals = const ListEquality();

  /// Import, export, and part directives.
  final List<BuiltDirective> directives;

  /// Top-level definitions (fields, methods, classes).
  final List<BuiltNamedDefinition> definitions;

  /// The library name this file declares or belongs to.
  final String libraryName;

  /// True if the file is part of [libraryName] versus the library itself.
  final bool isPartOf;

  const BuiltFile(this.libraryName,
      {this.definitions: const [],
      this.directives: const [],
      this.isPartOf: false});

  @override
  int get hashCode {
    int hashCode = _hashCodes[this];
    if (hashCode == null) {
      hashCode = hashObjects([
        hashObjects(directives),
        hashObjects(definitions),
        libraryName,
        isPartOf
      ]);
      _hashCodes[this] = hashCode;
    }
    return hashCode;
  }

  @override
  bool operator ==(Object o) {
    if (o is BuiltFile) {
      // Avoid a more expensive comparison if the hash codes are different.
      if (o.hashCode != hashCode) return false;
      return _listEquals.equals(o.directives, directives) &&
          _listEquals.equals(o.definitions, definitions) &&
          o.libraryName == libraryName &&
          o.isPartOf == isPartOf;
    }
    return false;
  }
}
