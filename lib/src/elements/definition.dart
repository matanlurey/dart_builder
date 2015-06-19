library dart_builder.src.elements.definition;

import 'package:dart_builder/src/keywords.dart';
import 'package:dart_builder/src/elements/base.dart';
import 'package:dart_builder/src/elements/source.dart';
import 'package:dart_builder/src/elements/type.dart';

abstract class Definition extends NamedSourceElement {
  Definition(String name) : super(name);
}

class ClassDefinition extends Definition implements TopLevelElement {
  final List<FieldDefinition> fields;
  final List<MethodDefinition> methods;
  final bool isAbstract;

  ClassDefinition(
      String name, {
      this.fields: const [],
      this.methods: const [],
      this.isAbstract: false}) : super(name);

  bool get hasBody => fields.isNotEmpty || methods.isNotEmpty;

  @override
  void write(StringSink out) {
    if (isAbstract) {
      out.write($ABSTRACT);
      out.write(' ');
    }
    out.write($CLASS);
    out.write(' ');
    out.write(name);
    if (!hasBody) {
      out.write(' {}');
    } else {
      out.writeln(' {');
      for (final field in fields) {
        out.write('  ');
        field.write(out, inClass: true);
        out.writeln();
      }
      for (final method in methods) {
        out.write('  ');
        method.write(out);
        out.writeln();
      }
      out.writeln('}');
    }
  }
}

/// A marker interface for elements that can be top-level within a class.
abstract class ClassLevelElement {}

class FunctionTypeDefinition extends Definition implements TopLevelElement {}

class FieldDefinition
    extends Definition
    implements ClassLevelElement, TopLevelElement {
  final Source assignment;
  final DartType dartType;

  final bool isConst;
  final bool isFinal;
  final bool isStatic;

  FieldDefinition(
      String name, {
      this.assignment,
      this.dartType: DartType.DYNAMIC,
      this.isConst: false,
      this.isFinal: false,
      this.isStatic: false}) : super(name) {
    if (isFinal && isConst) {
      throw new ArgumentError('Only "isFinal" or "isConst" can be true.');
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
    if (!inClass && isStatic) {
      throw new StateError('Cannot output a static field outside of a class.');
    }
    if (isStatic) {
      out.write($STATIC);
      out.write(' ');
    }
    if (isFinal) {
      out.write($FINAL);
      out.write(' ');
    } else if (isConst) {
      out.write($CONST);
      out.write(' ');
    }
    if (!dartType.isTyped && !isFinal && !isConst) {
      out.write($VAR);
      out.write(' ');
    } else if (dartType.isTyped) {
      dartType.write(out);
      out.write(' ');
    }
    out.write(name);
    if (assignment != null) {
      out.write(' = ');
      assignment.write(out);
    }
    out.write(';');
  }
}

class MethodArgument extends Source {
  final DartType dartType;
  final Source defaultValue;
  final String name;

  MethodArgument(
      this.name, {
      this.dartType: DartType.DYNAMIC,
      this.defaultValue});

  @override
  String toSource({bool isPositional: true}) {
    var buffer = new StringBuffer();
    write(buffer, isPositional: isPositional);
    return buffer.toString();
  }

  @override
  void write(StringSink out, {bool isPositional: true}) {
    if (dartType.isTyped) {
      dartType.write(out);
      out.write(' ');
    }
    out.write(name);
    if (defaultValue != null) {
      if (isPositional) {
        out.write(' = ');
      } else {
        out.write(': ');
      }
      defaultValue.write(out);
    }
  }
}

class MethodDefinition
    extends Definition
    implements ClassLevelElement, TopLevelElement {
  final bool isGetter;
  final bool isSetter;
  final bool isStatic;
  final Source methodBody;
  final List<MethodArgument> optionalArguments;
  final List<MethodArgument> positionalArguments;
  final DartType returnType;
  final bool useNamedOptionals;

  /// A shortcut for creating a property getter.
  factory MethodDefinition.getter(
      String name, {
      DartType dartType: DartType.DYNAMIC,
      Source methodBody}) {
    return new MethodDefinition(
        name,
        isGetter: true,
        returnType: dartType,
        methodBody: methodBody);
  }

  /// A shortcut for creating a property setter.
  factory MethodDefinition.setter(
      String name, {
      DartType dartType: DartType.DYNAMIC,
      Source methodBody})  {
    return new MethodDefinition(
        name,
        isSetter: true,
        returnType: dartType,
        methodBody: methodBody);
  }

  /// Creates a new method definition, either top level or within a class.
  MethodDefinition(
      String name, {
      this.isGetter: false,
      this.isSetter: false,
      this.isStatic: false,
      this.methodBody,
      this.optionalArguments: const [],
      this.positionalArguments: const [],
      this.returnType: DartType.DYNAMIC,
      this.useNamedOptionals: false}) : super(name) {
    if (isGetter && isSetter) {
      throw new ArgumentError('Can only set isGetter or isSetter.');
    }
  }

  @override
  void write(StringSink out) {
    if (isStatic) {
      out.write($STATIC);
      out.write(' ');
    }
    if (returnType.isTyped) {
      returnType.write(out);
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
      var arguments = [new MethodArgument(name, dartType: returnType)];
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
              customWrite: (MethodArgument source, StringSink out) {
                source.write(out, isPositional: false);
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
