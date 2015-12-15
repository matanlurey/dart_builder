library dart_builder.test.type.built_type_test;

import 'package:dart_builder/src/type/built_type.dart';
import 'package:dart_builder/src/source_writer.dart';
import 'package:test/test.dart';

void main() {
  group('BuiltType with StringSourceWriter', () {
    StringSourceWriter sourceWriter;

    setUp(() {
      sourceWriter = new StringSourceWriter();
    });

    test('writes coreDynamic properly', () {
      sourceWriter.writeType(BuiltType.coreDynamic);
      expect(sourceWriter.toString(), 'dynamic');
    });

    test('writes coreObject properly', () {
      sourceWriter.writeType(BuiltType.coreObject);
      expect(sourceWriter.toString(), 'Object');
    });

    test('writes coreString properly', () {
      sourceWriter.writeType(BuiltType.coreString);
      expect(sourceWriter.toString(), 'String');
    });

    test('writes coreVoid properly', () {
      sourceWriter.writeType(BuiltType.coreVoid);
      expect(sourceWriter.toString(), 'void');
    });

    test('writes a non-prefixed simple type', () {
      sourceWriter.writeType(const BuiltType('Foo'));
      expect(sourceWriter.toString(), 'Foo');
    });

    test('writes a prefixed type', () {
      sourceWriter.writeType(
          const BuiltType('Foo', prefix: 'bar'));
      expect(sourceWriter.toString(), 'bar.Foo');
    });

    test('writes a simple generic type', () {
      sourceWriter.writeType(
          const BuiltType.coreList(const [BuiltType.coreString]));
      expect(sourceWriter.toString(), 'List<String>');
    });

    test('writes a complex generic type', () {
      sourceWriter.writeType(
          const BuiltType.coreMap(const [
            BuiltType.coreString,
            const BuiltType.coreList(const [BuiltType.coreInt])
          ]));
      expect(sourceWriter.toString(), 'Map<String, List<int>>');
    });
  });
}
