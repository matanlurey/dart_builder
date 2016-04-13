library dart_builder.src.parameter_list.parameter_list_builder;

import 'package:dart_builder/src/base.dart';
import 'package:dart_builder/src/parameter_list/built_parameter_list.dart';
import 'package:dart_builder/src/variable/built_variable.dart';
import 'package:dart_builder/src/variable/variable_builder.dart';

/// A mutable helper for creating a [BuiltParameterList] incrementally.
class ParameterListBuilder implements Builder<BuiltParameterList> {
  static int _indexOfByName(List<VariableBuilder> parameters, String name) {
    for (var i = 0; i < parameters.length; i++) {
      if (parameters[i].name == name) return i;
    }
    return -1;
  }

  final List<VariableBuilder> _requiredParameters;
  final List<VariableBuilder> _optionalParameters;

  factory ParameterListBuilder() {
    return new ParameterListBuilder._([], []);
  }

  ParameterListBuilder._(this._requiredParameters, this._optionalParameters);

  /// Whether the optional parameters should be named instead of positional.
  bool useNamedOptionalArguments = false;

  /// Returns a builder for adding [name] as a parameter.
  ///
  /// Required unless [optional] is set.
  VariableBuilder addParameter(String name, {bool optional: false}) {
    if (_indexOfByName(_requiredParameters, name) != -1 ||
        _indexOfByName(_optionalParameters, name) != -1) {
      throw new ArgumentError('Parameter already exists named "$name".');
    }
    var variableBuilder = new VariableBuilder(name);
    var parameters = optional ? _optionalParameters : _requiredParameters;
    parameters.add(variableBuilder);
    return variableBuilder;
  }

  @override
  BuiltParameterList build() {
    return new BuiltParameterList(
        requiredArguments:
            Builder.buildHelper(_requiredParameters) as List<BuiltVariable>,
        optionalArguments:
            Builder.buildHelper(_optionalParameters) as List<BuiltVariable>,
        useNamedOptionalArguments: useNamedOptionalArguments);
  }

  @override
  ParameterListBuilder clone() {
    return new ParameterListBuilder._(Builder.cloneHelper(_requiredParameters),
        Builder.cloneHelper(_optionalParameters));
  }

  /// Returns whether [name] is an optional or required parameter.
  bool containsParameter(String name) {
    return isOptionalParameter(name) || isRequiredParameter(name);
  }

  /// Returns whether [name] is an optional parameter.
  bool isOptionalParameter(String name) {
    return _indexOfByName(_optionalParameters, name) != -1;
  }

  /// Returns whether [name] is a required parameter.
  bool isRequiredParameter(String name) {
    return _indexOfByName(_requiredParameters, name) != -1;
  }

  /// Removes the parameter named [name] from the parameter list.
  ///
  /// Returns whether a parameter with that name was found and removed.
  bool removeParameter(String name) {
    // Check required parameters.
    var i = _indexOfByName(_requiredParameters, name);
    if (i != -1) {
      _requiredParameters.removeAt(i);
      return true;
    }
    i = _indexOfByName(_optionalParameters, name);
    if (i != -1) {
      _optionalParameters.removeAt(i);
      return true;
    }
    return false;
  }
}
