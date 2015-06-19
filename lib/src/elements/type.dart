library dart_builder.src.elements.type;

import 'package:dart_builder/src/elements/source.dart';

/// A defined dart type.
class DartType extends Source {
  /// Any explicitly untyped field or method.
  ///
  /// *NOTE*: Some source generator may choose to omit 'dynamic' in the output
  /// if not required. For example, it will be kept as a generic parameter in
  /// a type (e.g. Map<String, dynamic>) but not as a return type of a method.
  static const DartType DYNAMIC = const DartType('dynamic');

  static const DartType STRING = const DartType('String');

  /// The type name.
  final String name;

  /// The namespace of the type, if imported via an 'import "" as' directive.
  final String namespace;

  /// Generic type parameters of the type, if any.
  final List<DartType> parameters;

  const DartType(this.name, {this.namespace, this.parameters: const []});

  /// Whether this is typed (e.g., not DYNAMIC).
  bool get isTyped => this != DYNAMIC;

  @override
  void write(StringSink out) {
    if (namespace != null) {
      out.write(namespace);
      out.write('.');
    }
    out.write(name);
    if (parameters.isNotEmpty) {
      writeAll(parameters, out, prefix: '<', postfix: '>');
    }
  }
}
