library dart_builder.test.variable.built_variable_test;

import 'package:dart_builder/src/variable/built_variable.dart';
import 'package:dart_builder/src/type/built_type.dart';
import 'package:dart_builder/src/source_writer.dart';
import 'package:test/test.dart';

void main() {
  group('BuiltVariale with StringSourceWriter', () {
    StringSourceWriter sourceWriter;

    setUp(() {
      sourceWriter = new StringSourceWriter();
    });

    test('writes a parameter', () {
      sourceWriter.writeVariable(
          const BuiltVariable('foo', type: BuiltType.coreString));
      expect(sourceWriter.toString(), 'String foo');
    });

    test('writes a parameter with a default value', () {
      sourceWriter.writeVariable(
          const BuiltVariable('foo',
              type: BuiltType.coreBool, defaultValue: 'true'));
      expect(sourceWriter.toString(), 'bool foo = true');
    });

    test('writes a parameter with a default value (key/value pair)', () {
      sourceWriter.writeVariable(
          const BuiltVariable('foo',
              type: BuiltType.coreBool, defaultValue: 'true'),
          keyValuePair: true);
      expect(sourceWriter.toString(), 'bool foo: true');
    });
  });
}
