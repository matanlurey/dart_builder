library dart_builder.test.method.built_method_test;

import 'package:dart_builder/src/method/built_method.dart';
import 'package:dart_builder/src/method/built_method_body.dart';
import 'package:dart_builder/src/parameter_list/built_parameter_list.dart';
import 'package:dart_builder/src/source_writer.dart';
import 'package:dart_builder/src/type/built_type.dart';
import 'package:dart_builder/src/variable/built_variable.dart';
import 'package:test/test.dart';

void main() {
  group('BuiltMethod with StringSourceWriter', () {
    StringSourceWriter sourceWriter;

    setUp(() {
      sourceWriter = new StringSourceWriter();
    });

    test('writes a simple no-parameter closure', () {
      sourceWriter.writeMethod(const BuiltMethod());
      expect(sourceWriter.toString(), 'void ()');
    });

    test('writes a method with parameters', () {
      sourceWriter.writeMethod(const BuiltMethod(
          name: 'foo',
          parameters: const BuiltParameterList(requiredArguments:
              const [const BuiltVariable('bar', type: BuiltType.coreBool)]),
          returnType: BuiltType.coreString));
      expect(sourceWriter.toString(), 'String foo(bool bar)');
    });

    test('writes a getter method', () {
      sourceWriter.writeMethod(const BuiltMethod.getter('foo'));
      expect(sourceWriter.toString(), 'dynamic get foo');
    });

    test('writes a setter method', () {
      sourceWriter.writeMethod(const BuiltMethod.setter('foo',
          parameters: const BuiltParameterList(
              requiredArguments: const [const BuiltVariable('foo')])));
      expect(sourceWriter.toString(), 'void set foo(dynamic foo)');
    });

    test('writes an abstract method', () {
      sourceWriter.writeMethod(const BuiltMethod(
          name: 'foo', isAbstract: true, returnType: BuiltType.coreString));
      expect(sourceWriter.toString(), 'abstract String foo()');
    });

    test('writes a static method', () {
      sourceWriter.writeMethod(const BuiltMethod(
          name: 'foo', isStatic: true, returnType: BuiltType.coreString));
      expect(sourceWriter.toString(), 'static String foo()');
    });

    test('writes a method with a method body', () {
      sourceWriter.writeMethod(
          const BuiltMethod(name: 'foo', body: BuiltMethodBody.empty));
      expect(sourceWriter.toString(), 'void foo() {}\n');
    });
  });
}
