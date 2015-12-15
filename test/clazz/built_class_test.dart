library dart_builder.test.clazz.built_class_test;

import 'package:dart_builder/src/clazz/built_class.dart';
import 'package:dart_builder/src/method/built_method.dart';
import 'package:dart_builder/src/method/built_method_body.dart';
import 'package:dart_builder/src/type/built_type.dart';
import 'package:dart_builder/src/variable/built_variable.dart';
import 'package:dart_builder/src/source_writer.dart';
import 'package:test/test.dart';

void main() {
  group('BuiltClass with StringSourceWriter', () {
    StringSourceWriter sourceWriter;

    setUp(() {
      sourceWriter = new StringSourceWriter();
    });

    test('writes a simple class', () {
      sourceWriter.writeClass(const BuiltClass('Foo'));
      expect(
          sourceWriter.toString(),
          'class Foo {\n'
          '}\n');
    });

    test('writes a decorated class', () {
      sourceWriter.writeClass(const BuiltClass('Foo', isAbstract: true));
      expect(
          sourceWriter.toString(),
          'abstract class Foo {\n'
          '}\n');
    });

    test('writes a generic class', () {
      sourceWriter.writeClass(const BuiltClass('Foo', generics: const [const BuiltType('T')]));
      expect(
          sourceWriter.toString(),
          'class Foo<T> {\n'
          '}\n');
    });

    test('writes a class with inheritence', () {
      sourceWriter.writeClass(
          const BuiltClass('Foo',
              extend: const BuiltType('Bar'),
              mixin: const [const BuiltType('Baz1'), const BuiltType('Baz2')],
              implement: const [const BuiltType('IFoo')]));
      expect(
          sourceWriter.toString(),
          'class Foo extends Bar with Baz1, Baz2 implements IFoo {\n'
          '}\n');
    });

    test('writes a full class', () {
      sourceWriter.writeClass(
          const BuiltClass('Foo', fields: const [
            const BuiltVariable('_fooInstance')
          ], methods: const [
            const BuiltMethod(
                name: 'getFoo',
                returnType: BuiltType.coreDynamic,
                body: const BuiltMethodBody(
                    const ['_fooInstance ??= createFoo();'],
                    isExpression: true))
          ]));
      expect(
          sourceWriter.toString(),
          'class Foo {\n'
          'dynamic _fooInstance;\n'
          'dynamic getFoo() => _fooInstance ??= createFoo();}\n');
    });
  });
}
