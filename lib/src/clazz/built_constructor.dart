library dart_builder.src.clazz.built_constructor;

import 'package:collection/equality.dart';
import 'package:dart_builder/src/base.dart';
import 'package:dart_builder/src/method/built_method_invocation.dart';
import 'package:dart_builder/src/parameter_list/built_parameter_list.dart';
import 'package:dart_builder/src/type/built_type.dart';
import 'package:quiver/core.dart';

/// Immutable constructor declaration, useful for code generation.
///
/// See [ConstructorBuilder] for a mutable builder.
class BuiltConstructor implements BuiltNamedDefinition {
  static final Expando<int> _hashCodes = new Expando<int>('hashCodes');
  static const MapEquality _mapEquals = const MapEquality();

  /// Whether the constructor is marked const.
  final bool isConst;

  /// Whether the constructor is marked external.
  final bool isExternal;

  /// Whether the constructor is a factory.
  final bool isFactory;

  /// The name of the constructor.
  ///
  /// If `null`, this is the default constructor.
  @override
  final String name;

  /// The parameters of the constructor.
  final BuiltParameterList parameters;

  /// The body of the constructor, if any.
  final String body;

  /// Initializers (fields to expression).
  final Map<String, String> initializers;

  /// The `super(...)` call to make as part of the initializer.
  final BuiltMethodInvocation superCall;

  /// The `super.<name>` call to make as part of the initializer.
  final String superConstructorName;

  /// An optional redirect for a factory constructor.
  final BuiltType redirectTo;

  /// If [redirectTo] is non-null, what constructor name to redirect to, if any.
  final String redirectToName;

  /// Create a constructor, optionally named as [name].
  const BuiltConstructor(
      {this.isConst: false,
      this.name,
      this.body,
      this.parameters: BuiltParameterList.empty,
      this.initializers: const {},
      this.superCall,
      this.superConstructorName})
      : this.isExternal = false,
        this.isFactory = false,
        this.redirectTo = null,
        this.redirectToName = null;

  /// Create an externally implemented constructor.
  const BuiltConstructor.external(
      {this.isConst: false,
      this.isFactory: false,
      this.name,
      this.parameters: BuiltParameterList.empty})
      : this.isExternal = true,
        this.body = null,
        this.initializers = const {},
        this.superCall = null,
        this.superConstructorName = null,
        this.redirectTo = null,
        this.redirectToName = null;

  /// Create a factory constructor.
  const BuiltConstructor.factory(
      {this.isConst: false,
      this.name,
      this.parameters: BuiltParameterList.empty,
      this.body})
      : this.isExternal = false,
        this.isFactory = true,
        this.initializers = const {},
        this.superCall = null,
        this.superConstructorName = null,
        this.redirectTo = null,
        this.redirectToName = null;

  /// Create a factory constructor that redirects to another constructor.
  const BuiltConstructor.redirect(this.redirectTo,
      {this.isConst: false,
      this.name,
      this.parameters: BuiltParameterList.empty,
      this.redirectToName})
      : this.body = null,
        this.isExternal = false,
        this.isFactory = true,
        this.initializers = const {},
        this.superCall = null,
        this.superConstructorName = null;

  @override
  int get hashcode {
    int hashCode = _hashCodes[this];
    if (hashCode == null) {
      hashCode = hashObjects([
        isConst,
        isExternal,
        isFactory,
        name,
        parameters,
        body,
        hashObjects(initializers.keys),
        hashObjects(initializers.values),
        superCall,
        superConstructorName,
        redirectTo
      ]);
    }
    return hashCode;
  }

  @override
  bool operator ==(Object o) {
    if (o is BuiltConstructor) {
      // Avoid a more expensive comparison if the hash codes are different.
      if (o.hashCode != hashCode) return false;
      return o.isConst == isConst &&
          o.isExternal == isExternal &&
          o.isFactory == isFactory &&
          o.name == name &&
          o.parameters == parameters &&
          o.body == name &&
          _mapEquals.equals(o.initializers, initializers) &&
          o.superCall == superCall &&
          o.superConstructorName == superConstructorName &&
          o.redirectTo == redirectTo;
    }
  }
}
