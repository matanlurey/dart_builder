library dart_builder.src.method.built_method_body;

import 'package:collection/equality.dart';
import 'package:quiver/core.dart';

/// Immutable method body declaration, useful for code generation.
///
/// See [MethodBodyBuilder] for a mutable builder.
class BuiltMethodBody {
  static final Expando<int> _hashCodes = new Expando<int>('hashCodes');
  static const _listEquals = const ListEquality();
  static const BuiltMethodBody empty = const BuiltMethodBody(const []);

  /// Whether the body is a lambda expression.
  final bool isExpression;

  /// Whether the body is preceded with the `async` keyword.
  final bool isAsync;

  /// Whether the body's `async` or `sync` keyword is post-fixed with a `*`.
  final bool isStar;

  /// Whether the body is preceded with the `sync` keyword.
  final bool isSync;

  /// The lines of the method body.
  ///
  /// This is assumed to be a list of length 1 if [isExpression].
  ///
  /// TODO: Consider making this is a data structure as well.
  final List<String> lines;

  const BuiltMethodBody(this.lines,
      {this.isExpression: false,
      this.isAsync: false,
      this.isStar: false,
      this.isSync: false});

  @override
  int get hashCode {
    int hashCode = _hashCodes[this];
    if (hashCode == null) {
      hashCode = hashObjects([
        isExpression,
        isAsync,
        isStar,
        isSync,
        hashObjects[lines]
      ]);
      _hashCodes[this] = hashCode;
    }
    return hashCode;
  }

  @override
  bool operator ==(Object o) {
    if (o is BuiltMethodBody) {
      // Avoid a more expensive comparison if the hash codes are different.
      if (o.hashCode != hashCode) return false;
      return o.isExpression == isExpression &&
             o.isAsync == isAsync &&
             o.isStar == isStar &&
             o.isSync == isSync &&
             _listEquals(o.lines, lines);
    }
    return false;
  }
}
