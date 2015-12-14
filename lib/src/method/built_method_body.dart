library dart_builder.src.method.built_method_body;

/// Immutable method body declaration, useful for code generation.
///
/// See [MethodBodyBuilder] for a mutable builder.
class BuiltMethodBody {
  static const BuiltMethodBody empty = const BuiltMethodBody(const []);

  final bool isExpression;
  final bool isAsync;
  final bool isStar;
  final bool isSync;
  final List<String> lines;

  const BuiltMethodBody(this.lines,
      {this.isExpression: false,
      this.isAsync: false,
      this.isStar: false,
      this.isSync: false});
}
