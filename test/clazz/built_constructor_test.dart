library dart_builder.test.clazz.built_constructor_test;

import 'package:dart_builder/src/clazz/built_constructor.dart';
import 'package:dart_builder/src/method/built_method_invocation.dart';
import 'package:dart_builder/src/parameter_list/built_parameter_list.dart';
import 'package:dart_builder/src/source_writer.dart';
import 'package:dart_builder/src/type/built_type.dart';
import 'package:dart_builder/src/variable/built_variable.dart';
import 'package:test/test.dart';

void main() {
  group('BuiltClass with StringSourceWriter', () {
    StringSourceWriter sourceWriter;

    setUp(() {
      sourceWriter = new StringSourceWriter();
    });

    test('should write a simple default constructor', () {
      sourceWriter.writeConstructor(const BuiltConstructor(), 'Foo');
      expect(sourceWriter.toString(), 'Foo();');
    });

    test('should write a constructor with parameters', () {
      sourceWriter.writeConstructor(
          const BuiltConstructor(parameters: const BuiltParameterList(
              requiredArguments: const [const BuiltVariable('x')])),
          'Foo');
      expect(sourceWriter.toString(), 'Foo(dynamic x);');
    });

    test('should write a constructor with assigning paramters', () {
      sourceWriter.writeConstructor(
          const BuiltConstructor(
              parameters: const BuiltParameterList(requiredArguments: const [
            // TODO: Consider adding 'assignThis' as a parameter.
            const BuiltVariable('this.x')
          ])),
          'Foo');
      expect(sourceWriter.toString(), 'Foo(dynamic this.x);');
    });

    test('should write a named constructor', () {
      sourceWriter.writeConstructor(
          const BuiltConstructor(name: 'internal'), 'Foo');
      expect(sourceWriter.toString(), 'Foo.internal();');
    });

    test('should write a const constructor', () {
      sourceWriter.writeConstructor(
          const BuiltConstructor(isConst: true), 'Foo');
      expect(sourceWriter.toString(), 'const Foo();');
    });

    test('should write a factory constructor', () {
      sourceWriter.writeConstructor(const BuiltConstructor.factory(), 'Foo');
      expect(sourceWriter.toString(), 'factory Foo();');
    });

    test('should write a redirecting constructor', () {
      sourceWriter.writeConstructor(
          const BuiltConstructor.redirect(const BuiltType('Bar')), 'Foo');
      expect(sourceWriter.toString(), 'factory Foo() = Bar;');
    });

    test('should write a redirecting named constructor', () {
      sourceWriter.writeConstructor(
          const BuiltConstructor.redirect(const BuiltType('Bar'),
              redirectToName: 'internal'),
          'Foo');
      expect(sourceWriter.toString(), 'factory Foo() = Bar.internal;');
    });

    test('should write a constructor with a body', () {
      sourceWriter.writeConstructor(
          const BuiltConstructor(body: "foo = 'bar';"), 'Foo');
      expect(sourceWriter.toString(), "Foo() { foo = 'bar';}");
    });

    test('should write a constructor with initializers', () {
      sourceWriter.writeConstructor(
          const BuiltConstructor(initializers: const {'x': '5', 'y': 'null'}),
          'Foo');
      expect(sourceWriter.toString(), "Foo() : this.x = 5, this.y = null;");
    });

    test('should write a constructor with initializers and a body', () {
      sourceWriter.writeConstructor(
          const BuiltConstructor(
              body: "foo = 'bar';",
              initializers: const {'x': '5', 'y': 'null'}),
          'Foo');
      expect(sourceWriter.toString(),
          "Foo() : this.x = 5, this.y = null { foo = 'bar';}");
    });

    test('should write a constructor with a super call', () {
      sourceWriter.writeConstructor(
          const BuiltConstructor(superCall: const BuiltMethodInvocation()),
          'Foo');
      expect(sourceWriter.toString(), 'Foo() : super();');
    });

    test('should write a constructor with a named super call', () {
      sourceWriter.writeConstructor(
          const BuiltConstructor(
              superCall: const BuiltMethodInvocation(),
              superConstructorName: 'internal'),
          'Foo');
      expect(sourceWriter.toString(), 'Foo() : super.internal();');
    });

    test('should write a constructor with a super call and initializers', () {
      sourceWriter.writeConstructor(
          const BuiltConstructor(
              initializers: const {'y': 'null'},
              superCall: const BuiltMethodInvocation()),
          'Foo');
      expect(sourceWriter.toString(), 'Foo() : super(), this.y = null;');
    });
  });
}
