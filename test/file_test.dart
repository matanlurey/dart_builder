library dart_builder.test.file_test;

import 'package:dart_builder/src/file.dart';
import 'package:dart_builder/src/elements/definition.dart';
import 'package:dart_builder/src/elements/directive.dart';
import 'package:test/test.dart';

void main() {
  group('SourceFile', () {
    test('as a library', () {
      var file = new SourceFile.library(
        'bar',
        imports: [new ImportDirective(Uri.parse('package:foo/foo.dart'))]);
      expect(file.toSource(),
        'library bar;\n'
        '\n'
        "import 'package:foo/foo.dart';\n");
    });

    test('as a part', () {
      var file = new SourceFile.part('bar');
      expect(file.toSource(), 'part of bar;\n');
    });

    test('supports top level elements like classes', () {
      var file = new SourceFile.library('foo', topLevelElements: [
        new ClassRef('Foo')
      ]);
      expect(
          file.toSource(),
          'library foo;\n'
          '\n'
          'class Foo {}\n');
    });
  });
}
