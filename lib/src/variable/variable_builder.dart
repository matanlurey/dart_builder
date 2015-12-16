library dart_builder.src.variable.variable_builder;

import 'package:dart_builder/src/base.dart';
import 'package:dart_builder/src/type/type_builder.dart';
import 'package:dart_builder/src/variable/built_variable.dart';

/// A mutable helper for creating a [BuiltVariable] incrementally.
class VariableBuilder implements Builder<BuiltVariable> {
  final String name;

  bool _isConst;
  bool _isFinal;

  TypeBuilder _typeBuilder;

  /// The default value.
  String defaultValue;

  /// Whether the variable should be `static`.
  bool isStatic;

  factory VariableBuilder(String name,
      {TypeBuilder type: TypeBuilder.coreDynamic}) {
    return new VariableBuilder._(name, false, false, false, type, null);
  }

  VariableBuilder._(this.name, this._isConst, this._isFinal, this.isStatic,
      this._typeBuilder, this.defaultValue);

  @override
  BuiltVariable build() {
    BuiltVariable builtVariable;
    if (isConst) {
      builtVariable = new BuiltVariable.asConst(name,
          defaultValue: defaultValue,
          isStatic: isStatic,
          type: _typeBuilder.build());
    } else if (isFinal) {
      builtVariable = new BuiltVariable.asFinal(name,
          defaultValue: defaultValue,
          isStatic: isStatic,
          type: _typeBuilder.build());
    } else {
      builtVariable = new BuiltVariable(name,
          defaultValue: defaultValue,
          isStatic: isStatic,
          type: _typeBuilder.build());
    }
    return builtVariable;
  }

  @override
  VariableBuilder clone({String rename}) {
    return new VariableBuilder(
        rename ?? name, _isConst, _isFinal, isStatic, _typeBuilder.clone());
  }

  /// Whether the variable should be `const`.
  bool get isConst => _isConst;
  void set isConst(bool isConst) {
    _isConst = isConst;
    _isFinal = false;
  }

  /// Whether the variable should be `final`.
  bool get isFinal => _isFinal;
  void set isFinal(bool isFinal) {
    _isConst = false;
    _isFinal = isFinal;
  }

  /// Removes the [defaultValue], returning the one that previously existed.
  String removeDefaultValue() {
    var tempDefaultValue = defaultValue;
    defaultValue = null;
    return tempDefaultValue;
  }

  /// The type.
  TypeBuilder get type => _typeBuilder;
  void set type(TypeBuilder typeBuilder) {
    _typeBuilder = typeBuilder;
  }
}
