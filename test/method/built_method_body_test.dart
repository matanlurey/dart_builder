library dart_builder.test.method.built_method_test;

import 'package:dart_builder/src/method/built_method_body.dart';
import 'package:dart_builder/src/source_writer.dart';
import 'package:test/test.dart';

void main() {
  group('BuiltMethodBody with SourceWriter', () {
    StringBuffer stringBuffer;
    SourceWriter sourceWriter;

    setUp(() {
      stringBuffer = new StringBuffer();
      sourceWriter = const SourceWriter();
    });

    test('writes a lambda expression', () {
      sourceWriter.writeMethodBody(stringBuffer,
          const BuiltMethodBody(const ['return 5;'], isExpression: true));
      expect(stringBuffer.toString(), ' => return 5;');
    });

    test('writes a method body', () {
      sourceWriter.writeMethodBody(
          stringBuffer, const BuiltMethodBody(const ['_someFoo = 5;']));
      expect(
          stringBuffer.toString(),
          ' {\n'
          '_someFoo = 5;\n'
          '}\n');
    });
  });
}
