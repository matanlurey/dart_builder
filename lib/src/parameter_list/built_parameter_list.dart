library dart_builder.src.parameter.built_parameter_list;

import 'package:collection/equality.dart';
import 'package:dart_builder/src/variable/built_variable.dart';
import 'package:quiver/core.dart';

/// Immutable parameter list, useful for code generation.
///
/// See [ParameterListBuilder] for a mutable builder.
class BuiltParameterList {
  static const BuiltParameterList empty = const BuiltParameterList();
  static final Expando<int> _hashCodes = new Expando<int>('hashCodes');
  static const _listEquals = const ListEquality();

  /// Arguments that are optional to invoke a method.
  final List<BuiltVariable> optionalArguments;

  /// Arguments that are required to invoke a method.
  final List<BuiltVariable> requiredArguments;

  /// Whether [optionalArguments] are named.
  ///
  /// If `false`, they are positional.
  final bool useNamedOptionalArguments;

  const BuiltParameterList(
      {this.requiredArguments: const [],
      this.optionalArguments: const [],
      this.useNamedOptionalArguments: false});

  @override
  int get hashCode {
    int hashCode = _hashCodes[this];
    if (hashCode == null) {
      hashCode = hash3(hashObjects(requiredArguments),
          hashObjects(optionalArguments), useNamedOptionalArguments);
      _hashCodes[this] = hashCode;
    }
    return hashCode;
  }

  @override
  bool operator ==(Object o) {
    if (o is BuiltParameterList) {
      return _listEquals(o.requiredArguments, requiredArguments) &&
          _listEquals(o.optionalArguments, optionalArguments) &&
          o.useNamedOptionalArguments == useNamedOptionalArguments;
    }
    return false;
  }
}
