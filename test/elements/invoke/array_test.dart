library dart_builder.test.elements.invoke.array_test;

import 'package:dart_builder/src/elements/invoke/array.dart';
import 'package:dart_builder/src/elements/source.dart';
import 'package:dart_builder/src/elements/type.dart';
import 'package:test/test.dart';

void main() {
  group('ArrayRef', () {
    test('can create a simple untyped empty array', () {
      expect(new ArrayRef().toSource(), '[]');
    });

    test('can create a simple untyped empty const array', () {
      expect(new ArrayRef(isConst: true).toSource(), 'const []');
    });

    test('can define the type of the array', () {
      expect(new ArrayRef(typeRef: TypeRef.STRING).toSource(), '<String> []');
    });

    test('can have values in the array', () {
      var array = new ArrayRef(values: [
        new Source.fromDart('1'),
        new Source.fromDart('2'),
        new Source.fromDart('3'),
      ]);
      expect(array.toSource(), '[1, 2, 3]');
    });
  });
}
