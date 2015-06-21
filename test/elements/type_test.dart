library dart_builder.test.type_test;

import 'package:dart_builder/src/elements/type.dart';
import 'package:test/test.dart';

void main() {
  group('TypeRef', () {
    test('can be defined', () {
      expect(new TypeRef('Foo').toSource(), 'Foo');
    });

    test('can be defined with a namespace', () {
      expect(new TypeRef('Foo', namespace: 'foo').toSource(), 'foo.Foo');
    });

    test('can be defined with generics', () {
      expect(
          new TypeRef('Foo', parameters: [new TypeRef('Bar')]).toSource(),
          'Foo<Bar>');
    });

    test('can be a nested generic type', () {
      expect(
          new TypeRef('Pair', parameters: [
            new TypeRef('Foo'),
            new TypeRef('List', parameters: [new TypeRef('Bar')])
          ]).toSource(),
          'Pair<Foo, List<Bar>>');
    });
  });
}
