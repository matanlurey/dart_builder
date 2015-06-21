library dart_builder.src.elements.invoke.map;

import 'package:dart_builder/src/elements/source.dart';
import 'package:dart_builder/src/elements/type.dart';
import 'package:dart_builder/src/elements/invoke/pair.dart';
import 'package:dart_builder/src/keywords.dart';

/// A reference to an Array that will be generated.
class MapRef extends Source {
  static List<KeyValuePairRef> _fromMap(Map<Source, Source> map) {
    if (map == null || map.isEmpty) return const [];
    var list = <KeyValuePairRef> [];
    map.forEach((key, value) {
      list.add(new KeyValuePairRef(key, value));
    });
    return list;
  }

  /// Whether the array should be constant.
  final bool isConst;

  /// The type of the key value, if any.
  final TypeRef keyTypeRef;

  /// The type of the map value, if any.
  final TypeRef valueTypeRef;

  /// Values in the array.
  final List<KeyValuePairRef> values;

  /// Create a new array of [values].
  MapRef({
      Map<Source, Source> values,
      this.isConst: false,
      this.keyTypeRef: TypeRef.DYNAMIC,
      this.valueTypeRef: TypeRef.DYNAMIC})
          : this.values = _fromMap(values);

  @override
  void write(StringSink out) {
    if (isConst) {
      out.write($CONST);
      out.write(' ');
    }
    if (keyTypeRef != TypeRef.DYNAMIC || valueTypeRef != TypeRef.DYNAMIC) {
      out.write('<');
      keyTypeRef.write(out);
      out.write(', ');
      valueTypeRef.write(out);
      out.write('> ');
    }
    writeAll(values, out, prefix: '{', postfix: '}');
  }
}
