library dart_builder.test.method.built_method_invocation_test;

import 'package:dart_builder/src/method/built_method_invocation.dart';
import 'package:dart_builder/src/source_writer.dart';
import 'package:test/test.dart';

void main() {
  group('BuiltMethodInvocation with StringSourceWriter', () {
    StringSourceWriter sourceWriter;

    setUp(() {
      sourceWriter = new StringSourceWriter();
    });

    test('should write an empty method invocation', () {
      sourceWriter.writeMethodInvocation(BuiltMethodInvocation.empty);
      expect(sourceWriter.toString(), '()');
    });

    test('should write a single positional invocation', () {
      sourceWriter.writeMethodInvocation(
          const BuiltMethodInvocation(positionalArguments: const ['foo']));
      expect(sourceWriter.toString(), '(foo)');
    });

    test('should write a single named invocation', () {
      sourceWriter.writeMethodInvocation(
          const BuiltMethodInvocation(namedArguments: const {'foo': 'bar'}));
      expect(sourceWriter.toString(), '(foo: bar)');
    });

    test('should write multiple positional arguments invocation', () {
      sourceWriter.writeMethodInvocation(const BuiltMethodInvocation(
          positionalArguments: const ['foo', 'bar']));
      expect(sourceWriter.toString(), '(foo, bar)');
    });

    test('should write multiple named arguments invocation', () {
      sourceWriter.writeMethodInvocation(const BuiltMethodInvocation(
          namedArguments: const {'foo': 'a', 'bar': 'b'}));
      expect(sourceWriter.toString(), '(foo: a, bar: b)');
    });

    test('should write multiple mixed arguments invocation', () {
      sourceWriter.writeMethodInvocation(const BuiltMethodInvocation(
          positionalArguments: const ['foo', 'bar'],
          namedArguments: const {'a': 'a', 'b': 'b'}));
      expect(sourceWriter.toString(), '(foo, bar, a: a, b: b)');
    });
  });
}
