library dart_builder.test.type_test;

import 'package:dart_builder/src/elements/type.dart';
import 'package:test/test.dart';

void main() {
  group('DartType', () {
    test('can be defined', () {
      expect(new DartType('Foo').toSource(), 'Foo');
    });

    test('can be defined with a namespace', () {
      expect(new DartType('Foo', namespace: 'foo').toSource(), 'foo.Foo');
    });

    test('can be defined with generics', () {
      expect(
          new DartType('Foo', parameters: [new DartType('Bar')]).toSource(),
          'Foo<Bar>');
    });

    test('can be a nested generic type', () {
      expect(
          new DartType('Pair', parameters: [
            new DartType('Foo'),
            new DartType('List', parameters: [new DartType('Bar')])
          ]).toSource(),
          'Pair<Foo, List<Bar>>');
    });
  });
}
