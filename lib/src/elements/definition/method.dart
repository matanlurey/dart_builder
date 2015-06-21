part of dart_builder.src.elements.definition;

/// A method definition.
class MethodRef
    extends Definition
    implements ClassLevelElement, TopLevelElement {
  /// Whether it is a getter.
  final bool isGetter;

  /// Whether it is a setter.
  final bool isSetter;

  /// Whether it is static on a class.
  final bool isStatic;

  /// The body of the method. Assumed to be abstract without one.
  final Source methodBody;

  /// Optional arguments.
  final List<ParameterRef> optionalArguments;

  /// Positional arguments.
  final List<ParameterRef> positionalArguments;

  /// The return type ref.
  final TypeRef returnTypeRef;

  /// Whether [optional]s should be named, not positional.
  final bool useNamedOptionals;

  /// A shortcut for creating a property getter.
  factory MethodRef.getter(
      String name, {
      TypeRef typeRef: TypeRef.DYNAMIC,
      Source methodBody}) {
    return new MethodRef(
        name,
        isGetter: true,
        returnTypeRef: typeRef,
        methodBody: methodBody);
  }

  /// A shortcut for creating a property setter.
  factory MethodRef.setter(
      String name, {
      TypeRef typeRef: TypeRef.DYNAMIC,
      Source methodBody})  {
    return new MethodRef(
        name,
        isSetter: true,
        returnTypeRef: typeRef,
        methodBody: methodBody);
  }

  /// Creates a new method definition, either top level or within a class.
  MethodRef(
      String name, {
      this.isGetter: false,
      this.isSetter: false,
      this.isStatic: false,
      this.methodBody,
      this.optionalArguments: const [],
      this.positionalArguments: const [],
      this.returnTypeRef: TypeRef.DYNAMIC,
      this.useNamedOptionals: false})
          : super(name) {
    if (isGetter && isSetter) {
      throw new ArgumentError('Can only set isGetter or isSetter.');
    }
  }

  @override
  String toSource({bool inClass: false}) {
    var buffer = new StringBuffer();
    write(buffer, inClass: inClass);
    return buffer.toString();
  }

  @override
  void write(StringSink out, {bool inClass: false}) {
    if (isStatic) {
      if (!inClass) {
        throw new StateError('Cannot define static methods outside a class.');
      }
      out.write($STATIC);
      out.write(' ');
    }
    if (returnTypeRef.isTyped) {
      returnTypeRef.write(out);
      out.write(' ');
    }
    if (isGetter) {
      out.write($GET);
      out.write(' ');
    } else if (isSetter) {
      out.write($SET);
      out.write(' ');
    }
    out.write(name);
    if (isGetter) {
      // Do nothing.
    } else if (isSetter) {
      var arguments = [new ParameterRef(name, typeRef: returnTypeRef)];
      writeAll(arguments, out, prefix: '(', postfix: ')');
    } else {
      out.write('(');
      writeAll(positionalArguments, out);
      if (optionalArguments.isNotEmpty) {
        if (positionalArguments.isNotEmpty) {
          out.write(', ');
        }
        if (useNamedOptionals) {
          writeAll(
              optionalArguments,
              out,
              prefix: '{',
              postfix: '}',
              customWrite: (ParameterRef source, StringSink out) {
                source.write(out, asPositional: false);
              });
        } else {
          writeAll(optionalArguments, out, prefix: '[', postfix: ']');
        }
      }
      out.write(')');
    }
    if (methodBody != null) {
      out.writeln(' {');
      methodBody.write(out);
      out.writeln();
      out.writeln('}');
    } else {
      out.write(';');
    }
  }
}
