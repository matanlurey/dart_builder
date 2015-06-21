library dart_builder.test.elements.invoke.map_test;

import 'package:dart_builder/src/elements/invoke/call.dart';
import 'package:dart_builder/src/elements/source.dart';
import 'package:dart_builder/src/elements/type.dart';
import 'package:test/test.dart';

void main() {
  group('CallRef', () {
    test('can create a simple call site', () {
      var call = new CallRef(methodName: 'foo');
      expect(call.toSource(), 'foo()');
    });

    test('can create a call site with positional arguments', () {
      var call = new CallRef(positionalArguments: [new Source.fromDart('1')]);
      expect(call.toSource(), '(1)');
    });

    test('can create a call site with named arguments', () {
      var call = new CallRef(namedArguments: {'a': new Source.fromDart('1')});
      expect(call.toSource(), '(a: 1)');
    });

    test('can create a call site to a static class method', () {
      var fooTypeRef = new TypeRef('Foo');
      var call = new CallRef.static(fooTypeRef, 'bar');
      expect(call.toSource(), 'Foo.bar()');
    });

    test('can create a call site to a class costructor', () {
      var fooTypeRef = new TypeRef('Foo');
      var call = new CallRef.constructor(fooTypeRef);
      expect(call.toSource(), 'new Foo()');
    });

    test('can creata a call site to a named class constructor', () {
      var fooTypeRef = new TypeRef('Foo');
      var call = new CallRef.constructor(fooTypeRef, constructorName: 'bar');
      expect(call.toSource(), 'new Foo.bar()');
    });
  });
}
