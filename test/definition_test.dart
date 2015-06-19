library dart_builder.test.file_test;

import 'package:dart_builder/src/elements/definition.dart';
import 'package:dart_builder/src/elements/source.dart';
import 'package:dart_builder/src/elements/type.dart';
import 'package:test/test.dart';

void main() {
  group('ClassDefinition', () {
    test('emits dart source in the simplest case', () {
      var clazz = new ClassDefinition('Foo');
      expect(clazz.toSource(), 'class Foo {}');
    });

    test('can include fields when emitting', () {
      var clazz = new ClassDefinition('Foo', fields: [
        new FieldDefinition('bar')
      ]);
      expect(
          clazz.toSource(),
          'class Foo {\n'
          '  var bar;\n'
          '}\n');
    });

    test('can include methods when emitting', () {
      var clazz = new ClassDefinition('Foo', isAbstract: true, methods: [
        new MethodDefinition('bar')
      ]);
      expect(
          clazz.toSource(),
          'abstract class Foo {\n'
          '  bar();\n'
          '}\n');
    });
  });

  group('FieldDefinition', () {
    test('throws if attempting to set const and final', () {
      expect(
          () => new FieldDefinition('foo', isConst: true, isFinal: true),
          throwsArgumentError);
    });

    test('throws if attempting to emit static outside of a class', () {
      var field = new FieldDefinition('foo', isStatic: true);
      expect(() => field.toSource(), throwsStateError);
    });

    test('can emit a non-typed const', () {
      var field = new FieldDefinition('foo', isConst: true);
      expect(field.toSource(), 'const foo;');
    });

    test('can emit a typed const', () {
      var field = new FieldDefinition(
          'foo',
          isConst: true,
          dartType: DartType.STRING);
      expect(field.toSource(), 'const String foo;');
    });

    test('can emit a non-typed final', () {
      var field = new FieldDefinition('foo', isFinal: true);
      expect(field.toSource(), 'final foo;');
    });

    test('can emit a typed final', () {
      var field = new FieldDefinition(
          'foo',
          isFinal: true,
          dartType: DartType.STRING);
      expect(field.toSource(), 'final String foo;');
    });

    test('can emit a non-typed var', () {
      var field = new FieldDefinition('foo');
      expect(field.toSource(), 'var foo;');
    });

    test('can emit a typed var', () {
      var field = new FieldDefinition('foo', dartType: DartType.STRING);
      expect(field.toSource(), 'String foo;');
    });

    test('can emit a static var', () {
      var field = new FieldDefinition('foo', isStatic: true);
      expect(field.toSource(inClass: true), 'static var foo;');
    });

    test('can emit with an assignment', () {
      var field = new FieldDefinition(
          'foo',
          assignment: new Source.fromDart('5'));
      expect(field.toSource(), 'var foo = 5;');
    });
  });

  group('MethodDefinition', () {
    group('MethodArgument', () {
      test('can emit a non-typed argument', () {
        var arg = new MethodArgument('foo');
        expect(arg.toSource(), 'foo');
      });

      test('can emit a typed argument', () {
        var arg = new MethodArgument('foo', dartType: DartType.STRING);
        expect(arg.toSource(), 'String foo');
      });

      test('can emit an argument with a default value', () {
        var arg = new MethodArgument(
            'foo',
            defaultValue: new Source.fromDart('5'));
        expect(arg.toSource(), 'foo = 5');
      });

      test('can emit an argument with a default value when named', () {
        var arg = new MethodArgument(
            'foo',
            defaultValue: new Source.fromDart('5'));
        expect(arg.toSource(isPositional: false), 'foo: 5');
      });
    });

    test('can create an untyped simple method', () {
      var method = new MethodDefinition('foo');
      expect(method.toSource(), 'foo();');
    });

    test('can include a method body', () {
      var method = new MethodDefinition(
          'foo',
          methodBody: new Source.fromDart('return 5;'));
      expect(method.toSource(),
          'foo() {\n'
          'return 5;\n'
          '}\n');
    });

    test('can create a typed method', () {
      var method = new MethodDefinition('foo', returnType: DartType.STRING);
      expect(method.toSource(), 'String foo();');
    });

    test('can create a static method', () {
      var method = new MethodDefinition('foo', isStatic: true);
      expect(method.toSource(), 'static foo();');
    });

    test('can create a method with arguments', () {
      var method = new MethodDefinition('foo',
          positionalArguments: [
            new MethodArgument('bar'),
            new MethodArgument('baz')
          ]);
      expect(method.toSource(), 'foo(bar, baz);');
    });

    test('can create a method with optional arguments', () {
      var method = new MethodDefinition('foo',
          optionalArguments: [
            new MethodArgument(
                'bar',
                defaultValue: new Source.fromDart('5')),
            new MethodArgument('baz')
          ]);
      expect(method.toSource(), 'foo([bar = 5, baz]);');
    });

    test('can create a method with named arguments', () {
      var method = new MethodDefinition('foo',
          optionalArguments: [
            new MethodArgument(
                'bar',
                defaultValue: new Source.fromDart('5')),
            new MethodArgument('baz')
          ],
          useNamedOptionals: true);
      expect(method.toSource(), 'foo({bar: 5, baz});');
    });

    test('can create a method with a mix of arguments', () {
      var method = new MethodDefinition('foo',
          positionalArguments: [new MethodArgument('bar')],
          optionalArguments: [new MethodArgument('baz')]);
      expect(method.toSource(), 'foo(bar, [baz]);');
    });

    test('can create a method with a mix of arguments (named)', () {
      var method = new MethodDefinition('foo',
          positionalArguments: [new MethodArgument('bar')],
          optionalArguments: [new MethodArgument('baz')],
          useNamedOptionals: true);
      expect(method.toSource(), 'foo(bar, {baz});');
    });
  });
}
