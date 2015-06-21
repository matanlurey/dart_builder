library dart_builder.src.elements.invoke.array;

import 'package:dart_builder/src/elements/source.dart';
import 'package:dart_builder/src/elements/type.dart';
import 'package:dart_builder/src/keywords.dart';

/// A reference to an Array that will be generated.
class ArrayRef extends Source {
  /// Whether the array should be constant.
  final bool isConst;

  /// The type of the array, if any.
  final TypeRef typeRef;

  /// Values in the array.
  final List<Source> values;

  /// Create a new array of [values].
  const ArrayRef({
      this.values: const [],
      this.isConst: false,
      this.typeRef: TypeRef.DYNAMIC});

  @override
  void write(StringSink out) {
    if (isConst) {
      out.write($CONST);
      out.write(' ');
    }
    if (typeRef != TypeRef.DYNAMIC) {
      out.write('<');
      typeRef.write(out);
      out.write('> ');
    }
    writeAll(values, out, prefix: '[', postfix: ']');
  }
}
