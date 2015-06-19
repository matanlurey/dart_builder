library dart_builder.test.directive_test;

import 'package:dart_builder/src/elements/directive.dart';
import 'package:test/test.dart';

void main() {
  test('LibraryDirective emits dart source code', () {
    expect(new LibraryDirective('foo').toSource(), 'library foo;');
  });

  test('PartDirective emits dart source code', () {
    expect(
        new PartDirective(Uri.parse('foo.dart')).toSource(),
        "part 'foo.dart';");
  });

  test('PartOfDirective emits dart source code', () {
    expect(new PartOfDirective('foo').toSource(), 'part of foo;');
  });

  group('ImportDirective', () {
    final uri = Uri.parse('package:foo/foo.dart');

    test('emits dart source code in the simplest case', () {
      expect(
          new ImportDirective(uri).toSource(),
          "import 'package:foo/foo.dart';");
    });

    test('can namespace', () {
      expect(
          new ImportDirective(uri, as: 'foo').toSource(),
          "import 'package:foo/foo.dart' as foo;");
    });

    test('can show certain elements', () {
      expect(
          new ImportDirective(uri, show: ['bar', 'baz']).toSource(),
          "import 'package:foo/foo.dart' show bar, baz;");
    });

    test('can hide certain elements', () {
      expect(
          new ImportDirective(uri, hide: ['bar', 'baz']).toSource(),
          "import 'package:foo/foo.dart' hide bar, baz;");
    });

    test('throws if trying to both show and hide', () {
      expect(
          () => new ImportDirective(uri, show: ['foo'], hide: ['foo']),
          throwsArgumentError);
    });
  });
}
