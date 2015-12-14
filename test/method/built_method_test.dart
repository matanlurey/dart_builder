library dart_builder.test.method.built_method_test;

import 'package:dart_builder/src/method/built_method.dart';
import 'package:dart_builder/src/method/built_method_body.dart';
import 'package:dart_builder/src/parameter_list/built_parameter_list.dart';
import 'package:dart_builder/src/source_writer.dart';
import 'package:dart_builder/src/type/built_type.dart';
import 'package:dart_builder/src/variable/built_variable.dart';
import 'package:test/test.dart';

void main() {
  group('BuiltMethod with SourceWriter', () {
    StringBuffer stringBuffer;
    SourceWriter sourceWriter;

    setUp(() {
      stringBuffer = new StringBuffer();
      sourceWriter = const SourceWriter();
    });

    test('writes a simple no-parameter closure', () {
      sourceWriter.writeMethod(stringBuffer, const BuiltMethod());
      expect(stringBuffer.toString(), 'void ()');
    });

    test('writes a method with parameters', () {
      sourceWriter.writeMethod(
          stringBuffer,
          const BuiltMethod(
              name: 'foo',
              parameters: const BuiltParameterList(requiredArguments:
                  const [const BuiltVariable('bar', type: BuiltType.coreBool)]),
              returnType: BuiltType.coreString));
      expect(stringBuffer.toString(), 'String foo(bool bar)');
    });

    test('writes a getter method', () {
      sourceWriter.writeMethod(stringBuffer, const BuiltMethod.getter('foo'));
      expect(stringBuffer.toString(), 'dynamic get foo');
    });

    test('writes a setter method', () {
      sourceWriter.writeMethod(
          stringBuffer,
          const BuiltMethod.setter('foo',
              parameters: const BuiltParameterList(
                  requiredArguments: const [const BuiltVariable('foo')])));
      expect(stringBuffer.toString(), 'void set foo(dynamic foo)');
    });

    test('writes an abstract method', () {
      sourceWriter.writeMethod(
          stringBuffer,
          const BuiltMethod(
              name: 'foo', isAbstract: true, returnType: BuiltType.coreString));
      expect(stringBuffer.toString(), 'abstract String foo()');
    });

    test('writes a static method', () {
      sourceWriter.writeMethod(
          stringBuffer,
          const BuiltMethod(
              name: 'foo', isStatic: true, returnType: BuiltType.coreString));
      expect(stringBuffer.toString(), 'static String foo()');
    });

    test('writes a method with a method body', () {
      sourceWriter.writeMethod(stringBuffer,
          const BuiltMethod(name: 'foo', body: BuiltMethodBody.empty));
      expect(stringBuffer.toString(), 'void foo() {}\n');
    });
  });
}
