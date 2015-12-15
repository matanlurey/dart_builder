library dart_builder.src.parameter.built_parameter;

import 'package:dart_builder/src/base.dart';
import 'package:dart_builder/src/type/built_type.dart';
import 'package:quiver/core.dart';

/// Immutable variable definition, useful for code generation.
///
/// See [VariableBuilder] for a mutable builder.
class BuiltVariable implements BuiltNamedDefinition {
  static final Expando<int> _hashCodes = new Expando<int>('hashCodes');

  /// A default value, if any.
  ///
  /// TODO: Make this a built (const) expression.
  final String defaultValue;

  /// Whether the declaration is final.
  final bool isFinal;

  /// The name of the parameter.
  @override
  final String name;

  /// The type of the parameter.
  final BuiltType type;

  const BuiltVariable(this.name,
      {this.defaultValue,
      // TODO: Add metadata.
      this.isFinal: false,
      this.type: BuiltType.coreDynamic});

  @override
  int get hashCode {
    int hashCode = _hashCodes[this];
    if (hashCode == null) {
      hashCode = hash4(name, type, defaultValue, isFinal);
    }
    return hashCode;
  }

  @override
  bool operator ==(Object o) {
    if (o is BuiltVariable) {
      return o.name == name &&
          o.type == type &&
          o.defaultValue == defaultValue &&
          o.isFinal == isFinal;
    }
    return false;
  }
}
