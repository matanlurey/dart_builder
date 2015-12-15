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

  /// Whether the declaration is const.
  final bool isConst;

  /// Whether the declaration is final.
  final bool isFinal;

  /// Whether the declaration is static.
  final bool isStatic;

  /// The name of the parameter.
  @override
  final String name;

  /// The type of the parameter.
  final BuiltType type;

  const BuiltVariable(this.name,
      {this.defaultValue,
      this.isStatic: false,
      this.type: BuiltType.coreDynamic})
      : this.isConst = false,
        this.isFinal = false;

  const BuiltVariable.asConst(this.name,
      {this.defaultValue,
      this.isStatic: false,
      this.type: BuiltType.coreDynamic})
      : this.isConst = true,
        this.isFinal = false;

  const BuiltVariable.asFinal(this.name,
      {this.defaultValue,
      this.isStatic: false,
      this.type: BuiltType.coreDynamic})
      : this.isConst = false,
        this.isFinal = true;

  @override
  int get hashCode {
    int hashCode = _hashCodes[this];
    if (hashCode == null) {
      hashCode =
          hashObjects([defaultValue, isConst, isFinal, isStatic, name, type]);
    }
    return hashCode;
  }

  @override
  bool operator ==(Object o) {
    if (o is BuiltVariable) {
      return o.defaultValue == defaultValue &&
          o.isConst == isConst &&
          o.isFinal == isFinal &&
          o.isStatic == isStatic &&
          o.name == name &&
          o.type == type;
    }
    return false;
  }

  @override
  String toString() => 'BuiltVariable ' +
      {
        'defaultValue': defaultValue,
        'isConst': isConst,
        'isFinal': isFinal,
        'isStatic': isStatic,
        'name': name,
        'type': type
      }.toString();
}
