library dart_builder.test.elements.definition.class_test;

import 'package:dart_builder/src/elements/definition.dart';
import 'package:test/test.dart';

void main() {
  group('ClassRef', () {
    test('can create a simple class with no body', () {
      expect(new ClassRef('Foo').toSource(), 'class Foo {}');
    });

    test('can define a class as `abstract`', () {
      expect(
          new ClassRef('Foo', isAbstract: true).toSource(),
          'abstract class Foo {}');
    });

    test('can include a field', () {
      expect(
          new ClassRef('Foo', fields: [
            new FieldRef('bar')
          ]).toSource(),
          'class Foo {\n'
          '  var bar;\n'
          '}\n');
    });

    test('can include a method', () {
      expect(
          new ClassRef('Foo', methods: [
            new MethodRef('bar')
          ]).toSource(),
          'class Foo {\n'
          '  bar();\n'
          '}\n');
    });
  });
}
