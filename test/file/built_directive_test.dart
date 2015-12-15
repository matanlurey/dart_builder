library dart_builder.test.file.built_directive_test;

import 'package:dart_builder/src/file/built_directive.dart';
import 'package:dart_builder/src/source_writer.dart';
import 'package:test/test.dart';

void main() {
  group('BuiltDirective with SourceWriter', () {
    StringBuffer stringBuffer;
    SourceWriter sourceWriter;

    setUp(() {
      stringBuffer = new StringBuffer();
      sourceWriter = const SourceWriter();
    });

    test('writes an import', () {
      sourceWriter.writeDirective(
          stringBuffer, const BuiltDirective.import('package:foo/foo.dart'));
      expect(stringBuffer.toString(), "import 'package:foo/foo.dart'");
    });

    test('writes an export', () {
      sourceWriter.writeDirective(
          stringBuffer, const BuiltDirective.export('package:foo/foo.dart'));
      expect(stringBuffer.toString(), "export 'package:foo/foo.dart'");
    });

    test('writes a part', () {
      sourceWriter.writeDirective(
          stringBuffer, const BuiltDirective.part('src/foo.dart'));
      expect(stringBuffer.toString(), "part 'src/foo.dart'");
    });

    test('writes with a namespace', () {
      sourceWriter.writeDirective(
          stringBuffer,
          const BuiltDirective.import('package:foo/foo.dart',
              namespace: 'foo'));
      expect(stringBuffer.toString(), "import 'package:foo/foo.dart' as foo");
    });

    test('writes deferred with a namespace', () {
      sourceWriter.writeDirective(
          stringBuffer,
          const BuiltDirective.import('package:foo/foo.dart',
              isDeferred: true, namespace: 'foo'));
      expect(stringBuffer.toString(),
          "import 'package:foo/foo.dart' deferred as foo");
    });

    test('writes with show', () {
      sourceWriter.writeDirective(
          stringBuffer,
          const BuiltDirective.import('package:foo/foo.dart',
              show: const ['Foo']));
      expect(stringBuffer.toString(), "import 'package:foo/foo.dart' show Foo");
    });

    test('writes with hide', () {
      sourceWriter.writeDirective(
          stringBuffer,
          const BuiltDirective.import('package:foo/foo.dart',
              hide: const ['Bar']));
      expect(stringBuffer.toString(), "import 'package:foo/foo.dart' hide Bar");
    });
  });
}
