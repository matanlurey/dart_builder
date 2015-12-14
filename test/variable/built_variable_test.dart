library dart_builder.test.variable.built_variable_test;

import 'package:dart_builder/src/variable/built_variable.dart';
import 'package:dart_builder/src/type/built_type.dart';
import 'package:dart_builder/src/source_writer.dart';
import 'package:test/test.dart';

void main() {
  group('BuiltVariale with SourceWriter', () {
    StringBuffer stringBuffer;
    SourceWriter sourceWriter;

    setUp(() {
      stringBuffer = new StringBuffer();
      sourceWriter = const SourceWriter();
    });

    test('writes a parameter', () {
      sourceWriter.writeVariable(
          stringBuffer, const BuiltVariable('foo', type: BuiltType.coreString));
      expect(stringBuffer.toString(), 'String foo');
    });

    test('writes a parameter with a default value', () {
      sourceWriter.writeVariable(
          stringBuffer,
          const BuiltVariable('foo',
              type: BuiltType.coreBool, defaultValue: 'true'));
      expect(stringBuffer.toString(), 'bool foo = true');
    });

    test('writes a parameter with a default value (key/value pair)', () {
      sourceWriter.writeVariable(
          stringBuffer,
          const BuiltVariable('foo',
              type: BuiltType.coreBool, defaultValue: 'true'),
          keyValuePair: true);
      expect(stringBuffer.toString(), 'bool foo: true');
    });
  });
}
