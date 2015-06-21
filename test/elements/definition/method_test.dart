library dart_builder.test.elements.definition.field_test;

import 'package:dart_builder/src/elements/definition.dart';
import 'package:dart_builder/src/elements/source.dart';
import 'package:dart_builder/src/elements/type.dart';
import 'package:test/test.dart';

void main() {
  group('MethodRef', () {
    test('can create a simple method', () {
      var method = new MethodRef('bar');
      expect(method.toSource(), 'bar();');
    });

    test('can create a simple getter', () {
      var method = new MethodRef.getter('bar');
      expect(method.toSource(), 'get bar;');
    });

    test('can create a simple setter', () {
      var method = new MethodRef.setter('bar');
      expect(method.toSource(), 'set bar(bar);');
    });

    test('throws when attempting to set getter and setter', () {
      expect(
          () => new MethodRef('bar', isGetter: true, isSetter: true),
          throwsArgumentError);
    });

    test('can create a static method', () {
      var method = new MethodRef('bar', isStatic: true);
      expect(method.toSource(inClass: true), 'static bar();');
    });

    test('throws when trying to create a static method outside a class', () {
      var method = new MethodRef('bar', isStatic: true);
      expect(() => method.toSource(), throwsStateError);
    });

    test('can define a method body', () {
      var method = new MethodRef(
          'bar',
          methodBody: new Source.fromDart('return 5;'));
      expect(
          method.toSource(),
          'bar() {\n'
          'return 5;\n'
          '}\n');
    });

    test('can define positional arguments', () {
      var method = new MethodRef('bar', positionalArguments: [
        new ParameterRef('baz')
      ]);
      expect(method.toSource(), 'bar(baz);');
    });

    test('can define optional arguments', () {
      var method = new MethodRef('bar', optionalArguments: [
        new ParameterRef('baz')
      ]);
      expect(method.toSource(), 'bar([baz]);');
    });

    test('can define named arguments', () {
      var method = new MethodRef('bar', optionalArguments: [
        new ParameterRef('baz')
      ], useNamedOptionals: true);
      expect(method.toSource(), 'bar({baz});');
    });

    test('can define a return type', () {
      var method = new MethodRef('bar', returnTypeRef: TypeRef.STRING);
      expect(method.toSource(), 'String bar();');
    });
  });

  group('ParameterRef', () {
    test('can create a simple parameter', () {
      var parameter = new ParameterRef('bar');
      expect(parameter.toSource(), 'bar');
    });

    test('can create a typed parameter', () {
      var parameter = new ParameterRef('bar', typeRef: TypeRef.STRING);
      expect(parameter.toSource(), 'String bar');
    });

    group('can create with a default value', () {
      var parameter = new ParameterRef(
          'bar',
          defaultValue: new Source.fromDart('5'));

      test('for positional parameters', () {
        expect(parameter.toSource(), 'bar = 5');
      });

      test('for named parameters', () {
        expect(parameter.toSource(asPositional: false), 'bar: 5');
      });
    });
  });
}
