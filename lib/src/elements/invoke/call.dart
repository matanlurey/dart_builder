library dart_builder.src.elements.invoke.call;

import 'package:dart_builder/src/elements/source.dart';
import 'package:dart_builder/src/elements/type.dart';
import 'package:dart_builder/src/elements/invoke/pair.dart';
import 'package:dart_builder/src/keywords.dart';

class CallRef extends Source {
  static List<KeyValuePairRef> _convertMap(Map<String, Source> map) {
    var list = <KeyValuePairRef> [];
    map.forEach((key, value) {
      list.add(new KeyValuePairRef(new Source.fromDart(key), value));
    });
    return list;
  }

  final bool isConst;
  final bool isConstructor;
  final String methodName;
  final List<Source> positionalArguments;
  final List<KeyValuePairRef> namedArguments;
  final TypeRef sourceTypeRef;

  /// A helper constructor for defining a constructor call site.
  ///
  /// The [constructorName] of [sourceTypeRef] is called, optionally [isConst].
  ///
  /// Optionally define [positionalArguments] and [namedArguments].
  factory CallRef.constructor(
      TypeRef sourceTypeRef, {
      String constructorName: '',
      bool isConst: false,
      List<Source> positionalArguments: const [],
      Map<String, Source> namedArguments: const {}}) {
    return new CallRef(
        isConst: isConst,
        isConstructor: true,
        methodName: constructorName,
        positionalArguments: positionalArguments,
        namedArguments: namedArguments,
        sourceTypeRef: sourceTypeRef);
  }

  /// A helper constructor for defining a static [methodName] call site.
  ///
  /// Optionally define [positionalArguments] and [namedArguments].
  factory CallRef.static(
      TypeRef sourceTypeRef,
      String methodName, {
      List<Source> positionalArguments: const [],
      Map<String, Source> namedArguments: const {}}) {
    return new CallRef(
        methodName: methodName,
        positionalArguments: positionalArguments,
        namedArguments: namedArguments,
        sourceTypeRef: sourceTypeRef);
  }

  /// Creates a new reference to a call site.
  ///
  /// [isConstructor]: Define as a constructor call site. See [isConst] as well.
  ///
  /// Both static methods and constructors need a [sourceTypeRef] and a
  /// [methodName] (which can be omitted if it is a constructor).
  ///
  /// Optionally define [positionalArguments] and [namedArguments].
  CallRef({
      this.isConst: false,
      this.isConstructor: false,
      this.methodName: '',
      this.positionalArguments: const [],
      Map<String, Source> namedArguments: const {},
      this.sourceTypeRef})
          : this.namedArguments = _convertMap(namedArguments);

  @override
  void write(StringSink out) {
    if (isConstructor) {
      out.write(isConst ? $CONST : $NEW);
      out.write(' ');
    }
    if (sourceTypeRef != null) {
      sourceTypeRef.write(out);
      if (!isConstructor || methodName.isNotEmpty) {
        out.write('.');
        out.write(methodName);
      }
    } else {
      out.write(methodName);
    }
    out.write('(');
    writeAll(positionalArguments, out);
    if (namedArguments.isNotEmpty) {
      if (positionalArguments.isNotEmpty) {
        out.write(', ');
      }
      writeAll(namedArguments, out);
    }
    out.write(')');
  }
}
