library dart_builder.src.method.built_method_invocation;

import 'package:collection/equality.dart';
import 'package:quiver/core.dart';

/// Immutable method invocation, useful for code generation.
///
/// See [MethodInvocationBuilder] for a mutable builder.
class BuiltMethodInvocation {
  static const BuiltMethodInvocation empty = const BuiltMethodInvocation();
  static final Expando<int> _hashCodes = new Expando<int>('hashCodes');
  static const ListEquality _listEquals = const ListEquality();
  static const MapEquality _mapEquals = const MapEquality();

  /// Arguments that are positional in invoking a method.
  final List<String> positionalArguments;

  /// Arguments that are named (and optional) in invoking a method.
  final Map<String, String> namedArguments;

  const BuiltMethodInvocation(
      {this.positionalArguments: const [], this.namedArguments: const {}});

  @override
  int get hashCode {
    int hashCode = _hashCodes[this];
    if (hashCode == null) {
      hashCode = hash3(hashObjects(positionalArguments),
          hashObjects(namedArguments.keys), hashObjects(namedArguments.values));
      _hashCodes[this] = hashCode;
    }
    return hashCode;
  }

  @override
  bool operator ==(Object o) {
    if (o is BuiltMethodInvocation) {
      // Avoid a more expensive comparison if the hash codes are different.
      if (o.hashCode != hashCode) return false;
      return _listEquals.equals(o.positionalArguments, positionalArguments) &&
          _mapEquals.equals(o.namedArguments, namedArguments);
    }
    return false;
  }
}
