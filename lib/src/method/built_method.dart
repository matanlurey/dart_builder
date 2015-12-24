library dart_builder.src.method.built_method;

import 'package:dart_builder/src/base.dart';
import 'package:dart_builder/src/method/built_method_body.dart';
import 'package:dart_builder/src/parameter_list/built_parameter_list.dart';
import 'package:dart_builder/src/type/built_type.dart';
import 'package:quiver/core.dart';

/// Immutable method declaration, useful for code generation.
///
/// See [MethodBuilder] for a mutable builder.
class BuiltMethod implements BuiltNamedDefinition {
  static final Expando<int> _hashCodes = new Expando<int>('hashCodes');

  static const String operatorAddition = '+';
  static const String operatorBracket = '[]';
  static const String operatorBracketEquals = '[]=';
  static const String operatorDivision = '/';
  static const String operatorEquals = '==';
  static const String operatorGreaterThan = '>';
  static const String operatorLessThan = '<';
  static const String operatorMultiplication = '*';
  static const String operatorSubtraction = '-';

  /// Body.
  final BuiltMethodBody body;

  /// Whether the method is marked abstract.
  final bool isAbstract;

  /// Whether the method (constructor) is marked const.
  final bool isConst;

  /// Whether the method is marked external.
  final bool isExternal;

  /// Whether the method is class factory function.
  final bool isFactory;

  /// Whether the method is a property getter.
  final bool isGetter;

  /// Whether the method is an operator overload.
  final bool isOperator;

  /// Whether the method is a property setter.
  final bool isSetter;

  /// Whether the method is marked static.
  final bool isStatic;

  /// The name of the method.
  ///
  /// May be `null` if the method is a (non-named) closure.
  @override
  final String name;

  /// Defined parameters.
  final BuiltParameterList parameters;

  /// Return type of the method.
  final BuiltType returnType;

  const BuiltMethod(
      {this.body,
      this.isAbstract: false,
      this.isConst: false,
      this.isExternal: false,
      this.isFactory: false,
      this.isGetter: false,
      this.isOperator: false,
      this.isSetter: false,
      this.isStatic: false,
      this.name,
      this.parameters: BuiltParameterList.empty,
      this.returnType: BuiltType.coreVoid});

  const BuiltMethod.getter(this.name,
      {this.body,
      this.isAbstract: false,
      this.isExternal: false,
      this.isStatic: false,
      this.returnType: BuiltType.coreDynamic})
      : this.isGetter = true,
        this.isConst = false,
        this.isFactory = false,
        this.isOperator = false,
        this.isSetter = false,
        this.parameters = BuiltParameterList.empty;

  const BuiltMethod.setter(this.name,
      {this.body,
      this.isAbstract: false,
      this.isExternal: false,
      this.isStatic: false,
      this.parameters: BuiltParameterList.empty})
      : this.isGetter = false,
        this.isConst = false,
        this.isFactory = false,
        this.isOperator = false,
        this.isSetter = true,
        this.returnType = BuiltType.coreVoid;

  @override
  int get hashCode {
    int hashCode = _hashCodes[this];
    if (hashCode == null) {
      hashCode = hashObjects([
        body,
        isAbstract,
        isConst,
        isExternal,
        isFactory,
        isGetter,
        isOperator,
        isSetter,
        isStatic,
        name,
        parameters,
        returnType
      ]);
      _hashCodes[this] = hashCode;
    }
    return hashCode;
  }

  @override
  bool operator ==(Object o) {
    if (o is BuiltMethod) {
      // Avoid a more expensive comparison if the hash codes are different.
      if (o.hashCode != hashCode) return false;
      return o.body == body &&
          o.isAbstract == isAbstract &&
          o.isConst == isConst &&
          o.isExternal == isExternal &&
          o.isFactory == isFactory &&
          o.isGetter == isGetter &&
          o.isOperator == isOperator &&
          o.isSetter == isSetter &&
          o.name == name &&
          o.parameters == parameters &&
          o.returnType == returnType;
    }
    return false;
  }

  @override
  String toString() => 'BuiltMethod' + {
    'body': body,
    'isAbstract': isAbstract,
    'isConst': isConst,
    'isExternal': isExternal,
    'isFactory': isFactory,
    'isGetter': isGetter,
    'isOperator': isOperator,
    'isSetter': isSetter,
    'name': name,
    'parameters': parameters,
    'returnType': returnType
  }.toString();
}
