library dart_builder.test.method.built_method_test;

import 'package:dart_builder/src/method/built_method_body.dart';
import 'package:dart_builder/src/source_writer.dart';
import 'package:test/test.dart';

void main() {
  group('BuiltMethodBody with StringSourceWriter', () {
    StringSourceWriter sourceWriter;

    setUp(() {
      sourceWriter = new StringSourceWriter();
    });

    test('writes a lambda expression', () {
      sourceWriter.writeMethodBody(
          const BuiltMethodBody('return 5;', isExpression: true));
      expect(sourceWriter.toString(), ' => return 5;');
    });

    test('writes a method body', () {
      sourceWriter.writeMethodBody(const BuiltMethodBody('_someFoo = 5;'));
      expect(sourceWriter.toString(), ' {_someFoo = 5;}');
    });
  });
}
