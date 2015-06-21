library dart_builder.src.elements.invoke.pair;

import 'package:dart_builder/src/elements/source.dart';

/// A simple key-value pair.
class KeyValuePairRef extends Source {
  /// The key.
  final Source key;

  /// The value.
  final Source value;

  KeyValuePairRef(this.key, this.value);

  @override
  void write(StringSink out) {
    key.write(out);
    out.write(': ');
    value.write(out);
  }
}
