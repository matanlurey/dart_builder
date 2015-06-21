library dart_builder.src.elements.invoke;

import 'package:dart_builder/src/elements/source.dart';
import 'package:dart_builder/src/elements/type.dart';
import 'package:dart_builder/src/keywords.dart';

// TODO: Add tests.

/// A reference to an Array that will be generated.
class ArrayRef extends Source {
  final bool isConst;
  final DartType typeRef;
  final List<Source> values;

  /// Create a new array of [values].
  ArrayRef({
      this.values: const [],
      this.isConst: false,
      this.typeRef: DartType.DYNAMIC});

  @override
  void write(StringSink out) {
    if (isConst) {
      out.write($CONST);
      out.write(' ');
    }
    if (typeRef != DartType.DYNAMIC) {
      out.write('<');
      typeRef.write(out);
      out.write('> ');
    }
    writeAll(values, out, prefix: '[', postfix: ']');
  }
}

// TODO: Add tests.
abstract class InvokeMethod extends Source {
  InvokeMethod();

  /// Creates a new instance of [classType].
  ///
  /// Optionally define what [constructorName], otherwise uses default.
  factory InvokeMethod.constructor(
      DartType classType, {
      String constructorName,
      bool isConst: false,
      List<Source> positionalArguments: const [],
      Map<String, Source> namedArguments: const {}}) {
    // TODO: Use builder constructs, not raw code.
    return new _ConstructorInvokeMethod(
        classType,
        constructorName: constructorName,
        isConst: isConst,
        positionalArguments: positionalArguments,
        namedArguments: namedArguments);
  }

  /// Invokes [methodName] on [classType].
  factory InvokeMethod.static(
      DartType classType,
      String methodName, {
      List<Source> positionalArguments: const [],
      Map<String, Source> namedArguments: const {}}) {
    // TODO: Use builder constructs, not raw code.
    // TODO: Support all use cases.
    if (positionalArguments.isNotEmpty || namedArguments.isNotEmpty) {
      throw new UnimplementedError();
    }
    return new _StaticMethodInvokeMethod(
        classType,
        methodName);
  }
}

class _ConstructorInvokeMethod extends InvokeMethod {
  final DartType classType;
  final String constructorName;
  final bool isConst;
  final List<Source> positionalArguments;
  final Map<String, Source> namedArguments;

  _ConstructorInvokeMethod(
      this.classType, {
      this.constructorName,
      this.isConst: false,
      this.positionalArguments: const [],
      this.namedArguments: const {}});

  @override
  void write(StringSink out) {
    if (isConst) {
      out.write($CONST);
    } else {
      out.write($NEW);
    }
    out.write(' ');
    classType.write(out);
    if (constructorName != null) {
      out.write('.');
      out.write(constructorName);
    }
    // TODO: Use [namedArguments] as well.
    writeAll(positionalArguments, out, prefix: '(', postfix: ')');
  }
}

class _StaticMethodInvokeMethod extends InvokeMethod {
  final DartType classType;
  final String methodName;

  _StaticMethodInvokeMethod(this.classType, this.methodName);

  @override
  void write(StringSink out) {
    classType.write(out);
    out.write('.');
    out.write(methodName);
    out.write('()');
  }
}
