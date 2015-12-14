library dart_builder.test.type.built_type_test;

import 'package:dart_builder/src/type/built_type.dart';
import 'package:dart_builder/src/source_writer.dart';
import 'package:test/test.dart';

void main() {
  group('BuiltType with SourceWriter', () {
    StringBuffer stringBuffer;
    SourceWriter sourceWriter;

    setUp(() {
      stringBuffer = new StringBuffer();
      sourceWriter = const SourceWriter();
    });

    test('writes coreDynamic properly', () {
      sourceWriter.writeType(stringBuffer, BuiltType.coreDynamic);
      expect(stringBuffer.toString(), 'dynamic');
    });

    test('writes coreObject properly', () {
      sourceWriter.writeType(stringBuffer, BuiltType.coreObject);
      expect(stringBuffer.toString(), 'Object');
    });

    test('writes coreString properly', () {
      sourceWriter.writeType(stringBuffer, BuiltType.coreString);
      expect(stringBuffer.toString(), 'String');
    });

    test('writes coreVoid properly', () {
      sourceWriter.writeType(stringBuffer, BuiltType.coreVoid);
      expect(stringBuffer.toString(), 'void');
    });

    test('writes a non-prefixed simple type', () {
      sourceWriter.writeType(stringBuffer, const BuiltType('Foo'));
      expect(stringBuffer.toString(), 'Foo');
    });

    test('writes a prefixed type', () {
      sourceWriter.writeType(
          stringBuffer, const BuiltType('Foo', prefix: 'bar'));
      expect(stringBuffer.toString(), 'bar.Foo');
    });

    test('writes a simple generic type', () {
      sourceWriter.writeType(
          stringBuffer, const BuiltType.coreList(const [BuiltType.coreString]));
      expect(stringBuffer.toString(), 'List<String>');
    });

    test('writes a complex generic type', () {
      sourceWriter.writeType(
          stringBuffer,
          const BuiltType.coreMap(const [
            BuiltType.coreString,
            const BuiltType.coreList(const [BuiltType.coreInt])
          ]));
      expect(stringBuffer.toString(), 'Map<String, List<int>>');
    });
  });
}
